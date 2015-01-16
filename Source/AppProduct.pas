unit AppProduct;

interface

uses
  System.SysUtils, FMX.Controls, XMLIntf, XMLDoc,

  Content, System.Classes, FMX.TabControl, Widgets, FMX.Types, CustomSettings;

type
  TAppProduct = class
  private
    fWidgets: TWidgetsCollection;
    [Weak]
    fContainer: TFmxObject;
    fContent: TContent;
    fSettings: TSettings;
    procedure CreateBase;
    procedure ApplySettings(Settings: TSettings);
    procedure ResetSettings;
    procedure SetContainer(const Value: TFmxObject);
    function GetResources: TStrings;
    procedure SetResources(const Value: TStrings);
  public
    constructor Create(Container: TFmxObject);
    destructor Destroy; override;
    procedure Build;
    procedure ClearAll;
    property Widgets: TWidgetsCollection read fWidgets;
    property Content: TContent read fContent;
    property Container: TFmxObject read fContainer write SetContainer;
    property Resources: TStrings read GetResources write SetResources;
    property Settings: TSettings read fSettings;
  end;

  TAppHolder = class
  protected
    [Weak]
    fAppProduct: TAppProduct;
    fFileName: String;
  public
    constructor Create(AppProduct: TAppProduct; FileName: String); virtual;
  end;

  TAppLoader = class(TAppHolder)
    function Load: Boolean; virtual; abstract;
  end;

  TAppSaver = class(TAppHolder)
    function Save: Boolean; virtual; abstract;
  end;

  TXMLAppLoader = class(TAppLoader)
  private
    fXML: IXMLDocument;
  public
    constructor Create(AppProduct: TAppProduct; FileName: String); override;
    function LoadSettings: Boolean;
    function LoadContent: Boolean;
    function LoadResources: Boolean;
    function Load: Boolean; override;
  end;

  TXMLAppSaver = class(TAppSaver)
  private
    fXML: IXMLDocument;
  public
    constructor Create(AppProduct: TAppProduct; FileName: String); override;
    procedure WriteContent;
    procedure WriteSettings;
    procedure WriteResources;
    procedure SaveFile;
    function Save: Boolean; override;
  end;

implementation

uses ContentCollection, System.IOUtils, FMX.Dialogs, System.UITypes,
  System.UIConsts;

{ TAppProduct }

procedure TAppProduct.ClearAll;
begin
  fWidgets.Clear;
  fContent.Clear;
  Resources.Clear;
  CreateBase;
  ResetSettings;
end;

constructor TAppProduct.Create(Container: TFmxObject);
begin
  fContainer := Container;
  fWidgets := TWidgetsCollection.Create;
  fContent := TContent.Create(fContainer, fWidgets);
  fSettings := TSettings.Create;
  with fSettings do
  begin
    RegisterSetting(cstString, 'Name', 'Название', 'Application');
    RegisterSetting(cstString, 'Version', 'Версия', '1.0');
    RegisterSetting(cstIcon, 'Icon', 'Значок', '-1');
    RegisterSetting(cstColor, 'Background', 'Фон',
      AlphaColorToString(claWhite));
    RegisterSetting(cstNone, 'NavigationStyle', 'Стиль навигации',
      'TTabNavigationContent');
    RegisterSetting(cstSpecial, 'Preview', '', '-1');
    OnChange := ApplySettings;
  end;
  CreateBase;
end;

procedure TAppProduct.CreateBase;
begin
  fContent.Add(TBackground.Create);
end;

destructor TAppProduct.Destroy;
begin
  fSettings.Free;
  fContent.Free;
  fWidgets.Free;
  inherited;
end;

function TAppProduct.GetResources: TStrings;
begin
  Result := fContent.Resources;
end;

procedure TAppProduct.ResetSettings;
begin
  with fSettings do
  begin
    BeginUpdate;
    SetValue('Name', 'Application');
    SetValue('Version', '1.0');
    SetValue('Icon', '-1');
    SetValue('Background', AlphaColorToString(claWhite));
    SetValue('NavigationStyle', 'TTabNavigationContent');
    EndUpdate;
    Update;
  end;
end;

procedure TAppProduct.SetContainer(const Value: TFmxObject);
begin
  fContainer := Value;
  fContent.Container := fContainer;
end;

procedure TAppProduct.SetResources(const Value: TStrings);
begin
  fContent.Resources := Value;
end;

procedure TAppProduct.ApplySettings(Settings: TSettings);
var
  I: Integer;
  Background: TBackground;
begin
  Background := nil;
  for I := 0 to fContent.Count - 1 do
    if fContent[I] is TBackground then
      Background := TBackground(fContent[I]);

  if Background <> nil then
    Background.Settings.SetValue('Color', Settings.GetValue('Background'));
end;

procedure TAppProduct.Build;
var
  WidgetsContent: TWidgetsContent;
  NaviStyle: String;
  fWidgetsContentType: TWidgetsContentClass;
begin
  if fContent.GetContentByClass<TWidgetsContent>(WidgetsContent) then
  begin
    NaviStyle := Settings.GetValue('NavigationStyle');

    if WidgetsContent.ContentName <> NaviStyle then
    begin
      WidgetsContent.RestoreWidgets;
      fContent.Delete(fContent.IndexOf(WidgetsContent));
      // Устанавливаем новый тип
      fWidgetsContentType := TWidgetsContentClass
        (ContentItemsLibrary.Find(NaviStyle));
      if fWidgetsContentType <> nil then
      begin
        // Создаём экземпляр TWidgetsContent нового типа
        WidgetsContent := fWidgetsContentType.Create;
        fContent.Add(WidgetsContent);
      end
      else
        raise Exception.CreateFmt
          ('Navigation style "%s" not found in ContentItemsLibrary',
          [NaviStyle]);
    end;
    WidgetsContent.Build;
  end
  else
  begin
    // if Widgets.Count > 0 then

  end;
end;

// -----------------------------------------------------------------------------
// Экспорт \ Импорт
// -----------------------------------------------------------------------------

{ TAppHolder }

constructor TAppHolder.Create(AppProduct: TAppProduct; FileName: String);
begin
  fAppProduct := AppProduct;
  fFileName := FileName;
end;

{ TXMLAppHolder }

function TXMLAppLoader.LoadSettings: Boolean;
var
  I: Integer;
begin
  // Application Settings
  // ----------------------------------------------------------
  with fAppProduct do
  begin
    Settings.BeginUpdate;
    for I := 0 to fXML.DocumentElement.AttributeNodes.Count - 1 do
    begin
      Settings.SetValue(fXML.DocumentElement.AttributeNodes[I].NodeName,
        fXML.DocumentElement.AttributeNodes[I].Text);
    end;
    Settings.EndUpdate;
    Settings.Update;
  end;
  Result := true;
end;

constructor TXMLAppLoader.Create(AppProduct: TAppProduct; FileName: String);
begin
  inherited;
  fXML := TXMLDocument.Create(FileName);
  if fXML.Version <> '1.0' then
    raise Exception.CreateFmt('Unable to load "%s". Version not supported!',
      [FileName]);
end;

function TXMLAppLoader.Load: Boolean;
begin
  with fAppProduct do
  begin
    ClearAll;
    // Загрузка всех элементов
    // Проядок загрузки строго фиксирован:
    // 1. Вначале загружаем ресурсы
    // 2. Затем создаём Content
    // 3. И только после - настройки (Чтобы применить TBackground)
    if LoadResources and LoadContent and LoadSettings then
    begin
      Build;
      Result := true;
    end
    else
    begin
      raise Exception.CreateFmt('Unable to load "%s"', [fFileName]);
      Result := false;
    end;
  end;
end;

function TXMLAppLoader.LoadContent: Boolean;
var
  Root, Node: IXMLNode;
  ContentItemClass: TContentItemClass;
  ContentItem: TContentItem;
  WidgetPrototype, Widget: TWidget;
  I: Integer;
  J: Integer;
begin
  // Content
  // ----------------------------------------------------------
  Root := fXML.DocumentElement.ChildNodes.FindNode('Content');
  if (Root <> nil) then
    for I := 0 to Root.ChildNodes.Count - 1 do
    begin
      Node := Root.ChildNodes[I];
      if Node <> nil then
      begin
        ContentItemClass := ContentItemsLibrary.Find(Node.NodeName);
        if ContentItemClass <> nil then
        begin
          ContentItem := ContentItemClass.Create;
          fAppProduct.Content.Add(ContentItem);
          with ContentItem.Settings do
          begin
            BeginUpdate;
            for J := 0 to ContentItem.Settings.Count - 1 do
              SetValue(J, Node.Attributes[ContentItem.Settings[J].Name]);
            EndUpdate;
            Update;
          end;
        end;
      end;
    end;

  // Widgets
  // ----------------------------------------------------------
  Root := fXML.DocumentElement.ChildNodes.FindNode('Widgets');
  if (Root <> nil) then
    for I := 0 to Root.ChildNodes.Count - 1 do
    begin
      Node := Root.ChildNodes[I];
      if Node <> nil then
      begin
        WidgetPrototype := WidgetsLibrary.Find(Node.NodeName);
        if WidgetPrototype <> nil then
        begin
          Widget := WidgetPrototype.Clone;
          fAppProduct.Widgets.Add(Widget);
          for J := 0 to Widget.Settings.Count - 1 do
            if Node.HasAttribute(Widget.Settings[J].Name) then
              Widget.Settings.SetValue(J,
                Node.Attributes[Widget.Settings[J].Name]);
          // TContentItem(ContentItem).Settings.Update;
        end;
      end;
    end;
  Result := true;
end;

function TXMLAppLoader.LoadResources: Boolean;
var
  Root, Node: IXMLNode;
  I: Integer;
begin
  // Resources
  // ----------------------------------------------------------
  Root := fXML.DocumentElement.ChildNodes.FindNode('Resources');
  if (Root <> nil) then
    for I := 0 to Root.ChildNodes.Count - 1 do
    begin
      Node := Root.ChildNodes[I];
      if Node <> nil then
        // Добавляем путь ресурса относительно расположения файла, с которого
        // загружаемся
        fAppProduct.Content.Resources.Add(ExtractFilePath(fFileName) +
          Node.Text);
    end;
  Result := true;
end;

{ TXMLAppSaver }

constructor TXMLAppSaver.Create(AppProduct: TAppProduct; FileName: String);
var
  Node: IXMLNode;
begin
  inherited;
  fXML := TXMLDocument.Create(nil);
  fXML.Options := [doNodeAutoIndent];
  fXML.Active := true;
  fXML.Version := '1.0';
  fXML.Encoding := 'utf-8';

  fXML.DocumentElement := fXML.AddChild('ApplicationProduct');
  Node := fXML.CreateNode('This file is generated by AppFactory', ntComment);
  fXML.DocumentElement.ChildNodes.Add(Node);
end;

function TXMLAppSaver.Save: Boolean;
begin
  Result := false;
  try
    if not TDirectory.Exists(TPath.GetDirectoryName(fFileName)) then
      TDirectory.CreateDirectory(TPath.GetDirectoryName(fFileName));
    WriteSettings;
    WriteContent;
    WriteResources;
    SaveFile;
  except
    Result := false;
    Exit;
  end;
  Result := true;
end;

procedure TXMLAppSaver.SaveFile;
begin
  fXML.SaveToFile(fFileName);
end;

procedure TXMLAppSaver.WriteContent;
var
  I: Integer;
  Root, Node: IXMLNode;
  J: Integer;
begin
  try
    with fAppProduct do
    begin
      // Content
      // ----------------------------------------------------------
      Root := fXML.DocumentElement.AddChild('Content');
      for I := 0 to Content.Count - 1 do
      begin
        Node := fXML.CreateNode(Content[I].ContentName);
        for J := 0 to Content[I].Settings.Count - 1 do
          Node.Attributes[Content[I].Settings[J].Name] :=
            Content[I].Settings[J].Value;

        Root.ChildNodes.Add(Node);
      end;

      // Widgets
      // ----------------------------------------------------------
      Root := fXML.DocumentElement.AddChild('Widgets');
      for I := 0 to Widgets.Count - 1 do
      begin
        Node := fXML.CreateNode(Widgets[I].Name);
        for J := 0 to Widgets[I].Settings.Count - 1 do
        begin
          { FNode := XML.CreateNode(Widgets[I].Settings[J].Name);
            FNode.Text := Widgets[I].Settings[J].Value;

            Node.ChildNodes.Add(FNode); }
          Node.Attributes[Widgets[I].Settings[J].Name] :=
            Widgets[I].Settings[J].Value;
        end;

        Root.ChildNodes.Add(Node);
      end;
    end;
  except
    on E: Exception do
      raise Exception.CreateFmt('Unable to write content to "%s".%s',
        [fFileName, E.Message]);
  end;
end;

procedure TXMLAppSaver.WriteResources;
var
  I: Integer;
  Root, Node: IXMLNode;
  AbsResPath, RelResPath, NewRes: String;
begin
  try
    with fAppProduct do
    begin
      // Resources
      // ----------------------------------------------------------
      // Каталог сохранения ресурсов - расположение файла .xml + Имя программы
      RelResPath := fAppProduct.Settings.GetValue('Name') +
        TPath.DirectorySeparatorChar;
      AbsResPath := TPath.Combine(ExtractFilePath(fFileName), RelResPath);
      if (not TDirectory.Exists(AbsResPath)) and (fContent.Resources.Count > 0)
      then
        TDirectory.CreateDirectory(AbsResPath);

      Root := fXML.DocumentElement.AddChild('Resources');
      for I := 0 to fContent.Resources.Count - 1 do
      begin
        Node := fXML.CreateNode('id', ntElement, '');

        // Если изменилось раположение (имя) AppProduct
        // ExtractFilePath
        NewRes := TPath.Combine(AbsResPath,
          ExtractFileName(fContent.Resources[I]));
        if ExtractFilePath(TPath.GetFullPath(fContent.Resources[I])) <> AbsResPath
        then
        begin
          if TFile.Exists(NewRes) then
            TFile.Delete(NewRes);
          // Копируем ресурс в новое расположение
          TFile.Copy(fContent.Resources[I], NewRes);
        end;

        // Записываем относительный путь
        Node.Text := TPath.Combine(RelResPath,
          ExtractFileName(fContent.Resources[I]));

        Root.ChildNodes.Add(Node);
      end;
    end;
  except
    on E: Exception do
      raise Exception.CreateFmt
        ('Unable to write resources to "%s". Error message: %s',
        [fFileName, E.Message]);
  end;
end;

procedure TXMLAppSaver.WriteSettings;
var
  J: Integer;
begin
  try
    // Application Settings
    // ----------------------------------------------------------
    for J := 0 to fAppProduct.fSettings.Count - 1 do
      fXML.DocumentElement.Attributes[fAppProduct.fSettings[J].Name] :=
        fAppProduct.fSettings[J].Value;
  except
    on E: Exception do
      raise Exception.CreateFmt('Unable to write settings to "%s".%s',
        [fFileName, E.Message]);
  end;
end;

end.
