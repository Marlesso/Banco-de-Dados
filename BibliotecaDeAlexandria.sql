-- BIBLIOTECA DE ALEXANDRIA
-- Projeto acadêmico da disciplina de Banco de Dados 1, com objetivo de modelar e implementar o banco de dados de uma biblioteca, 
-- contemplando entidades, relacionamentos e regras de negócio básicas de um sistema de empréstimos.
-- Grupo: Gabriel Costa Aparecida, Marcelo Rodrigues Rosa Paschoal, Tiago Da Silva Machado.

DROP DATABASE IF EXISTS BibliotecaAlexandria;
CREATE DATABASE IF NOT EXISTS BibliotecaAlexandria;
USE BibliotecaAlexandria;

CREATE TABLE IF NOT EXISTS Autor (
	idAutor INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Livro (
	idLivro INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    ISBN VARCHAR(13) NOT NULL UNIQUE,
    ano INT,
    editora VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Cliente (
	idCliente INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    matricula INT NOT NULL UNIQUE,
    endereco VARCHAR(150)
);

CREATE TABLE IF NOT EXISTS Bibliotecario (
	idBibliotecario INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    matricula INT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Categoria (
	idCategoria INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    idCategoria_pai INT,
    FOREIGN KEY (idCategoria_pai) REFERENCES Categoria(idCategoria)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Escreve (
	idAutor INT NOT NULL,
    idLivro INT NOT NULL,
    PRIMARY KEY (idAutor, idLivro),
    FOREIGN KEY (idAutor) REFERENCES Autor(idAutor)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (idLivro) REFERENCES Livro(idLivro)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Categoriza (
	idLivro INT NOT NULL,
    idCategoria INT NOT NULL,
    PRIMARY KEY (idLivro, idCategoria),
    FOREIGN KEY (idLivro) REFERENCES Livro(idLivro)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (idCategoria) REFERENCES Categoria(idCategoria)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Exemplar (
	idExemplar INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    codigo_patrimonio INT NOT NULL UNIQUE,
    estado_conservacao VARCHAR(150),
    idLivro INT NOT NULL,
    FOREIGN KEY (idLivro) REFERENCES Livro(idLivro)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Setor (
	idSetor INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    idBibliotecario INT NOT NULL UNIQUE,
    FOREIGN KEY (idBibliotecario) REFERENCES Bibliotecario(idBibliotecario)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Emprestimo (
	idEmprestimo INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    idBibliotecario INT NOT NULL,
    idCliente INT NOT NULL,
    idExemplar INT NOT NULL,
    data_emprestimo DATE NOT NULL,
    data_devolucao DATE,
    FOREIGN KEY (idBibliotecario) REFERENCES Bibliotecario(idBibliotecario)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
    FOREIGN KEY (idExemplar) REFERENCES Exemplar(idExemplar)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

