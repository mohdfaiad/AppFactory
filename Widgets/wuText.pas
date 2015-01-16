unit wuText;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  Widgets, FMX.Edit, FMX.WebBrowser, CustomSettings, FMX.Layouts, FMX.Memo,
  Content, FMX.Objects;

type
  TwdgText = class(TFrame, IWidgetAsc)
    Memo1: TMemo;
  private
    function GetSetSettingsEvent: TWidgetEvent;
    procedure WidgetShow;
  public
    procedure SettingsChange(Widget: TWidget);
  end;

var
  wdgText: TwdgText;

implementation

uses
  System.UIConsts;

{$R *.fmx}
{ TwdgBrowser }

function TwdgText.GetSetSettingsEvent: TWidgetEvent;
begin
  Result := SettingsChange;
end;

procedure TwdgText.SettingsChange(Widget: TWidget);
begin
  with Widget do
  begin
    Memo1.Lines.Text := Settings.GetValue('Text');
    Memo1.Font.Size := Settings.GetValue('FontSize').ToSingle;
    Memo1.FontColor := StringToAlphaColor(Settings.GetValue('FontColor'));
    Memo1.TextAlign := TTextAlign(Settings.GetValue('TextAlign').ToInteger);
  end;
end;

procedure TwdgText.WidgetShow;
begin

end;

var
  TextWidgetPrototype: TFrameWidgetPrototype;

initialization

TextWidgetPrototype := TFrameWidgetPrototype.Create(TwdgText, 'TextWidget',
  'Text Widget', 2);
with TextWidgetPrototype.Settings do
begin
  RegisterSetting(cstText, 'Text', 'Текст', '(Введите текст страницы)');
  RegisterSetting(cstInteger, 'FontSize', 'Размер шрифта', '18');
  RegisterSetting(cstColor, 'FontColor', 'Цвет шрифта',
    AlphaColorToString(claBlack));
  RegisterSetting(cstTextAlign, 'TextAlign', 'Выравнивание', '1');
end;
WidgetsLibrary.Add(TextWidgetPrototype);

end.
