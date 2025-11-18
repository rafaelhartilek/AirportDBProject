Pessoa(
  [idPessoa],
  nome,
  nif,
  dataNascimento,
  contacto
)

Passageiro(
  [idPessoa -> Pessoa],
  numPassaporte
)

Funcionario(
  [idPessoa -> Pessoa],
  idFuncionario,
  salario,
  horario
)

Tripulacao(
  [idPessoa -> Funcionario],
  certificacoes,
  idiomasFalados,
  disponibilidade
)

Piloto(
  [idPessoa -> Tripulacao],
  numLicenca,
  validadeLicenca,
  nivelCertificacao
)

Comissario(
  [idPessoa -> Tripulacao],
  funcaoBordo
)

FuncionarioAeroporto(
  [idPessoa -> Funcionario],
  turno
)

Seguranca(
  [idPessoa -> FuncionarioAeroporto],
  idSecao,
  resultadoVerificacaoPadrao
)

CompanhiaAerea(
  [idCompanhia],
  nome
)

Aviao(
  [idAviao],
  idCompanhia -> CompanhiaAerea,
  modelo,
  capacidade,
  velocidadeMaxima,
  numMotores,
  peso,
  combustivelDepositado,
  horasVoo
)

Voo(
  [idVoo],
  idAviao -> Aviao,
  origem,
  destino,
  horaPartida,
  horaChegada,
  duracao
)

PermissaoPiloto(
  [idPessoa -> Piloto, idAviao -> Aviao],
  autorizado,
  restricao
)

Bilhete(
  [idBilhete],
  idPessoa -> Passageiro,
  idVoo    -> Voo,
  numLugar,
  classeVoo,
  preco
)

CheckIn(
  [idCheckIn],
  idBilhete -> Bilhete,
  data,
  hora,
  local,
  estado,
  numMalas,
  observacoes
)

CartaoEmbarque(
  [idCartao],
  idCheckIn -> CheckIn,
  idVoo     -> Voo,
  portaEmbarque,
  horaEmbarque
)

Bagagem(
  [idBagagem],
  idCheckIn -> CheckIn,
  idSecao   -> Seguranca,
  peso,
  estadoValidacao,
  destino
)

Equipamento(
  [idEquipamento],
  idPessoa -> FuncionarioAeroporto,
  tipo,
  estado,
  emUso
)

Manutencao(
  [idManutencao],
  idAviao  -> Aviao,
  idPessoa -> FuncionarioAeroporto,
  data,
  tipo,
  custo
)
