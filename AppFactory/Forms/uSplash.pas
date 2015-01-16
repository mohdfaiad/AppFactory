unit uSplash;

interface

uses
  System.SysUtils, FMX.Controls, FMX.Forms, System.Classes, FMX.Types,
  FMX.Objects, FMX.Ani, FMX.StdCtrls;

type
  TfrmSplash = class(TForm)
    Image1: TImage;
    Image2: TImage;
    FloatAnimation1: TFloatAnimation;
    FloatAnimation2: TFloatAnimation;
    FloatAnimation3: TFloatAnimation;
    imgFooter: TImage;
    procedure FloatAnimation3Finish(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FloatAnimation1Finish(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSplash: TfrmSplash;

implementation

{$R *.fmx}

uses uEditor, uProducts, System.IOUtils, uIcons, uTemplates, uChooseNaviStyle;

procedure TfrmSplash.FloatAnimation1Finish(Sender: TObject);
begin
  FloatAnimation2.Start;
  FloatAnimation3.Start;
end;

procedure TfrmSplash.FloatAnimation3Finish(Sender: TObject);
begin
  frmProducts.Show;
end;

procedure TfrmSplash.FormShow(Sender: TObject);
begin
  Application.CreateForm(TfrmChooseNaviStyle, frmChooseNaviStyle);
  Application.CreateForm(TfrmIcons, frmIcons);
  Application.CreateForm(TfrmProducts, frmProducts);
  Application.CreateForm(TfrmEditor, frmEditor);
  Application.CreateForm(TfrmTemplates, frmTemplates);
  FloatAnimation1.Start;
end;

end.
