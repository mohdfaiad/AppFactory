unit uEditor;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.ListBox, FMX.TabControl, System.Actions, FMX.ActnList,
  AppProduct, FMX.ListView.Types, FMX.ListView, Content,
  CustomSettings, FMX.Edit, FMX.Effects, FMX.Filter.Effects, FMX.ExtCtrls,
  FMX.Gestures, FMX.Ani, FMX.Objects, FMX.StdActns, FMX.MediaLibrary.Actions,
  AndroidSelection, SettingsConstruct, System.Generics.Collections;

type
  TfrmEditor = class(TForm)
    tcPages: TTabControl;
    tabAppWidgets: TTabItem;
    tabEditor: TTabItem;
    tabItemSettings: TTabItem;
    tbAppWidgetsHeader: TToolBar;
    spbAddWidget: TSpeedButton;
    spbEditor: TSpeedButton;
    ActionList: TActionList;
    ShowEditorAction: TChangeTabAction;
    tbEditorHeader: TToolBar;
    sbAppWidgets: TSpeedButton;
    sbItemSettings: TSpeedButton;
    ShowItemSettingsAction: TChangeTabAction;
    Label1: TLabel;
    lblAppEditor: TLabel;
    ShowAppWidgetsFXAction: TChangeTabAction;
    tbSettingsHeader: TToolBar;
    lblSettings: TLabel;
    sbBack: TSpeedButton;
    tbEditorFooter: TToolBar;
    sbAppContentItem: TSpeedButton;
    sbRemoveContent: TSpeedButton;
    ShowAppWidgetsAction: TChangeTabAction;
    lvAppWidgets: TListView;
    sbRefresh: TSpeedButton;
    ShadowEffect1: TShadowEffect;
    sbDeleteWidget: TSpeedButton;
    tabWidgets: TTabItem;
    tbWidgetsFooter: TToolBar;
    tbWidgetsHeader: TToolBar;
    Label4: TLabel;
    SpeedButton7: TSpeedButton;
    ShowWidgetsAction: TChangeTabAction;
    GestureManager: TGestureManager;
    lbPopup: TListBox;
    lbiSave: TListBoxItem;
    ShadowEffect2: TShadowEffect;
    lbiExit: TListBoxItem;
    pnlAppBox: TPanel;
    scrlArea: TScrollBox;
    ltApp: TLayout;
    pnlApplication: TPanel;
    TakePhotoFromLibraryAction: TTakePhotoFromLibraryAction;
    AppShadow: TShadowEffect;
    sbApplyContentChanges: TSpeedButton;
    sbCancelContentChanges: TSpeedButton;
    lvItemSettings: TListBox;
    ToolBar2: TToolBar;
    btnSaveSettings: TButton;
    btnCancelSettingsChange: TButton;
    lbiRun: TListBoxItem;
    tbAppWidgetsFooter: TToolBar;
    StartAppAnimation: TFloatAnimation;
    imgStarting: TImage;
    imgSwipeUpTip: TImage;
    Panel1: TPanel;
    ShadowEffect3: TShadowEffect;
    ToolBar3: TToolBar;
    StyleBook: TStyleBook;
    lbContentItems: TListBox;
    pnlContentItems: TPanel;
    FloatAnimation1: TFloatAnimation;
    InnerGlowEffect1: TInnerGlowEffect;
    Image3: TImage;
    ltNoWidgets: TLayout;
    Label2: TLabel;
    lbWidgets: TListBox;
    Layout2: TLayout;
    AniIndicator1: TAniIndicator;
    Label3: TLabel;
    Layout1: TLayout;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Label5: TLabel;
    Layout4: TLayout;
    Rectangle3: TRectangle;
    Image1: TImage;
    tcHelp: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    Label6: TLabel;
    Layout3: TLayout;
    Rectangle4: TRectangle;
    Image2: TImage;
    Rectangle5: TRectangle;
    TabItem3: TTabItem;
    Image4: TImage;
    Image5: TImage;
    Label7: TLabel;
    Layout5: TLayout;
    Rectangle6: TRectangle;
    Image6: TImage;
    Rectangle7: TRectangle;
    lbiHelp: TListBoxItem;
    TabItem4: TTabItem;
    Image7: TImage;
    Label8: TLabel;
    Rectangle9: TRectangle;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure sbItemSettingsClick(Sender: TObject);
    procedure sbRefreshClick(Sender: TObject);
    procedure sbDeleteWidgetClick(Sender: TObject);
    procedure sbRemoveContentClick(Sender: TObject);
    procedure sbAppContentItemClick(Sender: TObject);
    procedure sbApplyContentChangesClick(Sender: TObject);
    procedure sbCancelContentChangesClick(Sender: TObject);
    procedure sbBackClick(Sender: TObject);
    procedure sbAppWidgetsClick(Sender: TObject);
    procedure btnSaveSettingsClick(Sender: TObject);
    procedure btnCancelSettingsChangeClick(Sender: TObject);
    procedure tcPagesGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure lvAppWidgetsDeleteItem(Sender: TObject; AIndex: Integer);
    procedure lbiExitClick(Sender: TObject);
    procedure lbPopupExit(Sender: TObject);
    procedure lbPopupItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure lbContentItemsItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure lbWidgetsItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure lbiRunClick(Sender: TObject);
    procedure lbiHelpClick(Sender: TObject);
    procedure lbiSaveClick(Sender: TObject);
    procedure scrlAreaClick(Sender: TObject);
    procedure tbEditorFooterGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure StartAppAnimationFinish(Sender: TObject);
    procedure Rectangle2Click(Sender: TObject);
    procedure spbEditorClick(Sender: TObject);
  private
    fSettings: TSettings;
    fProductsPath: String;
    fFileName: String;
    fChanged: Boolean;
    fShowedHints: set of 0 .. 255;
    fLastDistance: Integer;
    ComplexSelection: TComplexSelection;
    GestureEnabled: Boolean;
    ContentItemsShown: Boolean;
    SettingsConstructor: TListBoxSettingsConstructor;
    procedure LoadSettings;
    procedure SaveSettings;
    procedure UpdateApp;
    procedure CenterizeAppLayout;

    procedure WidgetShowEvent(Widget: TWidget);
    procedure ContentItemClick(Sender: TContentItem);
    procedure ContentItemDeactivate(Sender: TContentItem);

    // Selection
    procedure ShowSelection(SelectedItem: TContentItem);
    procedure HideSelection(ApplyChanges: Boolean = false);
    procedure SelectionResize(Sender: TObject);

    procedure ShowAppWidgets(AppProduct: TAppProduct);
    procedure ShowItemSettings;
    procedure DoSettingSelect(Index: Integer; SettingType: TSettingType;
      var Value: String; var StandartAction: Boolean);
    function BitmapSaverHandler(Image: TBitmap): Integer;

    procedure ShowContentItems;
    procedure HideContentItems;

    // Content Controls
    procedure ShowRegisteredWidgets;
    procedure ShowRegisteredContentItems;

    // AppProducts
    procedure InstallAppProducts;
    procedure RunAppProducts;

    procedure ShowHint(Index: SmallInt);
    procedure HideHint;
  public
    AppProduct: TAppProduct;
    procedure CreateAppProduct(AppName: String; TemplateFileName: String = '');
    procedure SaveAppProduct(FileName: String = '');
    procedure LoadAppProduct(FileName: String);
  end;

var
  frmEditor: TfrmEditor;

resourcestring
  MSG_ASK_SAVE_CHANGES = 'Сохранить изменения в приложении "%s"?';
  MSG_ASK_CLOSE = 'Завершить редактирование приложения "%s"?';

implementation

uses
{$IFDEF Android}
  FMX.Platform.Android, FMX.Helpers.Android,
  Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Net, Posix.Pthread, Posix.SysTypes,
{$ENDIF}
  ContentCollection, Widgets, Math, System.IOUtils,
  System.UIConsts, uProducts, uChooseNaviStyle, Android.JNI.Toast, uIcons,
  INIFiles;

type
  TSettingsThread = class(TThread)
  private
    fSettings: TSettings;
    fSettingsConstructor: TListBoxSettingsConstructor;
  protected
    procedure Execute; override;
    procedure Finished;
  public
    constructor Create(const Settings: TSettings;
      const SettingsConstructor: TListBoxSettingsConstructor);
  end;

{$R *.fmx}

procedure TfrmEditor.FormCreate(Sender: TObject);
begin
  fProductsPath := TPath.GetSharedDownloadsPath + TPath.DirectorySeparatorChar +
    'AppFactory' + TPath.DirectorySeparatorChar + 'Products' +
    TPath.DirectorySeparatorChar;

  ComplexSelection := TComplexSelection.Create(ltApp);
  ComplexSelection.OnSelectionResize := SelectionResize;

  with scrlArea do
  begin
    AniCalculations.BoundsAnimation := true;
    AniCalculations.Animation := true;
    AniCalculations.TouchTracking := [ttVertical];
  end;

  AppProduct := TAppProduct.Create(ltApp);
  with AppProduct do
  begin
    Content.DesignMode := true;
    Content.OnWidgetShow := WidgetShowEvent;
    Content.OnItemClick := ContentItemClick;
    Content.OnItemDeactivate := ContentItemDeactivate;
    Content.OnGesture := tcPagesGesture;
  end;

  SettingsConstructor := TListBoxSettingsConstructor.Create(lvItemSettings);
  SettingsConstructor.BitmapSaverFunc := BitmapSaverHandler;
  SettingsConstructor.OnSettingSelect := DoSettingSelect;

  ShowRegisteredWidgets;
  ShowRegisteredContentItems;
  ShowAppWidgets(AppProduct);

  UpdateApp;
  tcPages.TabPosition := TTabPosition.tpNone;
  lbPopup.BringToFront;

  LoadSettings;
end;

procedure TfrmEditor.FormDestroy(Sender: TObject);
begin
  SaveSettings;
  ComplexSelection.Free;
  AppProduct.Free;
end;

procedure TfrmEditor.FormShow(Sender: TObject);
begin
  tcPages.ActiveTab := tabEditor;
  GestureEnabled := true;
  if ContentItemsShown then
  begin
    ContentItemsShown := false;
    tcPages.Position.Y := 0;
  end;
  ShowHint(0);
end;

procedure TfrmEditor.HideContentItems;
begin
  ContentItemsShown := false;
  if tcPages.Position.Y <> 0 then
    tcPages.AnimateFloatWait('Position.Y', 0, 0.5);
end;

procedure TfrmEditor.HideHint;
begin
  tcHelp.Visible := false;
end;

procedure TfrmEditor.btnCancelSettingsChangeClick(Sender: TObject);
begin
  ShowEditorAction.ExecuteTarget(tcPages.ActiveTab);
  ShowHint(2);
end;

procedure TfrmEditor.btnSaveSettingsClick(Sender: TObject);
var
  I, n: Integer;
begin
  if SettingsConstructor.Constructing then
    exit;
  if fSettings <> nil then
  begin
    fSettings.BeginUpdate;
    n := 0;
    for I := 0 to fSettings.Count - 1 do
    begin
      if (fSettings[I].SettingType = cstSpecial) then
        Continue;
      if (fSettings[I].SettingType = cstNone) or
        (fSettings[I].SettingType = cstIcon) then
      begin
        inc(n);
        Continue;
      end;
      fSettings.SetValue(I, SettingsConstructor.GetValue(n));
      inc(n);
    end;
    fSettings.EndUpdate;
    fSettings.Update;
  end;
  fChanged := true;
  UpdateApp;
  ShowAppWidgets(AppProduct);
  ShowEditorAction.ExecuteTarget(tcPages.ActiveTab);
  ShowHint(2);
end;

procedure TfrmEditor.ContentItemClick(Sender: TContentItem);
begin
  if Sender <> nil then
  begin
    HideSelection(true);
    Application.ProcessMessages;
    ShowSelection(Sender);
  end;
end;

procedure TfrmEditor.ContentItemDeactivate(Sender: TContentItem);
begin
  HideSelection(true);
end;

procedure TfrmEditor.SaveSettings;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(TPath.GetHomePath + TPath.DirectorySeparatorChar +
    'config.ini');
  try
    if ([0, 1, 2, 3] = fShowedHints) then
      Ini.WriteBool('Editor', 'ShowHints', false)
    else
      Ini.WriteBool('Editor', 'ShowHints', true);
  finally
    Ini.Free;
  end;
end;

procedure TfrmEditor.LoadSettings;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(TPath.GetHomePath + TPath.DirectorySeparatorChar +
    'config.ini');
  try
    if not Ini.ReadBool('Editor', 'ShowHints', true) then
      fShowedHints := [0, 1, 2, 3];
  finally
    Ini.Free;
  end;
end;

// ----------------------------------------------------------------------------
// AppProduct
// ----------------------------------------------------------------------------

procedure TfrmEditor.CreateAppProduct(AppName, TemplateFileName: String);
var
  AppLoader: TAppLoader;
begin
  HideSelection(true);
  if fChanged then
    case MessageDlg(Format(MSG_ASK_SAVE_CHANGES,
      [AppProduct.Settings.GetValue('Name')]), TMsgDlgType.mtConfirmation,
      [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo, TMsgDlgBtn.mbCancel], -1) of
      mrYes:
        SaveAppProduct;
      mrCancel:
        exit;
    end;
  AppProduct.ClearAll;
  if not TemplateFileName.IsEmpty then
  begin
    LoadAppProduct(TemplateFileName);
  end;
  AppProduct.Settings.SetValue('Name', AppName);
  ShowAppWidgets(AppProduct);
end;

procedure TfrmEditor.SaveAppProduct(FileName: String = '');
var
  AppSaver: TAppSaver;
begin
  HideSelection(true);
  if FileName.IsEmpty then
    fFileName := fProductsPath + AppProduct.Settings.GetValue('Name') + '.xml'
  else
    fFileName := FileName;

  AppSaver := TXMLAppSaver.Create(AppProduct, fFileName);

  if AppSaver.Save then
  begin
    fChanged := false;
    Toast('Saved to: ' + fFileName);
  end
  else
    Toast('Не удалось сохранить файл ' + fFileName);
end;

procedure TfrmEditor.LoadAppProduct(FileName: String);
var
  AppLoader: TAppLoader;
begin
  HideSelection(true);
  if fChanged then
    case MessageDlg(Format(MSG_ASK_SAVE_CHANGES,
      [AppProduct.Settings.GetValue('Name')]), TMsgDlgType.mtConfirmation,
      [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo, TMsgDlgBtn.mbCancel], -1) of
      mrYes:
        SaveAppProduct;
      mrCancel:
        exit;
    end;

  AppLoader := TXMLAppLoader.Create(AppProduct, FileName);
  if AppLoader.Load then
  begin
    fFileName := FileName;
    fChanged := false;
    Toast('Loaded from: ' + FileName);
    ShowAppWidgets(AppProduct);
  end;
end;

// ----------------------------------------------------------------------------

procedure TfrmEditor.DoSettingSelect(Index: Integer; SettingType: TSettingType;
  var Value: String; var StandartAction: Boolean);
var
  I, Shift: Integer;
begin
  if (fSettings = AppProduct.Settings) and
    (AppProduct.Settings[Index].Name = 'NavigationStyle') then
  begin
    frmChooseNaviStyle.ShowModal(
      procedure(ModalResult: TModalResult)
      var
        NavigationStyle: String;
      begin
        if ModalResult = mrOk then
        begin
          case frmChooseNaviStyle.lbNavigationStyle.ItemIndex of
            0:
              NavigationStyle := TTabNavigationContent.ClassName;
            1:
              NavigationStyle := TBottomTabNavigationContent.ClassName;
            2:
              NavigationStyle := TListNavigationContent.ClassName;
          end;
          fSettings.SetValue('NavigationStyle', NavigationStyle);
        end;
        frmChooseNaviStyle.Hide;
      end);
    StandartAction := false;
    exit;
  end;

  Shift := 0;
  for I := Index - 1 downto 0 do
    if fSettings[I].SettingType = cstSpecial then
      inc(Shift);
  Index := Index + Shift;

  if fSettings[Index].Name = 'Icon' then
  begin
    frmIcons.ShowModal(
      procedure(ModalResult: TModalResult)
      begin
        if ModalResult = mrOk then
        begin
          fSettings.SetValue(Index, frmIcons.IconIndex.ToString);
        end;
        frmIcons.Hide;
      end);
    StandartAction := false;
  end;
  lvItemSettings.SetFocus;
end;

procedure TfrmEditor.lbContentItemsItemClick(const Sender: TCustomListBox;
const Item: TListBoxItem);
var
  NewItem: TContentItem;
begin
  if lbContentItems.ItemIndex <> -1 then
  begin
    NewItem := ContentItemsLibrary[lbContentItems.ItemIndex].Create;
    AppProduct.Content.Add(NewItem);
    ContentItemClick(NewItem);
    ComplexSelection.SizeChanged := true;
    scrlArea.ScrollTo(0, Height);
    fChanged := true;
    sbAppContentItemClick(Self);
    ShowHint(1);
  end;
end;

procedure TfrmEditor.lbPopupExit(Sender: TObject);
begin
  lbPopup.Visible := false;
end;

procedure TfrmEditor.lbPopupItemClick(const Sender: TCustomListBox;
const Item: TListBoxItem);
begin
  lbPopupExit(Self);
end;

procedure TfrmEditor.lbiSaveClick(Sender: TObject);
begin
  SaveAppProduct;
end;

procedure TfrmEditor.lbiHelpClick(Sender: TObject);
begin
  fShowedHints := [];
  ShowHint(0);
end;

procedure TfrmEditor.lbiExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmEditor.lbiRunClick(Sender: TObject);
begin
  RunAppProducts;
end;

procedure TfrmEditor.lvAppWidgetsDeleteItem(Sender: TObject; AIndex: Integer);
begin
  AppProduct.Widgets.Delete(AIndex);
  UpdateApp;
  ShowAppWidgets(AppProduct);
end;

procedure TfrmEditor.lbWidgetsItemClick(const Sender: TCustomListBox;
const Item: TListBoxItem);
begin
  if lbWidgets.ItemIndex <> -1 then
    AppProduct.Widgets.Add(WidgetsLibrary[lbWidgets.ItemIndex].Clone);
  fChanged := true;
  UpdateApp;
  ShowAppWidgets(AppProduct);
  ShowAppWidgetsAction.ExecuteTarget(tcPages.ActiveTab);
end;

procedure TfrmEditor.ShowAppWidgets(AppProduct: TAppProduct);
var
  I: Integer;
begin
  lvAppWidgets.Items.Clear;
  for I := 0 to AppProduct.Widgets.Count - 1 do
    with lvAppWidgets.Items.Add do
    begin
      Text := AppProduct.Widgets[I].Caption;
      Detail := AppProduct.Widgets[I].Name;
      Bitmap := frmIcons.GetIcon(1, AppProduct.Widgets[I].Settings.GetValue
        ('Icon').ToInteger);
    end;
  ltNoWidgets.Visible := AppProduct.Widgets.Count = 0;
end;

procedure TfrmEditor.ShowContentItems;
begin
  ContentItemsShown := true;
  if tcPages.Position.Y = 0 then
    tcPages.AnimateFloat('Position.Y', -pnlContentItems.Height, 0.5);
end;

procedure TfrmEditor.ShowItemSettings;
var
  SelectedItem: TContentItem;
begin
  HideHint;
  ShowItemSettingsAction.ExecuteTarget(tcPages.ActiveTab);

  if fSettings <> nil then
  begin
    if fSettings = AppProduct.Settings then
      lblSettings.Text := 'Настрока приложения'
    else if Assigned(ComplexSelection.SelectedControl) and
      (ComplexSelection.SelectedControl is TContentItem) then
    begin
      SelectedItem := TContentItem(ComplexSelection.SelectedControl);
      HideSelection(true);
      fSettings := SelectedItem.Settings;
      lblSettings.Text := 'Настрока элемента';
    end
    else
      lblSettings.Text := 'Настрока виджета';
  end
  else
  begin
    lblSettings.Text := 'Настрока приложения';
    fSettings := AppProduct.Settings;
  end;

  TSettingsThread.Create(fSettings, SettingsConstructor).Start;
end;

procedure TfrmEditor.UpdateApp;
begin
  HideSelection(true);
  AppProduct.build;
  tbEditorHeader.BringToFront;
end;

procedure TfrmEditor.WidgetShowEvent(Widget: TWidget);
begin
  fSettings := Widget.Settings;
end;


// Content Controls Lists
// ----------------------------------------------------------------------------

procedure TfrmEditor.ShowRegisteredContentItems;
var
  I: Integer;
  Item: TListBoxItem;
begin
  lbContentItems.Items.Clear;
  for I := 0 to ContentItemsLibrary.Count - 1 do
    if not ContentItemsLibrary[I].InheritsFrom(TWidgetsContent) then
    begin
      Item := TListBoxItem.Create(nil);
      Item.Parent := lbContentItems;
      Item.StyleLookup := 'CustomItem';
      Item.Text := ContentItemsLibrary[I].ContentName;
      Item.ItemData.Bitmap.SetSize(48, 48);
      Item.ItemData.Bitmap := frmIcons.GetIcon(0, I);
    end;
end;

procedure TfrmEditor.ShowRegisteredWidgets;
var
  I: Integer;
  Item: TListBoxItem;
begin
  lbWidgets.Items.Clear;
  for I := 0 to WidgetsLibrary.Count - 1 do
  begin
    Item := TListBoxItem.Create(nil);
    Item.Parent := lbWidgets;
    Item.StyleLookup := 'WidgetItem';
    Item.Text := WidgetsLibrary[I].Caption;
    Item.Height := 80;
    Item.ItemData.Bitmap := frmIcons.GetIcon(1, WidgetsLibrary[I].IconIndex);
  end;
end;
// ----------------------------------------------------------------------------

// Selection
// ----------------------------------------------------------------------------

procedure TfrmEditor.ShowSelection(SelectedItem: TContentItem);
begin
  if not SelectedItem.Selectable then
    exit;
  ComplexSelection.Select(SelectedItem);
  fSettings := SelectedItem.Settings;
  // Запретим скроллинг во время выделения
  scrlArea.AniCalculations.TouchTracking := [];
  // Обновляем состояние кнопок
  sbRemoveContent.Visible := true;
  sbCancelContentChanges.Visible := false;
  sbApplyContentChanges.Visible := false;
end;

procedure TfrmEditor.spbEditorClick(Sender: TObject);
begin
  ShowEditorAction.ExecuteTarget(tcPages.ActiveTab);
  ShowHint(3);
end;

procedure TfrmEditor.HideSelection(ApplyChanges: Boolean);
var
  SelectedItem: TContentItem;
begin
  fSettings := nil;
  GestureEnabled := true;
  if ComplexSelection.SelectedControl = nil then
    exit;
  ComplexSelection.Selection.HitTest := true;

  if ComplexSelection.SelectedControl is TContentItem then
  begin
    SelectedItem := TContentItem(ComplexSelection.SelectedControl);
    if not SelectedItem.Selectable then
      exit;
    // Устанавливаем новые параметры расположения
    with SelectedItem do
    begin
      if ComplexSelection.SizeChanged and ApplyChanges and
        Settings.Registered('Height') then
      begin
        fChanged := true;
        Settings.BeginUpdate;
        Settings.SetValue('Height', Round(ComplexSelection.Selection.Height)
          .ToString);
        Settings.SetValue('Width', Round(ComplexSelection.Selection.Width)
          .ToString);
        Settings.EndUpdate;
        ComplexSelection.Unselect;
      end
      else
        ComplexSelection.Unselect(true);
    end;
  end
  else
    ComplexSelection.Unselect;

  // Разрешаем скроллинг
  scrlArea.AniCalculations.TouchTracking := [ttVertical];

  // Обновляем состояние кнопок
  sbApplyContentChanges.Visible := false;
  sbCancelContentChanges.Visible := false;
  sbRemoveContent.Visible := false;

  pnlApplication.UpdateEffects;
end;

procedure TfrmEditor.SelectionResize(Sender: TObject);
begin
  if not sbApplyContentChanges.Visible then
  begin
    tbEditorFooter.BeginUpdate;
    sbApplyContentChanges.Align := TAlignLayout.alNone;
    sbCancelContentChanges.Align := TAlignLayout.alNone;

    sbApplyContentChanges.Visible := true;
    sbCancelContentChanges.Visible := true;
    sbApplyContentChanges.Position.X := sbCancelContentChanges.Position.X + 1;

    sbApplyContentChanges.Align := TAlignLayout.alRight;
    sbCancelContentChanges.Align := TAlignLayout.alRight;
    tbEditorFooter.EndUpdate;
    GestureEnabled := false;
    fChanged := true;
  end;
end;

// ----------------------------------------------------------------------------

procedure TfrmEditor.sbRefreshClick(Sender: TObject);
begin
  UpdateApp;
end;

procedure TfrmEditor.sbDeleteWidgetClick(Sender: TObject);
begin
  if lvAppWidgets.ItemIndex <> -1 then
    AppProduct.Widgets.Delete(lvAppWidgets.ItemIndex);
  UpdateApp;
  ShowAppWidgets(AppProduct);
end;

procedure TfrmEditor.sbCancelContentChangesClick(Sender: TObject);
begin
  HideSelection;
  // fSelectedItem := nil;
end;

procedure TfrmEditor.sbAppContentItemClick(Sender: TObject);
begin
  if ContentItemsShown then
  begin
    sbAppContentItem.StyleLookup := 'additembutton';
    HideContentItems;
  end
  else
  begin
    HideHint;
    sbAppContentItem.StyleLookup := 'arrowdowntoolbutton';
    ShowContentItems;
  end;
end;

procedure TfrmEditor.StartAppAnimationFinish(Sender: TObject);
begin
  RunAppProducts;
  tcPages.Position.Y := 0;
  pnlContentItems.Visible := true;
end;

procedure TfrmEditor.sbRemoveContentClick(Sender: TObject);
var
  SelectedItem: TContentItem;
begin
  if ComplexSelection.SelectedControl <> nil then
  begin
    SelectedItem := TContentItem(ComplexSelection.SelectedControl);
    HideSelection;
    AppProduct.Content.Remove(SelectedItem);
    fChanged := true;
    UpdateApp;
  end;
end;

procedure TfrmEditor.ShowHint(Index: SmallInt);
begin
  if not(Index in fShowedHints) then
  begin
    Include(fShowedHints, Index);
    tcHelp.Visible := true;
    tcHelp.Opacity := 0;
    tcHelp.TabIndex := Index;
    tcPages.ActiveTab := tabEditor;
    tcHelp.AnimateFloat('Opacity', 1, 0.5);
  end;
end;

procedure TfrmEditor.scrlAreaClick(Sender: TObject);
begin
  HideSelection(true);
end;

procedure TfrmEditor.CenterizeAppLayout;
var
  LayoutCenter: TPointF;
begin
  with pnlApplication do
  begin
    LayoutCenter := PointF(scrlArea.Width / 2, scrlArea.Height / 2);
    Position.X := max(0, LayoutCenter.X - (Width * Scale.X / 2));
    Position.Y := max(0, LayoutCenter.Y - (Height * Scale.Y / 2));
  end;
end;

procedure TfrmEditor.sbApplyContentChangesClick(Sender: TObject);
begin
  HideSelection(true);
  // fSelectedItem := nil;
end;

procedure TfrmEditor.sbAppWidgetsClick(Sender: TObject);
begin
  ShowAppWidgetsFXAction.ExecuteTarget(tabEditor);
  HideHint;
end;

procedure TfrmEditor.sbBackClick(Sender: TObject);
begin
  fSettings := nil;
  ShowEditorAction.ExecuteTarget(tabItemSettings);
end;

procedure TfrmEditor.sbItemSettingsClick(Sender: TObject);
begin
  ShowItemSettings;
end;

procedure TfrmEditor.Rectangle2Click(Sender: TObject);
begin
  tcHelp.Visible := false;
end;

procedure TfrmEditor.FormResize(Sender: TObject);
begin
  pnlApplication.Width := frmEditor.Width;
  pnlApplication.Height := frmEditor.Height;
  CenterizeAppLayout;
end;

// ----------------------------------------------------------------------------

function TfrmEditor.BitmapSaverHandler(Image: TBitmap): Integer;
var
  FileName: String;
begin
  Result := -1;
  if Assigned(Image) then
  begin
    FileName := TPath.GetTempPath + TPath.DirectorySeparatorChar +
      TPath.GetRandomFileName + '.png';
    Image.SaveToFile(FileName);
    Result := AppProduct.Content.Resources.Add(FileName);
  end;
end;

// ----------------------------------------------------------------------------

procedure TfrmEditor.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if fChanged then
  begin
    case MessageDlg(Format(MSG_ASK_SAVE_CHANGES,
      [AppProduct.Settings.GetValue('Name')]), TMsgDlgType.mtConfirmation,
      [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo, TMsgDlgBtn.mbCancel], -1) of
      mrYes:
        SaveAppProduct;
      mrNo:
        fChanged := false;
      mrCancel:
        CanClose := false;
    end;
  end
  else if MessageDlg(Format(MSG_ASK_CLOSE, [AppProduct.Settings.GetValue('Name')
    ]), TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbOK, TMsgDlgBtn.mbCancel], -1)
    = mrCancel then
    CanClose := false;
end;


// ----------------------------------------------------------------------------
// AppProducts Application
// ----------------------------------------------------------------------------

procedure TfrmEditor.RunAppProducts;
{$IFDEF Android}
var
  PackageManager: JPackageManager;
  Intent: JIntent;
  TempFileName: String;
  OldChanged: Boolean;
{$ENDIF}
begin
{$IFDEF Android}
  PackageManager := SharedActivityContext.getPackageManager();
  Intent := SharedActivityContext.getPackageManager().getLaunchIntentForPackage
    (StringToJString('com.pavellitvinko.AppProducts'));
  if Assigned(Intent) then
  begin
    // Сохраняем приложение во временный файл, чтобы после запуска можно
    // было бы отменить сделанные изменения
    if fChanged or fFileName.IsEmpty then
    begin
      TempFileName := TPath.GetTempFileName + '.xml';
      SaveAppProduct(TempFileName);
      fChanged := true;
    end
    else
      TempFileName := fFileName;

    Intent.putExtra(StringToJString('FileName'), StringToJString(TempFileName));
    MainActivity.startActivity(Intent);
  end
  else
    ShowMessage
      ('Не удалось найти AppProducts. Чтобы запускать ваши приложения, установите AppProducts!');
{$ENDIF}
end;

procedure TfrmEditor.InstallAppProducts;
{$IFDEF Android}
var
  Intent: JIntent;
  TempFileName: String;
  OldChanged: Boolean;
  apkUri: Jnet_Uri;
  apkFile: JFile;
  Uri_Builder: JUri_Builder;
{$ENDIF}
begin
{$IFDEF Android}
  // ALOOPER_POLL_ERROR
  Intent := TJIntent.Create;
  if Assigned(Intent) then
  begin
    Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);

    apkUri := TJnet_Uri.JavaClass.parse
      ((StringToJString(TPath.Combine(TPath.GetDocumentsPath,
      'AppProducts.apk'))));

    Intent.setType(StringToJString('application/vnd.android.package-archive'));
    Intent.setData(apkUri);
    MainActivity.startActivity(Intent);
  end;
{$ENDIF}
end;

// ----------------------------------------------------------------------------




// ----------------------------------------------------------------------------
// Form Control Procedures
// ----------------------------------------------------------------------------

// Gestures
// ----------------------------------------------------------------------------

procedure TfrmEditor.tbEditorFooterGesture(Sender: TObject;
const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  case EventInfo.GestureID of
    sgiUp:
      begin
        if ContentItemsShown then
          HideContentItems;
        pnlContentItems.Visible := false;
        if imgSwipeUpTip.Visible then
          imgSwipeUpTip.Visible := false;
        StartAppAnimation.StopValue := tcPages.Height * -1;
        StartAppAnimation.Start;
      end;
    sgiDown:
      if ContentItemsShown then
        HideContentItems;
  end;
end;

procedure TfrmEditor.tcPagesGesture(Sender: TObject;
const EventInfo: TGestureEventInfo; var Handled: Boolean);
const
  cfScale = 0.005;
var
  CPoint: TPointF;
begin
  if GestureEnabled then
    case EventInfo.GestureID of
      sgiLeft:
        begin
          if ContentItemsShown then
          begin
            sbAppContentItem.StyleLookup := 'additembutton';
            HideContentItems;
          end;

          if tcPages.TabIndex < tcPages.TabCount - 2 then
          // Игнорируем переход с tabItemSettings на tabWidgets
          begin
            if tcPages.ActiveTab = tabEditor then
              ShowItemSettings
            else
              tcPages.SetActiveTabWithTransition
                (tcPages.Tabs[tcPages.TabIndex + 1], TTabTransition.ttSlide);
          end;
          Handled := true;
          HideHint;
        end;

      sgiRight:
        begin
          if ContentItemsShown then
          begin
            sbAppContentItem.StyleLookup := 'additembutton';
            HideContentItems;
          end;
          if tcPages.TabIndex > 0 then
            if tcPages.ActiveTab = tabWidgets then
              tcPages.SetActiveTabWithTransition(tabAppWidgets,
                TTabTransition.ttSlide, TTabTransitionDirection.tdReversed)
            else
              tcPages.SetActiveTabWithTransition
                (tcPages.Tabs[tcPages.TabIndex - 1], TTabTransition.ttSlide,
                TTabTransitionDirection.tdReversed);
          Handled := true;
          HideHint;
        end;

      igiZoom:
        begin
          with pnlApplication do
          begin
            if (not(TInteractiveGestureFlag.gfBegin in EventInfo.Flags)) and
              (not(TInteractiveGestureFlag.gfEnd in EventInfo.Flags)) then
            begin
              Scale.X := Scale.X + (EventInfo.Distance - fLastDistance)
                * cfScale;
              Scale.Y := Scale.Y + (EventInfo.Distance - fLastDistance)
                * cfScale;

              Scale.X := min(3, Scale.X);
              Scale.Y := min(3, Scale.Y);
              Scale.X := max(0.2, Scale.X);
              Scale.Y := max(0.2, Scale.Y);

              CenterizeAppLayout;
            end;
            if (TInteractiveGestureFlag.gfEnd in EventInfo.Flags) then
            begin
              if (Scale.X >= 0.8) and (Scale.X <= 1.2) then
              begin
                AnimateFloat('Scale.X', 1);
                AnimateFloat('Scale.Y', 1);

                with pnlApplication do
                begin
                  CPoint := PointF(scrlArea.Width / 2, scrlArea.Height / 2);
                  Position.X := max(0, CPoint.X - (Width / 2));
                  Position.Y := max(0, CPoint.Y - (Height / 2));
                end;
              end
            end;
          end;
          fLastDistance := EventInfo.Distance;
          Handled := true;
        end;
      { igiLongTap:
        if TInteractiveGestureFlag.gfBegin in EventInfo.Flags then
        begin
        if (tcPages.ActiveTab = tabEditor) and
        Assigned(ComplexSelection.SelectedControl) and
        (ComplexSelection.SelectedControl is TContentItem) then
        ShowItemSettings;
        Handled := true;
        end; }
    end;
end;


// Hardware Buttons
// ----------------------------------------------------------------------------

procedure TfrmEditor.FormKeyUp(Sender: TObject; var Key: Word;
var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkHardwareBack then
  begin
    if lbPopup.Visible then
    begin
      // Прячем контекстное меню
      lbPopup.Visible := false;
      Key := 0;
      exit;
    end;
    if ContentItemsShown then
    begin
      // Прячем меню добавления элементов
      sbAppContentItemClick(Self);
      Key := 0;
      exit;
    end;
    if (tcPages.ActiveTab <> tabEditor) then
    begin
      ShowEditorAction.ExecuteTarget(tcPages.ActiveTab);
      Key := 0;
      exit;
    end;
    Self.Close; // Иначе - закрываем окно редактора
    Key := 0;
  end
  else if Key = sgiUpRightLong then
  begin
    lbPopup.Visible := true;
    lbPopup.SetFocus;
    Key := 0;
  end;
end;


// ============================================================================

{ TSettingsThread }

constructor TSettingsThread.Create(const Settings: TSettings;
const SettingsConstructor: TListBoxSettingsConstructor);
begin
  inherited Create(true);
  fSettings := Settings;
  fSettingsConstructor := SettingsConstructor;
end;

procedure TSettingsThread.Execute;
var
  I: Integer;
begin
  inherited;
  try
    with fSettingsConstructor do
    begin
      BeginConstruct;
      Reset;
      for I := 0 to fSettings.Count - 1 do
      begin
        try
          case fSettings[I].SettingType of
            cstAlignment:
              AddAlign(fSettings[I].Caption,
                TAlignLayout(fSettings[I].Value.ToInteger));
            cstBoolean:
              AddBool(fSettings[I].Caption, fSettings[I].Value.ToBoolean);
            cstString:
              AddString(fSettings[I].Caption, fSettings[I].Value);
            cstText:
              AddText(fSettings[I].Caption, fSettings[I].Value);
            cstInteger:
              AddInteger(fSettings[I].Caption, fSettings[I].Value.ToExtended);
            cstImage:
              AddImage(fSettings[I].Caption, fSettings[I].Value);
            cstColor:
              AddColor(fSettings[I].Caption,
                StringToAlphaColor(fSettings[I].Value));
            cstWrapMode:
              AddWrapMode(fSettings[I].Caption,
                TImageWrapMode(fSettings[I].Value.ToInteger));
            cstTextAlign:
              AddTextAlign(fSettings[I].Caption,
                TTextAlign(fSettings[I].Value.ToInteger));
            cstSpecial:
              ;
          else
            AddUnknown(fSettings[I].Caption, fSettings[I].Value);
          end;
        except
          on E: EConvertError do
          begin
            fSettings.SetValue(I, '0');
            AddUnknown('!' + fSettings[I].Caption, fSettings[I].Value);
            Toast(Format('Неверное значение параметра "%s"',
              [fSettings[I].Caption]));
          end;
        end;
      end;
      EndConstruct;
    end;
    Synchronize(Finished);
{$IFDEF Android}
    // Keep the thread running
    while not Terminated do
    begin
      Sleep(100);
    end;
{$ENDIF}
  except
    Toast('Не удалось загрузить настройки элемента.');
{$IFDEF Android}
    while not Terminated do
    begin
      Sleep(100);
    end;
{$ENDIF}
  end;
end;

procedure TSettingsThread.Finished;
begin
  fSettingsConstructor.ListBox.Visible := true;
end;

end.
