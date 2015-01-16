unit Content;

interface

uses System.Generics.Collections, FMX.Types, CustomSettings, System.Classes,
  FMX.Controls;

type
  TWidget = class;
  TContent = class;

  TWidgetsCollection = class(TList<TWidget>)
  private
    [Weak]
    fContent: TContent;
  public
    procedure Delete(Index: Integer);
    procedure Clear;
    function Find(Name: String): TWidget;
    function Add(Widget: TWidget): Integer;
    property Content: TContent read fContent write fContent;
  end;

  TContentItem = class;
  TContentItemClass = class of TContentItem;

  // ---------------------------------------------------------------------------
  // Content (Всё содержимое)
  // ---------------------------------------------------------------------------

  TContentItemClickEvent = procedure(Sender: TContentItem) of object;

  TWidgetEvent = procedure(Sender: TWidget) of object;

  TContent = class(TList<TContentItem>)
  private
    fWidgets: TWidgetsCollection;
    [Weak]
    fContainer: TFmxObject;
    fResources: TStrings;
    fDesignMode: Boolean;
    fOnItemClick: TContentItemClickEvent;
    fOnItemDeactivate: TContentItemClickEvent;
    FOnGesture: TGestureEvent;
    fOnWidgetShow: TWidgetEvent;
    procedure SetOnItemClick(const Value: TContentItemClickEvent);
    procedure SetOnItemDeactivate(const Value: TContentItemClickEvent);
    procedure SetOnWidgetShow(const Value: TWidgetEvent);
  public
    constructor Create(Container: TFmxObject; Widgets: TWidgetsCollection);
    function Add(ContentItem: TContentItem): Integer;
    procedure Delete(Index: Integer);
    function Remove(const ContentItem: TContentItem): Integer;
    function GetContentByClass<T: class>(var ContentItemClass: T): Boolean;
    procedure Clear;
  public
    property Widgets: TWidgetsCollection read fWidgets;
    property Resources: TStrings read fResources write fResources;
    property Container: TFmxObject read fContainer write fContainer;
    property DesignMode: Boolean read fDesignMode write fDesignMode
      default false;
    property OnWidgetShow: TWidgetEvent read fOnWidgetShow
      write SetOnWidgetShow;
    property OnItemClick: TContentItemClickEvent read fOnItemClick
      write SetOnItemClick;
    property OnItemDeactivate: TContentItemClickEvent read fOnItemDeactivate
      write SetOnItemDeactivate;
    property OnGesture: TGestureEvent read FOnGesture write FOnGesture;
  end;

  TContentPosition = (cpNormal, cpFront, cpBack);

  TContentItem = class(TControl)
  private
    [Weak]
    fContent: TContent;
    fPosition: TContentPosition;
    fSelectable: Boolean;
    fSettings: TSettings;
    fOnDeactivate: TContentItemClickEvent;
    fOnActivate: TContentItemClickEvent;
    procedure SetSettings(const Value: TSettings);
    procedure SettingsChange(Settings: TSettings);
  protected
    procedure ApplySettings; virtual;
    procedure DoItemEnter(Sender: TObject);
    procedure DoItemExit(Sender: TObject);
  public
    class function ContentName: String; virtual; abstract;
    constructor Create; reintroduce; virtual;
    destructor Destroy; reintroduce; virtual;
    property ContentPosition: TContentPosition read fPosition write fPosition
      default TContentPosition.cpNormal;
    property Selectable: Boolean read fSelectable write fSelectable
      default True;
    property Settings: TSettings read fSettings write SetSettings;
    property Content: TContent read fContent write fContent;
    property OnActivate: TContentItemClickEvent read fOnActivate
      write fOnActivate;
    property OnDeactivate: TContentItemClickEvent read fOnDeactivate
      write fOnDeactivate;
  end;

  TWidgetsContent = class(TContentItem)
    // Определяет каркас для Меню Виджетов
  private
    fOnWidgetShow: TWidgetEvent;
  protected
    procedure DoWidgetShow(Widget: TWidget);
  public
    class function ContentName: String; override;
    procedure RestoreWidgets;
    constructor Create; override;
    procedure Build; virtual; abstract;
    property OnWidgetShow: TWidgetEvent read fOnWidgetShow write fOnWidgetShow;
  end;

  TWidgetsContentClass = class of TWidgetsContent;

  TWidget = class(TContentItem) // Prototype
  private
    fName: String;
    fCaption: String;
    fIconIndex: Integer;
    fOnSettingsChange: TWidgetEvent;
    // function GetSettings: TSettings;
    // procedure SetSettings(Value: TSettings);
    procedure SetCaption(const Value: String);
    procedure SetIconIndex(const Value: Integer);
  protected
    procedure ApplySettings; override;
  public
    constructor Create; override;
    procedure Show(Container: TFmxObject); reintroduce; virtual; abstract;
    // procedure Hide; virtual; abstract;
    function Clone: TWidget; virtual;
    procedure DoSettingsChange(Settings: TSettings);
    property Caption: String read fCaption write SetCaption;
    property Name: String read fName write fName;
    property IconIndex: Integer read fIconIndex write SetIconIndex;
    property OnSettingsChange: TWidgetEvent read fOnSettingsChange
      write fOnSettingsChange;
  end;

implementation

uses
  System.SysUtils, FMX.Dialogs, System.UITypes, uIcons;

{ TContent }

function TContent.Add(ContentItem: TContentItem): Integer;
var
  Content: TWidgetsContent;
begin
  Result := -1;
  if fContainer = nil then
    exit;
  if ContentItem is TWidgetsContent then
    if GetContentByClass<TWidgetsContent>(Content) then
      raise Exception.Create('Unable to all more then one TWidgetsContent');

  Result := inherited Add(ContentItem);
  with ContentItem do
  begin
    Content := self;
    OnActivate := fOnItemClick;
    OnDeactivate := fOnItemDeactivate;
    Parent := fContainer;

    if fContainer.ChildrenCount > 1 then
      case ContentPosition of
        cpFront:
          BringToFront;
        cpBack:
          SendToBack;
      end;
  end;
  if ContentItem is TWidgetsContent then
  begin
    TWidgetsContent(ContentItem).OnWidgetShow := fOnWidgetShow;
  end;

  // fContainer.InsertComponent(ContentItem);
end;

procedure TContent.Clear;
var
  i: Integer;
begin
  for i := Count - 1 downto 0 do
    Delete(i);
end;

constructor TContent.Create(Container: TFmxObject; Widgets: TWidgetsCollection);
begin
  inherited Create;
  fDesignMode := false;
  fContainer := Container;
  fWidgets := Widgets;
  fWidgets.Content := self;
  fResources := TStringList.Create;
end;

procedure TContent.Delete(Index: Integer);
var
  Item: TContentItem;
begin
  if Index < self.Count then
  begin
    Item := Items[Index];
    Item.Parent := nil;
    FreeAndNil(Item);
    inherited Delete(Index);
  end;
end;

function TContent.GetContentByClass<T>(var ContentItemClass: T): Boolean;
var
  i: Integer;
begin
  Result := false;
  for i := 0 to Count - 1 do
    if (Items[i] is T) then
    begin
      ContentItemClass := T(Items[i]);
      Result := True;
      exit;
    end;
end;

function TContent.Remove(const ContentItem: TContentItem): Integer;
begin
  Result := IndexOf(ContentItem);
  if Result >= 0 then
    Delete(Result);
end;

procedure TContent.SetOnItemClick(const Value: TContentItemClickEvent);
var
  i: Integer;
begin
  fOnItemClick := Value;
  for i := 0 to self.Count - 1 do
    Items[i].OnActivate := fOnItemClick;
end;

procedure TContent.SetOnItemDeactivate(const Value: TContentItemClickEvent);
begin
  fOnItemDeactivate := Value;
end;

procedure TContent.SetOnWidgetShow(const Value: TWidgetEvent);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    if Items[i] is TWidgetsContent then
      TWidgetsContent(Items[i]).OnWidgetShow := Value;
  fOnWidgetShow := Value;
end;

// Base Content
// ---------------------------------------------------------------------------
{ TContentItem }

procedure TContentItem.ApplySettings;
begin
  ContentPosition := TContentPosition(Settings.GetValue('Position').ToInteger);
end;

constructor TContentItem.Create;
begin
  inherited Create(nil);
  fSelectable := True;
  fSettings := TSettings.Create;
  with Settings do
  begin
    RegisterSetting(cstSpecial, 'Position', 'Положение',
      Integer(ContentPosition).ToString);
    OnChange := SettingsChange;
  end;
  OnClick := DoItemEnter;
  OnExit := DoItemExit;
end;

destructor TContentItem.Destroy;
begin
  FreeAndNil(fSettings);
  inherited;
end;

procedure TContentItem.DoItemEnter(Sender: TObject);
begin
  inherited DoEnter;
  if Assigned(fOnActivate) then
    OnActivate(self);
end;

procedure TContentItem.DoItemExit(Sender: TObject);
begin
  inherited DoExit;
  if Assigned(fOnDeactivate) then
    OnDeactivate(self);
end;

procedure TContentItem.SetSettings(const Value: TSettings);
begin
  fSettings := Value;
  ApplySettings;
end;

procedure TContentItem.SettingsChange(Settings: TSettings);
begin
  try
    ApplySettings;
  except
    on E: Exception do
      MessageDlg('Не удалось применить настройки для ' + self.ClassName + '. ' +
        E.Message, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], -1);
  end;
end;

{ TWidgetsContent }

class function TWidgetsContent.ContentName: String;
begin
  Result := 'Default Content';
end;

constructor TWidgetsContent.Create;
begin
  inherited;
  Align := TAlignLayout.alClient;
end;

procedure TWidgetsContent.DoWidgetShow(Widget: TWidget);
begin
  if Assigned(fOnWidgetShow) then
    OnWidgetShow(Widget);
end;

procedure TWidgetsContent.RestoreWidgets;
var
  i: Integer;
begin
  for i := 0 to fContent.Widgets.Count - 1 do
    fContent.Widgets[i].Parent := nil;
end;

{ TWidget }

procedure TWidget.ApplySettings;
begin
  inherited;
  with fSettings do
  begin
    fCaption := GetValue('Caption');
    fIconIndex := GetValue('Icon').ToInteger;
  end;
end;

function TWidget.Clone: TWidget;
begin
  Result := TWidget.Create;
  with Result do
  begin
    Content := fContent;
    Caption := fCaption;
    IconIndex := fIconIndex;
    Settings.Clear;
    Settings := fSettings.Clone;
  end;
end;

constructor TWidget.Create;
begin
  inherited Create;
  Align := TAlignLayout.alClient;
  fName := 'Widget';
  with fSettings do
  begin
    RegisterSetting(cstString, 'Caption', 'Заголовок', 'Widget');
    RegisterSetting(cstNone, 'Icon', 'Значок', '0');
    RegisterSetting(cstBoolean, 'ShowIcon', 'Отображать значок', '1');
    OnChange := DoSettingsChange;
  end;
end;

procedure TWidget.DoSettingsChange(Settings: TSettings);
begin
  ApplySettings;
  if Assigned(fOnSettingsChange) then
    OnSettingsChange(self);
end;

{ function TWidget.GetSettings: TSettings;
  begin
  Result := fSettings;
  end; }

procedure TWidget.SetCaption(const Value: String);
begin
  fCaption := Value;
  Settings.SetValue('Caption', Value);
end;

procedure TWidget.SetIconIndex(const Value: Integer);
begin
  fIconIndex := Value;
  Settings.SetValue('Icon', Value.ToString);
end;

{ procedure TWidget.SetSettings(Value: TSettings);
  begin
  fSettings := Value;
  ApplySettings;
  end; }

{ TWidgetsCollection }

function TWidgetsCollection.Add(Widget: TWidget): Integer;
begin
  Result := inherited Add(Widget);
  Widget.Content := fContent;
end;

procedure TWidgetsCollection.Clear;
var
  i: Integer;
begin
  for i := Count - 1 downto 0 do
    Delete(i);
end;

procedure TWidgetsCollection.Delete(Index: Integer);
var
  Item: TWidget;
begin
  if Index < self.Count then
  begin
    Item := Items[Index];
    Item.Parent := nil;
    FreeAndNil(Item);
    inherited Delete(Index);
  end;
end;

function TWidgetsCollection.Find(Name: String): TWidget;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if Items[i].Name = Name then
    begin
      Result := Items[i];
      break;
    end;
end;

end.
