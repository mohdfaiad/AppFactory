unit DelphiExport;

interface

uses
  AppProduct, System.Classes;

type
  TDelphiSourceSaver = class(TAppSaver)
  private
    fVariablesDef, fSource: TStrings;
    fUnit: TStrings;
    function RemoveLineBreaks(S: String): String;
    procedure AddVar(Name, VarType: String);
    procedure AddConstructor(IndName, VarType: String);
    procedure AddContentAddition(IndName: String);
    procedure AddSettingsSet(IndName, SettingName, Value: String);
    procedure AddWidgetConstructor(IndName, WidgetName: String);
    procedure AddWidgetAddition(IndName: String);
    procedure AddResource(Res: String);
  public
    constructor Create(AppProduct: TAppProduct; FileName: String); override;
    procedure WriteContent;
    procedure WriteSettings;
    procedure WriteResources;
    function Save: Boolean; override;
  end;

const
  WIDGETS_USES = 'wuBrowser, wuContact, wuImage, wuMap, wuText;';

  FORM_Text = 'object frmApp: TfrmApp' + #13#10 + '  Left = 0' + #13#10 +
    '  Top = 0' + #13#10 + '  Caption = ''Form1''' + #13#10 +
    '  ClientHeight = 567' + #13#10 + '  ClientWidth = 384' + #13#10 +
    '  OnCreate = FormCreate' + #13#10 + 'end';

  UNIT_INIT = 'unit uMain;' + #13#10 + '' + #13#10 + 'interface' + #13#10 + '' +
    #13#10 + 'uses' + #13#10 +
    '  System.SysUtils, System.Types, System.UITypes, System.Classes,' + #13#10
    + '  System.Variants,' + #13#10 +
    '  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,' + #13#10
    + '' + #13#10 + '  // AppFactory Units' + #13#10 +
    '  AppProduct, Content, ContentCollection, Widgets, uIcons,' + #13#10 + '' +
    #13#10 + '  // Widgets' + #13#10 + WIDGETS_USES + #13#10 + '' + #13#10 +
    'type' + #13#10 + '  TfrmApp = class(TForm)' + #13#10 +
    '    procedure FormCreate(Sender: TObject);' + #13#10 + '  private' + #13#10
    + '    fAppProduct: TAppProduct;' + #13#10 + '  end;' + #13#10 + '' + #13#10
    + 'var' + #13#10 + '  frmApp: TfrmApp;' + #13#10 + '' + #13#10 +
    'implementation' + #13#10 + '' + #13#10 + 'uses System.IOUtils;' + #13#10 +
    '' + #13#10 + '{$R *.fmx}' + #13#10 + '' + #13#10 +
    'procedure TfrmApp.FormCreate(Sender: TObject);';
  UNIT_END = '    fAppProduct.Build;' + #13#10 + '   end;' + #13#10 + '' +
    #13#10 + 'end.';

implementation

uses
  System.SysUtils, System.IOUtils;

{ TDelphiSourceSaver }

procedure TDelphiSourceSaver.AddContentAddition(IndName: String);
begin
  fSource.Add(Format('  fAppProduct.Content.Add(%s);', [IndName]));
end;

procedure TDelphiSourceSaver.AddResource(Res: String);
begin
  fSource.Add('  fAppProduct.Content.Resources.Add(' + Res + ');');
end;

procedure TDelphiSourceSaver.AddConstructor(IndName, VarType: String);
begin
  fSource.Add('  ' + IndName + ' := ' + VarType + '.Create;');
end;

procedure TDelphiSourceSaver.AddSettingsSet(IndName, SettingName,
  Value: String);
begin
  fSource.Add(Format('  %s.Settings.SetValue(''%s'', ''%s'');',
    [IndName, SettingName, RemoveLineBreaks(Value)]));
end;

procedure TDelphiSourceSaver.AddVar(Name, VarType: String);
begin
  fVariablesDef.Add('  ' + Name + ': ' + VarType + ';');
end;

procedure TDelphiSourceSaver.AddWidgetAddition(IndName: String);
begin
  fSource.Add(Format('  fAppProduct.Widgets.Add(%s);', [IndName]));
end;

procedure TDelphiSourceSaver.AddWidgetConstructor(IndName, WidgetName: String);
begin
  fSource.Add(Format('  %s := WidgetsLibrary.Find(''%s'').Clone;',
    [IndName, WidgetName]));
end;

constructor TDelphiSourceSaver.Create(AppProduct: TAppProduct;
  FileName: String);
begin
  inherited Create(AppProduct, FileName);

  fVariablesDef := TStringList.Create;
  fSource := TStringList.Create;
  fUnit := TStringList.Create;

  fVariablesDef.Add('var');
  fSource.Add('begin');
  fSource.Add('  frmIcons := TfrmIcons.Create(Application);');
  fSource.Add('  fAppProduct := TAppProduct.Create(Self);');
end;

function TDelphiSourceSaver.RemoveLineBreaks(S: String): String;
const
  LineBreak = ''' + #13#10 + ''';
begin
  S := StringReplace(S, #13#10, LineBreak, [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, #13, LineBreak, [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(S, #10, LineBreak, [rfReplaceAll, rfIgnoreCase]);
end;

function TDelphiSourceSaver.Save: Boolean;
begin
  try
    Result := true;
    WriteResources;
    WriteSettings;
    WriteContent;
    with fUnit do
    begin
      // Unit File
      Clear;
      Add(UNIT_INIT);
      if fVariablesDef.Count > 1 then
        AddStrings(fVariablesDef);
      AddStrings(fSource);
      Add(UNIT_END);
      SaveToFile(fFileName + '.pas');

      // Form File
      Clear;
      Add(FORM_Text);
      SaveToFile(fFileName + '.fmx');
    end;
  except
    Result := false;
  end;
end;

procedure TDelphiSourceSaver.WriteContent;
var
  I, j: Integer;
  NodeName: String;
begin
  with fAppProduct do
  begin
    fSource.Add('');
    fSource.Add('// Content');

    for I := 0 to Content.Count - 1 do
    begin
      NodeName := Content[I].ContentName + I.ToString;
      AddVar(NodeName, Content[I].ClassName);
      AddConstructor(NodeName, Content[I].ClassName);
      AddContentAddition(NodeName);
      for j := 0 to Content[I].Settings.Count - 1 do
        AddSettingsSet(NodeName, Content[I].Settings[j].Name,
          Content[I].Settings[j].Value);
    end;

    fSource.Add('');
    fSource.Add('// Widgets');

    for I := 0 to Widgets.Count - 1 do
    begin
      NodeName := Widgets[I].Name + I.ToString;
      AddVar(NodeName, 'TWidget');
      AddWidgetConstructor(NodeName, Widgets[I].Name);
      AddWidgetAddition(NodeName);
      for j := 0 to Widgets[I].Settings.Count - 1 do
        AddSettingsSet(NodeName, Widgets[I].Settings[j].Name,
          Widgets[I].Settings[j].Value);
    end;
  end;
end;

procedure TDelphiSourceSaver.WriteResources;
var
  I: Integer;
  ResPath, RelResPath, NewRes: String;
begin
  try
    with fAppProduct do
    begin
      // Resources
      // ----------------------------------------------------------
      // Каталог сохранения ресурсов - расположение файла .xml + Имя программы
      ResPath := TPath.Combine(ExtractFilePath(fFileName), 'Resources');
      if (not TDirectory.Exists(ResPath)) and (Content.Resources.Count > 0) then
        TDirectory.CreateDirectory(ResPath);

      for I := 0 to Content.Resources.Count - 1 do
      begin
        NewRes := TPath.Combine(ResPath, ExtractFileName(Content.Resources[I]));
        if TFile.Exists(NewRes) then
          TFile.Delete(NewRes);
        // Копируем ресурс в новое расположение
        TFile.Copy(Content.Resources[I], NewRes);

        // Записываем путь
        AddResource('TPath.Combine(''Resources'', ''' +
          ExtractFileName(Content.Resources[I]) + ''')');
      end;
    end;
  except
    on E: Exception do
      raise Exception.CreateFmt
        ('Unable to write resources to "%s". Error message: %s',
        [fFileName, E.Message]);
  end;
end;

procedure TDelphiSourceSaver.WriteSettings;
var
  I: Integer;
begin
  with fAppProduct do
  begin
    fSource.Add('');
    fSource.Add('// Application Settings');
    for I := 0 to Settings.Count - 1 do
    begin
      AddSettingsSet('fAppProduct', Settings[I].Name, Settings[I].Value);
    end;
  end;
end;

end.
