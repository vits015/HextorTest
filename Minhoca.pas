unit Minhoca;

interface

type
  /// <summary>
  /// Encapsula a logica de movimentacao da minhoca no buraco.
  /// Separada da interface para facilitar testes e manutencao.
  /// </summary>
  TMinhoca = class
  private
    FProfundidade: Integer;
    FPosicao: Integer;
    FSubida: Integer;
    FQueda: Integer;
    FQuantidadeSubidas: Integer;
    function GetMeta: Integer;
    function GetChegouNaMeta: Boolean;
    function GetSaiuDoBuraco: Boolean;
  public
    constructor Create(AProfundidade, ASubida, AQueda: Integer);

    /// <summary>
    /// Executa uma subida. Retorna True quando a minhoca atinge ou ultrapassa o topo.
    /// </summary>
    function Subir: Boolean;

    /// <summary>
    /// Executa uma queda apos a pausa de 1 segundo.
    /// </summary>
    procedure Cair;

    /// <summary>
    /// Reinicia posicao e contador para uma nova simulacao.
    /// </summary>
    procedure Reiniciar;

    property Profundidade: Integer read FProfundidade;
    property Posicao: Integer read FPosicao;
    property QuantidadeSubidas: Integer read FQuantidadeSubidas;
    property Meta: Integer read GetMeta;
    property ChegouNaMeta: Boolean read GetChegouNaMeta;
    property SaiuDoBuraco: Boolean read GetSaiuDoBuraco;
  end;

implementation

{ TMinhoca }

constructor TMinhoca.Create(AProfundidade, ASubida, AQueda: Integer);
begin
  FProfundidade := AProfundidade;
  FSubida := ASubida;
  FQueda := AQueda;
  Reiniciar;
end;

function TMinhoca.GetMeta: Integer;
begin
  Result := FProfundidade div 2;
end;

function TMinhoca.GetChegouNaMeta: Boolean;
begin
  Result := FPosicao >= Meta;
end;

function TMinhoca.GetSaiuDoBuraco: Boolean;
begin
  Result := FPosicao >= FProfundidade;
end;

procedure TMinhoca.Reiniciar;
begin
  FPosicao := 0;
  FQuantidadeSubidas := 0;
end;

function TMinhoca.Subir: Boolean;
begin
  Inc(FQuantidadeSubidas);
  FPosicao := FPosicao + FSubida;
  Result := SaiuDoBuraco;
end;

procedure TMinhoca.Cair;
begin
  FPosicao := FPosicao - FQueda;
  if FPosicao < 0 then
    FPosicao := 0;
end;

end.
