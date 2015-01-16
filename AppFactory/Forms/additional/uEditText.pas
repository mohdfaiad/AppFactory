unit uEditText;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Colors, FMX.StdCtrls, FMX.Layouts, FMX.Memo, FMX.Objects, FMX.Effects,
  FMX.VirtualKeyboard, FMX.Platform;

type
  TfrmEditText = class(TForm)
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label1: TLabel;
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    Memo1: TMemo;
  private

  public
    procedure SetText(Text: String);
    function GetText: String;
  end;

var
  frmEditText: TfrmEditText;

implementation

uses
  Android.JNI.Toast;

{$R *.fmx}
{ TfrmEditText }

function TfrmEditText.GetText: String;
begin
  Result := Memo1.Lines.Text;
end;

procedure TfrmEditText.SetText(Text: String);
begin
  Memo1.Lines.Text := Text;
end;

end.
