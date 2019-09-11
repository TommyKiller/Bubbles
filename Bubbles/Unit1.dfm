object Form1: TForm1
  Left = 244
  Top = 331
  Width = 916
  Height = 639
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 908
    Height = 612
    Align = alClient
    OnMouseDown = Image1MouseDown
  end
  object Score: TLabel
    Left = 824
    Top = 0
    Width = 6
    Height = 13
    Caption = '0'
  end
  object HP: TLabel
    Left = 0
    Top = 0
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 136
    Top = 8
  end
end
