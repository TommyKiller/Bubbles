unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Timer1: TTimer;
    Score: TLabel;
    HP: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Move;
    procedure Randomizing(j: Integer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  BackGround,Ellipse: TBitmap;
  GOM: Boolean;
  Map: array [-100..1400,-100..1400] of Integer;
  Cord,Invert: array of array of Integer;
  Size,Speed: array of Integer;
  i,j,m,n,k,BubblesCount,Interval,Points,Health: Integer;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Form1.Height:=600;
  Form1.Width:=900;
  BubblesCount:=15;
  Interval:=200;
  Points:=0;
  Health:=100;
  SetLength(Cord,2,BubblesCount);
  SetLength(Invert,2,BubblesCount);
  SetLength(Size,BubblesCount);
  SetLength(Speed,BubblesCount);
  GOM:=false;
  BackGround:=TBitmap.Create;
  BackGround.LoadFromFile('BackGround.bmp');
  Image1.Canvas.StretchDraw(Rect(0,0,Form1.Width,Form1.Height),BackGround);
  Ellipse:=TBitmap.Create;
  Ellipse.LoadFromFile('Ellipse.bmp');
  Ellipse.Transparent:=true;
  Score.Caption:='Score: '+IntToStr(Points);
  HP.Caption:='HP left: '+IntToStr(Health);
  Timer1.Enabled:=true;
  for m:=-100 to 1400 do
    for n:=-100 to 1400 do
      Map[m,n]:=0;
  for j:=0 to BubblesCount do Randomizing(j);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if Timer1.Enabled then begin
    Application.ProcessMessages;
    Timer1.Interval:=100;
    Image1.Canvas.StretchDraw(Rect(0,0,Form1.Width,Form1.Height),BackGround);
    Move;
  end;
end;

procedure TForm1.Move;
begin
  for i:=0 to BubblesCount do begin
    if (Cord[1,i]+Size[i])<=0 then begin
      if Health>0 then begin
        dec(Health);
        HP.Caption:='HP left: '+IntToStr(Health);
      end
      else if Health<=0 then GOM:=true;
      Randomizing(i);
    end
    else if (Cord[1,i]+Size[i])>0 then begin
      for m:=Cord[1,i] to Cord[1,i]+Size[i] do
        for n:=Cord[0,i] to Cord[0,i]+Size[i] do
          Map[m,n]:=0;
      case Invert[0,i] of
        0:begin
          Cord[0,i]:=Cord[0,i]-Invert[1,i];
          Invert[0,i]:=1;
        end;
        1:begin
          Cord[0,i]:=Cord[0,i]+Invert[1,i];
          Invert[0,i]:=0;
        end;
      end;
      Cord[1,i]:=Cord[1,i]-Speed[i];
      for m:=Cord[1,i] to Cord[1,i]+Size[i] do
        for n:=Cord[0,i] to Cord[0,i]+Size[i] do
          Map[m,n]:=1;
      Image1.Canvas.StretchDraw(Rect(Cord[0,i],Cord[1,i],Cord[0,i]+Size[i],Cord[1,i]+Size[i]),Ellipse);
    end;
  end;
end;

procedure TForm1.Randomizing(j: Integer);
begin
  if not GOM then
    repeat
      k:=0;
      Invert[0,j]:=random(2);
      Invert[1,j]:=random(20)+5;
      Speed[j]:=random(30)+5;
      Size[j]:=random(50)+25;
      Cord[0,j]:=random(Form1.Width-Size[j]);
      Cord[1,j]:=random(Interval)+Form1.Height;
      for m:=Cord[1,j] to Cord[1,j]+Size[j] do
        for n:=Cord[0,j] to Cord[0,j]+Size[j] do
          if Map[n,m]=1 then inc(k);
    until k=0
  else if GOM then begin
    with Image1.Canvas do begin
      Font.Size:=20;
      Brush.Color:=clRed;
      TextOut(300,250,'Game over! You score: '+IntToStr(Points));
    end;
  end;
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  y1,x1,d: Integer;
begin
  if not GOM then
    if Map[y,x]=1 then begin
      x1:=x;
      y1:=y;
      while Map[y1,x1]=1 do dec(y1);
      inc(y1);
      while Map[y1,x1]=1 do dec(x1);
      inc(x1);
      for d:=0 to BubblesCount do
        if ((Cord[0,d]=x1) and (Cord[1,d]=y1)) then begin
          Image1.Canvas.FillRect(Rect(Cord[0,d],Cord[1,d],Cord[0,d]+Size[d],Cord[1,d]+Size[d]));
          Randomizing(d);
        end;
      inc(Points);
      Score.Caption:='Score: '+IntToStr(Points);
    end;
end;

end.
