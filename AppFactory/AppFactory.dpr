program AppFactory;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.MobilePreview,
  FMX.TabControl in '..\Source\FMX.TabControl.pas',
  {
    В процессе разработки программы в стандартном модуле "FMX.TabControl"
    была обнаружена ошибка, приводящая к неверному отображению TabItem
    при Scale <> 1.
    Internal Tracking #: 45845
  }

  Android.JNI.Toast in '..\Source\Android.JNI.Toast.pas',
  AndroidSelection in '..\Source\AndroidSelection.pas',
  AppProduct in '..\Source\AppProduct.pas',
  Content in '..\Source\Content.pas',
  Widgets in '..\Source\Widgets.pas' {WidgetsLibrary} ,
  ContentCollection
    in '..\Source\ContentCollection.pas' {TContentItemsLibrary} ,
  CustomSettings in '..\Source\CustomSettings.pas',
  SettingsConstruct in '..\Source\SettingsConstruct.pas',
  ProductsList in '..\Source\ProductsList.pas',
  uChooseColor in 'Forms\additional\uChooseColor.pas' {frmChooseColor} ,
  uSplash in 'Forms\uSplash.pas' {frmSplash} ,
  uEditor in 'Forms\uEditor.pas' {frmEditor} ,
  uProducts in 'Forms\uProducts.pas' {frmProducts} ,
  uEditText in 'Forms\additional\uEditText.pas' {frmEditText} ,
  uChooseNaviStyle
    in 'Forms\additional\uChooseNaviStyle.pas' {frmChooseNaviStyle} ,
  uIcons in 'Forms\uIcons.pas' {frmIcons} ,
  uTemplates in 'Forms\uTemplates.pas' {frmTemplates} ,
  DelphiExport in '..\Source\DelphiExport.pas',

  // Виджеты подключаются после инициализации модуля Widgets
{$I Widgets.inc};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmSplash, frmSplash);
  // Остальные формы создаются из TfrmSplash
  Application.Run;

end.
