unit ProductsList;

interface

uses
  System.Generics.Collections, AppProduct;

type
  TAppProductRec = record
    Product: TAppProduct;
    FileName: String;
  end;

  TAppProductsList = class(TList<TAppProductRec>)
  public
    function Get(Index: Integer): TAppProduct; // Not Working!
    procedure LoadApp(FileName: String);
    procedure LoadProductsDir(ProductsDir: String);
    procedure Delete(Index: Integer);
  end;

implementation

uses
  System.Types, System.IOUtils, System.SysUtils;

{ TAppProductsList }

procedure TAppProductsList.Delete(Index: Integer);
begin
  if Items[Index].Product.Resources.Count > 0 then
    // Удаляемое приложение содержит ресурсы
    TDirectory.Delete(ExtractFilePath(Items[Index].FileName) + Items[Index]
      .Product.Settings.GetValue('Name'), True);
  TFile.Delete(Items[Index].FileName);
  inherited Delete(Index);
end;

function TAppProductsList.Get(Index: Integer): TAppProduct;
var
  AppLoader: TXMLAppLoader;
begin
  AppLoader := TXMLAppLoader.Create(Items[Index].Product,
    Items[Index].FileName);
  if AppLoader.Load then
    Result := Items[Index].Product
  else
    Result := nil;
end;

procedure TAppProductsList.LoadApp(FileName: String);
var
  AppProduct: TAppProduct;
  AppLoader: TXMLAppLoader;
  ProductRec: TAppProductRec;
begin
  AppProduct := TAppProduct.Create(nil);
  AppLoader := TXMLAppLoader.Create(AppProduct, FileName);
  try
    // LoadResources для шаблонов
    if AppLoader.LoadSettings and AppLoader.LoadResources then
    begin
      ProductRec.Product := AppProduct;
      ProductRec.FileName := FileName;
      inherited Add(ProductRec);
    end;
  finally
    AppLoader.Free;
  end;
end;

procedure TAppProductsList.LoadProductsDir(ProductsDir: String);
var
  FileList: TStringDynArray;
  FileName: string;
begin
  if TDirectory.Exists(ProductsDir) then
  begin
    FileList := TDirectory.GetFiles(ProductsDir);
    for FileName in FileList do
      if ExtractFileExt(FileName).Equals('.xml') then
      begin
        LoadApp(FileName);
      end;
  end;
end;

end.
