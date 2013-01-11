Program MiniStudio3D;

Uses Crt, Graphics, Common3D; {Keyboard, Mouse}

Const Header = 'MiniStudio 3D version 1.01, Copyright (C) 2003-2004 Martin Riesz.';
      MsgLoading = 'Loading...';
      MsgSaving = 'Saving...';
      MsgInvalidFilename = 'ERROR: Invalid filename.';
      MsgEnterFilename = 'Enter filename to edit: ';
      MsgError = 'Error: ';
      MsgNaN = ' is not a number.';
      MsgHelp : Array[1..27] Of String = (
      'P .......................................set perspective mode',
      'F .............................................set front mode',
      'T ...............................................set top mode',
      'R .............................................set right mode',
      'ins .................................................add line',
      'del ..............................................delete line',
      '+ ...........................................select next line',
      '- .......................................select previous line',
      '* .....................................toggle point selection',
      'end(persp.) ............rotate counterclockwise around Z axis',
      'home(persp.) ..................rotate clockwise around Z axis',
      '^S .................................................save file',
      '^L .................................................load file',
      'esc .....................................................quit',
      'Q ...................................................edit rel',
      'E ...................................................edit abs',
      'spacebar ..................toggle editing in perspective mode',
      'PgUp .................................................zoom in',
      'PgDown ..............................................zoom out',
      '/ ......................................reset to default zoom',
      'A ...................................................pan left',
      'D ..................................................pan right',
      'W .....................................................pan up',
      'S ...................................................pan down',
      'C .....................................reset panning / center',
      'tab ............................................face creating',
      'enter ......................................add point to face'
      );

      XX = GetMaxX Div 2;
      YY = GetMaxY Div 2;

Type ModeType = (Perspective, Front, Top, Right, EditablePerspective, SmoothPerspective);
     RotationType = (X, Y, Z);

Var S, D : Real;
    PocetUseciek : Word;
    Data, View : Array[1..400] Of Array[1..2] Of Record
     X, Y, Z : Real;
    End;
    PocetBodov : Word;
    Data1 : Array[1..400] Of Record
     Usecka : Word;
     Bod : Byte;
    End;
    View1 : Array[1..133] Of Array[1..3] Of Record
     X, Y, Z : Real;
    End;
    Q, W, A : Integer;
    E : Real;
    T : Text;
    Ch : Char;
    rX, rY, rZ : Real;
    Rotation : Array[1..1000] Of Record
     Rotation : RotationType;
     Amount : Real;
    End;
    Rotations : Word;
    Mode : ModeType;
    Usecka : Word;
    Bod : Byte;
    Zoom : Real;
    PanX, PanY : Integer;

    Tick : integer;

Procedure SetMode(M : ModeType);
Begin
 If (M = Perspective)
  And (Mode <> EditablePerspective) And (Mode <> SmoothPerspective) Then
 Begin
  rX := 0;
  rY := 0;
  rZ := 0;
  Rotations := 1;
  Rotation[Rotations].Rotation := X;
  Rotation[Rotations].Amount := 0;
 End;
 Mode := M;
End;

Procedure DrawAxisHelper;
Const AxisSize = 30;
Var XXX, YYY, ZZZ : Array[1..3] Of Real;
Begin
 XXX[1] := AxisSize - 10;
 YYY[1] := 0;
 ZZZ[1] := 0;
 XXX[2] := 0;
 YYY[2] := AxisSize - 10;
 ZZZ[2] := 0;
 XXX[3] := 0;
 YYY[3] := 0;
 ZZZ[3] := AxisSize - 10;
 For W := 1 To 3 Do
 Begin
  For A := 1 To Rotations Do
  Begin
   Case Rotation[A].Rotation Of
    X:
    Begin
     S := PolS(YYY[W], ZZZ[W]) + Rotation[A].Amount;
     D := PolD(YYY[W], ZZZ[W]);
     YYY[W] := RecX(S, D);
     ZZZ[W] := RecY(S, D);
    End;
    Y:
    Begin
     S := PolS(XXX[W], ZZZ[W]) + Rotation[A].Amount;
     D := PolD(XXX[W], ZZZ[W]);
     XXX[W] := RecX(S, D);
     ZZZ[W] := RecY(S, D);
    End;
    Z:
    Begin
     S := PolS(XXX[W], YYY[W]) + Rotation[A].Amount;
     D := PolD(XXX[W], YYY[W]);
     XXX[W] := RecX(S, D);
     YYY[W] := RecY(S, D);
    End;
   End;
  End;
 End;
 SetColor(LightGray);
 Line(AxisSize, GetMaxY - AxisSize, AxisSize + Round(XXX[1]), GetMaxY - AxisSize - Round(YYY[1]));
 Line(AxisSize, GetMaxY - AxisSize, AxisSize + Round(XXX[2]), GetMaxY - AxisSize - Round(YYY[2]));
 Line(AxisSize, GetMaxY - AxisSize, AxisSize + Round(XXX[3]), GetMaxY - AxisSize - Round(YYY[3]));
 SetColor(White);
 OutTextXY(AxisSize + Round(XXX[1]), GetMaxY - AxisSize - Round(YYY[1]), 'X');
 OutTextXY(AxisSize + Round(XXX[2]), GetMaxY - AxisSize - Round(YYY[2]), 'Y');
 OutTextXY(AxisSize + Round(XXX[3]), GetMaxY - AxisSize - Round(YYY[3]), 'Z');
End;

Procedure Draw;
Const TSize = 3; {polovicna velkost [] mieritka}
Var
 Dx, Dy, Dz, R, Temp : Real;
 ToSwap : Boolean;
Begin
 if (Tick>30) and (Tick>59) then rectangle(15,15,17,17);

 OutTextXY(2, 2, Header); {text zahlavia}
 Case Mode Of
  Front:
  Begin
   SetColor(White);
   If Bod <> 0 Then Rectangle(XX + PanX + Round(Zoom * Data[Usecka][Bod].X) - TSize,
    YY + PanY - Round(Zoom * Data[Usecka][Bod].Y) - TSize,
    XX + PanX + Round(Zoom * Data[Usecka][Bod].X) + TSize, YY + PanY - Round(Zoom * Data[Usecka][Bod].Y) + TSize);
   For Q := 1 To PocetUseciek Do
   Begin
    SetColor(White);
    If Q = Usecka Then SetColor(LightRed);
    Line(XX + PanX + Round(Zoom * Data[Q][1].X), YY + PanY - Round(Zoom * Data[Q][1].Y),
     XX + PanX + Round(Zoom * Data[Q][2].X), YY + PanY - Round(Zoom * Data[Q][2].Y));
   End;
   SetColor(LightRed);
   Line(XX + PanX + Round(Zoom * Data[Usecka][1].X), YY + PanY - Round(Zoom * Data[Usecka][1].Y),
    XX + PanX + Round(Zoom * Data[Usecka][2].X), YY + PanY - Round(Zoom * Data[Usecka][2].Y));
  End;
  Top:
  Begin
   SetColor(White);
   If Bod <> 0 Then Rectangle(XX + PanX + Round(Zoom * Data[Usecka][Bod].X) - TSize,
    YY + PanY - Round(Zoom * Data[Usecka][Bod].Z) - TSize,
    XX + PanX + Round(Zoom * Data[Usecka][Bod].X) + TSize, YY + PanY - Round(Zoom * Data[Usecka][Bod].Z) + TSize);
   For Q := 1 To PocetUseciek Do
   Begin
    SetColor(White);
    If Q = Usecka Then SetColor(LightRed);
    Line(XX + PanX + Round(Zoom * Data[Q][1].X), YY + PanY - Round(Zoom * Data[Q][1].Z),
     XX + PanX + Round(Zoom * Data[Q][2].X), YY + PanY - Round(Zoom * Data[Q][2].Z));
   End;
   SetColor(LightRed);
   Line(XX + PanX + Round(Zoom * Data[Usecka][1].X), YY + PanY - Round(Zoom * Data[Usecka][1].Z),
    XX + PanX + Round(Zoom * Data[Usecka][2].X), YY + PanY - Round(Zoom * Data[Usecka][2].Z));
  End;
  Right:
  Begin
   SetColor(White);
   If Bod <> 0 Then Rectangle(XX + PanX + Round(Zoom * Data[Usecka][Bod].Z) - TSize,
    YY + PanY - Round(Zoom * Data[Usecka][Bod].Y) - TSize,
    XX + PanX + Round(Zoom * Data[Usecka][Bod].Z) + TSize, YY + PanY - Round(Zoom * Data[Usecka][Bod].Y) + TSize);
   For Q := 1 To PocetUseciek Do
   Begin
    SetColor(White);
    If Q = Usecka Then SetColor(LightRed);
    Line(XX + PanX + Round(Zoom * Data[Q][1].Z), YY + PanY - Round(Zoom * Data[Q][1].Y),
     XX + PanX + Round(Zoom * Data[Q][2].Z), YY + PanY - Round(Zoom * Data[Q][2].Y));
   End;
   SetColor(LightRed);
   Line(XX + PanX + Round(Zoom * Data[Usecka][1].Z), YY + PanY - Round(Zoom * Data[Usecka][1].Y),
    XX + PanX + Round(Zoom * Data[Usecka][2].Z), YY + PanY - Round(Zoom * Data[Usecka][2].Y));
  End; {pre mody vyssie uz sa nic v draw neurobi}
  Perspective, EditablePerspective, SmoothPerspective:
  Begin
   If rX <> 0 Then                   {zapis nove otocenie medzi otocenia}
   Begin
    If Rotation[Rotations].Rotation = X Then
     Rotation[Rotations].Amount := Rotation[Rotations].Amount + rX
    Else
    Begin
     Inc(Rotations);
     Rotation[Rotations].Rotation := X;
     Rotation[Rotations].Amount := rX;
    End;
   End;
   If rY <> 0 Then
   Begin
    If Rotation[Rotations].Rotation = Y Then
     Rotation[Rotations].Amount := Rotation[Rotations].Amount + rY
    Else
    Begin
     Inc(Rotations);
     Rotation[Rotations].Rotation := Y;
     Rotation[Rotations].Amount := rY;
    End;
   End;
   If rZ <> 0 Then
   Begin
    If Rotation[Rotations].Rotation = Z Then
     Rotation[Rotations].Amount := Rotation[Rotations].Amount + rZ
    Else
    Begin
     Inc(Rotations);
     Rotation[Rotations].Rotation := Z;
     Rotation[Rotations].Amount := rZ;
    End;
   End;
   DrawAxisHelper;                     {kresli axis helper}
   Move(Data, View, SizeOf(Data));  {data su data a view budu otocene data}
   For Q := 1 To PocetUseciek Do    {otacame usecky vo view}
   Begin
    For W := 1 To 2 Do             {usecka ma 2 body}
    Begin
     For A := 1 To Rotations Do    {pocet roznych otoceni}
     Begin
      Case Rotation[A].Rotation Of   {v smere osi x, y alebo z}
       X:
       Begin
        S := PolS(View[Q][W].Y, View[Q][W].Z) + Rotation[A].Amount;
        D := PolD(View[Q][W].Y, View[Q][W].Z);    {otoc}
        View[Q][W].Y := RecX(S, D);
        View[Q][W].Z := RecY(S, D);
       End;
       Y:
       Begin
        S := PolS(View[Q][W].X, View[Q][W].Z) + Rotation[A].Amount;
        D := PolD(View[Q][W].X, View[Q][W].Z);
        View[Q][W].X := RecX(S, D);
        View[Q][W].Z := RecY(S, D);
       End;
       Z:
       Begin
        S := PolS(View[Q][W].X, View[Q][W].Y) + Rotation[A].Amount;
        D := PolD(View[Q][W].X, View[Q][W].Y);
        View[Q][W].X := RecX(S, D);
        View[Q][W].Y := RecY(S, D);
       End;
      End;
     End;
    End;
   End;
   For Q := 1 To PocetUseciek Do
   Begin
    {biele [] mieritko na bode Bod}
    SetColor(White);
    If (Q = Usecka) And ((Mode = EditablePerspective) Or (Mode = SmoothPerspective)) Then
     Rectangle(
     XX + PanX + Round(Zoom * View[Q][Bod].X
      *Abs(1-View[Q][Bod].Z/200)) - TSize,
     YY + PanY - Round(Zoom * View[Q][Bod].Y
      *Abs(1-View[Q][Bod].Z/200)) - TSize,
     XX + PanX + Round(Zoom * View[Q][Bod].X
      *Abs(1-View[Q][Bod].Z/200)) + TSize,
     YY + PanY - Round(Zoom * View[Q][Bod].Y
      *Abs(1-View[Q][Bod].Z/200)) + TSize
     );
    {biela, zlta alebo cervena usecka}
    If (Q = Usecka) And (Mode = EditablePerspective) Then SetColor(LightRed);
    If (Q = Usecka) And (Mode = SmoothPerspective) Then SetColor(Yellow);
    Line(
    XX + PanX + Round(Zoom * View[Q][1].X
     *Abs(1-View[Q][1].Z/200)),
    YY + PanY - Round(Zoom * View[Q][1].Y
     *Abs(1-View[Q][1].Z/200)),
    XX + PanX + Round(Zoom * View[Q][2].X
     *Abs(1-View[Q][2].Z/200)),
    YY + PanY - Round(Zoom * View[Q][2].Y
     *Abs(1-View[Q][2].Z/200))
    );
   End;
   {dalej uz len smooth>}
   If Mode = SmoothPerspective Then {pouzitie Data1 a View1}
   Begin
    For Q := 1 To PocetBodov Div 3 Do
    Begin
     View1[Q][1].X := View[Data1[Q * 3 - 2].Usecka][Data1[Q * 3 - 2].Bod].X;
     View1[Q][1].Y := View[Data1[Q * 3 - 2].Usecka][Data1[Q * 3 - 2].Bod].Y;
     View1[Q][1].Z := View[Data1[Q * 3 - 2].Usecka][Data1[Q * 3 - 2].Bod].Z;
     View1[Q][2].X := View[Data1[Q * 3 - 1].Usecka][Data1[Q * 3 - 1].Bod].X;
     View1[Q][2].Y := View[Data1[Q * 3 - 1].Usecka][Data1[Q * 3 - 1].Bod].Y;
     View1[Q][2].Z := View[Data1[Q * 3 - 1].Usecka][Data1[Q * 3 - 1].Bod].Z;
     View1[Q][3].X := View[Data1[Q * 3].Usecka][Data1[Q * 3].Bod].X;
     View1[Q][3].Y := View[Data1[Q * 3].Usecka][Data1[Q * 3].Bod].Y;
     View1[Q][3].Z := View[Data1[Q * 3].Usecka][Data1[Q * 3].Bod].Z;
    End;
    {For W := 1 To PocetBodov Div 3 - 1 Do
    For Q := 1 To PocetBodov Div 3 - 1 Do
    Begin
     ToSwap := False;
     If Included(View1[Q][1].X, View1[Q][1].Y, View1[Q][2].X, View1[Q][2].Y, View1[Q][3].X, View1[Q][3].Y,
      View1[Q + 1][1].X, View1[Q + 1][1].Y)
     Then
     If IsTop(View1[Q][1].X, View1[Q][1].Y, View1[Q][1].Z, View1[Q][2].X, View1[Q][2].Y, View1[Q][2].Z,
      View1[Q][3].X, View1[Q][3].Y, View1[Q][3].Z,
      View1[Q + 1][1].X, View1[Q + 1][1].Y, View1[Q + 1][1].Z)
     Then ToSwap := True;
     If Included(View1[Q][1].X, View1[Q][1].Y, View1[Q][2].X, View1[Q][2].Y, View1[Q][3].X, View1[Q][3].Y,
      View1[Q + 1][2].X, View1[Q + 1][2].Y)
     Then
     If IsTop(View1[Q][1].X, View1[Q][1].Y, View1[Q][1].Z, View1[Q][2].X, View1[Q][2].Y, View1[Q][2].Z,
      View1[Q][3].X, View1[Q][3].Y, View1[Q][3].Z,
      View1[Q + 1][2].X, View1[Q + 1][2].Y, View1[Q + 1][2].Z)
     Then ToSwap := True;
     If Included(View1[Q][1].X, View1[Q][1].Y, View1[Q][2].X, View1[Q][2].Y, View1[Q][3].X, View1[Q][3].Y,
      View1[Q + 1][3].X, View1[Q + 1][3].Y)
     Then
     If IsTop(View1[Q][1].X, View1[Q][1].Y, View1[Q][1].Z, View1[Q][2].X, View1[Q][2].Y, View1[Q][2].Z,
      View1[Q][3].X, View1[Q][3].Y, View1[Q][3].Z,
      View1[Q + 1][3].X, View1[Q + 1][3].Y, View1[Q + 1][3].Z)
     Then ToSwap := True;
     If ToSwap Then
     Begin
      Temp := View1[Q + 1][1].X;
      View1[Q + 1][1].X := View1[Q][1].X;
      View1[Q][1].X := Temp;
      Temp := View1[Q + 1][1].Y;
      View1[Q + 1][1].Y := View1[Q][1].Y;
      View1[Q][1].Y := Temp;
      Temp := View1[Q + 1][1].Z;
      View1[Q + 1][1].Z := View1[Q][1].Z;
      View1[Q][1].Z := Temp;
      Temp := View1[Q + 1][2].X;
      View1[Q + 1][2].X := View1[Q][2].X;
      View1[Q][2].X := Temp;
      Temp := View1[Q + 1][2].Y;
      View1[Q + 1][2].Y := View1[Q][2].Y;
      View1[Q][2].Y := Temp;
      Temp := View1[Q + 1][2].Z;
      View1[Q + 1][2].Z := View1[Q][2].Z;
      View1[Q][2].Z := Temp;
      Temp := View1[Q + 1][3].X;
      View1[Q + 1][3].X := View1[Q][3].X;
      View1[Q][3].X := Temp;
      Temp := View1[Q + 1][3].Y;
      View1[Q + 1][3].Y := View1[Q][3].Y;
      View1[Q][3].Y := Temp;
      Temp := View1[Q + 1][3].Z;
      View1[Q + 1][3].Z := View1[Q][3].Z;
      View1[Q][3].Z := Temp;
     End;
    End;
    }For Q := 1 To PocetBodov Div 3 Do
    Begin
     Dx := GetNormalX(View1[Q][1].X, View1[Q][1].Y, View1[Q][1].Z, View1[Q][2].X,
      View1[Q][2].Y, View1[Q][2].Z, View1[Q][3].X, View1[Q][3].Y, View1[Q][3].Z);
     Dy := GetNormalY(View1[Q][1].X, View1[Q][1].Y, View1[Q][1].Z, View1[Q][2].X,
      View1[Q][2].Y, View1[Q][2].Z, View1[Q][3].X, View1[Q][3].Y, View1[Q][3].Z);
     Dz := GetNormalZ(View1[Q][1].X, View1[Q][1].Y, View1[Q][1].Z, View1[Q][2].X,
      View1[Q][2].Y, View1[Q][2].Z, View1[Q][3].X, View1[Q][3].Y, View1[Q][3].Z);
     R := Abs(Pi/2 - Abs(Pi - PolS(Dz, PolD(Dx, Dy))));
     If (R > 0) And (R <= 0.314159265) Then SetFillColor(1);
     If (R > 0.314159265) And (R <= 0.62831853) Then SetFillColor(2);
     If (R > 0.62831853) And (R <= 0.942477796) Then SetFillColor(3);
     If (R > 0.942477796) And (R <= 1.256637061) Then SetFillColor(4);
     If (R > 1.256637061) Then SetFillColor(5);
     FillTriangle(XX + PanX + Round(Zoom * View1[Q][1].X
       *Abs(1-View1[Q][1].Z/200)),
      YY + PanY - Round(Zoom * View1[Q][1].Y
       *Abs(1-View1[Q][1].Z/200)),
      XX + PanX + Round(Zoom * View1[Q][2].X
       *Abs(1-View1[Q][2].Z/200)),
      YY + PanY - Round(Zoom * View1[Q][2].Y
       *Abs(1-View1[Q][2].Z/200)),
      XX + PanX + Round(Zoom * View1[Q][3].X
       *Abs(1-View1[Q][3].Z/200)),
      YY + PanY - Round(Zoom * View1[Q][3].Y
       *Abs(1-View1[Q][3].Z/200)));
    End;
    If PocetBodov Mod 3 = 1 Then
    Begin
     SetColor(LightBlue);
     Rectangle(XX + PanX + Round(Zoom * View[Data1[PocetBodov].Usecka][Data1[PocetBodov].Bod].X) - TSize,
     YY + PanY - Round(Zoom * View[Data1[PocetBodov].Usecka][Data1[PocetBodov].Bod].Y) - TSize,
     XX + PanX + Round(Zoom * View[Data1[PocetBodov].Usecka][Data1[PocetBodov].Bod].X) + TSize,
     YY + PanY - Round(Zoom * View[Data1[PocetBodov].Usecka][Data1[PocetBodov].Bod].Y) + TSize);
    End Else
    If PocetBodov Mod 3 = 2 Then
    Begin
     SetColor(LightBlue);
     Rectangle(XX + PanX + Round(Zoom * View[Data1[PocetBodov].Usecka][Data1[PocetBodov].Bod].X) - TSize,
     YY + PanY - Round(Zoom * View[Data1[PocetBodov].Usecka][Data1[PocetBodov].Bod].Y) - TSize,
     XX + PanX + Round(Zoom * View[Data1[PocetBodov].Usecka][Data1[PocetBodov].Bod].X) + TSize,
     YY + PanY - Round(Zoom * View[Data1[PocetBodov].Usecka][Data1[PocetBodov].Bod].Y) + TSize);
     Rectangle(XX + PanX + Round(Zoom * View[Data1[PocetBodov - 1].Usecka][Data1[PocetBodov - 1].Bod].X) - TSize,
     YY + PanY - Round(Zoom * View[Data1[PocetBodov - 1].Usecka][Data1[PocetBodov - 1].Bod].Y) - TSize,
     XX + PanX + Round(Zoom * View[Data1[PocetBodov - 1].Usecka][Data1[PocetBodov - 1].Bod].X) + TSize,
     YY + PanY - Round(Zoom * View[Data1[PocetBodov - 1].Usecka][Data1[PocetBodov - 1].Bod].Y) + TSize);
    End;
   End;
  End;
 End;
End;

Procedure GetInput(X, Y : Integer; Var S : String; MaxLength : Byte);
Var Ch : Char;                      {graficky readln}
Begin
 BorderOn;
 OutTextXY(X, Y, S + '_');
 Repeat
  Ch := Readkey;
  If (Ch >= ' ') And (Ch <= '~') And (Length(S) < MaxLength) Then
  Begin
   S := S + Ch;
   OutTextXY(X, Y, S + '_');
  End;
  If Ch = #8 Then
  Begin
   OutTextXY(X, Y, S + ' ');
   Delete(S, Length(S), 1);
   OutTextXY(X, Y, S + '_');
  End;
  If Ch = #0 Then ReadKey;
 Until (Ch = #13) Or (Ch = #27);
 OutTextXY(X, Y, S + ' ');
 BorderOff;
End;

Var Filename : String;

Procedure Save;       {ulozi inf do suboru filename}
Begin
 Assign(T, Filename);
 Rewrite(T);
 Writeln(T, PocetUseciek);
 For Q := 1 To PocetUseciek Do
 For W := 1 To 2 Do
 Begin
  Writeln(T, Data[Q][W].X);
  Writeln(T, Data[Q][W].Y);
  Writeln(T, Data[Q][W].Z);
 End;
 Writeln(T, PocetBodov);
 For Q := 1 To PocetBodov Do
 Begin
  Writeln(T, Data1[Q].Usecka);
  Writeln(T, Data1[Q].Bod);
 End;
 Close(T);
End;

Procedure Load;                  {znova loadne subor a prepise aktualne inf}
Begin
 Reset(T);
 Readln(T, PocetUseciek);
 For Q := 1 To PocetUseciek Do
 For W := 1 To 2 Do
 Begin
  Readln(T, E);
  Data[Q][W].X := E;
  Readln(T, E);
  Data[Q][W].Y := E;
  Readln(T, E);
  Data[Q][W].Z := E;
 End;
 Readln(T, PocetBodov);
 For Q := 1 To PocetBodov Do
 Begin
  Readln(T, Data1[Q].Usecka);
  Readln(T, Data1[Q].Bod);
 End;
 Close(T);
End;

Procedure Drop;                      {zmaze usecku !USECKA!}
Begin
 If Q > 1 Then
 Begin
  For Q := Usecka To PocetUseciek - 1 Do
  Begin
   Data[Q][1].X := Data[Q + 1][1].X;
   Data[Q][1].Y := Data[Q + 1][1].Y;
   Data[Q][1].Z := Data[Q + 1][1].Z;
   Data[Q][2].X := Data[Q + 1][2].X;
   Data[Q][2].Y := Data[Q + 1][2].Y;
   Data[Q][2].Z := Data[Q + 1][2].Z;
  End;
  Dec(PocetUseciek);
 End;
 If Usecka > PocetUseciek Then Usecka := PocetUseciek;
End;

Procedure Put;                       {len prida usecku s [0,0,0][0,0,0]}
Begin
 Data[PocetUseciek + 1][1].X := 0;
 Data[PocetUseciek + 1][1].Y := 0;
 Data[PocetUseciek + 1][1].Z := 0;
 Data[PocetUseciek + 1][2].X := 0;
 Data[PocetUseciek + 1][2].Y := 0;
 Data[PocetUseciek + 1][2].Z := 0;
 Inc(PocetUseciek);
 Usecka := PocetUseciek;
End;

Procedure Warning(S : String); {otvori !nachvilu! okno na varovanie}
Const WarningDelay = 500;
      WarningColor = LightRed;
Begin
 SetColor(WarningColor);
 OutTextXY(10, 10, S);
 SetPrevColor;
 Delay(WarningDelay);
 While KeyPressed Do ReadKey;
 SetColor(Black);
 OutTextXY(10, 10, S);
 SetPrevColor;
End;

Function StrExtra(Number : Real) : String; {vrati zaokruhlene cislo}
Var Temp : String;                         {ak sa nestrati ziadna inf}
Begin
 If Round(Number) = Number Then
  Str(Round(Number), Temp)
 Else
  Str(Number, Temp);
 StrExtra := Temp;
End;

Procedure Input(Var X, Y, Z : Real); {otvori dialogove okno pre vstup XYZ}
Var
 S : String;
 Code : Integer;
Begin
 BorderOn;
 SetColor(White);
 SetFillColor(Black);
 DrawToBufferOff;
 S := StrExtra(X);
 Repeat
  OutTextXY(10, 20, 'X = ');
  GetInput(31, 20, S, 30);
  Val(S, X, Code);
  If Code <> 0 Then Warning(MsgError + S + MsgNaN);
 Until Code = 0;
 S := StrExtra(Y);
 Repeat
  OutTextXY(10, 27, 'Y = ');
  GetInput(31, 27, S, 30);
  Val(S, Y, Code);
  If Code <> 0 Then Warning(MsgError + S + MsgNaN);
 Until Code = 0;
 S := StrExtra(Z);
 Repeat
  OutTextXY(11, 34, 'Z = ');
  GetInput(31, 34, S, 30);
  Val(S, Z, Code);
  If Code <> 0 Then Warning(MsgError + S + MsgNaN);
 Until Code = 0;
 BorderOff;
 DrawToBufferOn(PBuffer);
End;

Procedure Help; {otvori okno s napovedou a caka na readkey}

Const PHelp : Array[1..8] Of String = (
             'for k:= 1 to n do',
             'for j:= 1 to n do',
             'if k<>j then',
             'begin','p:=a[k,j];','for i:=1 to n+1 do',
             'a[i,j]:=a[i,k]*(-p)+a[k,k]*a[i,j];',
             'end;');
Var      TmpC : Char;
Begin
 BorderOn;
 SetColor(LightGray);
 SetFillColor(Black);
 DrawToBufferOff;
 For Q := 1 To 27 Do
 OutTextXY(2, 3 + Q * 7, MsgHelp[Q]);
 TmpC := ReadKey;
 If UpCase(TmpC) = 'H' Then
 Begin
  For Q := 1 To 8 Do OutTextXY(2, 3 + Q * 7, PHelp[Q]);
  TmpC := ReadKey;
  If UpCase(TmpC) = 'H' Then
  For Q := 1 To 27 Do
  OutTextXY(2, 3 + Q * 7, MsgHelp[Q]);
  ReadKey;
 End;

 BorderOff;
 DrawToBufferOn(PBuffer);
 {ReadKey;}
End;

Const LoadColor = LightGray;
      SaveColor = LoadColor;
      R = Pi/128;
      Zooming = 0.05;
      PanXX = 5;
      PanYY = PanXX;
Var irelX, irelY, irelZ : Real;

Begin
 InitGraph;
 If ParamCount > 0 Then Filename := ParamStr(1) Else
 Begin
  SetColor(White);
  SetFillColor(Red);
  BorderOn;
  OutTextXY(2, 2, Header);
  SetColor(LightGray);
  SetFillColor(Black);
  OutTextXY(2, 14, MsgEnterFilename);
  SetColor(White);
  GetInput(92, 14, Filename, 12);
 End;
 If Pos('.', Filename) = 0 Then Filename := Filename + '.3D';
 Assign(T, Filename);
 {$I-}
 Reset(T);
 If IOResult <> 0 Then
 Begin
  Rewrite(T);
  {$I+}
  If IOResult <> 0 Then
  Begin
   CloseGraph;
   Writeln(MsgInvalidFilename);
   Halt;
  End;
  Writeln(T, '1');
  Writeln(T, '0');
  Writeln(T, '0');
  Writeln(T, '0');
  Writeln(T, '0');
  Writeln(T, '0');
  Writeln(T, '0');
  Writeln(T, '0');
  Close(T);
  Reset(T);
 End;
 Readln(T, PocetUseciek);
 For Q := 1 To PocetUseciek Do
 For W := 1 To 2 Do
 Begin
  Readln(T, E);
  Data[Q][W].X := E;
  Readln(T, E);
  Data[Q][W].Y := E;
  Readln(T, E);
  Data[Q][W].Z := E;
 End;
 Readln(T, PocetBodov);
 For Q := 1 To PocetBodov Do
 Begin
  Readln(T, Data1[Q].Usecka);
  Readln(T, Data1[Q].Bod);
 End;
 Close(T);
 SetRGBPalette(1, 24, 24, 24);
 SetRGBPalette(2, 32, 32, 32);
 SetRGBPalette(3, 40, 40, 40);
 SetRGBPalette(4, 48, 48, 48);
 SetRGBPalette(5, 63, 63, 63);
 SetMode(Perspective);
 Bod := 1;
 Usecka := 1;
 Zoom := 1;
 DrawToBufferOn(PBuffer);
 Repeat
  Draw;
  DrawBuffer;
  Clear(PBuffer);
  If KeyPressed Then Ch := ReadKey Else Ch := #1;
  Case Ch Of
   #19:                  {SAVE}
   Begin
    DrawToBufferOff;
    SetColor(SaveColor);
    OutTextXY(XX - 20, 10, MsgSaving);
    Save;
    Delay(150);
    DrawToBufferOn(PBuffer);
   End;
   #12:                  {LOAD}
    Begin
    DrawToBufferOff;
    SetColor(LoadColor);
    OutTextXY(XX - 20, 10, MsgLoading);
    Load;
    Delay(150);
    DrawToBufferOn(PBuffer);
   End;
   'P','p': SetMode(Perspective);
   'F','f': SetMode(Front);
   'T','t': SetMode(Top);
   'R','r': SetMode(Right);
   #32:
    If (Mode = Perspective) Or (Mode = SmoothPerspective) Then SetMode(EditablePerspective)
    Else If (Mode = EditablePerspective) Then SetMode(Perspective);
   #9:
    If (Mode = Perspective) Or (Mode = EditablePerspective) Then SetMode(SmoothPerspective)
    Else If (Mode = SmoothPerspective) Then SetMode(Perspective);
   '/': Zoom := 1;
   'A','a': PanX := PanX + PanXX;
   'D','d': PanX := PanX - PanXX;
   'W','w': PanY := PanY + PanYY;
   'S','s': PanY := PanY - PanYY;
   'C','c': Begin PanX := 0; PanY := 0; End;

  End;

  {tu}
  If Mode = SmoothPerspective Then
  Begin
   If Ch = '+' Then If Usecka < PocetUseciek Then Inc(Usecka) Else Usecka := 1;
   If Ch = '-' Then If Usecka > 1 Then Dec(Usecka) Else Usecka := PocetUseciek;
   If (Ch = '*') And (Usecka > 0) Then If Bod = 1 Then Bod := 2 Else Bod := 1;
   If Ch = #13 Then
   Begin
    If PocetBodov Mod 3 = 0 Then
    Begin
     Inc(PocetBodov);
     Data1[PocetBodov].Usecka := Usecka;
     Data1[PocetBodov].Bod := Bod;
    End Else
    If PocetBodov Mod 3 = 1 Then
    Begin
     If Not ((Data1[PocetBodov].Usecka = Usecka) And (Data1[PocetBodov].Bod = Bod)) Then
     Begin
      Inc(PocetBodov);
      Data1[PocetBodov].Usecka := Usecka;
      Data1[PocetBodov].Bod := Bod;
     End Else Dec(PocetBodov);
    End Else
    If PocetBodov Mod 3 = 2 Then
    Begin
     If Not ((Data1[PocetBodov].Usecka = Usecka) And (Data1[PocetBodov].Bod = Bod))
      And Not ((Data1[PocetBodov - 1].Usecka = Usecka) And (Data1[PocetBodov - 1].Bod = Bod)) Then
     Begin
      Inc(PocetBodov);
      Data1[PocetBodov].Usecka := Usecka;
      Data1[PocetBodov].Bod := Bod;
     End Else
     If (Data1[PocetBodov].Usecka = Usecka) And (Data1[PocetBodov].Bod = Bod) Then
     Dec(PocetBodov) Else
     Begin
      Data1[PocetBodov - 1].Usecka := Data1[PocetBodov].Usecka;
      Data1[PocetBodov - 1].Bod := Data1[PocetBodov].Bod;
      Dec(PocetBodov);
     End;
    End;
   End;
  End;
  If (Mode <> Perspective) And (Mode <> SmoothPerspective) Then
  Begin
   If Ch = '+' Then If Usecka < PocetUseciek Then Inc(Usecka) Else Usecka := 1;
   If Ch = '-' Then If Usecka > 1 Then Dec(Usecka) Else Usecka := PocetUseciek;
   If (Ch = '*') And (Usecka > 0) Then If Bod = 1 Then Bod := 2 Else Bod := 1;
   If (Ch = 'E') Or (Ch = 'e') Then Input(Data[Usecka][Bod].X, Data[Usecka][Bod].Y, Data[Usecka][Bod].Z);
   If (Ch = 'Q') Or (Ch = 'q') Then
   Begin
    irelX := 0;
    irelY := 0;
    irelZ := 0;
    Input(irelX, irelY, irelZ);
    Data[Usecka][Bod].X := Data[Usecka][Bod].X + irelX;
    Data[Usecka][Bod].Y := Data[Usecka][Bod].Y + irelY;
    Data[Usecka][Bod].Z := Data[Usecka][Bod].Z + irelZ;
   End;
   If Ch = #0 Then
   Begin
    Ch := ReadKey;
    If Ch = #82 Then Put;
    If Ch = #59 Then Help;
    Case Ch Of
     #73: Zoom := Zoom + Zooming;
     #81: If (Zoom > 0) Then Zoom := Zoom - Zooming;
    End;
    Case Mode Of
     Front:
     Begin
      If (Ch = #77) Then Data[Usecka][Bod].X := Data[Usecka][Bod].X + 1;
      If (Ch = #75) Then Data[Usecka][Bod].X := Data[Usecka][Bod].X - 1;
      If (Ch = #72) Then Data[Usecka][Bod].Y := Data[Usecka][Bod].Y + 1;
      If (Ch = #80) Then Data[Usecka][Bod].Y := Data[Usecka][Bod].Y - 1;
      If (Ch = #83) Then Drop;
     End;
     Top:
     Begin
      If (Ch = #77) Then Data[Usecka][Bod].X := Data[Usecka][Bod].X + 1;
      If (Ch = #75) Then Data[Usecka][Bod].X := Data[Usecka][Bod].X - 1;
      If (Ch = #72) Then Data[Usecka][Bod].Z := Data[Usecka][Bod].Z + 1;
      If (Ch = #80) Then Data[Usecka][Bod].Z := Data[Usecka][Bod].Z - 1;
      If (Ch = #83) Then Drop;
     End;
     Right:
     Begin
      If (Ch = #77) Then Data[Usecka][Bod].Z := Data[Usecka][Bod].Z + 1;
      If (Ch = #75) Then Data[Usecka][Bod].Z := Data[Usecka][Bod].Z - 1;
      If (Ch = #72) Then Data[Usecka][Bod].Y := Data[Usecka][Bod].Y + 1;
      If (Ch = #80) Then Data[Usecka][Bod].Y := Data[Usecka][Bod].Y - 1;
      If (Ch = #83) Then Drop;
     End;
     EditablePerspective:
     Begin
      If (Ch = #77) Then Data[Usecka][Bod].X := Data[Usecka][Bod].X + 1;
      If (Ch = #75) Then Data[Usecka][Bod].X := Data[Usecka][Bod].X - 1;
      If (Ch = #72) Then Data[Usecka][Bod].Y := Data[Usecka][Bod].Y + 1;
      If (Ch = #80) Then Data[Usecka][Bod].Y := Data[Usecka][Bod].Y - 1;
      If (Ch = #71) Then Data[Usecka][Bod].Z := Data[Usecka][Bod].Z + 1;
      If (Ch = #79) Then Data[Usecka][Bod].Z := Data[Usecka][Bod].Z - 1;
      If (Ch = #83) Then Drop;
     End;
    End;
   End;
  End;
  If Ch = #0 Then
  Begin
   Ch := ReadKey;
   If Ch = #59 Then Help;
   Case Ch Of
    #73: Zoom := Zoom + Zooming;
    #81: If (Zoom > 0) Then Zoom := Zoom - Zooming;
   End;
   If (Mode = Perspective) Or (Mode = SmoothPerspective) Then
   Begin
    Case Ch Of
     #77: rY := R;
     #75: rY := - R;
     #72: rX := R;
     #80: rX := - R;
     #79: rZ := R;
     #71: rZ := - R;
    End;
   End;
  End
  Else
  Begin
   rY := 0;
   rX := 0;
   rZ := 0;
   if Tick>100 then Tick:=0 else inc(Tick);
  End;
  While KeyPressed Do ReadKey;
 Until (Ch = #27);
 DrawToBufferOff;
 CloseGraph;
End.