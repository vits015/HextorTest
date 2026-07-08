# 🪱 Simulação da Minhoca - Delphi VCL

Projeto desenvolvido como teste técnico utilizando **Delphi (VCL)**.

A aplicação simula uma minhoca tentando sair de um buraco, considerando a profundidade do buraco, a distância percorrida a cada subida e a distância perdida a cada queda. Durante a execução, a interface apresenta uma animação da movimentação e atualiza o progresso da simulação em tempo real.

---

## 📋 Funcionalidades

* Validação dos dados informados pelo usuário.
* Simulação da movimentação da minhoca.
* Contagem da quantidade de subidas realizadas.
* Indicação visual ao atingir 50% da profundidade.
* Indicação visual quando a minhoca sai do buraco.
* Animação controlada por `TTimer`.

---

## 🏗️ Arquitetura

O projeto foi organizado separando a regra de negócio da interface gráfica.

### `Minhoca.pas`

Responsável por encapsular toda a lógica da simulação:

* Controle da posição atual.
* Regra de subida.
* Regra de queda.
* Quantidade de subidas.
* Verificação da metade do percurso.
* Verificação da saída do buraco.

### `uFrmPrincipal.pas`

Responsável pela interface gráfica:

* Validação das entradas.
* Controle do fluxo da simulação.
* Atualização dos componentes visuais.
* Posicionamento da minhoca no painel.
* Controle da animação através de uma máquina de estados (`csSubir`, `csCair` e `csPausa`).

---

## ⚙️ Funcionamento

1. O usuário informa:

   * Profundidade do buraco;
   * Distância que a minhoca sobe;
   * Distância que ela escorrega.

2. A simulação é iniciada.

3. A cada ciclo:

   * A minhoca sobe;
   * Caso ainda não tenha saído, ela escorrega;
   * O processo continua até atingir o topo do buraco.

4. Ao final, é exibida a quantidade total de subidas realizadas.

---

## 🛠️ Tecnologias utilizadas

* Delphi (VCL)
* Object Pascal
* Programação Orientada a Objetos

---

## 📁 Estrutura do projeto

```text
.
├── Minhoca.pas          // Lógica da simulação
├── uFrmPrincipal.pas    // Interface gráfica
├── uFrmPrincipal.dfm
└── README.md
```

---

## 💡 Boas práticas aplicadas

* Separação entre lógica de negócio e interface.
* Encapsulamento.
* Responsabilidade única (SRP).
* Código organizado e legível.
* Validação de entradas.
* Comentários em pontos importantes da implementação.

---

## ▶️ Execução

1. Abra o projeto no Delphi.
2. Compile a aplicação.
3. Informe os parâmetros da simulação.
4. Clique em **Iniciar** para acompanhar a execução.

---

Desenvolvido como parte de um teste técnico, priorizando organização do código, clareza da implementação e facilidade de manutenção.
