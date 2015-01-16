unit uProducts;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Ani,
  FMX.Layouts, FMX.Objects, FMX.StdCtrls, FMX.MagnifierGlass, ProductsList,
  FMX.Gestures, FMX.Edit, FMX.Effects, FMX.Filter.Effects, FMX.ListBox;

type
  TfrmProducts = class(TForm)
    ltProductsBelt: TLayout;
    tmrAutoScroll: TTimer;
    aniScroll: TFloatAnimation;
    StyleBook: TStyleBook;
    pnlAppPrototype: TPanel;
    imgBelt: TImage;
    ltControls: TLayout;
    imgLogo: TImage;
    ShowControlsAnimation: TFloatAnimation;
    imgConveyor: TImage;
    GestureManager: TGestureManager;
    pnlNewPrototype: TPanel;
    aniAddNew: TFloatAnimation;
    ltConveyorBelt: TLayout;
    pnlAppCreation: TCalloutPanel;
    Label1: TLabel;
    ltCreateApp: TLayout;
    edAppName: TEdit;
    lblErrorMessage: TLabel;
    Label2: TLabel;
    scrbx: TVertScrollBox;
    ShadowEffect1: TShadowEffect;
    sbAdd: TSpeedButton;
    ltAskDeletion: TLayout;
    pnlAskDeletion: TCalloutPanel;
    ShadowEffect2: TShadowEffect;
    lblDeletionMessage: TLabel;
    btnCancelDeletion: TButton;
    btnDeleteApp: TButton;
    Image1: TImage;
    ltWelcome: TLayout;
    Label3: TLabel;
    sbShare: TSpeedButton;
    imgFooter: TImage;
    pnlHeader: TPanel;
    pnlFooter: TPanel;
    Layout2: TLayout;
    Button1: TButton;
    Button2: TButton;
    rbEmpty: TRadioButton;
    rbTemplate: TRadioButton;
    Layout1: TLayout;
    lbShareMenu: TListBox;
    ShadowEffect3: TShadowEffect;
    lbiExportToDelphiSource: TListBoxItem;
    Layout3: TLayout;
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure tmrAutoScrollTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FloatAnimation3Finish(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormGesture(Sender: TObject; const EventInfo: TGestureEventInfo;
      var Handled: Boolean);
    procedure aniAddNewFinish(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure edAppNameChange(Sender: TObject);
    procedure aniScrollProcess(Sender: TObject);
    procedure sbAddClick(Sender: TObject);
    procedure btnDeleteAppClick(Sender: TObject);
    procedure btnCancelDeletionClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure rbTemplateClick(Sender: TObject);
    procedure sbShareClick(Sender: TObject);
    procedure lbiExportToDelphiSourceClick(Sender: TObject);
    procedure lbShareMenuExit(Sender: TObject);
    procedure scrbxClick(Sender: TObject);
  private
    fMoving: Boolean;
    fEnableScrolling, fEnableCircularScrolling: Boolean;
    LastPos, StartPos: TPointF;
    Selected, SelectedTemplate: Integer;
    Delta: Single;
    function GetControlPosX(NewPosX: Single; ImageWidth: Single): Single;

    // Animation
    procedure AnimateHideAll;
    procedure AnimateSelectCurrent;
    procedure MoveControls(Delta: Single; Parent: TFmxObject);
    procedure MoveControlsAni(PositionX: Single; Parent: TFmxObject;
      WaitLast: Boolean = false);
    procedure ZoomControlIn(Control: TControl; Scale: Single);
    procedure ZoomControlOut(Control: TControl; Scale: Single);
    function GetFirst: TControl;
  private
    fProductCreationMode: Boolean;
    fProductsList: TAppProductsList;
    procedure ShowProductsList;
    procedure AddNewProduct;
    procedure DeleteApp(Index: Integer);
    procedure ExportApp(Index: Integer);
  end;

const
  Scale = 1.1;

resourcestring
  STR_APPNAME_EMPTY = 'Пожалуйста введите имя приложения!';
  STR_APPNAME_USED = 'Такое имя приложения уже используется.' + #13#10 +
    'Придумайте другое название.';

var
  frmProducts: TfrmProducts;

implementation

uses
{$IFDEF Android}
  FMX.Platform.Android,
{$ENDIF}
  Android.JNI.Toast,
  System.UIConsts, System.IOUtils, uEditor, System.Rtti, AppProduct,
  ContentCollection, System.Math, uTemplates, DelphiExport;

{$R *.fmx}

procedure TfrmProducts.FormCreate(Sender: TObject);
begin
  fProductsList := TAppProductsList.Create;
  Delta := 0;
  Selected := -1;
  imgConveyor.Height := imgConveyor.Bitmap.Height / 2;
  fEnableScrolling := true;
  fEnableCircularScrolling := true;
  scrbx.AniCalculations.Animation := true;
  scrbx.AniCalculations.TouchTracking := [ttVertical];
  lbShareMenu.OnDeactivate := lbShareMenu.OnExit;
end;

procedure TfrmProducts.ShowProductsList;
var
  i: Integer;
  Panel: TPanel;
begin
  fProductsList.Clear;
  fProductsList.LoadProductsDir(TPath.GetSharedDownloadsPath +
    TPath.DirectorySeparatorChar + 'AppFactory' + TPath.DirectorySeparatorChar +
    'Products');
  ltProductsBelt.DeleteChildren;
  for i := 0 to fProductsList.Count - 1 do
  begin
    Panel := TPanel(pnlAppPrototype.Clone(ltProductsBelt));
    Panel.Parent := ltProductsBelt;
    with Panel do
    begin
      Position.X := i * (Width + 10);
      Position.Y := 0;
      Visible := true;
      StylesData['ProductName'] := fProductsList[i]
        .Product.Settings.GetValue('Name');
    end;
  end;
end;

procedure TfrmProducts.sbAddClick(Sender: TObject);
begin
  if not fProductCreationMode then
    AddNewProduct;
end;

procedure TfrmProducts.sbShareClick(Sender: TObject);
begin
  if (Selected >= 0) and (Selected < fProductsList.Count) then
  begin
    lbShareMenu.Visible := true;
    lbShareMenu.SetFocus;
  end
  else
    Toast('Выберите приложение либо создайте новое');
end;

procedure TfrmProducts.scrbxClick(Sender: TObject);
begin
  lbShareMenu.Visible := false;
end;

procedure TfrmProducts.FormActivate(Sender: TObject);
begin
  if not pnlAppCreation.Visible then
  begin
    ShowProductsList;
    AnimateSelectCurrent;
  end;
end;

// ============================================================================
// Animation
// ============================================================================

procedure TfrmProducts.FormShow(Sender: TObject);
begin
  // scrbx.Position.Y := Height;
  // ShowControlsAnimation.Start;
end;

procedure TfrmProducts.AnimateHideAll;
var
  i: Integer;
  minX: Single;
begin
  if ltProductsBelt.ChildrenCount = 0 then
    exit;

  minX := GetFirst.Position.X;

  tmrAutoScroll.Enabled := false;
  fEnableCircularScrolling := false;
  fEnableScrolling := false;
  MoveControlsAni(Abs(minX) + ltProductsBelt.Width, ltProductsBelt);
  fEnableCircularScrolling := true;
end;

procedure TfrmProducts.AnimateSelectCurrent;
var
  Item: TControl;
begin
  if Selected = -1 then
    Item := GetFirst
  else
    Item := TControl(ltProductsBelt.Children[Selected]);
  if Item = nil then
  begin
    // Нет ни одного приложения
    ltWelcome.Visible := true;
    exit;
  end;
  ltWelcome.Visible := false;
  MoveControlsAni((Width / 2 - Item.Width / 2) - Item.Position.X,
    ltProductsBelt);
  Selected := Item.Index;
  ZoomControlIn(Item, Scale);

end;

procedure TfrmProducts.aniScrollProcess(Sender: TObject);
var
  Item: TControl;
begin
  Item := TControl(TFmxObject(Sender).Parent);
  Item.Position.X := GetControlPosX(Item.Position.X, Item.Width);
end;

// Adding of a new application product
// ----------------------------------------------------------------------------

procedure TfrmProducts.AddNewProduct;
var
  Panel: TPanel;
  Ani: TFloatAnimation;
begin
  ltWelcome.Visible := false;
  fProductCreationMode := true;
  SelectedTemplate := -1;
  rbEmpty.IsChecked := true;
  AnimateHideAll;

  rbEmpty.IsChecked := true;
  rbTemplate.Text := 'Выбрать шаблон';

  Panel := TPanel(pnlNewPrototype.Clone(ltConveyorBelt));
  Panel.Parent := ltConveyorBelt;
  Selected := ltConveyorBelt.Children.IndexOf(Panel);
  with Panel do
  begin
    Position.X := (frmProducts.Width / 2) - Panel.Width / 2;
    Position.Y := ltProductsBelt.Position.Y;
    Visible := true;
    StyleLookup := 'ProductItemNew';
    StylesData['ProductName'] := '';
    Panel.RotationCenter.X := -1 * Position.X / Width;
    Ani := TFloatAnimation(Panel.Children[1]);
    Ani.OnFinish := aniAddNewFinish;
    Ani.Start;
  end;
end;

procedure TfrmProducts.aniAddNewFinish(Sender: TObject);
begin
  ltConveyorBelt.AnimateFloatWait('Position.Y', ltCreateApp.Position.Y +
    ltCreateApp.Height, 0.5);
  ltCreateApp.Visible := true;
  ltConveyorBelt.Align := TAlignLayout.alTop;

  pnlAppCreation.Visible := true;
  pnlAppCreation.Position.Y := ltCreateApp.Height + ltConveyorBelt.Height;
  pnlAppCreation.Width := Width - 10;
  scrbx.RealignContent;

  edAppName.SetFocus;
  edAppName.SelectWord;
end;

procedure TfrmProducts.btnApplyClick(Sender: TObject);
var
  i: Integer;
begin
  scrbx.ScrollTo(0, Height);
  // Проверяем, чтобы имя приложения не было пустым и было уникальным
  if edAppName.Text.IsEmpty then
  begin
    lblErrorMessage.Text := STR_APPNAME_EMPTY;
    lblErrorMessage.Visible := true;
    exit;
  end;
  for i := 0 to fProductsList.Count - 1 do
    if edAppName.Text = fProductsList[i].Product.Settings.GetValue('Name') then
    begin
      lblErrorMessage.Text := STR_APPNAME_USED;
      lblErrorMessage.Visible := true;
      exit;
    end;
  // Восстанавливаем положение
  pnlAppCreation.Visible := false;
  scrbx.RealignContent;
  ltConveyorBelt.Align := TAlignLayout.alNone;
  // Не даём отскочить вверх после следующего действия
  ltCreateApp.Visible := false;
  ltConveyorBelt.AnimateFloatWait('Position.Y',
    Height / 2 - ltConveyorBelt.Height / 2, 0.5);

  ltConveyorBelt.Position.Y := 0;
  ltConveyorBelt.Align := TAlignLayout.alVertCenter;

  if SelectedTemplate = -1 then // Создаём пустое приложение
  begin
    frmEditor.CreateAppProduct(edAppName.Text);
    // Стиль навигации
    frmEditor.AppProduct.Content.Add(TTabNavigationContent.Create);
  end
  else
    frmEditor.CreateAppProduct(edAppName.Text,
      frmTemplates.TemplatesList[SelectedTemplate].FileName);
  frmEditor.Show;

  // Уничтожаем значок без анимации (всё равно никто не увидит)
  ltConveyorBelt.Children[Selected].Parent := nil;

  // Разрешаем прокрутку
  Selected := -1;
  fEnableCircularScrolling := true;
  fEnableScrolling := true;
  AnimateSelectCurrent;

  ShowProductsList;
  fProductCreationMode := false;
end;

procedure TfrmProducts.btnCancelClick(Sender: TObject);
begin
  scrbx.ScrollTo(0, Height);
  lblErrorMessage.Visible := false;
  // Восстанавливаем положение
  pnlAppCreation.Visible := false;
  scrbx.RealignContent;
  ltConveyorBelt.Align := TAlignLayout.alNone;
  // Не даём отскочить вверх после следующего действия
  ltCreateApp.Visible := false;
  scrbx.RealignContent;
  ltConveyorBelt.AnimateFloatWait('Position.Y',
    Height / 2 - ltConveyorBelt.Height / 2, 0.5);

  ltConveyorBelt.Position.Y := 0;
  ltConveyorBelt.Align := TAlignLayout.alVertCenter;

  // Выкидываем ненужный значок приложения
  ltConveyorBelt.Children[Selected].AnimateFloatWait('Position.Y', Height, 0.7,
    TAnimationType.atIn, TInterpolationType.itBack);
  ltConveyorBelt.Children[Selected].Parent := nil;

  // Разрешаем прокрутку
  Selected := -1;
  fEnableCircularScrolling := true;
  fEnableScrolling := true;
  AnimateSelectCurrent;
  fProductCreationMode := false;
end;

procedure TfrmProducts.btnCancelDeletionClick(Sender: TObject);
begin
  ltAskDeletion.Visible := false;
end;

procedure TfrmProducts.btnDeleteAppClick(Sender: TObject);
begin
  ltAskDeletion.Visible := false;
  DeleteApp(Selected);
  if Selected > fProductsList.Count - 1 then
    Selected := -1;
  ShowProductsList;
  AnimateSelectCurrent;
end;

procedure TfrmProducts.edAppNameChange(Sender: TObject);
begin
  lblErrorMessage.Visible := false;
end;

procedure TfrmProducts.ExportApp(Index: Integer);
var
  DelphiSourceSaver: TDelphiSourceSaver;
  AppProduct: TAppProduct;
  AppLoader: TAppLoader;
  ExportPath, ExportFileName: String;
  Exported: Boolean;
begin
  Exported := false;
  try
    ExportPath := TPath.Combine(TPath.GetSharedDownloadsPath, 'AppFactory');
    ExportPath := TPath.Combine(ExportPath, 'Export');
    ExportFileName := fProductsList[Index].Product.Settings.GetValue('Name');

    ExportPath := TPath.Combine(ExportPath, ExportFileName);

    if TDirectory.Exists(ExportPath) then
      TDirectory.Delete(ExportPath, true);
    TDirectory.CreateDirectory(ExportPath);

    AppProduct := TAppProduct.Create(Layout1);
    if AppProduct <> nil then
    begin
      try
        AppLoader := TXMLAppLoader.Create(AppProduct,
          fProductsList[Index].FileName);
        if AppLoader.Load then
        begin
          DelphiSourceSaver := TDelphiSourceSaver.Create(AppProduct,
            TPath.Combine(ExportPath, ExportFileName));
          Exported := DelphiSourceSaver.Save;
        end;
      finally
        FreeAndNil(AppLoader);
        FreeAndNil(AppProduct);
      end;
    end;
  except
    on E: Exception do
      Toast('Не удалось экспортировать приложение: ' + E.Message);
  end;
  if Exported then
    Toast(Format('Приложение "%s" успешно экспортированно в %s',
      [fProductsList[Index].Product.Settings.GetValue('Name'), ExportPath]))
  else
    Toast('Не удалось экспортировать приложение!');

end;

// -----------------------------------------------------------------------------

procedure TfrmProducts.DeleteApp(Index: Integer);
begin
  if (Index >= 0) and (Index < ltProductsBelt.ChildrenCount) then
  begin
    tmrAutoScroll.Enabled := false;
    ltProductsBelt.Children[Index].AnimateFloatWait('Position.Y', Height, 0.7,
      TAnimationType.atIn, TInterpolationType.itBack);

    fProductsList.Delete(Index);
    ltProductsBelt.Children[Index].Free;
  end;
end;

// ----------------------------------------------------------------------------
// General Animation
// ----------------------------------------------------------------------------

procedure TfrmProducts.MoveControlsAni(PositionX: Single; Parent: TFmxObject;
  WaitLast: Boolean = false);
var
  i, j: Integer;
  Ani: TFloatAnimation;
  Item: TControl;
begin
  Ani := nil;
  for i := 0 to Parent.ChildrenCount - 1 do
  begin
    Item := TControl(Parent.Children[i]);
    for j := 0 to Item.ChildrenCount - 1 do
      if Item.Children[j] is TFloatAnimation then
      begin
        Ani := TFloatAnimation(Item.Children[j]);
        break;
      end
      else
        Ani := nil;
    if Ani <> nil then
    begin
      Ani.StopAtCurrent;
      Ani.StopValue := Item.Position.X + PositionX;
      Ani.Start;
    end;
  end;
  if (WaitLast) and (Ani <> nil) then
    while Ani.Running do
      Application.ProcessMessages;

end;

procedure TfrmProducts.rbTemplateClick(Sender: TObject);
begin
  if rbTemplate.IsChecked then
  begin
    frmTemplates.ShowModal(
      procedure(ModalResult: TModalResult)
      begin
        if ModalResult = mrOk then
        begin
          SelectedTemplate := frmTemplates.GetTemplate - 1;
          if SelectedTemplate <> -1 then
            rbTemplate.Text := Format('Шаблон "%s"',
              [frmTemplates.TemplatesList[SelectedTemplate]
              .Product.Settings.GetValue('Name')])
          else
          begin
            rbEmpty.IsChecked := true;
            rbTemplate.Text := 'Выбрать шаблон';
          end;
        end
        else
          rbEmpty.IsChecked := true;
        frmTemplates.Hide;
      end);
    Screen.ActiveForm := frmProducts;
  end;
end;

procedure TfrmProducts.MoveControls(Delta: Single; Parent: TFmxObject);
var
  i: Integer;
  Item: TControl;
  CenterX, FormCenterX: Single;
begin
  FormCenterX := Width / 2;
  if Delta <> 0 then
    for i := 0 to Parent.ChildrenCount - 1 do
    begin
      Item := TControl(Parent.Children[i]);
      Item.Position.X := GetControlPosX(Item.Position.X + Delta, Item.Width);
    end;

  for i := 0 to Parent.ChildrenCount - 1 do
  begin
    Item := TControl(Parent.Children[i]);
    CenterX := Item.Position.X + Item.Width / 2;

    if Item.Scale.X <> 1 then
      ZoomControlOut(Item, Scale);

    if ((Parent.ChildrenCount > 1) and (Selected <> i)) or
      (Parent.ChildrenCount = 1) then
      if Abs(CenterX - FormCenterX) <= 100 then
      begin
        tmrAutoScroll.Enabled := false; // Останавливаем автопрокрутку
        StartPos.X := Delta + StartPos.X; // Делаем Delta = 0
        fMoving := false;
        Selected := i;
        MoveControlsAni(FormCenterX - CenterX, Parent, true);

        // К этому моменту элемент может быть удалён с помощью жеста вниз
        if Item.Parent <> nil then
          ZoomControlIn(Item, Scale);
        exit;
      end;
  end;
end;

function TfrmProducts.GetControlPosX(NewPosX: Single;
ImageWidth: Single): Single;
var
  InvisibleCount: Integer;
begin
  // Position
  Result := NewPosX;
  if fEnableCircularScrolling then
  begin
    InvisibleCount := ltProductsBelt.ControlsCount -
      Round(Width / (ImageWidth + 10));
    if Result < -1 * (ImageWidth + InvisibleCount * (ImageWidth + 10)) then
      // Левая граница
      Result := Width + ImageWidth -
        (Abs(Result) - InvisibleCount * (ImageWidth + 10) - ImageWidth)
    else if (Result > (Width + 1 + InvisibleCount * (ImageWidth + 10))) then
      // Правая граница
      Result := ImageWidth * -2 + (Abs(Result) - (InvisibleCount) *
        (ImageWidth + 10) - Width + 1);
  end;
end;

function TfrmProducts.GetFirst: TControl;
var
  minX: Single;
  i, first: Integer;
begin
  // Находим самый правый элемент на панели
  minX := maxint;
  first := -1;
  for i := 0 to ltProductsBelt.ChildrenCount - 1 do
    if TControl(ltProductsBelt.Children[i]).Position.X < minX then
    begin
      first := i;
      minX := TControl(ltProductsBelt.Children[i]).Position.X;
    end;
  if first <> -1 then
    Result := TControl(ltProductsBelt.Children[first])
  else
    Result := nil;
end;

procedure TfrmProducts.lbiExportToDelphiSourceClick(Sender: TObject);
begin
  if (Selected >= 0) and (Selected < fProductsList.Count) then
    ExportApp(Selected);
  lbShareMenu.Visible := false;
end;

procedure TfrmProducts.lbShareMenuExit(Sender: TObject);
begin
  lbShareMenu.Visible := false;
end;

// ---------------------------------------------------------------------------
// Form Mouse Events
// ---------------------------------------------------------------------------

procedure TfrmProducts.FormMouseMove(Sender: TObject; Shift: TShiftState;
X, Y: Single);
begin
  if fMoving then
  begin
    Delta := X - StartPos.X;
    tmrAutoScroll.Enabled := true;
    MoveControls(Delta, ltProductsBelt);
    StartPos := PointF(X, Y);
  end;
end;

procedure TfrmProducts.FormMouseDown(Sender: TObject; Button: TMouseButton;
Shift: TShiftState; X, Y: Single);
begin
  // fMoved := false;
  if fEnableScrolling then
  begin
    fMoving := true;
    StartPos := PointF(X, Y);
    // Используется для анимации
    LastPos := PointF(X, Y); // Используется для выбора
  end;
end;

procedure TfrmProducts.FormMouseUp(Sender: TObject; Button: TMouseButton;
Shift: TShiftState; X, Y: Single);
var
  Item: TControl;
  ItemPos: TPointF;
begin
  if not fProductCreationMode then
  begin
    fMoving := false;
    if (Abs(LastPos.X - X) > 5) or (Abs(LastPos.Y - Y) > 5) then
      exit;
    if Selected <> -1 then
    begin
      Item := TControl(ltProductsBelt.Children[Selected]);
      ItemPos := ltProductsBelt.LocalToAbsolute(Item.Position.Point);
      if (X > ItemPos.X) and (ItemPos.X + Item.Width > X) and (Y > ItemPos.Y)
        and (ItemPos.Y + Item.Height > Y) then
      begin
        frmEditor.LoadAppProduct(fProductsList[Selected].FileName);
        frmEditor.Show;
        exit;
      end;
    end;
  end;
end;

// ---------------------------------------------------------------------------

procedure TfrmProducts.FloatAnimation3Finish(Sender: TObject);
begin
  ltControls.Opacity := 0;
  ltControls.Visible := true;
end;

procedure TfrmProducts.tmrAutoScrollTimer(Sender: TObject);
begin
  if Round(Delta) <> 0 then
  begin
    MoveControls(Delta, ltProductsBelt);
    Delta := Delta - (Delta / 500);
  end
  else
    tmrAutoScroll.Enabled := false;
end;

procedure TfrmProducts.ZoomControlIn(Control: TControl; Scale: Single);
begin
  Control.Position.X := Control.Position.X -
    ((Control.Width * Scale) - Control.Width) / 2;
  Control.Position.Y := Control.Position.Y -
    ((Control.Height * Scale) - Control.Height) / 2;
  Control.Scale.Point := PointF(Scale, Scale);

  { Control.AnimateFloat('Position.X', Control.Position.X -
    ((Control.Width * 1.2) - Control.Width) / 2);
    Control.AnimateFloat('Position.Y', Control.Position.Y -
    ((Control.Height * 1.2) - Control.Height) / 2);
    Control.AnimateFloat('Scale.X', 1.2);
    Control.AnimateFloatWait('Scale.Y', 1.2); }
end;

procedure TfrmProducts.ZoomControlOut(Control: TControl; Scale: Single);
begin
  Control.Position.X := Control.Position.X +
    (Control.Width - (Control.Width / Scale)) / 2;
  Control.Position.Y := Control.Position.Y +
    (Control.Height - (Control.Height / Scale)) / 2;
  Control.Scale.Point := PointF(1, 1);
end;

// ----------------------------------------------------------------------------
// Form Control Procedures
// ----------------------------------------------------------------------------

// Gestures
// ----------------------------------------------------------------------------

procedure TfrmProducts.FormGesture(Sender: TObject;
const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  if fEnableScrolling then
    case EventInfo.GestureID of
      sgiDown:
        // Проверяем что жест выполнен не в режиме добавлениея нового элемента
        if (Selected <> -1) and (not fProductCreationMode) then
        begin
          lblDeletionMessage.Text :=
            Format('Вы действительно хотите удалить приложение "%s"?',
            [fProductsList[Selected].Product.Settings.GetValue('Name')]);
          ltAskDeletion.Visible := true;
          ltAskDeletion.BringToFront;
          ltAskDeletion.SetFocus;

          fMoving := false;
          Delta := 0;
          Handled := true;
        end;
    end;
end;

procedure TfrmProducts.FormKeyUp(Sender: TObject; var Key: Word;
var KeyChar: Char; Shift: TShiftState);
begin
{$IFDEF Android}
  if Key = vkHardwareBack then
  begin
    if fProductCreationMode then
    begin
      btnCancelClick(Self);
      Key := 0
    end
    else if ltAskDeletion.Visible then
    begin
      btnCancelDeletionClick(Self);
      Key := 0;
    end
    else
      MainActivity.finish;
  end
{$ENDIF}
end;

end.
