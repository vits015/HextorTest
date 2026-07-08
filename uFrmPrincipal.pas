unit uFrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Minhoca, Vcl.Imaging.jpeg, System.ImageList, Vcl.ImgList,
  Vcl.BaseImageCollection, Vcl.ImageCollection, Vcl.VirtualImageList;

type
  /// <summary>
  /// Estados do ciclo da simulacao controlados pelo TTimer (1 tick = 1 segundo).
  /// </summary>
  TCicloSimulacao = (csSubir, csCair, csPausa);

  TFrmPrincipal = class(TForm)
    pnlBuraco: TPanel;
    shpMeta: TShape;
    shpChegada: TShape;
    Timer: TTimer;
    edtProfundidade: TEdit;
    edtSobe: TEdit;
    edtCai: TEdit;
    btnIniciar: TButton;
    lblSubidas: TLabel;
    lblProfundidade: TLabel;
    lblSobe: TLabel;
    lblCai: TLabel;
    lblTopo: TLabel;
    lblFundo: TLabel;
    shpMinhoca: TImage;
    VirtualImageList1:TVirtualImageList;
    ImageCollection1: TImageCollection;
    procedure btnIniciarClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FMinhoca: TMinhoca;
    FCiclo: TCicloSimulacao;
    FProfundidadeAtual: Integer;

    function ValidarEntradas(out Profundidade, Sobe, Cai: Integer): Boolean;
    procedure IniciarSimulacao(const Profundidade, Sobe, Cai: Integer);
    procedure FinalizarSimulacao;
    procedure AtualizarTela;
    procedure DefinirFrameMinhoca(const Indice: Integer);
    procedure AtualizarFrameMinhoca;
    procedure PosicionarShapeNoBuraco(const AShape: TImage; const PosicaoCm: Integer);
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

function TFrmPrincipal.ValidarEntradas(out Profundidade, Sobe, Cai: Integer): Boolean;
begin
  Result := False;

  if not TryStrToInt(Trim(edtProfundidade.Text), Profundidade) then
  begin
    ShowMessage('Informe um valor inteiro valido para a profundidade do buraco.');
    edtProfundidade.SetFocus;
    Exit;
  end;

  if not TryStrToInt(Trim(edtSobe.Text), Sobe) then
  begin
    ShowMessage('Informe um valor inteiro valido para a quantidade que sobe.');
    edtSobe.SetFocus;
    Exit;
  end;

  if not TryStrToInt(Trim(edtCai.Text), Cai) then
  begin
    ShowMessage('Informe um valor inteiro valido para a quantidade que cai.');
    edtCai.SetFocus;
    Exit;
  end;

  if Profundidade <= 0 then
  begin
    ShowMessage('A profundidade do buraco deve ser maior que zero.');
    edtProfundidade.SetFocus;
    Exit;
  end;

  if Sobe <= 0 then
  begin
    ShowMessage('A quantidade que sobe deve ser maior que zero.');
    edtSobe.SetFocus;
    Exit;
  end;

  if Cai < 0 then
  begin
    ShowMessage('A quantidade que cai nao pode ser negativa.');
    edtCai.SetFocus;
    Exit;
  end;

  if Sobe <= Cai then
  begin
    ShowMessage('A minhoca nunca conseguira sair do buraco.');
    Exit;
  end;

  Result := True;
end;

procedure TFrmPrincipal.PosicionarShapeNoBuraco(const AShape: TImage; const PosicaoCm: Integer);
var
  AreaUtil: Integer;
begin
  AreaUtil := pnlBuraco.ClientHeight - AShape.Height;
  if AreaUtil < 0 then
    AreaUtil := 0;

  AShape.Top := pnlBuraco.ClientHeight - AShape.Height -
    Round((PosicaoCm / FProfundidadeAtual) * AreaUtil);
end;

procedure TFrmPrincipal.DefinirFrameMinhoca(const Indice: Integer);
var
  Bmp: TBitmap;
begin
  Bmp := TBitmap.Create;
  try
    VirtualImageList1.GetBitmap(Indice, Bmp);
    shpMinhoca.Picture.Assign(Bmp);
  finally
    Bmp.Free;
  end;
end;

procedure TFrmPrincipal.AtualizarFrameMinhoca;
begin
  case FCiclo of
    csCair:
      DefinirFrameMinhoca(1); // minhoca esticada ao subir
    csPausa,csSubir:
      DefinirFrameMinhoca(0); // minhoca encolhida ao cair e durante a pausa
  end;
end;

procedure TFrmPrincipal.AtualizarTela;
begin
  if not Assigned(FMinhoca) then
    Exit;

  // Posiciona a minhoca conforme a profundidade percorrida
  PosicionarShapeNoBuraco(shpMinhoca, FMinhoca.Posicao);

  lblSubidas.Caption := Format('Quantidade de subidas: %d', [FMinhoca.QuantidadeSubidas]);

  // Quadro amarelo ao atingir a metade do caminho
  if FMinhoca.ChegouNaMeta and (not FMinhoca.SaiuDoBuraco) then
  begin
    shpChegada.Visible := True;
    shpChegada.Brush.Color := clYellow;
  end;

  // Quadro verde ao sair do buraco
  if FMinhoca.SaiuDoBuraco then
  begin
    shpChegada.Visible := True;
    shpChegada.Brush.Color := clLime;
  end;
end;

procedure TFrmPrincipal.IniciarSimulacao(const Profundidade, Sobe, Cai: Integer);
begin
  Timer.Enabled := False;

  FreeAndNil(FMinhoca);
  FMinhoca := TMinhoca.Create(Profundidade, Sobe, Cai);
  FProfundidadeAtual := Profundidade;
  FCiclo := csSubir;
  Timer.Interval := 750;   //
  Timer.Enabled := True;   //

  // Marca visual da meta (50%) sempre visivel durante a simulacao
//  PosicionarShapeNoBuraco(shpMeta, FMinhoca.Meta);
  shpMeta.Visible := True;

  shpChegada.Visible := False;
  shpChegada.Brush.Color := clYellow;

  btnIniciar.Enabled := False;
  edtProfundidade.Enabled := False;
  edtSobe.Enabled := False;
  edtCai.Enabled := False;

  AtualizarFrameMinhoca;
  AtualizarTela;
//  Timer.Enabled := True;
end;

procedure TFrmPrincipal.FinalizarSimulacao;
begin
  Timer.Enabled := False;
  AtualizarTela;

  lblSubidas.Caption := Format('Quantidade de subidas: %d', [FMinhoca.QuantidadeSubidas]);

  btnIniciar.Enabled := True;
  edtProfundidade.Enabled := True;
  edtSobe.Enabled := True;
  edtCai.Enabled := True;
end;

procedure TFrmPrincipal.TimerTimer(Sender: TObject);
begin
  //lbTimer.Caption:= IntToStr(StrToInt(lbTimer.Caption)+1);
  if not Assigned(FMinhoca) then
    Exit;

  case FCiclo of
    csSubir:
      begin
        if FMinhoca.Subir then
        begin
          AtualizarTela;
          FinalizarSimulacao;
          Exit;
        end;

        AtualizarTela;
        FCiclo := csCair;
        AtualizarFrameMinhoca;
        Timer.Interval := 500;
      end;

    csCair:
      begin
        FMinhoca.Cair;
        FCiclo := csPausa;
        AtualizarFrameMinhoca;
        AtualizarTela;
        Timer.Interval := 500;
      end;

    csPausa:
      begin
        FCiclo := csSubir;
        AtualizarFrameMinhoca;
        Timer.Interval := 500;
      end;
  end;
end;

procedure TFrmPrincipal.btnIniciarClick(Sender: TObject);
var
  Profundidade, Sobe, Cai: Integer;
begin
  if not ValidarEntradas(Profundidade, Sobe, Cai) then
    Exit;

  IniciarSimulacao(Profundidade, Sobe, Cai);
end;

procedure TFrmPrincipal.FormDestroy(Sender: TObject);
begin
  Timer.Enabled := False;
  FreeAndNil(FMinhoca);
end;

end.
