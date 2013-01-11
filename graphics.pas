Unit Graphics;
Interface
Uses Common3D;
Const
 SegA000 = $A000;
 ScreenX = 320;
 ScreenY = 200;
 GetMaxX = ScreenX - 1;
 GetMaxY = ScreenY - 1;
 ScreenSize = ScreenX * ScreenY;
 NumColors = 256;
 MaxColor = NumColors - 1;
 MinColorIntensity = 0;
 MaxColorIntensity = 63;
 FadeRate = 1;
 LastWrittenColor = 247;
Type
 PaletteType = Array[0..MaxColor] Of Record
  R, G, B : Byte;
 End;
Const
 Black        =  0;
 Blue         =  1;
 Green        =  2;
 Cyan         =  3;
 Red          =  4;
 Magenta      =  5;
 Brown        =  6;
 LightGray    =  7;
 DarkGray     =  8;
 LightBlue    =  9;
 LightGreen   = 10;
 LightCyan    = 11;
 LightRed     = 12;
 LightMagenta = 13;
 Yellow       = 14;
 White        = 15;

 DefaultColors : Array[0..MaxColor, 1..3] Of Byte = (
  (0, 0, 0),    (0, 0, 42),   (0, 42, 0),   (0, 42, 42),  (42, 0, 0),
  (42, 0, 42),  (42, 21, 0),  (42, 42, 42), (21, 21, 21), (21, 21, 63),
  (21, 63, 21), (21, 63, 63), (63, 21, 21), (63, 21, 63), (63, 63, 21),
  (63, 63, 63), (0, 0, 0),    (5, 5, 5),    (8, 8, 8),    (11, 11, 11),
  (14, 14, 14), (17, 17, 17), (20, 20, 20), (24, 24, 24), (28, 28, 28),
  (32, 32, 32), (36, 36, 36), (40, 40, 40), (45, 45, 45), (50, 50, 50),
  (56, 56, 56), (63, 63, 63), (0, 0, 63),   (16, 0, 63),  (31, 0, 63),
  (47, 0, 63),  (63, 0, 63),  (63, 0, 47),  (63, 0, 31),  (63, 0, 16),
  (63, 0, 0),   (63, 16, 0),  (63, 31, 0),  (63, 47, 0),  (63, 63, 0),
  (47, 63, 0),  (31, 63, 0),  (16, 63, 0),  (0, 63, 0),   (0, 63, 16),
  (0, 63, 31),  (0, 63, 47),  (0, 63, 63),  (0, 47, 63),  (0, 31, 63),
  (0, 16, 63),  (31, 31, 63), (39, 31, 63), (47, 31, 63), (55, 31, 63),
  (63, 31, 63), (63, 31, 55), (63, 31, 47), (63, 31, 39), (63, 31, 31),
  (63, 39, 31), (63, 47, 31), (63, 55, 31), (63, 63, 31), (55, 63, 31),
  (47, 63, 31), (39, 63, 31), (31, 63, 31), (31, 63, 39), (31, 63, 47),
  (31, 63, 55), (31, 63, 63), (31, 55, 63), (31, 47, 63), (31, 39, 63),
  (45, 45, 63), (49, 45, 63), (54, 45, 63), (58, 45, 63), (63, 45, 63),
  (63, 45, 58), (63, 45, 54), (63, 45, 49), (63, 45, 45), (63, 49, 45),
  (63, 54, 45), (63, 58, 45), (63, 63, 45), (58, 63, 45), (54, 63, 45),
  (49, 63, 45), (45, 63, 45), (45, 63, 49), (45, 63, 54), (45, 63, 58),
  (45, 63, 63), (45, 58, 63), (45, 54, 63), (45, 49, 63), (0, 0, 28),
  (7, 0, 28),   (14, 0, 28),  (21, 0, 28),  (28, 0, 28),  (28, 0, 21),
  (28, 0, 14),  (28, 0, 7),   (28, 0, 0),   (28, 7, 0),   (28, 14, 0),
  (28, 21, 0),  (28, 28, 0),  (21, 28, 0),  (14, 28, 0),  (7, 28, 0),
  (0, 28, 0),   (0, 28, 7),   (0, 28, 14),  (0, 28, 21),  (0, 28, 28),
  (0, 21, 28),  (0, 14, 28),  (0, 7, 28),   (14, 14, 28), (17, 14, 28),
  (21, 14, 28), (24, 14, 28), (28, 14, 28), (28, 14, 24), (28, 14, 21),
  (28, 14, 17), (28, 14, 14), (28, 17, 14), (28, 21, 14), (28, 24, 14),
  (28, 28, 14), (24, 28, 14), (21, 28, 14), (17, 28, 14), (14, 28, 14),
  (14, 28, 17), (14, 28, 21), (14, 28, 24), (14, 28, 28), (14, 24, 28),
  (14, 21, 28), (14, 17, 28), (20, 20, 28), (22, 20, 28), (24, 20, 28),
  (26, 20, 28), (28, 20, 28), (28, 20, 26), (28, 20, 24), (28, 20, 22),
  (28, 20, 20), (28, 22, 20), (28, 24, 20), (28, 26, 20), (28, 28, 20),
  (26, 28, 20), (24, 28, 20), (22, 28, 20), (20, 28, 20), (20, 28, 22),
  (20, 28, 24), (20, 28, 26), (20, 28, 28), (20, 26, 28), (20, 24, 28),
  (20, 22, 28), (0, 0, 16),   (4, 0, 16),   (8, 0, 16),   (12, 0, 16),
  (16, 0, 16),  (16, 0, 12),  (16, 0, 8),   (16, 0, 4),   (16, 0, 0),
  (16, 4, 0),   (16, 8, 0),   (16, 12, 0),  (16, 16, 0),  (12, 16, 0),
  (8, 16, 0),   (4, 16, 0),   (0, 16, 0),   (0, 16, 4),   (0, 16, 8),
  (0, 16, 12),  (0, 16, 16),  (0, 12, 16),  (0, 8, 16),   (0, 4, 16),
  (8, 8, 16),   (10, 8, 16),  (12, 8, 16),  (14, 8, 16),  (16, 8, 16),
  (16, 8, 14),  (16, 8, 12),  (16, 8, 10),  (16, 8, 8),   (16, 10, 8),
  (16, 12, 8),  (16, 14, 8),  (16, 16, 8),  (14, 16, 8),  (12, 16, 8),
  (10, 16, 8),  (8, 16, 8),   (8, 16, 10),  (8, 16, 12),  (8, 16, 14),
  (8, 16, 16),  (8, 14, 16),  (8, 12, 16),  (8, 10, 16),  (11, 11, 16),
  (12, 11, 16), (13, 11, 16), (15, 11, 16), (16, 11, 16), (16, 11, 15),
  (16, 11, 13), (16, 11, 12), (16, 11, 11), (16, 12, 11), (16, 13, 11),
  (16, 15, 11), (16, 16, 11), (15, 16, 11), (13, 16, 11), (12, 16, 11),
  (11, 16, 11), (11, 16, 12), (11, 16, 13), (11, 16, 15), (11, 16, 16),
  (11, 15, 16), (11, 13, 16), (11, 12, 16), (36, 36, 62), (26, 26, 62),
  (20, 20, 48), (14, 14, 34), (0, 0, 0),    (54, 54, 54), (50, 46, 46),
  (42, 36, 36));
 DefaultFonts : Array[0..94, 1..6, 1..5] Of Byte = (
  ((2, 2, 2, 0, 0), (2, 2, 2, 0, 0), (2, 2, 2, 0, 0), (2, 2, 2, 0, 0), (2, 2, 2, 0, 0), (2, 2, 2, 0, 0)),
  ((0, 1, 1, 0, 0), (1, 0, 0, 1, 0), (1, 0, 0, 1, 0), (1, 1, 1, 1, 0), (1, 0, 0, 1, 0), (0, 0, 0, 0, 0)),
  ((1, 1, 1, 0, 0), (1, 0, 0, 1, 0), (1, 1, 1, 0, 0), (1, 0, 0, 1, 0), (1, 1, 1, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 1, 1, 1, 0), (1, 0, 0, 0, 0), (1, 0, 0, 0, 0), (1, 0, 0, 0, 0), (0, 1, 1, 1, 0), (0, 0, 0, 0, 0)),
  ((1, 1, 1, 0, 0), (1, 0, 0, 1, 0), (1, 0, 0, 1, 0), (1, 0, 0, 1, 0), (1, 1, 1, 0, 0), (0, 0, 0, 0, 0)),
  ((1, 1, 1, 1, 0), (1, 0, 0, 0, 0), (1, 1, 1, 0, 0), (1, 0, 0, 0, 0), (1, 1, 1, 1, 0), (0, 0, 0, 0, 0)),
  ((1, 1, 1, 1, 0), (1, 0, 0, 0, 0), (1, 1, 1, 0, 0), (1, 0, 0, 0, 0), (1, 0, 0, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 1, 1, 1, 0), (1, 0, 0, 0, 0), (1, 0, 1, 1, 0), (1, 0, 0, 1, 0), (0, 1, 1, 1, 0), (0, 0, 0, 0, 0)),
  ((1, 0, 0, 1, 0), (1, 0, 0, 1, 0), (1, 1, 1, 1, 0), (1, 0, 0, 1, 0), (1, 0, 0, 1, 0), (0, 0, 0, 0, 0)),
  ((1, 1, 1, 0, 0), (0, 1, 0, 0, 0), (0, 1, 0, 0, 0), (0, 1, 0, 0, 0), (1, 1, 1, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 0, 0, 1, 0), (0, 0, 0, 1, 0), (0, 0, 0, 1, 0), (1, 0, 0, 1, 0), (0, 1, 1, 0, 0), (0, 0, 0, 0, 0)),
  ((1, 0, 0, 1, 0), (1, 0, 1, 0, 0), (1, 1, 0, 0, 0), (1, 0, 1, 0, 0), (1, 0, 0, 1, 0), (0, 0, 0, 0, 0)),
  ((1, 0, 0, 0, 0), (1, 0, 0, 0, 0), (1, 0, 0, 0, 0), (1, 0, 0, 0, 0), (1, 1, 1, 1, 0), (0, 0, 0, 0, 0)),
  ((1, 0, 0, 0, 1), (1, 1, 0, 1, 1), (1, 0, 1, 0, 1), (1, 0, 0, 0, 1), (1, 0, 0, 0, 1), (0, 0, 0, 0, 0)),
  ((1, 0, 0, 1, 0), (1, 1, 0, 1, 0), (1, 0, 1, 1, 0), (1, 0, 0, 1, 0), (1, 0, 0, 1, 0), (0, 0, 0, 0, 0)),
  ((0, 1, 1, 0, 0), (1, 0, 0, 1, 0), (1, 0, 0, 1, 0), (1, 0, 0, 1, 0), (0, 1, 1, 0, 0), (0, 0, 0, 0, 0)),
  ((1, 1, 1, 0, 0), (1, 0, 0, 1, 0), (1, 0, 0, 1, 0), (1, 1, 1, 0, 0), (1, 0, 0, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 1, 1, 0, 0), (1, 0, 0, 1, 0), (1, 0, 0, 1, 0), (1, 0, 1, 1, 0), (0, 1, 1, 1, 0), (0, 0, 0, 0, 0)),
  ((1, 1, 1, 0, 0), (1, 0, 0, 1, 0), (1, 0, 0, 1, 0), (1, 1, 1, 0, 0), (1, 0, 0, 1, 0), (0, 0, 0, 0, 0)),
  ((0, 1, 1, 1, 0), (1, 0, 0, 0, 0), (0, 1, 1, 0, 0), (0, 0, 0, 1, 0), (1, 1, 1, 0, 0), (0, 0, 0, 0, 0)),
  ((1, 1, 1, 1, 1), (0, 0, 1, 0, 0), (0, 0, 1, 0, 0), (0, 0, 1, 0, 0), (0, 0, 1, 0, 0), (0, 0, 0, 0, 0)),
  ((1, 0, 0, 1, 0), (1, 0, 0, 1, 0), (1, 0, 0, 1, 0), (1, 0, 0, 1, 0), (0, 1, 1, 0, 0), (0, 0, 0, 0, 0)),
  ((1, 0, 0, 0, 1), (1, 0, 0, 0, 1), (1, 0, 0, 0, 1), (0, 1, 0, 1, 0), (0, 0, 1, 0, 0), (0, 0, 0, 0, 0)),
  ((1, 0, 0, 0, 1), (1, 0, 0, 0, 1), (1, 0, 1, 0, 1), (1, 0, 1, 0, 1), (0, 1, 0, 1, 0), (0, 0, 0, 0, 0)),
  ((1, 0, 0, 0, 1), (0, 1, 0, 1, 0), (0, 0, 1, 0, 0), (0, 1, 0, 1, 0), (1, 0, 0, 0, 1), (0, 0, 0, 0, 0)),
  ((1, 0, 0, 0, 1), (0, 1, 0, 1, 0), (0, 0, 1, 0, 0), (0, 0, 1, 0, 0), (0, 0, 1, 0, 0), (0, 0, 0, 0, 0)),
  ((1, 1, 1, 1, 0), (0, 0, 1, 0, 0), (0, 1, 0, 0, 0), (1, 0, 0, 0, 0), (1, 1, 1, 1, 0), (0, 0, 0, 0, 0)),
  ((0, 0, 0, 0, 0), (0, 1, 1, 0, 0), (1, 0, 1, 0, 0), (1, 0, 1, 0, 0), (0, 1, 1, 0, 0), (0, 0, 0, 0, 0)),
  ((1, 0, 0, 0, 0), (1, 1, 0, 0, 0), (1, 0, 1, 0, 0), (1, 0, 1, 0, 0), (1, 1, 0, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 0, 0, 0, 0), (0, 1, 1, 0, 0), (1, 0, 0, 0, 0), (1, 0, 0, 0, 0), (0, 1, 1, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 0, 1, 0, 0), (0, 1, 1, 0, 0), (1, 0, 1, 0, 0), (1, 0, 1, 0, 0), (0, 1, 1, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 0, 0, 0, 0), (0, 1, 1, 0, 0), (1, 0, 1, 0, 0), (1, 1, 0, 0, 0), (0, 1, 1, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 0, 1, 0, 0), (0, 1, 0, 0, 0), (1, 1, 1, 0, 0), (0, 1, 0, 0, 0), (0, 1, 0, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 0, 0, 0, 0), (0, 1, 1, 0, 0), (1, 0, 1, 0, 0), (0, 1, 1, 0, 0), (0, 0, 1, 0, 0), (1, 1, 0, 0, 0)),
  ((1, 0, 0, 0, 0), (1, 0, 0, 0, 0), (1, 1, 0, 0, 0), (1, 0, 1, 0, 0), (1, 0, 1, 0, 0), (0, 0, 0, 0, 0)),
  ((1, 0, 0, 0, 0), (0, 0, 0, 0, 0), (1, 0, 0, 0, 0), (1, 0, 0, 0, 0), (1, 0, 0, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 0, 1, 0, 0), (0, 0, 0, 0, 0), (0, 0, 1, 0, 0), (0, 0, 1, 0, 0), (1, 0, 1, 0, 0), (0, 1, 0, 0, 0)),
  ((1, 0, 0, 0, 0), (1, 0, 1, 0, 0), (1, 1, 0, 0, 0), (1, 0, 1, 0, 0), (1, 0, 1, 0, 0), (0, 0, 0, 0, 0)),
  ((1, 0, 0, 0, 0), (1, 0, 0, 0, 0), (1, 0, 0, 0, 0), (1, 0, 0, 0, 0), (1, 0, 0, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 0, 0, 0, 0), (1, 1, 0, 1, 0), (1, 0, 1, 0, 1), (1, 0, 1, 0, 1), (1, 0, 1, 0, 1), (0, 0, 0, 0, 0)),
  ((0, 0, 0, 0, 0), (1, 1, 0, 0, 0), (1, 0, 1, 0, 0), (1, 0, 1, 0, 0), (1, 0, 1, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 0, 0, 0, 0), (0, 1, 0, 0, 0), (1, 0, 1, 0, 0), (1, 0, 1, 0, 0), (0, 1, 0, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 0, 0, 0, 0), (1, 1, 0, 0, 0), (1, 0, 1, 0, 0), (1, 0, 1, 0, 0), (1, 1, 0, 0, 0), (1, 0, 0, 0, 0)),
  ((0, 0, 0, 0, 0), (0, 1, 1, 0, 0), (1, 0, 1, 0, 0), (1, 0, 1, 0, 0), (0, 1, 1, 0, 0), (0, 0, 1, 0, 0)),
  ((0, 0, 0, 0, 0), (0, 1, 1, 0, 0), (1, 0, 0, 0, 0), (1, 0, 0, 0, 0), (1, 0, 0, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 0, 0, 0, 0), (0, 1, 1, 0, 0), (1, 1, 0, 0, 0), (0, 0, 1, 0, 0), (1, 1, 0, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 1, 0, 0, 0), (1, 1, 1, 0, 0), (0, 1, 0, 0, 0), (0, 1, 0, 0, 0), (0, 0, 1, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 0, 0, 0, 0), (1, 0, 1, 0, 0), (1, 0, 1, 0, 0), (1, 0, 1, 0, 0), (0, 1, 1, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 0, 0, 0, 0), (1, 0, 1, 0, 0), (1, 0, 1, 0, 0), (1, 0, 1, 0, 0), (0, 1, 0, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 0, 0, 0, 0), (1, 0, 1, 0, 1), (1, 0, 1, 0, 1), (1, 0, 1, 0, 1), (0, 1, 0, 1, 0), (0, 0, 0, 0, 0)),
  ((0, 0, 0, 0, 0), (1, 0, 1, 0, 0), (0, 1, 0, 0, 0), (0, 1, 0, 0, 0), (1, 0, 1, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 0, 0, 0, 0), (1, 0, 1, 0, 0), (1, 0, 1, 0, 0), (0, 1, 1, 0, 0), (0, 0, 1, 0, 0), (1, 1, 0, 0, 0)),
  ((0, 0, 0, 0, 0), (1, 1, 1, 0, 0), (0, 1, 0, 0, 0), (1, 0, 0, 0, 0), (1, 1, 1, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 1, 0, 0, 0), (1, 1, 0, 0, 0), (0, 1, 0, 0, 0), (0, 1, 0, 0, 0), (1, 1, 1, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 1, 1, 0, 0), (1, 0, 0, 1, 0), (0, 0, 1, 0, 0), (0, 1, 0, 0, 0), (1, 1, 1, 1, 0), (0, 0, 0, 0, 0)),
  ((1, 1, 1, 0, 0), (0, 0, 0, 1, 0), (0, 1, 1, 0, 0), (0, 0, 0, 1, 0), (1, 1, 1, 0, 0), (0, 0, 0, 0, 0)),
  ((1, 0, 0, 1, 0), (1, 0, 0, 1, 0), (1, 1, 1, 1, 0), (0, 0, 0, 1, 0), (0, 0, 0, 1, 0), (0, 0, 0, 0, 0)),
  ((1, 1, 1, 1, 0), (1, 0, 0, 0, 0), (1, 1, 1, 0, 0), (0, 0, 0, 1, 0), (1, 1, 1, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 1, 1, 1, 0), (1, 0, 0, 0, 0), (1, 1, 1, 0, 0), (1, 0, 0, 1, 0), (0, 1, 1, 0, 0), (0, 0, 0, 0, 0)),
  ((1, 1, 1, 1, 0), (0, 0, 0, 1, 0), (0, 0, 1, 0, 0), (0, 1, 0, 0, 0), (0, 1, 0, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 1, 1, 0, 0), (1, 0, 0, 1, 0), (0, 1, 1, 0, 0), (1, 0, 0, 1, 0), (0, 1, 1, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 1, 1, 0, 0), (1, 0, 0, 1, 0), (0, 1, 1, 1, 0), (0, 0, 0, 1, 0), (1, 1, 1, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 1, 1, 0, 0), (1, 0, 1, 1, 0), (1, 1, 0, 1, 0), (1, 0, 0, 1, 0), (0, 1, 1, 0, 0), (0, 0, 0, 0, 0)),
  ((1, 0, 0, 0, 0), (0, 1, 0, 0, 0), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 0, 0, 0, 0), (0, 1, 0, 1, 0), (1, 0, 1, 0, 0), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0)),
  ((1, 0, 0, 0, 0), (1, 0, 0, 0, 0), (1, 0, 0, 0, 0), (0, 0, 0, 0, 0), (1, 0, 0, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 1, 1, 1, 0), (1, 0, 0, 0, 1), (1, 0, 1, 1, 1), (1, 0, 1, 1, 1), (1, 0, 0, 0, 0), (0, 1, 1, 1, 0)),
  ((0, 1, 0, 1, 0), (1, 1, 1, 1, 1), (0, 1, 0, 1, 0), (1, 1, 1, 1, 1), (0, 1, 0, 1, 0), (0, 0, 0, 0, 0)),
  ((0, 1, 1, 1, 0), (1, 0, 1, 0, 0), (0, 1, 1, 1, 0), (0, 0, 1, 0, 1), (1, 1, 1, 1, 0), (0, 0, 0, 0, 0)),
  ((0, 0, 0, 0, 0), (1, 0, 0, 1, 0), (0, 0, 1, 0, 0), (0, 1, 0, 0, 0), (1, 0, 0, 1, 0), (0, 0, 0, 0, 0)),
  ((0, 1, 0, 0, 0), (1, 0, 1, 0, 0), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 1, 1, 0, 0), (1, 0, 0, 0, 0), (0, 1, 1, 0, 1), (1, 0, 0, 1, 0), (0, 1, 1, 0, 1), (0, 0, 0, 0, 0)),
  ((1, 0, 1, 0, 0), (0, 1, 0, 0, 0), (1, 0, 1, 0, 0), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 1, 0, 0, 0), (1, 0, 0, 0, 0), (1, 0, 0, 0, 0), (1, 0, 0, 0, 0), (1, 0, 0, 0, 0), (0, 1, 0, 0, 0)),
  ((1, 0, 0, 0, 0), (0, 1, 0, 0, 0), (0, 1, 0, 0, 0), (0, 1, 0, 0, 0), (0, 1, 0, 0, 0), (1, 0, 0, 0, 0)),
  ((0, 0, 0, 0, 0), (0, 0, 0, 0, 0), (1, 1, 1, 1, 0), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 0, 0, 0, 0), (1, 1, 1, 1, 0), (0, 0, 0, 0, 0), (1, 1, 1, 1, 0), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0)),
  ((1, 0, 0, 0, 0), (1, 0, 0, 0, 0), (0, 1, 0, 0, 0), (0, 1, 0, 0, 0), (0, 0, 1, 0, 0), (0, 0, 1, 0, 0)),
  ((0, 0, 0, 0, 0), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0), (1, 1, 1, 1, 1)),
  ((0, 0, 0, 0, 0), (0, 1, 0, 0, 0), (1, 1, 1, 0, 0), (0, 1, 0, 0, 0), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0)),
  ((1, 0, 0, 0, 0), (1, 0, 0, 0, 0), (1, 0, 0, 0, 0), (1, 0, 0, 0, 0), (1, 0, 0, 0, 0), (1, 0, 0, 0, 0)),
  ((1, 1, 0, 0, 0), (1, 0, 0, 0, 0), (1, 0, 0, 0, 0), (1, 0, 0, 0, 0), (1, 0, 0, 0, 0), (1, 1, 0, 0, 0)),
  ((1, 1, 0, 0, 0), (0, 1, 0, 0, 0), (0, 1, 0, 0, 0), (0, 1, 0, 0, 0), (0, 1, 0, 0, 0), (1, 1, 0, 0, 0)),
  ((0, 1, 1, 0, 0), (0, 1, 0, 0, 0), (1, 0, 0, 0, 0), (0, 1, 0, 0, 0), (0, 1, 1, 0, 0), (0, 0, 0, 0, 0)),
  ((1, 1, 0, 0, 0), (0, 1, 0, 0, 0), (0, 0, 1, 0, 0), (0, 1, 0, 0, 0), (1, 1, 0, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 0, 0, 0, 0), (0, 1, 0, 0, 0), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0), (0, 1, 0, 0, 0), (1, 0, 0, 0, 0)),
  ((0, 1, 0, 0, 0), (1, 0, 0, 0, 0), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 0, 0, 0, 0), (1, 0, 0, 0, 0), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0), (1, 0, 0, 0, 0), (0, 0, 0, 0, 0)),
  ((1, 0, 1, 0, 0), (1, 0, 1, 0, 0), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 0, 0, 0, 0), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0), (0, 1, 0, 0, 0), (1, 0, 0, 0, 0)),
  ((0, 0, 0, 0, 0), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0), (1, 0, 0, 0, 0), (0, 0, 0, 0, 0)),
  ((0, 0, 1, 0, 0), (0, 0, 1, 0, 0), (0, 1, 0, 0, 0), (0, 1, 0, 0, 0), (1, 0, 0, 0, 0), (1, 0, 0, 0, 0)),
  ((0, 0, 1, 0, 0), (0, 1, 0, 0, 0), (1, 0, 0, 0, 0), (0, 1, 0, 0, 0), (0, 0, 1, 0, 0), (0, 0, 0, 0, 0)),
  ((1, 0, 0, 0, 0), (0, 1, 0, 0, 0), (0, 0, 1, 0, 0), (0, 1, 0, 0, 0), (1, 0, 0, 0, 0), (0, 0, 0, 0, 0)),
  ((1, 1, 0, 0, 0), (0, 0, 1, 0, 0), (0, 1, 0, 0, 0), (0, 0, 0, 0, 0), (0, 1, 0, 0, 0), (0, 0, 0, 0, 0)));
 DefaultLiero : Array[1..21, 1..9, 1..10] Of Byte = (
  ((0, 0, 0, 0, 8, 0, 0, 0, 0, 0), (0, 0, 0, 0, 7, 0, 3, 2, 0, 0), (0, 0, 0, 3, 6, 0, 2, 1, 2, 0),
  (0, 0, 0, 2, 6, 2, 1, 1, 3, 0), (0, 0, 0, 1, 6, 1, 2, 3, 0, 0), (0, 0, 0, 2, 1, 2, 3, 0, 0, 0),
  (0, 0, 0, 2, 1, 3, 1, 3, 0, 0), (0, 0, 0, 2, 1, 1, 2, 1, 0, 0), (0, 0, 0, 0, 2, 2, 3, 2, 0, 0)),
  ((0, 0, 8, 0, 0, 0, 0, 0, 0, 0), (0, 0, 0, 7, 0, 3, 2, 0, 0, 0), (0, 0, 2, 6, 0, 2, 1, 2, 0, 0),
  (0, 0, 3, 2, 6, 1, 1, 3, 0, 0), (0, 0, 0, 1, 6, 1, 3, 0, 0, 0), (0, 0, 0, 2, 1, 2, 0, 0, 0, 0),
  (0, 0, 0, 2, 1, 3, 1, 3, 0, 0), (0, 0, 0, 2, 1, 1, 2, 1, 0, 0), (0, 0, 0, 0, 2, 2, 3, 2, 0, 0)),
  ((0, 0, 0, 0, 0, 0, 0, 0, 0, 0), (0, 8, 0, 0, 0, 3, 2, 0, 0, 0), (0, 0, 7, 0, 0, 2, 1, 2, 0, 0),
  (0, 0, 2, 6, 2, 1, 1, 3, 0, 0), (0, 0, 4, 1, 6, 1, 2, 0, 0, 0), (0, 0, 0, 2, 1, 2, 0, 0, 0, 0),
  (0, 0, 0, 2, 1, 3, 1, 3, 0, 0), (0, 0, 0, 2, 1, 1, 2, 1, 0, 0), (0, 0, 0, 0, 2, 2, 3, 2, 0, 0)),
  ((0, 0, 0, 0, 0, 0, 0, 0, 0, 0), (0, 0, 0, 0, 3, 2, 0, 0, 0, 0), (8, 0, 0, 3, 2, 1, 2, 0, 0, 0),
  (0, 7, 6, 0, 2, 1, 2, 0, 0, 0), (0, 3, 2, 6, 6, 1, 3, 0, 0, 0), (0, 0, 2, 1, 1, 2, 0, 0, 0, 0),
  (0, 0, 0, 2, 1, 3, 1, 3, 0, 0), (0, 0, 0, 2, 1, 1, 2, 1, 0, 0), (0, 0, 0, 0, 2, 2, 3, 2, 0, 0)),
  ((0, 0, 0, 0, 0, 0, 0, 0, 0, 0), (0, 0, 0, 0, 2, 2, 0, 0, 0, 0), (0, 0, 0, 2, 1, 1, 2, 0, 0, 0),
  (0, 0, 0, 3, 2, 1, 2, 0, 0, 0), (8, 7, 6, 6, 6, 1, 3, 0, 0, 0), (0, 3, 2, 1, 1, 2, 0, 0, 0, 0),
  (0, 0, 0, 2, 1, 3, 1, 3, 0, 0), (0, 0, 0, 2, 1, 1, 2, 1, 0, 0), (0, 0, 0, 0, 2, 2, 3, 2, 0, 0)),
  ((0, 0, 0, 0, 0, 0, 0, 0, 0, 0), (0, 0, 0, 0, 2, 2, 0, 0, 0, 0), (0, 0, 0, 2, 1, 1, 2, 0, 0, 0),
  (0, 0, 0, 3, 2, 1, 2, 0, 0, 0), (0, 0, 0, 6, 6, 1, 3, 0, 0, 0), (0, 7, 6, 1, 1, 2, 0, 0, 0, 0),
  (8, 3, 2, 2, 1, 3, 1, 3, 0, 0), (0, 0, 0, 2, 1, 1, 2, 1, 0, 0), (0, 0, 0, 0, 2, 2, 3, 2, 0, 0)),
  ((0, 0, 0, 0, 0, 0, 0, 0, 0, 0), (0, 0, 0, 0, 2, 2, 0, 0, 0, 0), (0, 0, 0, 2, 1, 1, 2, 0, 0, 0),
  (0, 0, 0, 3, 2, 1, 2, 0, 0, 0), (0, 0, 0, 0, 6, 1, 3, 0, 0, 0), (0, 0, 0, 6, 1, 2, 0, 0, 0, 0),
  (0, 0, 7, 2, 1, 3, 1, 3, 0, 0), (0, 8, 4, 2, 1, 1, 2, 1, 0, 0), (0, 0, 0, 0, 2, 2, 3, 2, 0, 0)),
  ((0, 0, 0, 0, 8, 0, 0, 0, 0, 0), (0, 0, 0, 0, 7, 2, 3, 0, 0, 0), (0, 0, 0, 3, 6, 1, 2, 0, 0, 0),
  (0, 0, 0, 2, 6, 1, 2, 0, 0, 0), (0, 0, 0, 1, 6, 2, 0, 0, 0, 0), (0, 0, 0, 2, 1, 2, 0, 0, 0, 0),
  (0, 0, 0, 2, 1, 2, 3, 0, 0, 0), (0, 0, 0, 0, 2, 1, 1, 2, 3, 0), (0, 0, 0, 0, 0, 3, 2, 2, 2, 3)),
  ((0, 0, 8, 0, 0, 0, 0, 0, 0, 0), (0, 0, 0, 7, 2, 0, 0, 0, 0, 0), (0, 0, 2, 6, 1, 2, 0, 0, 0, 0),
  (0, 0, 3, 1, 6, 1, 0, 0, 0, 0), (0, 0, 0, 1, 6, 1, 0, 0, 0, 0), (0, 0, 0, 2, 1, 2, 0, 0, 0, 0),
  (0, 0, 0, 2, 1, 2, 3, 0, 0, 0), (0, 0, 0, 0, 2, 1, 1, 2, 3, 0), (0, 0, 0, 0, 0, 3, 2, 2, 2, 3)),
  ((0, 0, 0, 0, 0, 0, 0, 0, 0, 0), (0, 8, 0, 3, 2, 0, 0, 0, 0, 0), (0, 0, 7, 2, 1, 2, 0, 0, 0, 0),
  (0, 0, 2, 6, 1, 2, 0, 0, 0, 0), (0, 0, 4, 1, 6, 2, 0, 0, 0, 0), (0, 0, 0, 2, 1, 2, 0, 0, 0, 0),
  (0, 0, 0, 2, 1, 2, 3, 0, 0, 0), (0, 0, 0, 0, 2, 1, 1, 2, 3, 0), (0, 0, 0, 0, 0, 3, 2, 2, 2, 3)),
  ((0, 0, 0, 0, 0, 0, 0, 0, 0, 0), (0, 0, 3, 2, 0, 0, 0, 0, 0, 0), (8, 3, 2, 1, 2, 0, 0, 0, 0, 0),
  (0, 7, 6, 1, 1, 0, 0, 0, 0, 0), (0, 3, 2, 6, 6, 2, 0, 0, 0, 0), (0, 0, 2, 1, 1, 2, 0, 0, 0, 0),
  (0, 0, 0, 2, 1, 2, 3, 0, 0, 0), (0, 0, 0, 0, 2, 1, 1, 2, 3, 0), (0, 0, 0, 0, 0, 3, 2, 2, 2, 3)),
  ((0, 0, 0, 0, 0, 0, 0, 0, 0, 0), (0, 0, 2, 2, 0, 0, 0, 0, 0, 0), (0, 2, 1, 1, 2, 0, 0, 0, 0, 0),
  (0, 3, 2, 2, 1, 0, 0, 0, 0, 0), (8, 7, 6, 6, 6, 2, 0, 0, 0, 0), (0, 3, 2, 1, 1, 2, 0, 0, 0, 0),
  (0, 0, 0, 2, 1, 2, 3, 0, 0, 0), (0, 0, 0, 0, 2, 1, 1, 2, 3, 0), (0, 0, 0, 0, 0, 3, 2, 2, 2, 3)),
  ((0, 0, 0, 0, 0, 0, 0, 0, 0, 0), (0, 0, 2, 2, 0, 0, 0, 0, 0, 0), (0, 2, 1, 1, 2, 0, 0, 0, 0, 0),
  (0, 3, 2, 2, 1, 0, 0, 0, 0, 0), (0, 0, 0, 6, 6, 2, 0, 0, 0, 0), (0, 7, 6, 1, 1, 2, 0, 0, 0, 0),
  (8, 3, 2, 2, 1, 2, 3, 0, 0, 0), (0, 0, 0, 0, 2, 1, 1, 2, 3, 0), (0, 0, 0, 0, 0, 3, 2, 2, 2, 3)),
  ((0, 0, 0, 0, 0, 0, 0, 0, 0, 0), (0, 0, 2, 2, 0, 0, 0, 0, 0, 0), (0, 2, 1, 1, 2, 0, 0, 0, 0, 0),
  (0, 3, 2, 2, 1, 0, 0, 0, 0, 0), (0, 0, 0, 2, 6, 2, 0, 0, 0, 0), (0, 0, 0, 6, 1, 2, 0, 0, 0, 0),
  (0, 0, 7, 2, 1, 2, 3, 0, 0, 0), (0, 8, 4, 0, 2, 1, 1, 2, 3, 0), (0, 0, 0, 0, 0, 3, 2, 2, 2, 3)),
  ((0, 0, 0, 0, 8, 0, 0, 0, 0, 0), (0, 0, 0, 0, 7, 3, 2, 0, 0, 0), (0, 0, 0, 3, 6, 2, 1, 2, 0, 0),
  (0, 0, 0, 2, 6, 1, 1, 2, 0, 0), (0, 0, 0, 1, 6, 1, 2, 0, 0, 0), (0, 0, 0, 2, 1, 2, 0, 0, 0, 0),
  (0, 0, 0, 2, 1, 3, 2, 3, 0, 0), (0, 0, 0, 3, 2, 1, 1, 2, 4, 0), (0, 0, 0, 0, 3, 2, 0, 2, 3, 0)),
  ((0, 0, 8, 0, 0, 0, 0, 0, 0, 0), (0, 0, 0, 7, 3, 2, 0, 0, 0, 0), (0, 0, 2, 6, 2, 1, 2, 0, 0, 0),
  (0, 0, 3, 1, 6, 1, 2, 0, 0, 0), (0, 0, 0, 1, 6, 1, 3, 0, 0, 0), (0, 0, 0, 2, 1, 2, 0, 0, 0, 0),
  (0, 0, 0, 2, 1, 3, 2, 3, 0, 0), (0, 0, 0, 3, 2, 1, 1, 2, 4, 0), (0, 0, 0, 0, 3, 2, 0, 2, 3, 0)),
  ((0, 0, 0, 0, 0, 0, 0, 0, 0, 0), (0, 8, 0, 0, 3, 2, 0, 0, 0, 0), (0, 0, 7, 3, 2, 1, 2, 0, 0, 0),
  (0, 0, 2, 6, 2, 1, 2, 0, 0, 0), (0, 0, 4, 1, 6, 1, 3, 0, 0, 0), (0, 0, 0, 2, 1, 2, 0, 0, 0, 0),
  (0, 0, 0, 2, 1, 3, 2, 3, 0, 0), (0, 0, 0, 3, 2, 1, 1, 2, 4, 0), (0, 0, 0, 0, 3, 2, 0, 2, 3, 0)),
  ((0, 0, 0, 0, 0, 0, 0, 0, 0, 0), (0, 0, 0, 3, 2, 0, 0, 0, 0, 0), (8, 0, 3, 2, 1, 2, 0, 0, 0, 0),
  (0, 7, 6, 2, 1, 1, 0, 0, 0, 0), (0, 3, 2, 6, 6, 1, 0, 0, 0, 0), (0, 0, 2, 1, 1, 2, 0, 0, 0, 0),
  (0, 0, 0, 2, 1, 3, 2, 3, 0, 0), (0, 0, 0, 3, 2, 1, 1, 2, 4, 0), (0, 0, 0, 0, 3, 2, 0, 2, 3, 0)),
  ((0, 0, 0, 0, 0, 0, 0, 0, 0, 0), (0, 0, 0, 2, 2, 0, 0, 0, 0, 0), (0, 0, 2, 1, 1, 2, 0, 0, 0, 0),
  (0, 0, 3, 2, 2, 1, 0, 0, 0, 0), (8, 7, 6, 6, 6, 1, 0, 0, 0, 0), (0, 3, 2, 1, 1, 2, 0, 0, 0, 0),
  (0, 0, 0, 2, 1, 3, 2, 3, 0, 0), (0, 0, 0, 3, 2, 1, 1, 2, 4, 0), (0, 0, 0, 0, 3, 2, 0, 2, 3, 0)),
  ((0, 0, 0, 0, 0, 0, 0, 0, 0, 0), (0, 0, 0, 2, 2, 0, 0, 0, 0, 0), (0, 0, 2, 1, 1, 2, 0, 0, 0, 0),
  (0, 0, 3, 2, 2, 1, 0, 0, 0, 0), (0, 0, 0, 6, 6, 1, 0, 0, 0, 0), (0, 7, 6, 1, 1, 2, 0, 0, 0, 0),
  (8, 3, 2, 2, 1, 3, 2, 3, 0, 0), (0, 0, 0, 3, 2, 1, 1, 2, 4, 0), (0, 0, 0, 0, 3, 2, 0, 2, 3, 0)),
  ((0, 0, 0, 0, 0, 0, 0, 0, 0, 0), (0, 0, 0, 2, 2, 0, 0, 0, 0, 0), (0, 0, 2, 1, 1, 2, 0, 0, 0, 0),
  (0, 0, 3, 2, 2, 1, 0, 0, 0, 0), (0, 0, 0, 0, 6, 1, 0, 0, 0, 0), (0, 0, 0, 6, 1, 2, 0, 0, 0, 0),
  (0, 0, 7, 2, 1, 3, 2, 3, 0, 0), (0, 8, 4, 3, 2, 1, 1, 2, 4, 0), (0, 0, 0, 0, 3, 2, 0, 2, 3, 0)));

 MaxAlloc = 65535;
 MapSizeX = ScreenX;
 MapSizeY = ScreenY;
 MapSize  = MapSizeX * MapSizeY;
 MapAlloc = MapSize;
 ImgSizeXY= 50;
 ImgSize  = ImgSizeXY * ImgSizeXY;
 ImgAlloc = ImgSize;
 TransparentColor = 255;
 Big = 4;

Var
 Color, PrevColor, FillColor, PrevFillColor : Byte;
 Fade, PaletteFade : Shortint;
 Palette, SavedPalette : PaletteType;
 DrawToBuffer, ReadFromMap, Border : Boolean;
 VGA : Pointer;
 PMap, PBuffer, Buffer : Pointer;
 MinX, MinY, MaxX, MaxY : Integer;

Procedure InitGraph;                                         {:-)}
Procedure DrawToBufferOn(P : Pointer);
Procedure DrawToBufferOff;
Procedure ReadFromMapOn;
Procedure ReadFromMapOff;
Procedure CloseGraph;                                        {:-)}
Procedure ClearDevice;                                       {:-)}
Procedure SetColor(C : Byte);                                {:-)}
Procedure SetPrevColor;                                      {:-)}
Procedure SetFillColor(C : Byte);                            {:-)}
Procedure SetPrevFillColor;                                  {:-)}
Procedure SetWindow(X1, Y1, X2, Y2 : Integer);
Procedure PutPixel(X, Y : Integer; C : Byte);                {:-)}
Function  GetPixel(X, Y : Integer) : Byte;                   {:-)}
Procedure Rectangle(X1, Y1, X2, Y2 : Integer);               {:-)}
Procedure Bar(X1, Y1, X2, Y2 : Integer);                     {:-)}
Procedure Line(X1, Y1, X2, Y2 : Integer);                    {:-)}
Procedure Circle(X, Y, R, Steps : Integer);
Procedure FillTriangle(X1, Y1, X2, Y2, X3, Y3 : Integer);
Procedure SetRGBPalette(C, R, G, B : Byte);                  {:-)}
Procedure GetRGBPalette(C : Byte; Var R, G, B : Byte);       {:-)}
Procedure GetSavedRGBPalette(C : Byte; Var R, G, B : Byte);  {:-|}
Procedure SavePalette;                                       {:-|}
Procedure ErasePalette;                                      {:-|}
Procedure RestorePalette;                                    {:-|}
Procedure ResetFade;                                         {:-|}
Procedure ResetPaletteFade;                                  {:-|}
Procedure FadeIn;                                            {:-|}
Procedure FadeOut;                                           {:-|}
Procedure PaletteFadeIn;                                     {:-|}
Procedure PaletteFadeOut;                                    {:-|}
Function  CharToNum(Ch : Char) : Byte;                       {:-)}
Procedure OutTextXY(X, Y : Integer; S : String);             {:-)}
Procedure BorderOn;                                          {:-)}
Procedure BorderOff;                                         {:-)}
Procedure DrawBuffer;
Procedure Clear(P : Pointer);
Procedure CopyToBuffer(P : Pointer);
Procedure LoadMap(Filename : String);
Procedure CloseMap;
Procedure SaveMap(Filename : String);
Procedure LoadImage(Var PImg : Pointer; Filename : String);
Procedure CloseImage(PImg : Pointer);
Procedure SaveImage(PImg : Pointer; Filename : String);
Procedure DrawImage(PImg : Pointer; X1, Y1 : Integer);
Procedure DrawBigImage(PImg : Pointer; X1, Y1 : Integer);
Procedure RotateImage(PImg : Pointer; X1, Y1, SizeX, SizeY : Integer; Scale, Ang : Real);
Procedure DrawLiero(X, Y, Item : Integer);

Implementation

Procedure InitGraph;
Var C : Byte;
Begin
 If MaxAvail < MapAlloc Then
 Begin
  Writeln('Low Memory. ', MapAlloc - MaxAvail, ' bytes needed.');
  Halt(1);
 End;
 Asm
  mov AX, 13H
  int 10H
 End;
 GetMem(PBuffer, MapAlloc);
 Clear(PBuffer);
 Color := White;
 PrevColor := White;
 FillColor := Black;
 PrevFillColor := Black;
 Border := False;
 DrawToBuffer := False;
 MinX := 0;
 MinY := 0;
 MaxX := GetMaxX;
 MaxY := GetMaxY;
 For C := 0 To MaxColor Do
 Begin
  Palette[C].R := DefaultColors[C, 1];
  Palette[C].G := DefaultColors[C, 2];
  Palette[C].B := DefaultColors[C, 3];
  SetRGBPalette(C, DefaultColors[C, 1], DefaultColors[C, 2], DefaultColors[C, 3]);
 End;
 VGA := Ptr(SegA000, 0);
End;

Procedure DrawToBufferOn(P : Pointer);
Begin
 DrawToBuffer := True;
 Buffer := P;
End;

Procedure DrawToBufferOff;
Begin
 DrawToBuffer := False;
End;

Procedure ReadFromMapOn;
Begin
 ReadFromMap := True;
End;

Procedure ReadFromMapOff;
Begin
 ReadFromMap := False;
End;

Procedure CloseGraph;
Begin
 Asm
  mov AH, 00H
  mov AL, 03H
  int 10H
 End;
 FreeMem(PBuffer, MapAlloc);
End;

Procedure ClearDevice; Assembler;
Asm
  les DI, VGA
  mov CX, ScreenX * ScreenY / 2
  sub AX, AX
  cld
  rep stosw
End;

Procedure SetColor(C : Byte);
Begin
 PrevColor := Color;
 Color := C;
End;

Procedure SetPrevColor;
Begin
 Color := PrevColor;
End;

Procedure SetFillColor(C : Byte);
Begin
 PrevFillColor := FillColor;
 FillColor := C;
End;

Procedure SetPrevFillColor;
Begin
 FillColor := PrevFillColor;
End;

Procedure SetWindow(X1, Y1, X2, Y2 : Integer);
Begin
 MinX := X1;
 MinY := Y1;
 MaxX := X2;
 MaxY := Y2;
End;

Procedure PutPixel(X, Y : Integer; C : Byte);
Begin
 If (X >= MinX) And (Y >= MinY) And (X <= MaxX) And (Y <= MaxY) Then
 If C <> TransparentColor Then
 If Not DrawToBuffer Then Mem[SegA000 : Word(ScreenX * Y + X)] := C
 Else Mem[Seg(Buffer^) : Ofs(Buffer^) + Word(ScreenX * Y + X)] := C;
End;

Function GetPixel(X, Y : Integer) : Byte;
Begin
 If (X >= 0) And (Y >= 0) And (X <= GetMaxX) And (Y <= GetMaxY) Then
 If Not ReadFromMap Then GetPixel := Mem[SegA000 : Word(ScreenX * Y + X)]
 Else GetPixel := Mem[Seg(PMap^) : Ofs(PMap^) + Word(ScreenX * Y + X)];
End;

Procedure Rectangle(X1, Y1, X2, Y2 : Integer);
Var N, Temp : Integer;
Begin
 If (X1 > X2) Then
 Begin
  Temp := X1;
  X1 := X2;
  X2 := Temp;
 End;
 If (Y1 > Y2) Then
 Begin
  Temp := Y1;
  Y1 := Y2;
  Y2 := Temp;
 End;
 For N := 0 To X2 - X1 Do
 Begin
  PutPixel(X1 + N, Y1, Color);
  PutPixel(X2 - N, Y2, Color);
 End;
 For N := 0 To Y2 - Y1 Do
 Begin
  PutPixel(X2, Y1 + N, Color);
  PutPixel(X1, Y2 - N, Color);
 End;
End;

Procedure Bar(X1, Y1, X2, Y2 : Integer);
Var X, Y, Temp : Integer;
Begin
 If (X1 > X2) Then
 Begin
  Temp := X1;
  X1 := X2;
  X2 := Temp;
 End;
 If (Y1 > Y2) Then
 Begin
  Temp := Y1;
  Y1 := Y2;
  Y2 := Temp;
 End;
 For Y := 0 To Y2 - Y1 Do
 For X := 0 To X2 - X1 Do
 PutPixel(X1 + X, Y1 + Y, FillColor);
End;

Procedure Line(X1, Y1, X2, Y2 : Integer);
Var N, SX, SY : Integer;
Begin
 SX := Abs(X2 - X1);
 SY := Abs(Y2 - Y1);
 If X1 = X2 Then
 Begin
  If Y1 < Y2 Then For N := 0 To SY Do PutPixel(X2, Y1 + N, Color)
             Else For N := 0 To SY Do PutPixel(X2, Y1 - N, Color);
  Exit;
 End;
 If Y1 = Y2 Then
 Begin
  If X1 < X2 Then For N := 0 To SX Do PutPixel(X1 + N, Y1, Color)
             Else For N := 0 To SX Do PutPixel(X1 - N, Y1, Color);
  Exit;
 End;
 If SX > SY Then
 Begin
  If (X1 < X2) And (Y1 < Y2) Then
   For N := 0 To SX Do
   PutPixel(X1 + N, Y1 + Round(N * (SY / SX)), Color) Else
  If (X1 > X2) And (Y1 > Y2) Then
   For N := 0 To SX Do
   PutPixel(X1 - N, Y1 - Round(N * (SY / SX)), Color) Else
  If (X1 < X2) And (Y1 > Y2) Then
   For N := 0 To SX Do
   PutPixel(X1 + N, Y1 - Round(N * (SY / SX)), Color) Else
  If (X1 > X2) And (Y1 < Y2) Then
   For N := 0 To SX Do
   PutPixel(X1 - N, Y1 + Round(N * (SY / SX)), Color);
 End Else
 If SX <= SY Then
 Begin
  If (X1 < X2) And (Y1 < Y2) Then
   For N := 0 To SY Do
   PutPixel(X1 + Round(N * (SX / SY)), Y1 + N, Color) Else
  If (X1 > X2) And (Y1 > Y2) Then
   For N := 0 To SY Do
   PutPixel(X1 - Round(N * (SX / SY)), Y1 - N, Color) Else
  If (X1 < X2) And (Y1 > Y2) Then
   For N := 0 To SY Do
   PutPixel(X1 + Round(N * (SX / SY)), Y1 - N, Color) Else
  If (X1 > X2) And (Y1 < Y2) Then
   For N := 0 To SY Do
   PutPixel(X1 - Round(N * (SX / SY)), Y1 + N, Color) Else
 End;
End;

Procedure Circle(X, Y, R, Steps : Integer);
Var Q : Integer;
Begin
 For Q := 0 To Steps Do
 PutPixel(X + Round(R * Sin(Q / Steps * 2 * Pi)),
 Y + Round(R * Cos(Q / Steps * 2 * Pi)), Color);
End;

Procedure FillTriangle(X1, Y1, X2, Y2, X3, Y3 : Integer);
Var X, Y, minX, minY, maxX, maxY : Integer;
Begin
 SetColor(FillColor);
 Line(X1, Y1, X2, Y2);
 Line(X2, Y2, X3, Y3);
 Line(X1, Y1, X3, Y3);
 SetPrevColor;
 minX := X1;
 If X2 < minX Then minX := X2;
 If X3 < minX Then minX := X3;
 maxX := X1;
 If X2 > maxX Then maxX := X2;
 If X3 > maxX Then maxX := X3;
 minY := Y1;
 If Y2 < minY Then minY := Y2;
 If Y3 < minY Then minY := Y3;
 maxY := Y1;
 If Y2 > maxY Then maxY := Y2;
 If Y3 > maxY Then maxY := Y3;
 For Y := minY To maxY Do
 For X := minX To maxX Do
 If Included(X1, Y1, X2, Y2, X3, Y3, X, Y) Then PutPixel(X, Y, FillColor);
End;

Procedure SetRGBPalette(C, R, G, B : Byte);
Begin
 Palette[C].R := R;
 Palette[C].G := G;
 Palette[C].B := B;
 Port[$3C8] := C;
 Port[$3C9] := R;
 Port[$3C9] := G;
 Port[$3C9] := B;
End;

Procedure GetRGBPalette(C : Byte; Var R, G, B : Byte);
Begin
 R := Palette[C].R;
 G := Palette[C].G;
 B := Palette[C].B;
End;

Procedure GetSavedRGBPalette(C : Byte; Var R, G, B : Byte);
Begin
 R := SavedPalette[C].R;
 G := SavedPalette[C].G;
 B := SavedPalette[C].B;
End;

Procedure SavePalette;
Begin
 SavedPalette := Palette;
End;

Procedure RestorePalette;
Var C : Byte;
Begin
 Palette := SavedPalette;
 For C := 0 To NumColors - 1 Do
  With Palette[C] Do
   SetRGBPalette(C, R, G, B);
End;

Procedure ResetFade;
Begin
 Fade := 0;
End;

Procedure FadeIn;
Var C, R, G, B : Byte;
Begin
 If Fade < MaxColorIntensity Then
 Begin
  Inc(Fade);
  For C := 0 To NumColors - 1 Do
  Begin
   GetRGBPalette(C, R, G, B);
   If (R < MaxColorIntensity) Then Inc(R, FadeRate);
   If (G < MaxColorIntensity) Then Inc(G, FadeRate);
   If (B < MaxColorIntensity) Then Inc(B, FadeRate);
   SetRGBPalette(C, R, G, B);
  End;
 End;
End;

Procedure FadeOut;
Var C, R, G, B : Byte;
Begin
 If Fade > - MaxColorIntensity Then
 Begin
  Dec(Fade);
  For C := 0 To NumColors - 1 Do
  Begin
   GetRGBPalette(C, R, G, B);
   If (R > MinColorIntensity) Then Dec(R, FadeRate);
   If (G > MinColorIntensity) Then Dec(G, FadeRate);
   If (B > MinColorIntensity) Then Dec(B, FadeRate);
   SetRGBPalette(C, R, G, B);
  End;
 End;
End;

Procedure ResetPaletteFade;
Begin
 PaletteFade := 0;
End;

Procedure PaletteFadeIn;
Var C, R, G, B, sR, sG, sB : Byte;
Begin
 If PaletteFade < MaxColorIntensity Then
 Begin
  Inc(PaletteFade);
  For C := 0 To NumColors - 1 Do
  Begin
   GetRGBPalette(C, R, G, B);
   GetSavedRGBPalette(C, sR, sG, sB);
   If PaletteFade > (MaxColorIntensity - sR) Then Inc(R, FadeRate);
   If PaletteFade > (MaxColorIntensity - sG) Then Inc(G, FadeRate);
   If PaletteFade > (MaxColorIntensity - sB) Then Inc(B, FadeRate);
   SetRGBPalette(C, R, G, B);
  End;
 End;
End;

Procedure PaletteFadeOut;
Var C, R, G, B, sR, sG, sB : Byte;
Begin
 If PaletteFade > -MaxColorIntensity Then
 Begin
  Dec(PaletteFade);
  For C := 0 To NumColors - 1 Do
  Begin
   GetRGBPalette(C, R, G, B);
   GetSavedRGBPalette(C, sR, sG, sB);
   If - PaletteFade < (MaxColorIntensity - sR) Then Dec(R, FadeRate);
   If - PaletteFade < (MaxColorIntensity - sG) Then Dec(G, FadeRate);
   If - PaletteFade < (MaxColorIntensity - sB) Then Dec(B, FadeRate);
   SetRGBPalette(C, R, G, B);
  End;
 End;
End;

Procedure ErasePalette;
Var C : Byte;
Begin
 For C := 0 To NumColors - 1 Do
  SetRGBPalette(C, 0, 0, 0);
End;

Function CharToNum(Ch : Char) : Byte;
Begin
 CharToNum := 0;
 Case Ch Of
  'A': CharToNum := 1;
  'B': CharToNum := 2;
  'C': CharToNum := 3;
  'D': CharToNum := 4;
  'E': CharToNum := 5;
  'F': CharToNum := 6;
  'G': CharToNum := 7;
  'H': CharToNum := 8;
  'I': CharToNum := 9;
  'J': CharToNum := 10;
  'K': CharToNum := 11;
  'L': CharToNum := 12;
  'M': CharToNum := 13;
  'N': CharToNum := 14;
  'O': CharToNum := 15;
  'P': CharToNum := 16;
  'Q': CharToNum := 17;
  'R': CharToNum := 18;
  'S': CharToNum := 19;
  'T': CharToNum := 20;
  'U': CharToNum := 21;
  'V': CharToNum := 22;
  'W': CharToNum := 23;
  'X': CharToNum := 24;
  'Y': CharToNum := 25;
  'Z': CharToNum := 26;
  'a': CharToNum := 27;
  'b': CharToNum := 28;
  'c': CharToNum := 29;
  'd': CharToNum := 30;
  'e': CharToNum := 31;
  'f': CharToNum := 32;
  'g': CharToNum := 33;
  'h': CharToNum := 34;
  'i': CharToNum := 35;
  'j': CharToNum := 36;
  'k': CharToNum := 37;
  'l': CharToNum := 38;
  'm': CharToNum := 39;
  'n': CharToNum := 40;
  'o': CharToNum := 41;
  'p': CharToNum := 42;
  'q': CharToNum := 43;
  'r': CharToNum := 44;
  's': CharToNum := 45;
  't': CharToNum := 46;
  'u': CharToNum := 47;
  'v': CharToNum := 48;
  'w': CharToNum := 49;
  'x': CharToNum := 50;
  'y': CharToNum := 51;
  'z': CharToNum := 52;
  '1': CharToNum := 53;
  '2': CharToNum := 54;
  '3': CharToNum := 55;
  '4': CharToNum := 56;
  '5': CharToNum := 57;
  '6': CharToNum := 58;
  '7': CharToNum := 59;
  '8': CharToNum := 60;
  '9': CharToNum := 61;
  '0': CharToNum := 62;
  '`': CharToNum := 63;
  '~': CharToNum := 64;
  '!': CharToNum := 65;
  '@': CharToNum := 66;
  '#': CharToNum := 67;
  '$': CharToNum := 68;
  '%': CharToNum := 69;
  '^': CharToNum := 70;
  '&': CharToNum := 71;
  '*': CharToNum := 72;
  '(': CharToNum := 73;
  ')': CharToNum := 74;
  '-': CharToNum := 75;
  '=': CharToNum := 76;
  '\': CharToNum := 77;
  '_': CharToNum := 78;
  '+': CharToNum := 79;
  '|': CharToNum := 80;
  '[': CharToNum := 81;
  ']': CharToNum := 82;
  '{': CharToNum := 83;
  '}': CharToNum := 84;
  ';': CharToNum := 85;
  '''':CharToNum := 86;
  ':': CharToNum := 87;
  '"': CharToNum := 88;
  ',': CharToNum := 89;
  '.': CharToNum := 90;
  '/': CharToNum := 91;
  '<': CharToNum := 92;
  '>': CharToNum := 93;
  '?': CharToNum := 94;
 End;
End;

Procedure OutTextXY(X, Y : Integer; S : String);
 Procedure OutCharXY(X, Y : Integer; Ch : Char);
 Var Q, W : Integer;
 Begin
  For W := 0 To 6 Do
  For Q := 1 To 6 Do
  Begin
   If Not (Q = 6) And Not (W = 0) Then
   Begin
    If DefaultFonts[CharToNum(Ch), W, Q] = 1 Then
    Begin
     PutPixel(X + Q - 1, Y + W - 1, Color)
    End
    Else
    Begin
     If Border Then
     Begin
      PutPixel(X + Q - 1, Y + W - 1, FillColor);
     End;
    End;
   End;
   If (Q = 6) Or (W = 0) Then
   Begin
    If Border Then
    Begin
     PutPixel(X + Q - 1, Y + W - 1, FillColor);
    End;
   End;
  End;
 End;
 Function GetCharSize(Ch : Char) : Byte;
 Var
  R, CharSize : Byte;
  Stop : Boolean;
 Begin
  Stop := False;
  CharSize := 5;
  For R := 5 Downto 1 Do
  Begin
  If (DefaultFonts[CharToNum(Ch), 1, R] <> 0) Or
     (DefaultFonts[CharToNum(Ch), 2, R] <> 0) Or
     (DefaultFonts[CharToNum(Ch), 3, R] <> 0) Or
     (DefaultFonts[CharToNum(Ch), 4, R] <> 0) Or
     (DefaultFonts[CharToNum(Ch), 5, R] <> 0) Or
     (DefaultFonts[CharToNum(Ch), 6, R] <> 0) Then
   Stop := True;
   If Not Stop Then Dec(CharSize);
  End;
  GetCharSize := CharSize;
 End;
Var
 L, Q, Balance : Integer;
Begin
 If Border Then
 Begin
  For Q := 0 To 6 Do PutPixel(X - 1, Y - 1 + Q, FillColor);
  For Q := 1 To 5 Do PutPixel(X - 2, Y - 1 + Q, FillColor);
 End;
 Balance := 0;
 For L := 1 To Length(S) Do
 Begin
  OutCharXY(X - Balance + (L - 1) * 6, Y, S[L]);
  Inc(Balance, 5 - GetCharSize(S[L]));
 End;
 If Border Then For Q := 1 To 5 Do PutPixel(X - Balance + L * 6, Y - 1 + Q, FillColor);
End;

Procedure BorderOn;
Begin
 Border := True;
End;

Procedure BorderOff;
Begin
 Border := False;
End;

Procedure DrawBuffer; Assembler;
Asm
 push ds
 mov di, SegA000
 mov es, di
 sub di, di
 lds si, PBuffer
 mov cx, ScreenSize / 2
 cld
 rep movsw
 pop ds
End;

Procedure Clear(P : Pointer); Assembler;
Asm
 les di, P
 mov cx, ScreenSize / 2
 sub ax, ax
 cld
 rep stosw
End;

Procedure CopyToBuffer(P : Pointer); Assembler;
Asm
 les di, PBuffer
 push ds
 lds si, P
 mov cx, MapAlloc
 cld
 rep movsb
 pop ds
End;

Procedure LoadMap(Filename : String);
Var
 T : Text;
 Ch : Char;
 Q : Longint;
Begin
 If MaxAvail < MapAlloc Then
 Begin
  CloseGraph;
  Writeln('Low Memory. ', MapAlloc - MaxAvail, ' bytes needed.');
  Halt(1);
 End;
 Assign(T, Filename);
 Reset(T);
 GetMem(PMap, MapAlloc);
 Clear(PMap);
 For Q := 0 To MapSize - 1 Do
 Begin
  Read(T, Ch);
  Mem[Seg(PMap^) : Ofs(PMap^) + Word(Q)] := Ord(Ch);
 End;
 Close(T);
End;

Procedure CloseMap;
Begin
 FreeMem(PMap, MapAlloc);
End;

Procedure SaveMap(Filename : String);
Var
 T : Text;
 Q : Longint;
Begin
 Assign(T, Filename);
 Rewrite(T);
 For Q := 0 To MapSize - 1 Do
 Begin
  Write(T, Chr(Mem[Seg(PMap^) : Ofs(PMap^) + Word(Q)]));
 End;
 Close(T);
End;

Procedure LoadImage(Var PImg : Pointer; Filename : String);
Var
 T : Text;
 Ch : Char;
 Q : Longint;
Begin
 If MaxAvail < ImgAlloc Then
 Begin
  CloseGraph;
  Writeln('Low Memory. ', ImgAlloc - MaxAvail, ' bytes needed.');
  Halt(1);
 End;
 Assign(T, Filename);
 Reset(T);
 GetMem(PImg, ImgAlloc);
 Clear(PImg);
 For Q := 0 To ImgSize - 1 Do
 Begin
  Read(T, Ch);
  Mem[Seg(PImg^) : Ofs(PImg^) + Word(Q)] := Ord(Ch);
 End;
 Close(T);
End;

Procedure CloseImage;
Begin
 FreeMem(PImg, ImgAlloc);
End;

Procedure SaveImage(PImg : Pointer; Filename : String);
Var
 T : Text;
 Q : Longint;
Begin
 Assign(T, Filename);
 Rewrite(T);
 For Q := 0 To ImgSize - 1 Do
 Begin
  Write(T, Chr(Mem[Seg(PImg^) : Ofs(PImg^) + Word(Q)]));
 End;
 Close(T);
End;

Procedure DrawImage(PImg : Pointer; X1, Y1 : Integer);
Var X, Y : Integer;
Begin
 For Y := 0 To ImgSizeXY - 1 Do
 For X := 0 To ImgSizeXY - 1 Do
 PutPixel(X + X1, Y + Y1, Mem[Seg(PImg^) : Ofs(PImg^) + Word(X + Y * ImgSizeXY)]);
End;

Procedure DrawBigImage(PImg : Pointer; X1, Y1 : Integer);
Var X, Y : Integer;
Begin
 For Y := 0 To Big * ImgSizeXY - 1 Do
 For X := 0 To Big * ImgSizeXY - 1 Do
 PutPixel(X + X1, Y + Y1, Mem[Seg(PImg^) : Ofs(PImg^) + Word(X Div Big + Y Div Big * ImgSizeXY)]);
End;


Procedure RotateImage(PImg : Pointer; X1, Y1, SizeX, SizeY : Integer; Scale, Ang : Real);
Var
 Xscale, Yscale, XC, YC : Longint;
 YY : Word;
 X, Y : Integer;
 TempX, TempY : Word;
 Xlong, Ylong : Longint;
Begin
 Xscale := Round((Sin(Ang) * 65536.0) * Scale);
 Yscale := Round((Cos(Ang) * 65536.0) * Scale);
 XC := SizeX Div 2 * 65536 - (SizeX Div 2 * (Yscale + Xscale));
 YC := SizeY Div 2 * 65536 - (SizeY Div 2 * (Yscale - Xscale));
 YY := Y1;
 For Y := Y1 To Y1 + SizeY Do
 Begin
  Xlong := XC;
  Ylong := YC;
  For X := X1 To X1 + SizeX Do
  Begin
   TempX := Xlong Shr 16;
   TempY := Ylong Shr 16;
   If (TempX < 0) Or (TempX >= SizeX) Or (TempY < 0) Or
    (TempY >= SizeY) Then
    {PutPixel(X, YY, 1)}
   Else
    PutPixel(X, YY, Mem[Seg(PImg^) : Ofs(PImg^) + SizeX * TempY + TempX]);
   Inc(Xlong, Yscale);
   Dec(Ylong, Xscale);
  End;
  Inc(YY);
  Inc(XC, Xscale);
  Inc(YC, Yscale);
 End;
End;

Procedure DrawLiero(X, Y, Item : Integer);
Var Q, W : Integer;
Begin
 For W := 1 To 9 Do
 For Q := 1 To 10 Do
 If DefaultLiero[Item, W, Q] <> 0 Then
 PutPixel(X + Q - 5, Y + W - 5, LastWrittenColor + DefaultLiero[Item, W, Q]);
End;

End.