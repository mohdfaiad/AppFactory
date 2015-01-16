program SampleProduct;

uses
  System.StartUpCopy,
  FMX.MobilePreview,
  FMX.Forms,
  uMain in 'uMain.pas' {frmApp};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmApp, frmApp);
  Application.Run;
end.
