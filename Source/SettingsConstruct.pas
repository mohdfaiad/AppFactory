unit SettingsConstruct;

interface

uses
  System.Generics.Collections, FMX.ListBox, FMX.Types, FMX.Graphics,
  System.Classes, FMX.MediaLibrary.Actions, System.UITypes, uChooseColor,
  FMX.Objects, FMX.Forms;

type
  TSettingType = (stNone, stAlign, stBool, stInteger, stString, stBitmap,
    stColor, stText, stWrapMode, stTextAlign);

  PSettingItem = ^TSettingItem;

  TSettingItem = record
    SettingType: TSettingType;
    Value: String;
  end;

  TBitmapSaverFunc = function(Image: TBitmap): Integer of object;

  TSettingSelectEvent = procedure(Index: Integer; SettingType: TSettingType;
    var Value: String; var StandartAction: Boolean) of object;

  TListBoxSettingsConstructor = class
  private
    DefBounds: TBounds;
    [Weak]
    fListBox: TListBox;
    [Weak]
    fForm: TForm;
    fItems: TList;
    fCurrItem: Integer;
    fConstructing: Boolean;
    fBitmapSaverFunc: TBitmapSaverFunc;
    fTakePhotoAction: TTakePhotoFromLibraryAction;
    fOnSettingSelect: TSettingSelectEvent;
    function Add(SettingType: TSettingType; Text: String; Value: String)
      : TListBoxItem;
    procedure DoItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure ExecuteTakePhotoAction;
    procedure ExecuteChooseColor;
    procedure ExecuteEditText;
    procedure TakePhotoActionDidFinishTaking(Image: TBitmap);
  public
    constructor Create(ListBox: TListBox);
    function GetValue(Index: Integer): String;
    procedure Reset;
    procedure BeginConstruct;
    procedure EndConstruct;
    procedure AddUnknown(Text: String; Value: String);
    procedure AddAlign(Text: String; Value: TAlignLayout);
    procedure AddTextAlign(Text: String; Value: TTextAlign);
    procedure AddBool(Text: String; Value: Boolean);
    procedure AddColor(Text: String; Value: TAlphaColor);
    procedure AddString(Text: String; Value: String);
    procedure AddText(Text: String; Value: String);
    procedure AddInteger(Text: String; Value: Extended);
    procedure AddImage(Text: String; FileName: String);
    procedure AddWrapMode(Text: String; Value: TImageWrapMode);
    property ListBox: TListBox read fListBox write fListBox;
    property Constructing: Boolean read fConstructing;
    property BitmapSaverFunc: TBitmapSaverFunc read fBitmapSaverFunc
      write fBitmapSaverFunc;
    property OnSettingSelect: TSettingSelectEvent read fOnSettingSelect
      write fOnSettingSelect;
  end;

implementation

uses
  FMX.StdCtrls, System.SysUtils, FMX.Edit, System.Types, FMX.Dialogs,
  System.UIConsts, FMX.Colors, uEditText, FMX.ListView.Types;

{ TListBoxSettingsConstructor }

constructor TListBoxSettingsConstructor.Create(ListBox: TListBox);
var
  FmxObject: TFmxObject;
begin
  fListBox := ListBox;
  fListBox.OnItemClick := DoItemClick;

  FmxObject := fListBox.Parent;
  while Assigned(FmxObject) and (not(FmxObject is TForm)) do
    FmxObject := FmxObject.Parent;

  if Assigned(FmxObject) then
    fForm := TForm(FmxObject)
  else
    fForm := nil;

  fItems := TList.Create;
  DefBounds := TBounds.Create(RectF(0, 0, 10, 0));
end;
{
  procedure TListBoxSettingsConstructor.DoControlClick(Sender: TObject);
  begin
  if (Sender is TFmxObject) then
  begin
  fCurrItem := fListBox.Children.IndexOf(TFmxObject(Sender).Parent);
  if (fCurrItem <> -1) then
  DoItemClick(fListBox, fListBox.ItemByIndex(fCurrItem));
  end;
  end; }

procedure TListBoxSettingsConstructor.DoItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
var
  StandartAction: Boolean;
begin
  StandartAction := true;
  fCurrItem := Item.Index;
  // Переменная необходима, чтобы клиен мог подавить стандартное действие

  if Assigned(fOnSettingSelect) then
    fOnSettingSelect(fCurrItem, PSettingItem(fItems[fCurrItem])^.SettingType,
      PSettingItem(fItems[fCurrItem])^.Value, StandartAction);

  if StandartAction then
  begin
    case PSettingItem(fItems[fCurrItem])^.SettingType of
      stBitmap:
        ExecuteTakePhotoAction;
      stColor:
        ExecuteChooseColor;
      stText:
        ExecuteEditText;
    end;
  end;
  if Assigned(fForm) then
    Screen.ActiveForm := fForm;
end;

function TListBoxSettingsConstructor.Add(SettingType: TSettingType;
  Text: String; Value: String): TListBoxItem;
var
  NewItem: PSettingItem;
begin
  New(NewItem);
  NewItem^.SettingType := SettingType;
  NewItem^.Value := Value;
  fItems.Add(NewItem);

  Result := fListBox.ItemByIndex(fListBox.Items.Add(Text));
end;

function TListBoxSettingsConstructor.GetValue(Index: Integer): String;
begin
  if fConstructing then
    exit;
  try
    case PSettingItem(fItems[Index])^.SettingType of
      stAlign:
        Result := (TComboBox(fListBox.ItemByIndex(Index).Components[0])
          .ItemIndex + 1).ToString;
      stInteger:
        Result := TEdit(fListBox.ItemByIndex(Index).Components[0]).Text;
      stString:
        Result := TEdit(fListBox.ItemByIndex(Index).Components[0]).Text;
      stBool:
        Result := TSwitch(fListBox.ItemByIndex(Index).Components[0])
          .IsChecked.ToString;
      stColor:
        Result := AlphaColorToString
          (TColorBox(fListBox.ItemByIndex(Index).Components[0]).Color);
      stWrapMode:
        Result := (TComboBox(fListBox.ItemByIndex(Index).Components[0])
          .ItemIndex).ToString;
      stTextAlign:
        Result := (TComboBox(fListBox.ItemByIndex(Index).Components[0])
          .ItemIndex).ToString;
    else
      Result := PSettingItem(fItems[Index])^.Value;
    end;
  except
    Result := PSettingItem(fItems[Index])^.Value;
  end;
end;

procedure TListBoxSettingsConstructor.Reset;
begin
  fListBox.BeginUpdate;
  fItems.Clear;
  fListBox.Clear;
  fListBox.EndUpdate;
end;

procedure TListBoxSettingsConstructor.EndConstruct;
begin
  // fListBox.EndUpdate;
  fConstructing := false;
end;

procedure TListBoxSettingsConstructor.ExecuteChooseColor;
var
  frmChooseColor: TfrmChooseColor;
begin
  frmChooseColor := TfrmChooseColor.Create(nil);
  if (fItems[fCurrItem] <> nil) and
    (PSettingItem(fItems[fCurrItem])^.SettingType = stColor) then
  begin
    frmChooseColor.SetColor(StringToAlphaColor(PSettingItem(fItems[fCurrItem]
      )^.Value));
  end;

  frmChooseColor.ShowModal(
    procedure(ModalResult: TModalResult)
    begin
      if ModalResult = mrOk then
        if (fItems[fCurrItem] <> nil) and (PSettingItem(fItems[fCurrItem])
          ^.SettingType = stColor) then
        begin
          TColorBox(fListBox.ItemByIndex(fCurrItem).Components[0]).Color :=
            frmChooseColor.ColorPanel.Color;
        end;
      frmChooseColor.Hide;
    end);
end;

procedure TListBoxSettingsConstructor.ExecuteEditText;
var
  frmEditText: TfrmEditText;
begin
  frmEditText := TfrmEditText.Create(nil);
  if (fItems[fCurrItem] <> nil) and
    (PSettingItem(fItems[fCurrItem])^.SettingType = stText) then
  begin
    frmEditText.SetText(PSettingItem(fItems[fCurrItem])^.Value);
  end;
  frmEditText.ShowModal(
    procedure(ModalResult: TModalResult)
    begin
      if ModalResult = mrOk then
        if (fItems[fCurrItem] <> nil) and (PSettingItem(fItems[fCurrItem])
          ^.SettingType = stText) then
        begin
          PSettingItem(fItems[fCurrItem])^.Value := frmEditText.GetText;
        end;
      frmEditText.Hide;
    end);
end;

procedure TListBoxSettingsConstructor.ExecuteTakePhotoAction;
{$IFDEF Win32}
var
  OpenDialog: TOpenDialog;
  Image: TImage;
{$ENDIF}
begin
  if not Assigned(fTakePhotoAction) then
  begin
    fTakePhotoAction := TTakePhotoFromLibraryAction.Create(nil);
    fTakePhotoAction.OnDidFinishTaking := TakePhotoActionDidFinishTaking;
  end;
  fTakePhotoAction.ExecuteTarget(nil);
{$IFDEF Win32}
  OpenDialog := TOpenDialog.Create(nil);
  Image := TImage.Create(nil);
  if OpenDialog.Execute then
  begin
    Image.Bitmap.LoadFromFile(OpenDialog.FileName);
    TakePhotoActionDidFinishTaking(Image.Bitmap);
  end;
{$ENDIF}
end;

procedure TListBoxSettingsConstructor.TakePhotoActionDidFinishTaking
  (Image: TBitmap);
var
  ResIndex: Integer;
begin
  if Assigned(fBitmapSaverFunc) then
  begin
    ResIndex := BitmapSaverFunc(Image);

    if not(ResIndex = -1) then
      if (fItems[fCurrItem] <> nil) and
        (PSettingItem(fItems[fCurrItem])^.SettingType = stBitmap) then
      begin
        PSettingItem(fItems[fCurrItem])^.Value := ResIndex.ToString;
      end
      else
        MessageDlg('Unable to set PSettingItem:  ' + ResIndex.ToString +
          ' fCurrItem=' + fCurrItem.ToString, TMsgDlgType.mtInformation,
          [TMsgDlgBtn.mbOK], -1);
  end;
end;

procedure TListBoxSettingsConstructor.AddUnknown(Text, Value: String);
var
  Item: TListBoxItem;
begin
  Item := Add(stNone, Text, Value);
  Item.StyleLookup := 'listboxitemrightdetail';
end;

procedure TListBoxSettingsConstructor.AddWrapMode(Text: String;
Value: TImageWrapMode);
var
  Item: TListBoxItem;
  ComboBox: TComboBox;
begin
  Item := Add(stWrapMode, Text, Integer(Value).ToString);
  ComboBox := TComboBox.Create(Item);
  with ComboBox do
  begin
    Parent := Item;
    Width := fListBox.Width / 3;
    Align := TAlignLayout.alRight;
    Margins := DefBounds;
    Items.Add('Оригинал');
    Items.Add('Вместить');
    Items.Add('Растянуть');
    Items.Add('Замостить');
    Items.Add('По-центру');
    ItemIndex := Integer(Value);
  end;
end;

procedure TListBoxSettingsConstructor.BeginConstruct;
begin
  fConstructing := true;
  fListBox.Visible := false;
  // fListBox.BeginUpdate;
  // При включении BeginConstruct \ EndConstruct конструирование настроек
  // ускоряется, однако появляются проблемы с расположением элементов
end;

procedure TListBoxSettingsConstructor.AddAlign(Text: String;
Value: TAlignLayout);
var
  Item: TListBoxItem;
  ComboBox: TComboBox;
begin
  Item := Add(stAlign, Text, Integer(Value).ToString);

  ComboBox := TComboBox.Create(Item);
  with ComboBox do
  begin
    Parent := Item;
    Width := fListBox.Width / 3;
    Align := TAlignLayout.alRight;
    Margins := DefBounds;
    Items.Add('Вверху');
    Items.Add('Слева');
    Items.Add('Справа');
    Items.Add('Внизу');
    ItemIndex := Integer(Value) - 1;
  end;
end;

procedure TListBoxSettingsConstructor.AddBool(Text: String; Value: Boolean);
var
  Item: TListBoxItem;
  Switch: TSwitch;
begin
  Item := Add(stBool, Text, Value.ToString);

  Switch := TSwitch.Create(Item);
  with Switch do
  begin
    Parent := Item;
    Align := TAlignLayout.alRight;
    IsChecked := Value;
    Margins := DefBounds;
  end;
end;

procedure TListBoxSettingsConstructor.AddColor(Text: String;
Value: TAlphaColor);
var
  Item: TListBoxItem;
  ColorBox: TColorBox;
begin
  Item := Add(stColor, Text, AlphaColorToString(Value));

  ColorBox := TColorBox.Create(Item);
  with ColorBox do
  begin
    Parent := Item;
    Align := TAlignLayout.alRight;
    Margins := TBounds.Create(RectF(5, 5, 5, 5));
    Color := Value;
    HitTest := false;
    // OnClick :=  DoControlClick;
  end;
end;

procedure TListBoxSettingsConstructor.AddImage(Text, FileName: String);
var
  Item: TListBoxItem;
begin
  Item := Add(stBitmap, Text, FileName);
  Item.ItemData.Accessory := TListBoxItemData.TAccessory.aMore;
  // Item.ItemData.Detail := FileName;
  Item.StyleLookup := 'listboxitemrightdetail';
end;

procedure TListBoxSettingsConstructor.AddInteger(Text: String; Value: Extended);
var
  Item: TListBoxItem;
  Edit: TEdit;
begin
  Item := Add(stInteger, Text, Value.ToString);
  // Item.
  Edit := TEdit.Create(Item);
  with Edit do
  begin
    Parent := Item;
    Align := TAlignLayout.alRight;
    Text := Value.ToString;
    TextAlign := TTextAlign.taTrailing;
    Margins := DefBounds;
    KillFocusByReturn := true;
    KeyboardType := TVirtualKeyboardType.vktNumberPad;
    Width := fListBox.Width / 2;
  end;
end;

procedure TListBoxSettingsConstructor.AddString(Text, Value: String);
var
  Item: TListBoxItem;
  Edit: TEdit;
begin
  Item := Add(stString, Text, Value);

  Edit := TEdit.Create(Item);
  with Edit do
  begin
    Parent := Item;
    Align := TAlignLayout.alRight;
    Text := Value;
    TextAlign := TTextAlign.taTrailing;
    Margins := DefBounds;
    KillFocusByReturn := true;
    Width := fListBox.Width / 2;
  end;
end;

procedure TListBoxSettingsConstructor.AddText(Text, Value: String);
var
  Item: TListBoxItem;
begin
  Item := Add(stText, Text, Value);
  Item.ItemData.Accessory := TListBoxItemData.TAccessory.aMore;
end;

procedure TListBoxSettingsConstructor.AddTextAlign(Text: String;
Value: TTextAlign);
var
  Item: TListBoxItem;
  ComboBox: TComboBox;
begin
  Item := Add(stTextAlign, Text, Integer(Value).ToString);

  ComboBox := TComboBox.Create(Item);
  with ComboBox do
  begin
    Parent := Item;
    Width := fListBox.Width / 3;
    Align := TAlignLayout.alRight;
    Margins := DefBounds;
    Items.Add('По центру');
    Items.Add('Слева');
    Items.Add('Справа');
    ItemIndex := Integer(Value);
  end;
end;

end.
