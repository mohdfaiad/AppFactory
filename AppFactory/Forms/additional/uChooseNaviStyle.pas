unit uChooseNaviStyle;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListBox, FMX.Layouts, FMX.Objects, FMX.Effects;

type
  TfrmChooseNaviStyle = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    lbNavigationStyle: TListBox;
    ListBoxItem2: TListBoxItem;
    ListBoxItem1: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    Layout1: TLayout;
    SpeedButton1: TSpeedButton;
    Rectangle1: TRectangle;
    StyleBook1: TStyleBook;
    ShadowEffect1: TShadowEffect;
    procedure FormShow(Sender: TObject);
    procedure lbNavigationStyleItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmChooseNaviStyle: TfrmChooseNaviStyle;

implementation

{$R *.fmx}

procedure TfrmChooseNaviStyle.FormShow(Sender: TObject);
begin
{$IFDEF Android}
  Width := Screen.Size.cx;
  Height := Screen.Size.cy;
  Rectangle1.Align := TAlignLayout.alClient;
  Panel1.Align := TAlignLayout.alCenter;
{$ENDIF}
end;

procedure TfrmChooseNaviStyle.lbNavigationStyleItemClick
  (const Sender: TCustomListBox; const Item: TListBoxItem);
begin
  ModalResult := mrOK;
  Close;
end;

end.
