Pessoa(
  [idPessoa],
  nome,
  nif,
  dataNascimento,
  contacto
)

Passageiro(
  [idPassageiro],
  idPessoa->Pessoa,
  nome,
  nif,
  dataNascimento,
  contacto,
  numPassaporte
)

Funcionario(
  [idFuncionario],
  idPessoa->Pessoa,
  nome,
  nif,
  dataNascimento,
  contacto,
  salario,
  horario
)

Tripulacao(
  [idTripulacao],
  idFuncionario->Funcionario,
  nome,
  nif,
  dataNascimento,
  contacto,
  salario,
  horario,
  certificacoes,
  idiomasFalados,
  disponibilidade
)

Piloto(
  [idPiloto],
  idTripulacao->Tripulacao,
  nome,
  nif,
  dataNascimento,
  contacto,
  salario,
  horario,
  certificacoes,
  idiomasFalados,
  disponibilidade,
  idPessoa,
  numLicenca,
  validadeLicenca,
  nivelCertificacao
)

Comissario(
  [idComissario],
  idTripulacao->Tripulacao,
  nome,
  nif,
  dataNascimento,
  contacto,
  salario,
  horario,
  certificacoes,
  idiomasFalados,
  disponibilidade,
  funcaoBordo
)

FuncionarioAeroporto(
  [idFuncionarioAeroporto],
  idFuncionario->Funcionario,
  nome,
  nif,
  dataNascimento,
  contacto,
  salario,
  horario,
  turno
)

Seguranca(
  [idSeguranca],
  idFuncionarioAeroporto->FuncionarioAeroporto,
  nome,
  nif,
  dataNascimento,
  contacto,
  salario,
  horario,
  turno,
  idSecao,
  resultadoVerificacaoPadrao
)

CompanhiaAerea(
  [idCompanhiaAerea],
  idCompanhia,
  nome
)

Aviao(
  [idAviao],
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
  horaPartida,
  horaChegada,
  origem,
  destino,
  duracao
)


Bilhete(
  [idBilhete],
  idVoo->Voo,
  numLugar,
  classeVoo,
  preco
)

CheckIn(
  [idCheckIn],
  data,
  hora,
  local,
  estado,
  numMalas,
  observacoes,
  idBilhete->Bilhete
)

CartaoEmbarque(
  [idCartaoEmbarque],
  idCartao->CheckIn,
  portaEmbarque,
  horaEmbarque
)

Bagagem(
  [idBagagem],
  peso,
  estadoValidacao,
  destino
)

Equipamento(
  [idEquipamento],
  tipo,
  estado,
  emUso
)

Manutencao(
  [idManutencao],
  data,
  tipo,
  custo
)
