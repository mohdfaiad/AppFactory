unit Widgets;

interface

uses
  Content, FMX.Types, FMX.Forms, System.Generics.Collections, FMX.Controls,
  CustomSettings, System.Classes;

type
  TProc = procedure;

  IWidgetAsc = interface(IInterface)
    ['{B787E06B-FE59-4665-BCE8-4AFF3D8D47D2}']
    function GetSetSettingsEvent: TWidgetEvent;
    procedure WidgetShow;
  end;

  TFrameClass = class of TFrame;

  TFrameWidgetPrototype = class(TWidget) // Concrete Prototype
  private
    fFrameClass: TFrameClass;
    [Weak]
    fFrame: TFrame; // Содержит конкретный фрейм
  public
    constructor Create(FrameClass: TFrameClass; AName, ACaption: string;
      AIconIndex: Integer); reintroduce;
    destructor Destroy; override;
    // Создаёт и отображает экземпляр виджета
    procedure Show(Container: TFmxObject); override;
    function Clone: TWidget; override;
  protected
    property FrameClass: TFrameClass read fFrameClass write fFrameClass;
  end;

  TFormClass = class of TForm;

  TFormWidgetPrototype = class(TWidget) // Concrete Prototype
  private
    fFormClass: TFormClass;
    [Weak]
    fForm: TForm;
  public
    constructor Create(FormClass: TFormClass; AName, ACaption: string;
      AIconIndex: Integer); reintroduce;
    destructor Destroy; override;
    // Создаёт и отображает экземпляр виджета
    procedure Show(Container: TFmxObject); override;
    function Clone: TWidget; override;
  protected
    property FormClass: TFormClass read fFormClass write fFormClass;
  end;

var
  WidgetsLibrary: TWidgetsCollection; // Диспетчер прототипов

implementation

uses
  System.SysUtils, uIcons;

{ TFrameWidgetPrototype }

function TFrameWidgetPrototype.Clone: TWidget;
begin
  Result := TFrameWidgetPrototype.Create(FrameClass, Name, Caption, IconIndex);
  Result.Settings := Settings.Clone;
  Result.Settings.SetValue('Icon', frmIcons.GetAbs(1, IconIndex).ToString);
  Result.Settings.OnChange := Result.DoSettingsChange;
end;

constructor TFrameWidgetPrototype.Create(FrameClass: TFrameClass;
  AName, ACaption: string; AIconIndex: Integer);
begin
  inherited Create;
  fFrameClass := FrameClass;
  Name := AName;
  Caption := ACaption;
  IconIndex := AIconIndex;
end;

destructor TFrameWidgetPrototype.Destroy;
begin
  Parent := nil;
  if Assigned(fFrame) then
    fFrame.Free;
  inherited;
end;

procedure TFrameWidgetPrototype.Show(Container: TFmxObject);
// Создаёт и отображает экземпляр виджета
begin
  Parent := Container;
  if not Assigned(fFrame) then
  begin
    fFrame := fFrameClass.Create(Self);
    fFrame.OnEnter := DoItemEnter;
    fFrame.OnExit := DoItemExit;
    fFrame.Parent := Self;
    fFrame.Align := TAlignLayout.alClient;
    if Supports(fFrame, IWidgetAsc) then
      OnSettingsChange := (fFrame as IWidgetAsc).GetSetSettingsEvent;
    DoSettingsChange(Self.Settings);
  end;

  if Supports(fFrame, IWidgetAsc) then
  begin
    OnSettingsChange := (fFrame as IWidgetAsc).GetSetSettingsEvent;
    (fFrame as IWidgetAsc).WidgetShow;
  end
  else
    raise Exception.CreateFmt('FrameWidget "%s" is not support IWidgetAsc!',
      [Self.Caption]);
end;

{ TFormWidgetPrototype }

function TFormWidgetPrototype.Clone: TWidget;
begin
  Result := TFormWidgetPrototype.Create(FormClass, Name, Caption, IconIndex);
  Result.Settings := Settings.Clone;
  Result.Settings.OnChange := Result.DoSettingsChange;
end;

constructor TFormWidgetPrototype.Create(FormClass: TFormClass;
  AName, ACaption: string; AIconIndex: Integer);
begin
  inherited Create;
  fFormClass := FormClass;
  Name := AName;
  Caption := ACaption;
  IconIndex := AIconIndex;
end;

destructor TFormWidgetPrototype.Destroy;
begin
  Parent := nil;
  if Assigned(fForm) then
    fForm.Free;
  inherited;
  inherited;
end;

procedure TFormWidgetPrototype.Show(Container: TFmxObject);
var
  I: Integer;
begin
  Parent := Container;

  if not Assigned(fForm) then
  begin
    fForm := fFormClass.Create(Self);
    fForm.OnShow := DoItemEnter;
    fForm.OnHide := DoItemExit;
    for I := 0 to fForm.ChildrenCount - 1 do
      fForm.Children[I].Parent := Self;
    // fForm.Parent := Self;
    // fForm.Visible := true;
    // fForm.Align := TAlignLayout.alClient;
    if Supports(fForm, IWidgetAsc) then
      OnSettingsChange := (fForm as IWidgetAsc).GetSetSettingsEvent;
    DoSettingsChange(Self.Settings);
  end;

  if Supports(fForm, IWidgetAsc) then
  begin
    OnSettingsChange := (fForm as IWidgetAsc).GetSetSettingsEvent;
    (fForm as IWidgetAsc).WidgetShow;
  end
  else
    raise Exception.CreateFmt('FrameWidget "%s" is not support IWidgetAsc!',
      [Self.Caption]);
end;

initialization

WidgetsLibrary := TWidgetsCollection.Create;

end.
