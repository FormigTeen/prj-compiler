# Linguagem Money

## Introdução

A **Money** é uma linguagem de programação criada para manipular valores monetários de forma intuitiva e eficiente. Ela oferece tipos e operações específicos para contas, moedas, notas e bancos, além de controle de fluxo e funções personalizadas para cálculos financeiros.

---

## Especificação da Linguagem

### Tipos de Dados

A linguagem **Money** oferece os seguintes tipos básicos:

- **`coin`**: Representa valores monetários em centavos ou frações (e.g., `.10`, `.550`).
- **`bill`**: Representa valores inteiros de dinheiro em notas (e.g., `10`).
- **`account`**: Combinação de valores inteiros e fracionados (e.g., `10.50`).
- **`bank`**: Um vetor que armazena contas.

### Estruturas de Controle

- **Condicional simples**: `if ... then ... end`
- **Condicional composto**: `if ... then ... else ... end`
- **Laços**: `while ... then ... end`

### Operadores

- Aritméticos: `+`, `-`, `*`, `/`
- Comparativos: `==`, `!=`, `<=`, `>=`, `<`, `>`

### Funções

- Funções com retorno: `account transaction`
- Funções sem retorno: `void transaction`
- Chamada de funções: `start <nome_da_função>`

---

## Exemplo de Uso

### Definição de Variáveis

```money
bill ten = 10
coin extra_coin = .20
account my_account = 10.20
bank[account:5] my_bank
```

### Controle de Fluxo

```money
if my_account > 10.00 then
    bill fee = 1
    my_account = my_account - fee
end
```

### Funções Personalizadas

```money
account transaction interest(account base, coin rate) then
    account result = base * rate
    return result
end

start log_transaction(interest(my_account, .03))
```

---

## Analisador Léxico

Foi criado um protótipo de um analisador léxico para a linguagem usando o Flex. Você pode acessar o código completo no arquivo [grammar.l](grammar.l).

Para a confecção do analisador foi usado como referência o livro de [Compiladores](https://www.amazon.com.br/Compiladores-princ%C3%ADpios-ferramentas-Alfred-Aho/dp/8588639246/ref=asc_df_8588639246/?tag=googleshopp00-20\&linkCode=df0\&hvadid=709883381743\&hvpos=\&hvnetw=g\&hvrand=15621733694786157935\&hvpone=\&hvptwo=\&hvqmt=\&hvdev=c\&hvdvcmdl=\&hvlocint=\&hvlocphy=9198184\&hvtargid=pla-810094896642\&psc=1\&mcid=99bbc039943c3c9ba6ee93a4e0ce140a\&gad_source=1).

Como um protótipo inicial, não foram definidas constantes que serão usadas ou manipuladas pelo analisador sintático. Consequentemente, foi omitido das ações sintáticas o uso do **return**.

### Estrutura do Código

#### Rotinas para Gerenciamento

Inicialmente, foram definidas algumas rotinas em C para o gerenciamento de uma tabela Hash, utilizando a biblioteca [uthash](/uthash.c).

#### Estruturas Principais

Duas **structs** foram criadas para armazenar informações durante o processo de análise:

1. **`Symbol`**: Responsável por salvar os IDs de Tokens encontrados durante o processo de análise. Os campos principais são:

   - `key`: Lexema encontrado.
   - `type`: Representa o tipo do lexema (atualmente apenas *id*).

2. **`SValue`**: Responsável por armazenar valores numéricos constantes. Os campos principais são:

   - `value`: Representação numérica em formato inteiro (e.g., `23.335` será convertido para `23335`).
   - `decimal`: Quantidade de casas decimais do número, conforme especificação única da linguagem.

#### Funções de Extração

Para processar valores numéricos, foram implementadas duas funções principais:

- **`get_number`**: Extrai a parte inteira do número do lexema.
- **`get_count`**: Calcula a quantidade de casas decimais do número.

#### Adição e Recuperação de Valores

Duas tabelas de símbolos foram criadas:

1. **Tabela de Tokens ID**: Armazena informações sobre os lexemas identificados.
2. **Tabela de Valores Numéricos**: Gerencia valores processados.

Vale ressaltar que a separação de escopo da tabela de símbolos não foi tratada, já que o analisador sintático deverá lidar com isso em fases posteriores.

#### Expressões Regulares e Regras Léxicas

Para melhorar a organização do código, foram criados *alias* para algumas expressões regulares, localizadas logo abaixo da linha `/* Expressions Alias */`. Essas *alias* tornam o código mais legível e facilitam a manutenção.

Após isso, foram implementadas regras de análise léxica para tratar a entrada do [texto de exemplo](test.money). Este arquivo cobre os principais casos de uso definidos no projeto, como:

- Declaração de variáveis e funções.
- Tipagem explícita e forte.
- Estruturas de controle (condicionais) e repetição.

As regras foram desenvolvidas para capturar e processar os elementos mais relevantes da linguagem. Além disso, foram implementadas as principais ações que um analisador léxico pode executar no contexto de um compilador.

#### Funções Auxiliares para Impressão

Para seguir a especificação do projeto, foram criadas funções auxiliares para a impressão e visualização dos lexemas convertidos:

1. **`print_tag`**: Exibe unicamente a tag do atributo no formato `<TAG />`.

   - **Exemplo**: `TYPE` será exibido como `<TYPE />`.

2. **`print_tag_with_value`**: Exibe a tag com o valor processado pelo analisador.

   - **Exemplo**: `= 55.2` será transformado em:
     ```xml
     <ASS />
     <BALANCE>552.1</BALANCE>
     ```

3. **`print_tag_with_symbol`**: Exibe a tag com o endereço do lexema na tabela de símbolos.

   - **Exemplo**: `my_var` será transformado em:
     ```xml
     <ID>54d5dfsd5f45</ID>
     ```

Essas funções permitem uma visualização estruturada e intuitiva do que está sendo analisado.

---

## Como Executar

O projeto utiliza **Make** para gerenciar a compilação e execução. As definições estão descritas no arquivo [Makefile](Makefile):

Você pode acessar o arquivo completo com as definições no [Makefile](Makefile).

### Passos para Executar

1. Certifique-se de ter o **Flex** e o **Make** instalados em sua máquina.
2. Para compilar o analisador léxico, execute:
   ```bash
   make compiler
   ```
3. Para executar o analisador léxico com o arquivo de teste, use:
   ```bash
   make test
   ```
4. Para limpar os arquivos gerados pela compilação, execute:
   ```bash
   make clean
   ```

---
