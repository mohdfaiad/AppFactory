unit uIcons;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.ListBox, FMX.StdCtrls, FMX.Objects;

type
  TfrmIcons = class(TForm)
    lbIcons: TListBox;
    StyleBook1: TStyleBook;
    Layout1: TLayout;
    SpeedButton1: TSpeedButton;
    tbHeader: TToolBar;
    Label1: TLabel;
    ListBoxGroupHeader1: TListBoxGroupHeader;
    lbFlatStyle: TListBox;
    itmFlatIcons: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    ListBoxItem7: TListBoxItem;
    ListBoxItem8: TListBoxItem;
    ListBoxItem9: TListBoxItem;
    ListBoxItem10: TListBoxItem;
    ListBoxItem11: TListBoxItem;
    ListBoxItem12: TListBoxItem;
    ListBoxItem13: TListBoxItem;
    ListBoxItem14: TListBoxItem;
    ListBoxItem15: TListBoxItem;
    ListBoxItem16: TListBoxItem;
    ListBoxItem17: TListBoxItem;
    ListBoxItem18: TListBoxItem;
    ListBoxItem19: TListBoxItem;
    ListBoxItem20: TListBoxItem;
    ListBoxItem21: TListBoxItem;
    ListBoxItem22: TListBoxItem;
    ListBoxItem23: TListBoxItem;
    ListBoxItem24: TListBoxItem;
    ListBoxItem25: TListBoxItem;
    ListBoxItem26: TListBoxItem;
    ListBoxGroupHeader2: TListBoxGroupHeader;
    ListBoxGroupHeader3: TListBoxGroupHeader;
    itmContentIcons: TListBoxItem;
    lbContentIcons: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem27: TListBoxItem;
    ListBoxItem28: TListBoxItem;
    ListBoxItem29: TListBoxItem;
    ListBoxItem30: TListBoxItem;
    itmECommerce: TListBoxItem;
    lbECommerce: TListBox;
    ListBoxItem31: TListBoxItem;
    ListBoxItem32: TListBoxItem;
    ListBoxItem33: TListBoxItem;
    ListBoxItem34: TListBoxItem;
    ListBoxItem36: TListBoxItem;
    ListBoxItem37: TListBoxItem;
    ListBoxItem38: TListBoxItem;
    ListBoxItem42: TListBoxItem;
    ListBoxItem43: TListBoxItem;
    ListBoxItem39: TListBoxItem;
    ListBoxItem40: TListBoxItem;
    ListBoxItem41: TListBoxItem;
    ListBoxItem44: TListBoxItem;
    ListBoxItem45: TListBoxItem;
    imgNoImage: TImage;
    Label2: TLabel;
    rctMessage: TRectangle;
    imgProduct: TImage;
    procedure FormShow(Sender: TObject);
    procedure lbFlatStyleItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    IconIndex: Integer;
    function GetAbs(IconGroup: Integer; Index: Integer): Integer;
    function GetIcon(IconGroup: Integer; Index: Integer): TBitmap;
    function GetIconAbs(Index: Integer): TBitmap;
  end;

var
  frmIcons: TfrmIcons;

implementation

{$R *.fmx}
{ TfrmIcons }

procedure TfrmIcons.FormResize(Sender: TObject);
  function TruncR(X: Extended): Integer;
  begin
    if Frac(X) > 0.000005 then
      Result := Trunc(X) + 1
    else
      Result := Trunc(X);
  end;

begin
  itmContentIcons.Height := lbContentIcons.ItemHeight *
    TruncR(lbContentIcons.Items.Count / lbContentIcons.Columns);

  itmFlatIcons.Height := lbFlatStyle.ItemHeight *
    TruncR(lbFlatStyle.Items.Count / lbFlatStyle.Columns);
  itmECommerce.Height := lbECommerce.ItemHeight *
    TruncR(lbECommerce.Items.Count / lbECommerce.Columns);
end;

procedure TfrmIcons.FormShow(Sender: TObject);
begin
  IconIndex := -1;
end;

function TfrmIcons.GetAbs(IconGroup, Index: Integer): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := IconGroup downto 1 do
    case I of
      1:
        inc(Result, lbContentIcons.Items.Count);
      2:
        inc(Result, lbECommerce.Items.Count);
    end;
  if Result = 0 then
    GetAbs := -1
  else
    Result := Result + Index + 1;
end;

function TfrmIcons.GetIcon(IconGroup, Index: Integer): TBitmap;
var
  SourceListBox: TListBox;
begin
  SourceListBox := nil;
  case IconGroup of
    0:
      SourceListBox := lbContentIcons;
    1:
      SourceListBox := lbFlatStyle;
    2:
      SourceListBox := lbECommerce;
  end;
  if SourceListBox <> nil then
  begin
    try
      if (Index >= 0) and (Index < SourceListBox.Items.Count) then
        Result := SourceListBox.ItemByIndex(Index).ItemData.Bitmap;
    except
      Result := nil;
    end;
  end;
end;

function TfrmIcons.GetIconAbs(Index: Integer): TBitmap;
begin
  Result := nil;
  if (0 <= Index) and (Index < lbContentIcons.Items.Count) then
    Result := GetIcon(0, Index)
  else if (lbContentIcons.Items.Count <= Index) and
    (Index < lbContentIcons.Items.Count + lbFlatStyle.Items.Count) then
    Result := GetIcon(1, Index - lbContentIcons.Items.Count)
  else if (lbContentIcons.Items.Count + lbFlatStyle.Items.Count <= Index) and
    (Index < lbContentIcons.Items.Count + lbFlatStyle.Items.Count +
    lbECommerce.Items.Count) then
    Result := GetIcon(2, Index - lbContentIcons.Items.Count -
      lbFlatStyle.Items.Count)
end;

procedure TfrmIcons.lbFlatStyleItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
var
  sIndex: Integer;
begin
  sIndex := 0;
  if Sender = lbFlatStyle then
    sIndex := lbContentIcons.Items.Count;
  if Sender = lbECommerce then
    sIndex := lbContentIcons.Items.Count + lbFlatStyle.Items.Count;

  IconIndex := Item.Index + sIndex;
  ModalResult := mrOk;
end;

end.
