unit wuImage;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,

  Widgets, FMX.StdCtrls, CustomSettings, Content;

type
  TwdgImage = class(TFrame, IWidgetAsc)
    Image1: TImage;
  private
    function GetSetSettingsEvent: TWidgetEvent;
    procedure WidgetShow;
  public
    procedure SettingsChange(Widget: TWidget);
  end;

var
  wdgImage: TwdgImage;

implementation

{$R *.fmx}
{ TwdgImage }

function TwdgImage.GetSetSettingsEvent: TWidgetEvent;
begin
  Result := SettingsChange;
end;

procedure TwdgImage.SettingsChange(Widget: TWidget);
var
  ImageIndex: Integer;
begin
  with Widget do
  begin
    ImageIndex := Settings.GetValue('Image').ToInteger;
    if ImageIndex <> -1 then
      Image1.Bitmap.LoadFromFile(Content.Resources[ImageIndex]);
    Image1.WrapMode :=   TImageWrapMode(Settings.GetValue('WrapMode').ToInteger);
  end;
end;

procedure TwdgImage.WidgetShow;
begin
  Image1.UpdateRect;
end;

var
  ImageWidgetPrototype: TFrameWidgetPrototype;

initialization

ImageWidgetPrototype := TFrameWidgetPrototype.Create(TwdgImage, 'ImageWidget',
  'Image Widget', 3);
ImageWidgetPrototype.Settings.RegisterSetting(cstImage, 'Image',
  'Изображение', '-1');
ImageWidgetPrototype.Settings.RegisterSetting(cstWrapMode, 'WrapMode',
  'Выравнивание', '1');

WidgetsLibrary.Add(ImageWidgetPrototype);

end.
