Unit Common3D;

Interface

Function PolS(X, Y : Real) : Real;
Function PolD(X, Y : Real) : Real;
Function RecX(S, D : Real) : Real;
Function RecY(S, D : Real) : Real;
Function GetNormalX(Ax, Ay, Az, Bx, By, Bz, Cx, Cy, Cz : Real) : Real;
Function GetNormalY(Ax, Ay, Az, Bx, By, Bz, Cx, Cy, Cz : Real) : Real;
Function GetNormalZ(Ax, Ay, Az, Bx, By, Bz, Cx, Cy, Cz : Real) : Real;
Function Left(Ax, Ay, Bx, By, Cx, Cy : Real) : Boolean;
Function Included(Ax, Ay, Bx, By, Cx, Cy, Dx, Dy : Real) : Boolean;
Function IsTop(Ax, Ay, Az, Bx, By, Bz, Cx, Cy, Cz, Dx, Dy, Dz : Real) : Boolean;

Implementation

Var _Sin, _Cos, _ArcTan : Array[0..200] Of Real;

Function fArcTan(R : Real) : Real;
Begin
{ while R > 1 do R := R - 2;
 while R < -1 do R := R + 2;}
 fArcTan := ArcTan(R); {_ArcTan[Round((R + 1) / 2 * 3639)];}
End;

Function fSin(R : Real) : Real;
Begin
 while R >= 2 * Pi do R := R - 2 * Pi;
 fSin := Sin(R);{_Sin[Round(R * 3639 / 2 / Pi)];}
End;

Function fCos(R : Real) : Real;
Begin
 while R >= 2 * Pi do R := R - 2 * Pi;
 fCos := Cos(R);{_Cos[Round(R * 3639 / 2 / Pi)];}
End;

Function PolS(X, Y : Real) : Real;
Begin
 If (X > 0) And (Y > 0) Then
 PolS := fArcTan(Y / X);
 If (X < 0) And (Y > 0) Then
 PolS := Pi/2 - fArcTan(X / Y);
 If (X < 0) And (Y < 0) Then
 PolS := Pi + fArcTan(Y / X);
 If (X > 0) And (Y < 0) Then
 PolS := Pi+Pi/2 - fArcTan(X / Y);
 If X = 0 Then
 Begin
  If Y > 0 Then PolS := Pi/2;
  If Y < 0 Then PolS := Pi+Pi/2;
  If Y = 0 Then PolS := 0;
 End;
 If Y = 0 Then
 Begin
  If X >= 0 Then PolS := 0;
  If X < 0 Then PolS := Pi;
 End;
End;

Function PolD(X, Y : Real) : Real;
Begin
 PolD := Sqrt(Sqr(X) + Sqr(Y));
End;

Function RecX(S, D : Real) : Real;
Begin
 RecX := D * fCos(S);
End;

Function RecY(S, D : Real) : Real;
Begin
 RecY := D * fSin(S);
End;

Function GetNormalX(Ax, Ay, Az, Bx, By, Bz, Cx, Cy, Cz : Real) : Real;
Begin
 GetNormalX := (By - Ay) * (Cz - Az) - (Cy - Ay) * (Bz - Az);
End;

Function GetNormalY(Ax, Ay, Az, Bx, By, Bz, Cx, Cy, Cz : Real) : Real;
Begin
 GetNormalY := (Bz - Az) * (Cx - Ax) - (Cz - Az) * (Bx - Ax);
End;

Function GetNormalZ(Ax, Ay, Az, Bx, By, Bz, Cx, Cy, Cz : Real) : Real;
Begin
 GetNormalZ := (Bx - Ax) * (Cy - Ay) - (Cx - Ax) * (By - Ay);
End;

Function Left(Ax, Ay, Bx, By, Cx, Cy : Real) : Boolean;
Begin
 Left := Cx * (Ay - By) + Cy * (Bx - Ax) - Ax * (Ay - By) - Ay * (Bx - Ax) > 0;
End;

Function Included(Ax, Ay, Bx, By, Cx, Cy, Dx, Dy : Real) : Boolean;
Begin
 If Left(Ax, Ay, Bx, By, Cx, Cy) Then
 Begin
  Included := Left(Ax, Ay, Bx, By, Dx, Dy) And Not Left(Ax, Ay, Cx, Cy, Dx, Dy) And Left(Bx, By, Cx, Cy, Dx, Dy);
 End
 Else
 Begin
  Included := Not Left(Ax, Ay, Bx, By, Dx, Dy) And Left(Ax, Ay, Cx, Cy, Dx, Dy) And Left(Cx, Cy, Bx, By, Dx, Dy);
 End;
End;

Function IsTop(Ax, Ay, Az, Bx, By, Bz, Cx, Cy, Cz, Dx, Dy, Dz : Real) : Boolean;
Begin
 IsTop := Dx * ((By - Ay) * (Cz - Az) - (Cy - Ay) * (Bz - Az)) + Dy * ((Bz - Az) * (Cx - Ax) - (Cz - Az) * (Bx - Ax)) + Dz
 * ((Bx - Ax) * (Cy - Ay) - (Cx - Ax) * (By - Ay)) - (Ax * ((By - Ay) * (Cz - Az) - (Cy - Ay) * (Bz - Az)) + Ay * ((Bz - Az)
 * (Cx - Ax) - (Cz - Az) * (Bx - Ax)) + Az * ((Bx - Ax) * (Cy - Ay) - (Cx - Ax) * (By - Ay))) > 0;
End;

Var Q : Word;

Begin
{ For Q := 0 To 3639 Do
 Begin
  _Sin[Q] := Sin(Q / 255 * 3639 * Pi);
  _Cos[Q] := Cos(Q / 255 * 3639 * Pi);
  _ArcTan[Q] := ArcTan(Q / 3639 * 2 - 1);
 End;}
End.