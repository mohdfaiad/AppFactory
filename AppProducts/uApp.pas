unit uApp;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  AppProduct, Android.JNI.Toast;

type
  TfrmApp = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    fAppProduct: TAppProduct;
  public
    procedure LoadAppProduct(FileName: String);
  end;

var
  frmApp: TfrmApp;

implementation

uses System.IOUtils;

{$R *.fmx}

procedure TfrmApp.FormCreate(Sender: TObject);
begin
  fAppProduct := TAppProduct.Create(Self);
  fAppProduct.Content.DesignMode := false;
end;

procedure TfrmApp.LoadAppProduct(FileName: String);
var
  AppLoader: TAppLoader;
begin
  AppLoader := TXMLAppLoader.Create(fAppProduct, FileName);
  if AppLoader.Load then
    fAppProduct.Build
  else
  begin
    Toast('Не удалось загрузить ' + FileName);
    Hide;
  end;
end;

end.
