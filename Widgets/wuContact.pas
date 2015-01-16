unit wuContact;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.Memo,

  Widgets, Content, CustomSettings;

type
  TwdgContact = class(TFrame, IWidgetAsc)
    imgContact: TImage;
    lblContactInfo: TLabel;
    lblNumber: TLabel;
    lblContactName: TLabel;
    imgCall: TImage;
    mmoAdditionalInfo: TMemo;
    procedure imgCallClick(Sender: TObject);
  private
    fTelephoneNumber: String;
    fAllowMakeCall: Boolean;
    function GetSetSettingsEvent: TWidgetEvent;
    procedure WidgetShow;
  public
    procedure SettingsChange(Widget: TWidget);
    procedure MakeCall(TelephoneNumber: String);
  end;

var
  wdgContact: TwdgContact;

implementation

uses FMX.PhoneDialer, FMX.Platform;

{$R *.fmx}
{ TForm1 }

function TwdgContact.GetSetSettingsEvent: TWidgetEvent;
begin
  Result := SettingsChange;
end;

procedure TwdgContact.imgCallClick(Sender: TObject);
begin
  MakeCall(fTelephoneNumber);
end;

procedure TwdgContact.MakeCall(TelephoneNumber: String);
var
  PhoneDialerService: IFMXPhoneDialerService;
begin
  if fAllowMakeCall then
  begin
    if TPlatformServices.Current.SupportsPlatformService(IFMXPhoneDialerService,
      IInterface(PhoneDialerService)) then
    begin
      if TelephoneNumber <> '' then
        PhoneDialerService.Call(TelephoneNumber)
      else
      begin
        ShowMessage('Please type-in a telephone number.');
      end;
    end;
  end
  else
    ShowMessage
      ('Совершение вызовов недоступно в режиме редактирования. Для проверки запустите ваше приложение с помощью AppProducts.');
end;

procedure TwdgContact.SettingsChange(Widget: TWidget);
var
  ImageIndex: Integer;
begin
  with Widget do
  begin
    fAllowMakeCall := not Widget.Content.DesignMode;
    lblContactName.Text := Settings.GetValue('ContactName');
    lblContactInfo.Text := Settings.GetValue('ContactInfo');
    ImageIndex := Settings.GetValue('ContactImage').ToInteger;
    if ImageIndex <> -1 then
      imgContact.Bitmap.LoadFromFile(Content.Resources[ImageIndex]);
    fTelephoneNumber := Settings.GetValue('Number');
    lblNumber.Text := fTelephoneNumber;

    mmoAdditionalInfo.Visible := Settings.GetValue('ShowAdditionalInfo')
      .ToBoolean;
    mmoAdditionalInfo.Lines.Text := Settings.GetValue('AdditionalInfo');
  end;
end;

procedure TwdgContact.WidgetShow;
begin
  imgContact.UpdateRect;
end;

var
  ContactPrototype: TFrameWidgetPrototype;

initialization

ContactPrototype := TFrameWidgetPrototype.Create(TwdgContact, 'ContactWidget',
  'Contact Widget', 4);
with ContactPrototype do
begin
  Settings.RegisterSetting(cstString, 'ContactName', 'Имя контакта',
    'Mr. Bean');
  Settings.RegisterSetting(cstString, 'ContactInfo', 'Должность', 'comedian');
  Settings.RegisterSetting(cstImage, 'ContactImage', 'Изображение', '-1');

  Settings.RegisterSetting(cstString, 'Number', 'Номер телефона',
    '+3752912345678');
  Settings.RegisterSetting(cstBoolean, 'ShowAdditionalInfo',
    'Показать информацию', '0');
  Settings.RegisterSetting(cstText, 'AdditionalInfo',
    'Дополнительная информация', '');
end;
WidgetsLibrary.Add(ContactPrototype);

end.
