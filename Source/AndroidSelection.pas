unit AndroidSelection;

interface

uses
  FMX.Objects, System.Classes, FMX.Controls, System.Types, FMX.Types;

type
  TAndroidSelection = class(TSelection)
  private
    fPaintGripSize: Extended;
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    property PaintGripSize: Extended read fPaintGripSize write fPaintGripSize;
  end;

  TComplexSelection = class
  private
    [Weak]
    fParent: TControl;
    [Weak]
    fSelectedControl: TControl;
    fContainerSelection: TSelection;
    fVisualSelection: TAndroidSelection;
    fSelectionBoundsRect: TRectF;
    fSizeChanged: Boolean;
    fOnSelectionResize: TNotifyEvent;
    LockDoResize: Boolean;
    procedure VisualSelectionResize(Sender: TObject);
    procedure VisualSelectionTrack(Sender: TObject);
    procedure DoSelectionResize;
  public
    constructor Create(AParent: TControl);
    destructor Destroy; override;
    procedure Select(Control: TControl);
    procedure Unselect(RestoreBoundsRect: Boolean = false);
    property Selection: TAndroidSelection read fVisualSelection;
    property SelectedControl: TControl read fSelectedControl
      write fSelectedControl;
    property SizeChanged: Boolean read fSizeChanged write fSizeChanged;
    property OnSelectionResize: TNotifyEvent read fOnSelectionResize
      write fOnSelectionResize;
  end;


implementation

uses
  FMX.Graphics, System.UIConsts;

{ TAndroidSelection }

constructor TAndroidSelection.Create(AOwner: TComponent);
begin
  inherited;
  GripSize := 20;
  PaintGripSize := 10;
end;

procedure TAndroidSelection.Paint;
var
  R: TRectF;
  Fill: TBrush;
const
  Inflate = -0.5;
var
  Stroke: TStrokeBrush;
begin
  if HideSelection then
    Exit;

  R := LocalRect;
  InflateRect(R, Inflate, Inflate);
  Canvas.Stroke.Thickness := 5;
  Canvas.DrawDashRect(R, 0, 0, AllCorners, AbsoluteOpacity, $FF1072C5);

  { angles }
  Fill := TBrush.Create(TBrushKind.bkGradient, $FF6FAAFF);
  Fill.Gradient.Color := $FF6FAAFF;
  Fill.Gradient.Color1 := $FF4E77EA;

  Stroke := TStrokeBrush.Create(TBrushKind.bkSolid, $FF1072C5);
  try
    R := LocalRect;
    InflateRect(R, Inflate, Inflate);
    Canvas.FillRect(RectF(R.Left - (fPaintGripSize), R.Top - (fPaintGripSize),
      R.Left + (fPaintGripSize), R.Top + (fPaintGripSize)), 0, 0, [],
      AbsoluteOpacity, Fill);
    Canvas.DrawRect(RectF(R.Left - (fPaintGripSize), R.Top - (fPaintGripSize),
      R.Left + (fPaintGripSize), R.Top + (fPaintGripSize)), 0, 0, [],
      AbsoluteOpacity, Stroke);

    R := LocalRect;
    Canvas.FillRect(RectF(R.Right - (fPaintGripSize), R.Top - (fPaintGripSize),
      R.Right + (fPaintGripSize), R.Top + (fPaintGripSize)), 0, 0, [],
      AbsoluteOpacity, Fill);
    Canvas.DrawRect(RectF(R.Right - (fPaintGripSize), R.Top - (fPaintGripSize),
      R.Right + (fPaintGripSize), R.Top + (fPaintGripSize)), 0, 0, [],
      AbsoluteOpacity, Stroke);

    R := LocalRect;
    Canvas.FillRect(RectF(R.Left - (fPaintGripSize),
      R.Bottom - (fPaintGripSize), R.Left + (fPaintGripSize),
      R.Bottom + (fPaintGripSize)), 0, 0, [], AbsoluteOpacity, Fill);
    Canvas.DrawRect(RectF(R.Left - (fPaintGripSize),
      R.Bottom - (fPaintGripSize), R.Left + (fPaintGripSize),
      R.Bottom + (fPaintGripSize)), 0, 0, [], AbsoluteOpacity, Stroke);

    R := LocalRect;
    Canvas.FillRect(RectF(R.Right - (fPaintGripSize),
      R.Bottom - (fPaintGripSize), R.Right + (fPaintGripSize),
      R.Bottom + (fPaintGripSize)), 0, 0, [], AbsoluteOpacity, Fill);
    Canvas.DrawRect(RectF(R.Right - (fPaintGripSize),
      R.Bottom - (fPaintGripSize), R.Right + (fPaintGripSize),
      R.Bottom + (fPaintGripSize)), 0, 0, [], AbsoluteOpacity, Stroke);
  finally
    Fill.Free;
    Stroke.Free;
  end;
end;

{ TComplexSelection }

constructor TComplexSelection.Create(AParent: TControl);
begin
  fParent := AParent;
  LockDoResize := true;
  fVisualSelection := TAndroidSelection.Create(nil);
  with fVisualSelection do
  begin
    Parent := AParent;
    OnResize := VisualSelectionResize;
    OnTrack := VisualSelectionTrack;
  end;

  fContainerSelection := TSelection.Create(nil);
  with fContainerSelection do
  begin
    HideSelection := true;
    Parent := AParent;
    HitTest := false;
    ClipChildren := true;
  end;

  fVisualSelection.Visible := false;
  fContainerSelection.Visible := false;
  LockDoResize := false;
end;

destructor TComplexSelection.Destroy;
begin
  Unselect;
  fContainerSelection.Parent := nil;
  fContainerSelection.Free;
  fVisualSelection.Parent := nil;
  fVisualSelection.Free;
  inherited;
end;

procedure TComplexSelection.DoSelectionResize;
begin
  if Assigned(fOnSelectionResize) and not LockDoResize then
    OnSelectionResize(Self);
end;

procedure TComplexSelection.Select(Control: TControl);
begin
  LockDoResize := true;
  if fSelectedControl <> nil then
    Unselect;

  fSelectedControl := Control;
  fSelectionBoundsRect := Control.BoundsRect;

  with fContainerSelection do
  begin
    Position := fSelectedControl.Position;
    // Align := fSelectedControl.Align;
    Height := fSelectedControl.Height;
    Width := fSelectedControl.Width;
    Visible := true;
    BringToFront;
  end;

  with fVisualSelection do
  begin
    Position := fSelectedControl.Position;
    Align := fSelectedControl.Align;
    Height := fSelectedControl.Height;
    Width := fSelectedControl.Width;
    Visible := true;
    BringToFront;
  end;

  fSelectedControl.Parent := fContainerSelection;
  fSelectedControl.Align := TAlignLayout.alClient;

  fSizeChanged := false;
  LockDoResize := false;
end;

procedure TComplexSelection.Unselect(RestoreBoundsRect: Boolean = false);
begin
  if fSelectedControl <> nil then
  begin
    with fSelectedControl do
    begin
      Align := fVisualSelection.Align;
      if RestoreBoundsRect then
        BoundsRect := fSelectionBoundsRect;
      Position := fVisualSelection.Position;
      Parent := fParent;
    end;

    fVisualSelection.Visible := false;
    fContainerSelection.Visible := false;
    fSelectedControl := nil;
  end;
end;

procedure TComplexSelection.VisualSelectionResize(Sender: TObject);
begin
  fParent.BeginUpdate;
  fContainerSelection.BeginUpdate;
  fVisualSelection.BeginUpdate;
  with fContainerSelection do
  begin
    Position := fVisualSelection.Position;
    Width := fVisualSelection.Width;
    Height := fVisualSelection.Height;
  end;
  with fVisualSelection do
  begin
    Position := fContainerSelection.Position;
    Width := fContainerSelection.Width;
    Height := fContainerSelection.Height;
  end;
  fVisualSelection.EndUpdate;
  fContainerSelection.EndUpdate;
  fParent.EndUpdate;
  fSizeChanged := true;
  DoSelectionResize;
end;

procedure TComplexSelection.VisualSelectionTrack(Sender: TObject);
begin
  fVisualSelection.Position := fContainerSelection.Position;
end;

end.
