unit wuBrowser;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  Widgets, FMX.Edit, FMX.WebBrowser, CustomSettings, FMX.Layouts, FMX.Memo,
  Content, FMX.Objects;

type
  TwdgBrowser = class(TFrame, IWidgetAsc)
    ToolBar1: TToolBar;
    sbGoBack: TSpeedButton;
    edURL: TEdit;
    WebBrowser: TWebBrowser;
    pnlContentUnavailable: TPanel;
    AniIndicator1: TAniIndicator;
    Layout1: TLayout;
    Image1: TImage;
    Label1: TLabel;
    procedure edURLChange(Sender: TObject);
    procedure sbGoBackClick(Sender: TObject);
    procedure WebBrowserDidStartLoad(ASender: TObject);
    procedure WebBrowserDidFinishLoad(ASender: TObject);
  private
    function GetSetSettingsEvent: TWidgetEvent;
    procedure WidgetShow;
  public
    procedure OpenURL;
    procedure SettingsChange(Widget: TWidget);
  end;

var
  wdgBrowser: TwdgBrowser;

implementation

{$R *.fmx}
{ TwdgBrowser }

procedure TwdgBrowser.edURLChange(Sender: TObject);
begin
  OpenURL;
end;

function TwdgBrowser.GetSetSettingsEvent: TWidgetEvent;
begin
  Result := SettingsChange;
end;

procedure TwdgBrowser.OpenURL;
begin
  WebBrowser.Navigate(edURL.Text);
end;

procedure TwdgBrowser.sbGoBackClick(Sender: TObject);
begin
  WebBrowser.GoBack;
end;

procedure TwdgBrowser.SettingsChange(Widget: TWidget);
begin
  with Widget do
  begin
    pnlContentUnavailable.Visible := Widget.Content.DesignMode;
    WebBrowser.Visible := not Widget.Content.DesignMode;

    ToolBar1.Visible := Settings.GetValue('ShowURL').ToBoolean;
    edURL.Text := Settings.GetValue('URL');
    edURL.ReadOnly := not Settings.GetValue('AllowCustomURL').ToBoolean;
//    pnlInfo.Visible := Settings.GetValue('ShowPanel').ToBoolean;
//    mmText.Lines.Add(Settings.GetValue('Text'));
  end;
  OpenURL;
end;

procedure TwdgBrowser.WebBrowserDidFinishLoad(ASender: TObject);
begin
  AniIndicator1.Visible := false;
  edURL.OnChange := nil;
  edURL.Text := WebBrowser.URL;
  edURL.OnChange := edURLChange;
end;

procedure TwdgBrowser.WebBrowserDidStartLoad(ASender: TObject);
begin
  AniIndicator1.Visible := true;
end;

procedure TwdgBrowser.WidgetShow;
begin
  OpenURL;
end;

var
  BrowserPrototype: TFrameWidgetPrototype;

initialization

BrowserPrototype := TFrameWidgetPrototype.Create(TwdgBrowser, 'BrowserWidget',
  'Browser Widget', 5);
with BrowserPrototype do
begin
  Settings.RegisterSetting(cstString, 'URL', 'Веб-адрес', 'google.com');
  Settings.RegisterSetting(cstBoolean, 'ShowURL',
    'Показать адресную строку', '1');
  Settings.RegisterSetting(cstBoolean, 'AllowCustomURL',
    'Разрешить ввод веб-адреса', '1');
 // Settings.RegisterSetting(cstBoolean, 'ShowPanel', 'Показать текст', '1');
//  Settings.RegisterSetting(cstString, 'Text', 'Текст', '');
end;
WidgetsLibrary.Add(BrowserPrototype);

end.
