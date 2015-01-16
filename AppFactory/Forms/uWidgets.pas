unit uWidgets;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.StdCtrls, FMX.ListView;

type
  TfrmWidgets = class(TForm)
    procedure btnAddWidgetClick(Sender: TObject);
  private
    { Private declarations }
  public

  end;

var
  frmWidgets: TfrmWidgets;

implementation

{$R *.fmx}



end.
