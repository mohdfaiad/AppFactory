unit wuMap;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.WebBrowser, FMX.Layouts, FMX.Memo,
  System.Sensors, FMX.Sensors, FMX.Objects,

  Widgets, Content, CustomSettings;

type
  TwdgMap = class(TFrame, IWidgetAsc)
    WebBrowser: TWebBrowser;
    pnlContentUnavailable: TPanel;
    LocationSensor: TLocationSensor;
    Layout1: TLayout;
    Image1: TImage;
    Label1: TLabel;
    procedure sbGoBackClick(Sender: TObject);
    procedure LocationSensorLocationChanged(Sender: TObject;
      const OldLocation, NewLocation: TLocationCoord2D);
  private
    function GetSetSettingsEvent: TWidgetEvent;
    procedure WidgetShow;
  public
    procedure ShowLocation(Latitude, Longitude: String);
    procedure SettingsChange(Widget: TWidget);
  end;

var
  wdgMap: TwdgMap;

implementation

{$R *.fmx}

{ TwdgBrowser }

function TwdgMap.GetSetSettingsEvent: TWidgetEvent;
begin
  Result := SettingsChange;
end;

procedure TwdgMap.LocationSensorLocationChanged(Sender: TObject;
  const OldLocation, NewLocation: TLocationCoord2D);
begin
  ShowLocation(NewLocation.Latitude.ToString, NewLocation.Longitude.ToString);
end;

procedure TwdgMap.sbGoBackClick(Sender: TObject);
begin
  WebBrowser.GoBack;
end;

procedure TwdgMap.SettingsChange(Widget: TWidget);
begin
  with Widget do
  begin
    pnlContentUnavailable.Visible := Widget.Content.DesignMode;
    if Widget.Content.DesignMode then
    begin
      WebBrowser.Visible := false;
      LocationSensor.Active := false;
    end
    else
      LocationSensor.Active := Settings.GetValue('Locate').ToBoolean;
      ShowLocation(Settings.GetValue('Latitude'), Settings.GetValue('Longitude'));
  end;
end;

procedure TwdgMap.ShowLocation(Latitude, Longitude: String);
begin
  WebBrowser.Navigate
    (Format('https://maps.google.com/maps?q=%s,%s&output=embed',
    [Latitude, Longitude]));
end;

procedure TwdgMap.WidgetShow;
begin

end;

var
  MapPrototype: TFrameWidgetPrototype;

initialization

MapPrototype := TFrameWidgetPrototype.Create(TwdgMap, 'MapWidget',
  'Map Widget', 1);
with MapPrototype do
begin
  Settings.RegisterSetting(cstInteger, 'Latitude', 'Долгота', '0');
  Settings.RegisterSetting(cstInteger, 'Longitude', 'Широта', '0');
  Settings.RegisterSetting(cstBoolean, 'Locate',
    'Определять местоположение', '1');
end;
WidgetsLibrary.Add(MapPrototype);

end.
