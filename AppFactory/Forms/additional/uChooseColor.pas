unit uChooseColor;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Edit, FMX.Colors, FMX.Layouts,
  FMX.StdCtrls, FMX.Objects, FMX.Effects;

type
  TfrmChooseColor = class(TForm)
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Layout1: TLayout;
    ColorPanel: TColorPanel;
    ColorBox: TColorBox;
    edColorValue: TEdit;
    ShadowEffect1: TShadowEffect;
    procedure ColorPanelChange(Sender: TObject);
    procedure edColorValueChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    procedure SetColor(Color: TAlphaColor);
    function GetColor: TAlphaColor;
  end;

var
  frmChooseColor: TfrmChooseColor;

implementation

uses
  System.UIConsts;

{$R *.fmx}

procedure TfrmChooseColor.ColorPanelChange(Sender: TObject);
begin
  edColorValue.Text := AlphaColorToString(ColorPanel.Color);
end;

procedure TfrmChooseColor.edColorValueChange(Sender: TObject);
begin
  try
    ColorPanel.Color := StringToAlphaColor(edColorValue.Text);
  except

  end;
end;

procedure TfrmChooseColor.FormShow(Sender: TObject);
begin
{$IFDEF Android}
  Width := Screen.Size.cx;
  Height := Screen.Size.cy;
  Panel1.Align := TAlignLayout.alCenter;
{$ENDIF}
end;

function TfrmChooseColor.GetColor: TAlphaColor;
begin
  Result := ColorPanel.Color;
end;

procedure TfrmChooseColor.SetColor(Color: TAlphaColor);
begin
  ColorPanel.Color := Color;
  ColorPanelChange(Self);
end;

end.
