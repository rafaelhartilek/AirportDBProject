# Relational Schema – AI-refined version (BCNF)

Este ficheiro apresenta uma versão refinada do modelo relacional do aeroporto, produzida com apoio de IA, a partir do esquema inicial em `relationalDesignSchema.md`.

Os principais objetivos desta versão foram:

- eliminar **redundâncias** (especialmente atributos repetidos devido à herança)
- clarificar **chaves primárias** e **estrangeiras**
- alinhar melhor com o **modelo UML** e a semântica pretendida
- garantir que, para cada relação, as dependências funcionais naturais são do tipo
  **chave → restantes atributos**, colocando o esquema em **BCNF**.

---

## 1. Principais alterações relativamente ao esquema inicial

1. **Herança de Pessoa simplificada**

   - Em vez de criar novos identificadores (`idPassageiro`, `idFuncionario`, `idTripulacao`, etc.) e repetir `nome`, `nif`, `dataNascimento`, `contacto` em todas as tabelas, optou-se por:
     - manter **uma única chave** `idPessoa` em `Pessoa`,
     - usar `idPessoa` como **PK e FK** nas subclasses (`Passageiro`, `Funcionario`, `Tripulacao`, `Piloto`, `Comissario`, `FuncionarioAeroporto`, `Seguranca`).

   - Desta forma, os dados pessoais são guardados **apenas uma vez** em `Pessoa`, evitando anomalias de atualização.

2. **Subclasses sem atributos redundantes**

   - Tabelas como `Passageiro`, `Funcionario`, `Tripulacao`, `Piloto`, `Comissario`, `FuncionarioAeroporto` e `Seguranca` passaram a conter **apenas os atributos realmente específicos** de cada subclasse; os dados comuns continuam em `Pessoa` / `Funcionario` / `Tripulacao` / `FuncionarioAeroporto`.

3. **Identificadores e nomes ajustados**

   - `CompanhiaAerea`: removido `idCompanhiaAerea` e mantido apenas `idCompanhia` como PK.
   - `CartaoEmbarque`: clarificado como cartão emitido a partir de um `CheckIn` e associado a um `Voo`, com PK simples `idCartao`.
   - `Bagagem`: ligada a `CheckIn` (bagagem associada ao check-in do passageiro) e à `Seguranca` (secção de verificação), através de FKs.

4. **BCNF**

   - Em todas as relações, assumiram-se dependências funcionais naturais do tipo:
     - `idRelação → todos os outros atributos` (ou o equivalente composto, quando for o caso),
   - não foram incluídos atributos que dependessem de outros não-chave (para evitar violações de BCNF).

---

## 2. Relational Schema – AI proposal (BCNF)

A notação segue o formato pedido:
`R([pk], attr1, attr2->OutraRelação, ...)`

### Pessoa

```
Pessoa(
  [idPessoa],
  nome,
  nif,
  dataNascimento,
  contacto
)
```

### Especializações de Pessoa

```
Passageiro(
  [idPessoa->Pessoa],
  numPassaporte
)

Funcionario(
  [idPessoa->Pessoa],
  salario,
  horario
)

Tripulacao(
  [idPessoa->Funcionario],
  certificacoes,
  idiomasFalados,
  disponibilidade
)

Piloto(
  [idPessoa->Tripulacao],
  numLicenca,
  validadeLicenca,
  nivelCertificacao
)

Comissario(
  [idPessoa->Tripulacao],
  funcaoBordo
)

FuncionarioAeroporto(
  [idPessoa->Funcionario],
  turno
)

Seguranca(
  [idPessoa->FuncionarioAeroporto],
  idSecao,
  resultadoVerificacaoPadrao
)
```

- Pessoa contém todos os dados pessoais.
- Cada subclasse usa a mesma chave idPessoa, garantindo uma hierarquia limpa e sem replicar atributos comuns.
- Em Seguranca, idSecao identifica a secção de segurança associada ao funcionário; pode ser declarada UNIQUE(idSecao) no SQL para garantir um para-um entre secção e funcionário, se desejado.

### Companhia, avião e voo

```
CompanhiaAerea(
  [idCompanhia],
  nome
)

Aviao(
  [idAviao],
  idCompanhia->CompanhiaAerea,
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
  idAviao->Aviao,
  origem,
  destino,
  horaPartida,
  horaChegada,
  duracao
)
```

- Cada avião pertence a uma companhia (idCompanhia->CompanhiaAerea).
- Cada voo é realizado por um avião específico (idAviao->Aviao).
- Em BCNF, assumimos FDs do tipo idAviao → ... e idVoo → ....

### Bilhetes, check-in e cartões de embarque

```
Bilhete(
  [idBilhete],
  idPessoa->Passageiro,
  idVoo->Voo,
  numLugar,
  classeVoo,
  preco
)

CheckIn(
  [idCheckIn],
  idBilhete->Bilhete,
  data,
  hora,
  local,
  estado,
  numMalas,
  observacoes
)

CartaoEmbarque(
  [idCartao],
  idCheckIn->CheckIn,
  idVoo->Voo,
  portaEmbarque,
  horaEmbarque
)
```

- Bilhete associa um Passageiro a um Voo.
- CheckIn refere sempre um bilhete específico.
- CartaoEmbarque é emitido a partir de um CheckIn e está ligado ao Voo (útil para cruzar com alterações de porta/horário).

### Bagagem

```
Bagagem(
  [idBagagem],
  idCheckIn->CheckIn,
  idSecao->Seguranca,
  peso,
  estadoValidacao,
  destino
)
```

- A bagagem é associada a um CheckIn (e, indiretamente, a um passageiro/bilhete).
- idSecao->Seguranca permite registar em que secção de segurança a bagagem foi verificada.
- Em BCNF, assumimos idBagagem → (idCheckIn, idSecao, peso, estadoValidacao, destino).

### Equipamento e manutenção

```
Equipamento(
  [idEquipamento],
  idPessoa->FuncionarioAeroporto,
  tipo,
  estado,
  emUso
)

Manutencao(
  [idManutencao],
  idAviao->Aviao,
  idPessoa->FuncionarioAeroporto,
  data,
  tipo,
  custo
)
```

- Equipamento: registamos qual funcionário de aeroporto é responsável pelo equipamento.
- Manutencao: liga um avião a um funcionário de aeroporto que executou a manutenção.
- Aqui também as FDs são da forma idEquipamento → ... e idManutencao → ..., que é consistente com BCNF.

# Relational schema refinado com apoio de IA por ChatGPT – GPT-5.1 Thinking (assistente de modelação de BD)
