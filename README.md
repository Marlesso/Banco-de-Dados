# **Biblioteca de Alexandria**

Projeto acadêmico da disciplina de Banco de Dados 1, com objetivo de modelar e implementar o banco de dados de uma biblioteca, contemplando entidades, relacionamentos e regras de negócio básicas de um sistema de empréstimos.
- Grupo: Gabriel Costa Aparecida, Marcelo Rodrigues Rosa Paschoal, Tiago Da Silva Machado.

## Sumário

1. [Descrição](#descrição)
2. [Entidades](#entidades)
3. [Relacionamentos](#relacionamentos)
4. [Entrega 1 - Requisitos Atendidos](#entrega-1---requisitos-atendidos)
5. [Diagrama Entidade-Relacionamento (DER)](#diagrama-entidade-de-relacionamento-der)
6. [Entrega 2 - Implementação](#entrega-2---implementação)
   - [6.1 Criação das tabelas (DDL)](#61-criação-das-tabelas-ddl)
   - [6.2 Inserção de dados (DML)](#62-inserção-de-dados-dml)
   - [6.3 Function](#63-function)
   - [6.4 Procedure](#64-procedure)
   - [6.5 Triggers](#65-triggers)
   - [6.6 Views](#66-views)
7. [Situação da entrega](#situação-da-entrega)

## Descrição:

O sistema permite gerenciar livros, exemplares físicos, clientes, bibliotecários, categorias, autores e empréstimos, cobrindo os principais tipos de relacionamento entre entidades (1:1, 1:N, N:N, recursivo e associativo/ternário).

## Entidades:

| Nome | Descrição | Atributos |
|------|-----------|-----------|
| **Livro** | informações gerais da obra | idLivro, titulo, ISBN, ano, editora |
| **Exemplar** | cópia física de um livro | idExemplar, idLivro, codigo_patrimonio, estado_conservacao, disponivel |
| **Autor** | autor(es) das obras | idAutor, nome |
| **Cliente** | usuário que realiza empréstimos | idCliente, nome, matricula, endereco |
| **Bibliotecário** | funcionário responsável pelo atendimento | idBibliotecario, nome, matricula |
| **Setor** | separações organizacional da biblioteca | idSetor, nome, idBibliotecario |
| **Categoria** | classificação temática dos livros | idCategoria, nome, idCategoria_pai |
| **Empréstimo** | registro de retirada/devolução | idEmprestimo, idCliente, idExemplar, idBibliotecario, data_emprestimo, data_devolucao |

## Relacionamentos:
 
| Tipo | Entidades envolvidas | Descrição |
|------|----------------------|-----------|
| 1:1 | Bibliotecário - Setor | Bibliotecário trabalha em um setor e um setor é trabalhado por um bibliotecário |
| 1:N | Livro - Exemplar | Existem vários exemplares de um livro, porém um exemplar só pode representar um livro |
| N:N | Livro - Categoria | Um livro pode ter várias categorias e uma categoria pode pertencer vários livros |
| N:N | Livro - Autor | Um livro precisa de pelo menos um autor e um autor precisa ter escrito pelo menos um livro |
| Recursivo | Categoria - Categoria (subcategorias) | Uma subcategoria pode estar dentro de uma categoria Ex.: ficção-científica está dentro de ficção |
| Associativo | Empréstimo (Cliente + Exemplar + Bibliotecário) | Um cliente pegou emprestado um exemplar com um bibliotecário |

## Entrega 1 - Requisitos Atendidos
 
- [x] Mínimo de 5 entidades
- [x] Relacionamento 1:1
- [x] Relacionamento 1:N
- [x] Relacionamento N:N
- [x] Relacionamento recursivo
- [x] Relacionamento associativo/ternário

## Diagrama Entidade de Relacionamento (DER)
![DER da biblioteca](docs/DER_mwb.png)
### Chen:
![DER chen da biblioteca](docs/DER_BibliotecaDeAlexandria.svg)

# Entrega 2 - Implementação

O arquivo 'BibliotecaDeAlexandria.sql' está organizado em seções tituladas divididas pelos pontos de requisição da própria tarefa.

* CRIAÇÃO DAS `TABLES`
* INSERÇÃO DE DADOS
* CRIAÇÃO DE `FUNCTION`, `PROCEDURE`, `TRIGGERS` e `VIEWS`

## 6.1 Criação das tabelas (DDL)
 
O modelo da entrega anterior foi implementado com chaves primárias, estrangeiras, `UNIQUE` e regras de `ON DELETE`/`ON UPDATE`.
 
**Ajustes em relação à entrega anterior:**
- `Livro.ISBN` passou de `INT` para `VARCHAR(13)`. Um ISBN-13 tem 13 dígitos e ultrapassa o limite do `INT` (2.147.483.647); além disso, pode começar com zero.
- `Exemplar` ganhou a coluna `disponivel` (`BOOLEAN`, padrão `TRUE`), mantida automaticamente pelos triggers de `Emprestimo` (ver [6.5](#65-triggers)).

**Regras de exclusão adotadas:**
 
| Tabela / FK | Regra | Motivo |
|-------------|-------|--------|
| Escreve, Categoriza | `CASCADE` | São tabelas associativas: se o livro/autor/categoria some, o vínculo perde o sentido |
| Categoria (pai) | `SET NULL` | Se a categoria pai for removida, a subcategoria não deve ser apagada, apenas vira raiz |
| Exemplar, Setor, Empréstimo | `RESTRICT` | Protege o histórico: não se apaga um livro com exemplares, nem cliente/exemplar/bibliotecário com empréstimos |
 
## 6.2 Inserção de dados (DML)
 
Todas as tabelas receberam **no mínimo 5 registros**:
 
| Tabela | Registros | Tabela | Registros |
|--------|:---------:|--------|:---------:|
| Autor | 8 | Exemplar | 10 |
| Livro | 8 | Setor | 5 |
| Cliente | 6 | Escreve | 9 |
| Bibliotecario | 6 | Categoriza | 10 |
| Categoria | 6 | Emprestimo | 8 |
 
Os dados foram escolhidos para exercitar vários casos: um livro com dois autores (coautoria), um livro em duas categorias, subcategorias de dois níveis (Ficção > Ficção Científica > Distopia), um bibliotecário sem setor, e empréstimos devolvidos, devolvidos com atraso e em aberto.
 
A inserção respeita a ordem das chaves estrangeiras: tabelas independentes primeiro, tabelas associativas e `Emprestimo` por último.
 
## 6.3 Function
 
### `dias_de_atraso(data_emprestimo, data_devolucao)`
Retorna quantos dias um empréstimo passou do prazo de 14 dias (0 se estiver dentro do prazo). Se o livro ainda não foi devolvido (`data_devolucao` nula), o cálculo vai até a data de hoje.
 
**Por que foi criada:** a regra do prazo é usada em mais de um lugar (procedure e view). Centralizar em uma função evita repetir o cálculo e permite mudar o prazo em um único ponto.
 
Detalhes da declaração:
- `NOT DETERMINISTIC`: o resultado pode mudar de um dia para o outro, pois usa `CURDATE()`.
- `NO SQL`: a função não consulta tabelas, apenas calcula com os parâmetros. O MySQL exige declarar uma dessas características (`DETERMINISTIC`, `NO SQL` ou `READS SQL DATA`) quando o log binário está ativo.

## 6.4 Procedure
 
### `registrar_devolucao(emprestimoID, OUT dias_atraso)`
Registra a devolução de um empréstimo gravando a data de hoje em `data_devolucao` e retorna, pelo parâmetro de saída, quantos dias de atraso ele teve (usando a function `dias_de_atraso`). Exibe um aviso quando o empréstimo não é encontrado ou já foi devolvido.
 
**Por que foi criada:** padroniza o registro da devolução e já entrega ao atendimento a informação de atraso, sem a aplicação precisar repetir a conta.
 
Exemplo de uso:
```sql
SET @dias = 0;
CALL registrar_devolucao(5, @dias);
SELECT @dias AS dias_de_atraso;
```
 
## 6.5 Triggers
 
### `trg_emprestimo_ai` (AFTER INSERT em Emprestimo)
Quando um empréstimo em aberto é registrado (`data_devolucao` nula), marca o exemplar como indisponível (`Exemplar.disponivel = FALSE`).
 
**Por que foi criado:** a disponibilidade do exemplar precisa acompanhar os empréstimos. Com o trigger, a atualização é automática e não depende de a aplicação lembrar de fazê-la.
 
### `trg_emprestimo_au` (AFTER UPDATE em Emprestimo)
Quando a devolução é registrada (`data_devolucao` deixa de ser nula), marca o exemplar como disponível de novo.
 
**Por que foi criado:** é o par do trigger anterior: o exemplar volta ao acervo assim que o livro é devolvido, seja pela procedure ou por um `UPDATE` direto.
 
## 6.6 Views
 
### `Consultar_Emprestimos`
Junta `Emprestimo`, `Cliente`, `Exemplar`, `Livro` e `Bibliotecario`, exibindo cliente, livro, estado de conservação, bibliotecário, data do empréstimo, situação (EM ABERTO / DEVOLVIDO) e dias de atraso.
 
**Por que foi criada:** a consulta de empréstimos exige juntar 5 tabelas. A view esconde essa complexidade e entrega o resultado pronto para relatórios e atendimento.
 
### `Disponibilidade_livros`
Mostra, para cada livro, o total de exemplares, quantos estão emprestados e quantos estão disponíveis.
 
**Por que foi criada:** responde a uma pergunta frequente no atendimento ("tem exemplar livre deste livro?") sem precisar escrever a consulta com `LEFT JOIN` e `GROUP BY` toda vez.
 
## Situação da entrega
 
- [x] Script SQL do modelo (banco e tabelas)
- [x] Inserção de dados (mínimo de 5 registros por tabela)
- [x] Function, Procedure, Triggers e Views com explicação do porquê de cada objeto
- [~] Documentação no README
- [ ] Comandos `UPDATE` e `DELETE` com explicação do motivo
- [ ] Dois usuários relacionados por uma ROLE
- [ ] Buscas com JOIN (1:1, 1:N e N:M)