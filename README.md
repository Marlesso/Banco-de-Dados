# **Biblioteca de Alexandria**

Projeto acadêmico da disciplina de Banco de Dados 1, com objetivo de modelar e implementar o banco de dados de uma biblioteca, contemplando entidades, relacionamentos e regras de negócio básicas de um sistema de empréstimos.
- Grupo: Gabriel Costa Aparecida, Marcelo Rodrigues Rosa Paschoal, Tiago Da Silva Machado.

## Descrição:

O sistema permite gerenciar livros, exemplares físicos, clientes, bibliotecários, categorias, autores e empréstimos, cobrindo os principais tipos de relacionamento entre entidades (1:1, 1:N, N:N, recursivo e associativo/ternário).

## Entidades:

| Nome | Descrição | Atributos |
|------|-----------|-----------|
| **Livro** | informações gerais da obra | idLivro, titulo, ISBN, ano, editora |
| **Exemplar** | cópia física de um livro | idExemplar, idLivro, codigo_patrimonio, estado_conservacao |
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

## Requisitos atendidos
 
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