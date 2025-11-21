Pessoa(
  [numeroCC],
  nome,
  dataNascimento,
  infoContacto,
)

Passageiro(
 [numeroCC]->Pessoa,
  númeroPassaporte, 
)

Funcionario(
  numeroCC->Pessoa,
 [idFuncionário],
  horário,
  salário,
)


Tripulacao(
  [idFuncionário]->Funcionario,
  certificados,
)

FuncionarioAeroporto(
 [idFuncionário]->Funcionario,
  departamento,
)

Piloto(
 [idFuncionário]->Tripulacao,
  nLicença,
  
)

Comissario(
 [idFuncionário]->Tripulacao,
  função,
)

CompanhiaAerea(
  [idCompanhia],
  nome,
)

PilotoDoAviao(
 [idAviao]->Aviao,
  idFuncionario->Piloto,
)

Aviao(
  [idAviao],
  modelo,
  numMotores,
  status,
  capacidade,
  peso,
  depósitoGasolina,
  consumoMédio,
  velocidadeMax,
  tempoUsoTotal,
  idCompanhia->CompanhiaAerea,
  idVoo->Voo,
)

TripulaçãoNoVoo(
  [idVoo]->Voo,
  idFuncionário->Tripulacao,
)

Voo(
  [idVoo],
  horaPartida,
  horaChegada,
  origem,
  destino,
  data,
  duracao,
  lugaresDisponiveis,
  idCompanhia->CompanhiaAerea,
)

Bilhete(
  [idBilhete],
  numeroLugar,
  classe,
  preco,
  idVoo->Voo,
  numeroCCPassageiro->Passageiro,
)


CheckIn(
  [idCheckIn],
  data,
  hora,
  local,
  estado,
  nMalas,
  pesoTotal
  observacoes,
  numeroCCPassageiro->Passageiro,
)

CartaoEmbarque(
  [idCartao],
  portaEmbarque,
  horaEmbarque,
  idCheckIn->CheckIn,
  idVoo-> Voo,
)

Bagagem(
  [idBagagem],
  peso,
  status,
  destinoFinal,
  idCheckIn->CheckIn,	
)

