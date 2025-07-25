object TProductEditForm: TTProductEditForm
  Left = 0
  Top = 0
  Caption = 'Edit Product'
  ClientHeight = 250
  ClientWidth = 400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poOwnerFormCenter
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 31
    Height = 13
    Caption = 'Name:'
  end
  object Label2: TLabel
    Left = 8
    Top = 43
    Width = 57
    Height = 13
    Caption = 'Description:'
  end
  object Label3: TLabel
    Left = 8
    Top = 70
    Width = 27
    Height = 13
    Caption = 'Price:'
  end
  object Label4: TLabel
    Left = 8
    Top = 97
    Width = 30
    Height = 13
    Caption = 'Stock:'
  end
  object EditName: TEdit
    Left = 80
    Top = 13
    Width = 300
    Height = 21
    TabOrder = 0
  end
  object EditDescription: TEdit
    Left = 80
    Top = 40
    Width = 300
    Height = 21
    TabOrder = 1
  end
  object EditPrice: TEdit
    Left = 80
    Top = 67
    Width = 100
    Height = 21
    TabOrder = 2
    Text = '0.00'
  end
  object EditStock: TEdit
    Left = 80
    Top = 94
    Width = 100
    Height = 21
    TabOrder = 3
    Text = '0'
  end
  object BtnSave: TButton
    Left = 80
    Top = 130
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 4
    OnClick = BtnSaveClick
  end
  object BtnCancel: TButton
    Left = 161
    Top = 130
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 5
    OnClick = BtnCancelClick
  end
end
