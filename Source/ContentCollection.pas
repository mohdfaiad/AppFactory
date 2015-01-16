unit ContentCollection;

interface

uses Content, FMX.StdCtrls, FMX.Types, FMX.TabControl, FMX.ListView,
  System.Generics.Collections, FMX.Objects;

type
  // Contents Collection
  // ---------------------------------------------------
  THeader = class(TContentItem)
  private
    fToolBar: TToolBar;
    lblTitle: TLabel;
  public
    class function ContentName: String; override;
    procedure ApplySettings; override;
    constructor Create; override;
    destructor Destroy; override;
  end;

  TFooter = class(THeader)
  public
    class function ContentName: String; override;
    constructor Create; override;
  end;

  TVisualItem = class(TContentItem)
  public
    procedure ApplySettings; override;
    constructor Create; override;
  end;

  TLabelItem = class(TVisualItem)
  private
    fLabel: TLabel;
  public
    class function ContentName: String; override;
    procedure ApplySettings; override;
    constructor Create; override;
    destructor Destroy; override;
  end;

  TImageItem = class(TVisualItem)
  private
    fImage: TImage;
  public
    class function ContentName: String; override;
    procedure ApplySettings; override;
    constructor Create; override;
    destructor Destroy; override;
  end;

  TShapeItem = class(TVisualItem)
  protected
    fRectangle: TRectangle;
  public
    class function ContentName: String; override;
    procedure ApplySettings; override;
    constructor Create; override;
    destructor Destroy; override;
  end;

  TBackground = class(TShapeItem)
    class function ContentName: String; override;
    procedure ApplySettings; override;
    constructor Create; override;
  end;

  // Navigation
  // ---------------------------------------------------
  TTabNavigationContent = class(TWidgetsContent)
  private
    fTabControl: TTabControl;
  protected
    procedure TabClick(Sender: TObject); virtual;
  public
    constructor Create; override;
    procedure Build; override;
    destructor Destroy; override;
    class function ContentName: String; override;
  end;

  TBottomTabNavigationContent = class(TTabNavigationContent)
    constructor Create; override;
    class function ContentName: String; override;
  end;

  TListNavigationContent = class(TTabNavigationContent)
  private
    fListView: TListView;
    fbtnBack: TSpeedButton;
    procedure CreateBackButton;
    procedure BackClick(Sender: TObject);
    procedure ItemClick(const Sender: TObject; const AItem: TListViewItem);
    function FindHeaderToolbar(var ContainsBackBtn: Boolean): TToolBar;
  protected
    procedure TabClick(Sender: TObject); override;
  public
    constructor Create; override;
    procedure Build; override;
    destructor Destroy; override;
    class function ContentName: String; override;
  end;

  // Library
  // ---------------------------------------------------
  TContentItemsLibrary = class(TList<TContentItemClass>)
  public
    function Find(ContentName: String): TContentItemClass;
  end;

var
  ContentItemsLibrary: TContentItemsLibrary;

implementation

uses
  CustomSettings, System.SysUtils, System.IOUtils, FMX.Dialogs,
  System.UITypes, System.UIConsts, FMX.Graphics, uIcons;

// -----------------------------------------------------------------------------
// Contents Collection
// -----------------------------------------------------------------------------

{ THeader }

procedure THeader.ApplySettings;
begin
  lblTitle.Text := Settings.GetValue('Text');
end;

class function THeader.ContentName: String;
begin
  Result := 'Header';
end;

constructor THeader.Create;
begin
  inherited Create;
  Align := TAlignLayout.alTop;

  fToolBar := TToolBar.Create(Self);
  fToolBar.Parent := Self;
  fToolBar.Align := TAlignLayout.alClient;
  fToolBar.HitTest := False;

  lblTitle := TLabel.Create(fToolBar);
  with lblTitle do
  begin
    Parent := fToolBar;
    Align := TAlignLayout.alContents;
    StyleLookup := 'toollabel';
    TextAlign := TTextAlign.taCenter;
  end;
  lblTitle.OnEnter := DoItemEnter;
  lblTitle.OnExit := DoItemExit;

  with Settings do
  begin
    RegisterSetting(cstString, 'Text', 'Текст', 'Title');
  end;
  ApplySettings;
end;

destructor THeader.Destroy;
begin
  FreeAndNil(lblTitle);
  FreeAndNil(fToolBar);
  inherited;
end;

{ TFooter }

class function TFooter.ContentName: String;
begin
  Result := 'Footer';
end;

constructor TFooter.Create;
begin
  inherited Create;
  Align := TAlignLayout.alMostBottom;
  fToolBar.StyleName := 'bottomtoolbar';
  fToolBar.BringToFront;
  Settings.SetValue('Text', 'Footer');
  ApplySettings;
end;

{ TVisualItem }

procedure TVisualItem.ApplySettings;
var
  OldAlign: TAlignLayout;
  AHeight, AWidth, buf: Single;
begin
  inherited;
  with Settings do
  begin
    OldAlign := Align;
    Align := TAlignLayout(GetValue('Align').ToInteger);
    AHeight := GetValue('Height').ToExtended;
    AWidth := GetValue('Width').ToExtended;

    if (((Align = TAlignLayout.alLeft) or (Align = TAlignLayout.alRight)) and
      ((OldAlign = TAlignLayout.alBottom) or (OldAlign = TAlignLayout.alTop)))
      or (((OldAlign = TAlignLayout.alLeft) or (OldAlign = TAlignLayout.alRight)
      ) and ((Align = TAlignLayout.alBottom) or (Align = TAlignLayout.alTop)))
    then
    begin
      buf := AHeight;
      AHeight := AWidth;
      AWidth := buf;
    end;
    Height := AHeight;
    Width := AWidth;

    BeginUpdate;
    SetValue('Height', AHeight.ToString);
    SetValue('Width', AWidth.ToString);
    EndUpdate;
  end;
end;

constructor TVisualItem.Create;
begin
  inherited;
  Align := TAlignLayout.alTop;
  with Settings do
  begin
    RegisterSetting(cstAlignment, 'Align', 'Расположение', '1');
    RegisterSetting(cstInteger, 'Height', 'Высота', Height.ToString);
    // ! Реальный тип - Extended
    RegisterSetting(cstInteger, 'Width', 'Ширина', Width.ToString);
    // ! Реальный тип - Extended
  end;
end;

{ TImage }

procedure TImageItem.ApplySettings;
var
  ImageResIndex: Integer;
begin
  inherited;
  ImageResIndex := Settings.GetValue('Image').ToInteger;
  if ImageResIndex <> -1 then
    fImage.Bitmap.LoadFromFile(Content.Resources[ImageResIndex]);

  fImage.WrapMode := TImageWrapMode(Settings.GetValue('WrapMode').ToInteger);
end;

class function TImageItem.ContentName: String;
begin
  Result := 'Image';
end;

constructor TImageItem.Create;
begin
  inherited;
  fImage := TImage.Create(Self);
  fImage.Parent := Self;
  with fImage do
  begin
    Align := TAlignLayout.alClient;
    Bitmap := frmIcons.imgNoImage.Bitmap;
    HitTest := False;
  end;
  with Settings do
  begin
    RegisterSetting(cstImage, 'Image', 'Изображение', '-1');
    RegisterSetting(cstWrapMode, 'WrapMode', 'Выравнивание', '1');
  end;
end;

destructor TImageItem.Destroy;
begin
  fImage.DisposeOf;
  inherited;
end;

{ TShapeItem }

procedure TShapeItem.ApplySettings;
begin
  inherited;
  fRectangle.Fill.Color := StringToAlphaColor(Settings.GetValue('Color'));
end;

class function TShapeItem.ContentName: String;
begin
  Result := 'Shape';
end;

constructor TShapeItem.Create;
begin
  inherited;
  fRectangle := TRectangle.Create(Self);
  fRectangle.Parent := Self;
  with fRectangle do
  begin
    HitTest := False;
    Align := TAlignLayout.alClient;
    Fill.Color := $FFDFFFDF;
    Stroke.Kind := TBrushKind.bkNone;
  end;

  with Settings do
  begin
    RegisterSetting(cstColor, 'Color', 'Цвет', AlphaColorToString($FFDFFFDF));
  end;
end;

destructor TShapeItem.Destroy;
begin
  inherited;
end;

{ TBackground }

procedure TBackground.ApplySettings;
begin
  inherited;
  Align := TAlignLayout.alContents;
  Selectable := False;
  ContentPosition := TContentPosition.cpBack;
end;

class function TBackground.ContentName: String;
begin
  Result := 'Background';
end;

constructor TBackground.Create;
begin
  inherited;
  Align := TAlignLayout.alContents;
  Selectable := False;
  ContentPosition := TContentPosition.cpBack;
end;

{ TLabelItem }

procedure TLabelItem.ApplySettings;
begin
  inherited;
  fLabel.Text := Settings.GetValue('Text');
  fLabel.Font.Size := Settings.GetValue('FontSize').ToSingle;
  fLabel.FontColor := StringToAlphaColor(Settings.GetValue('FontColor'));
  fLabel.TextAlign := TTextAlign(Settings.GetValue('TextAlign').ToInteger);
end;

class function TLabelItem.ContentName: String;
begin
  Result := 'Label';
end;

constructor TLabelItem.Create;
begin
  inherited;
  fLabel := TLabel.Create(Self);
  fLabel.Parent := Self;
  with fLabel do
  begin
    StyledSettings := [TStyledSetting.ssFamily, { TStyledSetting.ssFontColor, }
    TStyledSetting.ssOther];
    HitTest := False;
    Align := TAlignLayout.alClient;
    Text := 'Текст';
  end;

  with Settings do
  begin
    RegisterSetting(cstString, 'Text', 'Текст', 'Текст');
    RegisterSetting(cstInteger, 'FontSize', 'Размер шрифта', '18');
    RegisterSetting(cstColor, 'FontColor', 'Цвет шрифта',
      AlphaColorToString(claBlack));
    RegisterSetting(cstTextAlign, 'TextAlign', 'Выравнивание', '0');
  end;
end;

destructor TLabelItem.Destroy;
begin
  fLabel.Free;
  inherited;
end;

// -----------------------------------------------------------------------------
// Navigation
// -----------------------------------------------------------------------------

{ TTabNavigationWidgets }

procedure TTabNavigationContent.Build;
var
  I: Integer;
  TabItem: TTabItem;
begin
  RestoreWidgets;
  while fTabControl.TabCount > 0 do
    fTabControl.Tabs[0].Parent := nil;

  for I := 0 to Content.Widgets.Count - 1 do
  begin
    TabItem := TTabItem.Create(fTabControl);
    TabItem.Parent := fTabControl;
    TabItem.Text := Content.Widgets[I].Caption;
    if Content.Widgets[I].Settings.GetValue('ShowIcon').ToBoolean then
    begin
      TabItem.CustomIcon.Bitmap :=
        frmIcons.GetIconAbs(Content.Widgets[I].Settings.GetValue('Icon')
        .ToInteger);
      TabItem.StyleLookup := 'tabitemcustom';
    end;
    TabItem.OnClick := TabClick;
    Content.Widgets[I].Show(TabItem);

    TabItem.UpdateRect;
  end;

  // Исправляет баг, когда элементы меньше положеного
  fTabControl.ApplyStyleLookup;
  for I := fTabControl.TabCount - 1 downto 0 do
    fTabControl.TabIndex := I;
end;

class function TTabNavigationContent.ContentName: String;
begin
  Result := 'TTabNavigationContent';
end;

constructor TTabNavigationContent.Create;
begin
  inherited;
  fTabControl := TTabControl.Create(Self);
  fTabControl.Parent := Self;
  with fTabControl do
  begin
    Align := TAlignLayout.alClient;
    FullSize := true;
  end;
end;

destructor TTabNavigationContent.Destroy;
begin
  if Assigned(fTabControl) then
  begin
    RestoreWidgets;
    fTabControl.Parent := nil;
    FreeAndNil(fTabControl);
  end;
  inherited;
end;

procedure TTabNavigationContent.TabClick(Sender: TObject);
begin
  DoWidgetShow(Content.Widgets[fTabControl.TabIndex]);
end;

{ TListTabNavigationContent }

procedure TListNavigationContent.BackClick(Sender: TObject);
begin
  fTabControl.TabIndex := 0;
  fbtnBack.Visible := False;
end;

procedure TListNavigationContent.Build;
var
  I: Integer;
  TabItem: TTabItem;
begin
  RestoreWidgets;
  while fTabControl.TabCount > 1 do
    fTabControl.Tabs[1].Parent := nil;

  fListView.Items.Clear;
  with fTabControl do
  begin
    for I := 0 to Content.Widgets.Count - 1 do
    begin
      TabItem := TTabItem.Create(fTabControl);
      TabItem.Parent := fTabControl;
      TabItem.Text := Content.Widgets[I].Caption;
      TabItem.OnClick := TabClick;
      Content.Widgets[I].Show(TabItem);

      with fListView.Items.Add do
      begin
        Text := Content.Widgets[I].Caption;
        if Content.Widgets[I].Settings.GetValue('ShowIcon').ToBoolean then
          Bitmap := frmIcons.GetIconAbs
            (Content.Widgets[I].Settings.GetValue('Icon').ToInteger);
      end;
    end;
    TabIndex := 0;
  end;
  // Конпка "Назад"
  CreateBackButton;
  fTabControl.TabIndex := 0;
end;

class function TListNavigationContent.ContentName: String;
begin
  Result := 'TListNavigationContent';
end;

constructor TListNavigationContent.Create;
var
  TabItem: TTabItem;
begin
  inherited;
  fTabControl.TabPosition := TTabPosition.tpNone;
  TabItem := TTabItem.Create(fTabControl);
  TabItem.Parent := fTabControl;
  TabItem.Index := 0;

  // Главное меню
  fListView := TListView.Create(TabItem);
  with fListView do
  begin
    CanSwipeDelete := False;
    Parent := TabItem;
    Align := TAlignLayout.alClient;
    OnItemClick := ItemClick;
    ItemAppearanceName := 'ImageListItem';
  end;
end;

procedure TListNavigationContent.CreateBackButton;
var
  fToolBar: TToolBar;
  ContainsBackBtn: Boolean;
begin
  fToolBar := FindHeaderToolbar(ContainsBackBtn);
  if ContainsBackBtn then
  begin
    fbtnBack.Visible := False;
    exit;
  end;

  if Assigned(fbtnBack) then
  begin
    // fbtnBack.Parent := nil;
    // FreeAndNil(fbtnBack);
    fbtnBack := nil;
  end;

  fbtnBack := TSpeedButton.Create(Self);
  with fbtnBack do
  begin
    StyleLookup := 'backtoolbutton';
    Text := 'Back';
    Visible := False;
    OnClick := BackClick;
  end;

  with fbtnBack do
  begin
    if fToolBar = nil then
    begin
      fToolBar := THeader(Content[Content.Add(THeader.Create)]).fToolBar;
    end;
    fbtnBack.Parent := fToolBar;
    Align := TAlignLayout.alLeft;
  end;
end;

destructor TListNavigationContent.Destroy;
begin

  inherited;
end;

function TListNavigationContent.FindHeaderToolbar(var ContainsBackBtn: Boolean)
  : TToolBar;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Content.Count - 1 do
    if (Content[I] is THeader) then
    begin
      Result := THeader(Content[I]).fToolBar;
      if (Result.ContainsObject(fbtnBack)) then
        break;
    end;
  ContainsBackBtn := (Result <> nil) and (Result.ContainsObject(fbtnBack));
end;

procedure TListNavigationContent.ItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  fTabControl.TabIndex := AItem.Index + 1;
  fbtnBack.Visible := true;
  DoWidgetShow(Content.Widgets[AItem.Index]);
end;

procedure TListNavigationContent.TabClick(Sender: TObject);
begin
  if (fTabControl.TabIndex > 0) and
    (fTabControl.TabIndex - 1 < Content.Widgets.Count) then

    DoWidgetShow(Content.Widgets[fTabControl.TabIndex - 1]);
end;

{ TContentItemsLibrary }

function TContentItemsLibrary.Find(ContentName: String): TContentItemClass;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Self.Count - 1 do
    if Items[I].ContentName = ContentName then
    begin
      Result := Items[I];
      break;
    end;
end;

{ TBottomTabNavigationContent }

class function TBottomTabNavigationContent.ContentName: String;
begin
  Result := 'TBottomTabNavigationContent';
end;

constructor TBottomTabNavigationContent.Create;
begin
  inherited;
  fTabControl.TabPosition := TTabPosition.tpBottom;
end;

initialization

ContentItemsLibrary := TContentItemsLibrary.Create;
ContentItemsLibrary.Add(THeader);
ContentItemsLibrary.Add(TFooter);
ContentItemsLibrary.Add(TImageItem);
ContentItemsLibrary.Add(TShapeItem);
ContentItemsLibrary.Add(TLabelItem);

ContentItemsLibrary.Add(TTabNavigationContent);
ContentItemsLibrary.Add(TBottomTabNavigationContent);
ContentItemsLibrary.Add(TListNavigationContent);

end.
