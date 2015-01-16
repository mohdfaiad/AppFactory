unit CustomSettings;

interface

uses System.Generics.Collections, System.Classes;

type
  TCustomSettingType = (cstNone, cstSpecial, cstString, cstInteger, cstIcon,
    cstBoolean, cstImage, cstAlignment, cstColor, cstText, cstWrapMode,
    cstTextAlign);

  // PSettingItem = ^TSettingItem;
  TSettingItem = record
    Name: String;
    Caption: String;
    Value: String;
    SettingType: TCustomSettingType;
  end;

  TSettings = class;

  TSettingsEvent = procedure(Settings: TSettings) of object;

  TSettings = class(TList<TSettingItem>)
  private
    fOnChange: TSettingsEvent;
    fLockUpdate: Integer;
    function Find(Name: String): Integer;
    procedure DoChange;
  public
    procedure Update;
    procedure BeginUpdate;
    procedure EndUpdate;
    function SetValue(ItemIndex: Integer; Value: String): Boolean; overload;
    function SetValue(Name: String; Value: String): Boolean; overload;
    function GetValue(Name: String): String;
    function Clone: TSettings;
    function Registered(Name: String): Boolean;
    procedure RegisterSetting(SettingType: TCustomSettingType; Name: String;
      Caption: String; Value: String);
    property OnChange: TSettingsEvent read fOnChange write fOnChange;
  end;

implementation

uses
  System.SysUtils;

{ TSettings }

function TSettings.Registered(Name: String): Boolean;
begin
  Result := Find(Name) <> -1;
end;

procedure TSettings.RegisterSetting(SettingType: TCustomSettingType;
  Name: String; Caption: String; Value: String);
var
  Item: TSettingItem;
begin
  if Find(Name) <> -1 then
    raise Exception.Create('Setting with same name already registered!');

  Item.Name := Name;
  Item.Caption := Caption;
  Item.SettingType := SettingType;
  Item.Value := Value;
  Self.Add(Item);
end;

procedure TSettings.BeginUpdate;
begin
  inc(fLockUpdate);
end;

function TSettings.Clone: TSettings;
var
  I: Integer;
begin
  Result := TSettings.Create;
  for I := 0 to Count - 1 do
    Result.RegisterSetting(Items[I].SettingType, Items[I].Name,
      Items[I].Caption, Items[I].Value);
end;

procedure TSettings.DoChange;
begin
  if Assigned(fOnChange) then
    OnChange(Self);
end;

procedure TSettings.EndUpdate;
begin
  if fLockUpdate > 0 then
    dec(fLockUpdate);
end;

function TSettings.Find(Name: String): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Count - 1 do
    if Items[I].Name = Name then
    begin
      Result := I;
      break;
    end;
end;

function TSettings.SetValue(Name, Value: String): Boolean;
var
  ItemIndex: Integer;
begin
  Result := false;
  ItemIndex := Find(Name);
  if ItemIndex <> -1 then
    Result := SetValue(ItemIndex, Value)
  else
    raise Exception.CreateFmt('Setting "%s" is not registered!', [Name]);
end;

function TSettings.SetValue(ItemIndex: Integer; Value: String): Boolean;
var
  Item: TSettingItem;
begin
  if (ItemIndex > -1) and (ItemIndex < Count) then
  begin
    Item := Items[ItemIndex];
    Item.Value := Value;
    Items[ItemIndex] := Item;
    Result := true;
  end
  else
    raise Exception.CreateFmt('Setting with index %s is not registered!',
      [ItemIndex]);
  if fLockUpdate = 0 then
    DoChange;
end;

procedure TSettings.Update;
begin
  DoChange;
end;


function TSettings.GetValue(Name: String): String;
var
  ItemIndex: Integer;
begin
  Result := '';
  ItemIndex := Find(Name);
  if ItemIndex <> -1 then
  begin
    Result := Items[ItemIndex].Value;
  end
  else
    raise Exception.CreateFmt('Setting "%s" is not registered!', [Name]);
end;

end.
