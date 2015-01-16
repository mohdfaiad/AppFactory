unit Resources;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Menus;

type
  TResourceType = (rtIcons, rtContentItemsIcons, rtSpecial);

  TfrResources = class(TFrame)
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    srcSpecial: TPopupMenu;
    MenuItem8: TMenuItem;
    srcContentItems: TPopupMenu;
    MenuItem9: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    srcIcons: TPopupMenu;
    MenuItem14: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem25: TMenuItem;
    MenuItem26: TMenuItem;
    MenuItem27: TMenuItem;
    MenuItem28: TMenuItem;
  private
    function GetResBitmap(ResourceSource: TResourceType; Index: Integer)
      : TBitmap;
  public

  end;

var
  frResources: TfrResources;

implementation

{$R *.fmx}
{ TfrResurces }


function TfrResources.GetResBitmap(ResourceSource: TResourceType;
  Index: Integer): TBitmap;
var
  Source: TPopupMenu;
begin
  Source := nil;
  Result := nil;
  case ResourceSource of
    rtIcons: Source := srcIcons;
    rtContentItemsIcons: Source := srcContentItems;
    rtSpecial: Source := srcSpecial;
  end;

    // Source := TPopupMenu(FindComponent(ResourceName));
    if Assigned(Source) then
    begin
      try
        Result := nil;
        if Index < Source.ItemsCount then
        begin
          Result := Source.Items[Index].Bitmap;
        end;
      except
        Result := nil;
      end;
    end;
end;

end.
