unit uTemplates;

// Включаем загрузку шаблонов
{$DEFINE Templates}

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ListBox,
  FMX.Layouts, ProductsList, FMX.StdCtrls;

type
  TfrmTemplates = class(TForm)
    lbTemplates: TListBox;
    ListBoxItem1: TListBoxItem;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ToolBar2: TToolBar;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    StyleBook: TStyleBook;
    procedure FormCreate(Sender: TObject);
  public
    TemplatesList: TAppProductsList;
    procedure LoadTemplates;
    procedure ShowTemplatesList;
    function GetTemplate: Integer;
  end;

var
  frmTemplates: TfrmTemplates;

implementation

uses
  AppProduct, System.IOUtils;

{$R *.fmx}

procedure TfrmTemplates.FormCreate(Sender: TObject);
begin
  TemplatesList := TAppProductsList.Create;
  LoadTemplates;
  ShowTemplatesList;
end;

function TfrmTemplates.GetTemplate: Integer;
begin
  if lbTemplates.Selected <> nil then
    Result := lbTemplates.Selected.Index
  else
    Result := 0;
end;

procedure TfrmTemplates.LoadTemplates;
begin
{$IF DEFINED(Android) and DEFINED(Templates)}
    TemplatesList.LoadApp(TPath.Combine(TPath.GetDocumentsPath, 'Muesli.xml'));
    TemplatesList.LoadApp(TPath.Combine(TPath.GetDocumentsPath, 'Coffee.xml'));
    TemplatesList.LoadApp(TPath.Combine(TPath.GetDocumentsPath,
      'My University.xml'));
{$ENDIF}
end;

procedure TfrmTemplates.ShowTemplatesList;
var
  i, Res: Integer;
  Item: TListBoxItem;
  TemplateProduct: TAppProduct;
begin
  // Шаблоны загружаются индивидуально с помошью fTemplatesList
  for i := 0 to TemplatesList.Count - 1 do
  begin
    TemplateProduct := TemplatesList[i].Product;

    Item := TListBoxItem.Create(nil);
    Item.Width := 200;
    Item.Parent := lbTemplates;
    Item.StyleLookup := 'CustomItem';
    Item.Text := TemplateProduct.Settings.GetValue('Name');
    Res := TemplateProduct.Settings.GetValue('Preview').ToInteger;
    if Res <> -1 then
      Item.ItemData.Bitmap.LoadFromFile(TemplateProduct.Resources[Res]);
  end;
end;

end.
