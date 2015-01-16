unit uProducts;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  System.Generics.Collections, ProductsList, FMX.ListView.Types, FMX.ListView,
  FMX.StdCtrls, FMX.Layouts, FMX.ListBox, FMX.Objects;

type
  TfrmProducts = class(TForm)
    lbProducts: TListBox;
    ToolBar1: TToolBar;
    Label1: TLabel;
    StyleBook: TStyleBook;
    imgFooter: TImage;
    Image1: TImage;
    Label2: TLabel;
    ltEmpty: TLayout;
    procedure FormCreate(Sender: TObject);
    procedure lvProductsItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure FormShow(Sender: TObject);
    procedure lbProductsItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
  private
    { Private declarations }
  public
    fProductsList: TAppProductsList;
    procedure LoadProductsList;
  end;

var
  frmProducts: TfrmProducts;

implementation

uses
{$IFDEF Android}
  Androidapi.JNI.Os, Androidapi.JNI.JavaTypes,
  FMX.Platform.Android, Androidapi.JNI.GraphicsContentViewText,
{$ENDIF}
  System.IOUtils, uApp, uIcons;

{$R *.fmx}
{ TfrmProducts }

{ TfrmProducts }

procedure TfrmProducts.FormCreate(Sender: TObject);
begin
  frmApp := TfrmApp.Create(Application);
  frmIcons := TfrmIcons.Create(Application);
end;

procedure TfrmProducts.FormShow(Sender: TObject);
{$IFDEF Android}
var
  Intent: JIntent;
  Bundle: JBundle;
  FileName: String;
{$ENDIF}
begin
{$IFDEF Android}
  Intent := MainActivity.getIntent;
  Bundle := Intent.getExtras;
  if Assigned(Bundle) then
  begin
    FileName := JStringToString(Bundle.getString(StringToJString('FileName'),
      StringToJString('')));
    if FileName <> '' then
    begin
      frmApp.LoadAppProduct(FileName);
      frmApp.Show;
      Hide;
    end;
  end
  else
  begin
{$ENDIF}
    fProductsList := TAppProductsList.Create;
    LoadProductsList;
{$IFDEF Android}
  end;
{$ENDIF}
end;

procedure TfrmProducts.lbProductsItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  frmApp.LoadAppProduct(fProductsList[Item.Index].FileName);
  frmApp.Show;
end;

procedure TfrmProducts.LoadProductsList;
var
  I, IconIndex: Integer;
  Item: TListBoxItem;
begin
  fProductsList.LoadProductsDir(TPath.GetSharedDownloadsPath +
    TPath.DirectorySeparatorChar + 'AppFactory' + TPath.DirectorySeparatorChar +
    'Products');
  for I := 0 to fProductsList.Count - 1 do
  begin
    Item := TListBoxItem.Create(lbProducts);
    Item.Parent := lbProducts;
    Item.Height := 150;
    // Item.StyleName := 'ProductItem';
    Item.StylesData['ProductName'] := fProductsList[I]
      .Product.Settings.GetValue('Name');
    Item.StylesData['Version'] := 'Версия: ' + fProductsList[I]
      .Product.Settings.GetValue('Version');

    IconIndex := fProductsList[I].Product.Settings.GetValue('Icon').ToInteger;
    if IconIndex = -1 then
      Item.ItemData.Bitmap := frmIcons.imgProduct.Bitmap
    else
      Item.ItemData.Bitmap := frmIcons.GetIconAbs(IconIndex);
    Item.StylesData['pic'] := Item.ItemData.Bitmap;
  end;
  ltEmpty.Visible :=  fProductsList.Count = 0;
end;

procedure TfrmProducts.lvProductsItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  frmApp.LoadAppProduct(fProductsList[AItem.Index].FileName);
  frmApp.Show;
end;

end.
