program AppProducts;

uses
  System.StartUpCopy,
  FMX.Forms,
  uApp in 'uApp.pas' {frmApp},
  uProducts in 'uProducts.pas' {frmProducts},

{$DEFINE WidgetsSupport}
{$I Widgets.inc};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmProducts, frmProducts);
  // Application.CreateForm(TfrmApp, frmApp);
  Application.Run;

end.
