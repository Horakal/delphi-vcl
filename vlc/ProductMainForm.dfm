object TProductMainForm: TTProductMainForm
  Left = 0
  Top = 0
  Caption = 'Product Manager'
  ClientHeight = 451
  ClientWidth = 630
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 13
  object ListView1: TListView
    Left = 8
    Top = 96
    Width = 601
    Height = 305
    Columns = <
      item
        Caption = 'ID'
      end
      item
        Caption = 'Name'
        Width = 150
      end
      item
        Caption = 'Description'
        Width = 200
      end
      item
        Caption = 'Price'
        Width = 80
      end
      item
        Caption = 'Stock'
        Width = 80
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = ListView1DblClick
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 432
    Width = 630
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object EditSearch: TEdit
    Left = 300
    Top = 69
    Width = 309
    Height = 21
    TabOrder = 2
    TextHint = 'Pesquise por nome'
    OnChange = EditSearchChange
  end
  object BtnCreate: TButton
    Left = 8
    Top = 22
    Width = 97
    Height = 35
    Caption = 'Criar'
    TabOrder = 3
    OnClick = BtnCreateClick
  end
  object BtnEdit: TButton
    Left = 166
    Top = 22
    Width = 97
    Height = 35
    Caption = 'Editar'
    TabOrder = 4
    OnClick = BtnEditClick
  end
  object BtnDelete: TButton
    Left = 336
    Top = 22
    Width = 97
    Height = 35
    Caption = 'Deletar'
    TabOrder = 5
    OnClick = BtnDeleteClick
  end
  object BtnRefresh: TButton
    Left = 512
    Top = 22
    Width = 97
    Height = 35
    Caption = 'Recarregar'
    TabOrder = 6
    OnClick = BtnRefreshClick
  end
  object ImageList1: TImageList
    Left = 521
    Top = 280
  end
end
