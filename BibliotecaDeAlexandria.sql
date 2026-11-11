-- ==============================================================================================================================
-- BIBLIOTECA DE ALEXANDRIA
-- Projeto acadêmico da disciplina de Banco de Dados 1, com objetivo de modelar e implementar o banco de dados de uma biblioteca, 
-- contemplando entidades, relacionamentos e regras de negócio básicas de um sistema de empréstimos.
-- Grupo: Gabriel Costa Aparecida, Marcelo Rodrigues Rosa Paschoal, Tiago Da Silva Machado.
-- ==============================================================================================================================

DROP DATABASE IF EXISTS BibliotecaAlexandria;
CREATE DATABASE IF NOT EXISTS BibliotecaAlexandria;
USE BibliotecaAlexandria;

-- ==================================================
-- CRIAÇÃO DAS TABELAS
-- ==================================================
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
    disponivel BOOLEAN DEFAULT TRUE,
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

-- ==============================================================
-- INSERÇÃO DE DADOS
-- ==============================================================
INSERT INTO Autor (nome) VALUES
('Machado de Assis'),
('Clarice Lispector'),
('Isaac Asimov'),
('George Orwell'),
('J. R. R. Tolkien'),
('Frank Herbert'),
('Neil Gaiman'),
('Terry Pratchett');
 
INSERT INTO Livro (titulo, ISBN, ano, editora) VALUES
('Dom Casmurro', '9788500000011', 1899, 'Garnier'),
('A Hora da Estrela', '9788500000028', 1977, 'Rocco'),
('Eu, Robô', '9788500000035', 1950, 'Aleph'),
('Fundação', '9788500000042', 1951, 'Aleph'),
('1984', '9788500000059', 1949, 'Companhia das Letras'),
('O Senhor dos Anéis', '9788500000066', 1954, 'HarperCollins'),
('Duna', '9788500000073', 1965, 'Aleph'),
('Belas Maldições', '9788500000080', 1990, 'Galera Record');
 
INSERT INTO Cliente (nome, matricula, endereco) VALUES
('Ana Beatriz Souza', 20240001, 'Rua das Flores, 120 - Centro'),
('Carlos Eduardo Lima', 20240002, 'Av. Brasil, 455 - Jardim América'),
('Fernanda Oliveira', 20240003, 'Rua Minas Gerais, 78 - Vila Nova'),
('João Pedro Santos', 20240004, 'Rua Sete de Setembro, 301 - Centro'),
('Mariana Costa', 20240005, 'Rua dos Ipês, 22 - Bela Vista'),
('Rafael Almeida', 20240006, NULL);
 
INSERT INTO Bibliotecario (nome, matricula) VALUES
('Helena Martins', 1001),
('Roberto Silva', 1002),
('Patrícia Gomes', 1003),
('Lucas Ferreira', 1004),
('Sônia Ribeiro', 1005),
('Tiago Nunes', 1006);		-- sem setor (útil para demonstrar LEFT JOIN no 1:1)
 
INSERT INTO Setor (nome, idBibliotecario) VALUES
('Acervo Geral', 1),
('Referência', 2),
('Infantojuvenil', 3),
('Periódicos', 4),
('Obras Raras', 5);
 
-- Categorias raiz primeiro; depois as subcategorias (relacionamento recursivo)
INSERT INTO Categoria (nome, idCategoria_pai) VALUES
('Ficção', NULL),
('Literatura Brasileira', NULL),
('Ficção Científica', 1),
('Fantasia', 1),
('Distopia', 3),	-- (subcategoria de Ficção Científica)
('Comédia', 1);
 
INSERT INTO Escreve (idAutor, idLivro) VALUES
(1, 1),		-- Machado de Assis - Dom Casmurro
(2, 2),		-- Clarice Lispector - A Hora da Estrela
(3, 3),		-- Asimov - Eu, Robô
(3, 4),		-- Asimov - Fundação
(4, 5),		-- Orwell - 1984
(5, 6),		-- Tolkien - O Senhor dos Anéis
(6, 7),		-- Herbert - Duna
(7, 8),		-- Gaiman - Belas Maldições (coautoria)
(8, 8);		-- Pratchett - Belas Maldições (coautoria)
 
INSERT INTO Categoriza (idLivro, idCategoria) VALUES
(1, 2), (2, 2), (3, 3), (4, 3), (5, 5), (5, 3), (6, 4), (7, 3), (8, 4), (8, 6);
 
INSERT INTO Exemplar (codigo_patrimonio, estado_conservacao, idLivro) VALUES
(1001, 'Ótimo', 1),
(1002, 'Bom', 1),
(1003, 'Bom', 2),
(1004, 'Regular', 3),
(1005, 'Ótimo', 4),
(1006, 'Bom', 5),
(1007, 'Ótimo', 5),
(1008, 'Desgastado', 6),
(1009, 'Bom', 7),
(1010, 'Ótimo', 8);
 
-- Empréstimos (alguns devolvidos, outros em aberto - data_devolucao NULL)
INSERT INTO Emprestimo (idBibliotecario, idCliente, idExemplar, data_emprestimo, data_devolucao) VALUES
(1, 1, 1, '2026-09-01', '2026-09-10'),
(2, 2, 3, '2026-09-05', '2026-09-30'),		-- devolvido com atraso
(1, 3, 5, '2026-10-01', '2026-10-12'),
(3, 4, 6, '2026-10-20', NULL),
(2, 1, 9, '2026-10-25', NULL),
(4, 5, 4, '2026-11-02', NULL),
(5, 2, 2, '2026-10-10', '2026-10-20'),
(1, 6, 1, '2026-10-28', NULL);

-- ===============================================================================================
-- CRIAÇÃO DE FUNCTION, PROCEDURE, TRIGGER e VIEW
-- ===============================================================================================
DELIMITER $$
CREATE FUNCTION dias_de_atraso(data_emprestimo DATE, data_devolucao DATE)
RETURNS INT
NOT DETERMINISTIC
NO SQL
BEGIN
	DECLARE prazo_dias INT DEFAULT 14;
    RETURN GREATEST(DATEDIFF(IFNULL(data_devolucao, CURDATE()), data_emprestimo) - prazo_dias, 0);
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE registrar_devolucao(
	IN emprestimoID INT,
    OUT dias_atraso INT
)
BEGIN
	DECLARE D_emprestimo DATE;
    DECLARE D_devolucao DATE;
    
    SELECT data_emprestimo, data_devolucao INTO D_emprestimo, D_devolucao
    FROM Emprestimo WHERE idEmprestimo = emprestimoID;
    
    IF D_emprestimo IS NULL THEN
		SELECT 'Empréstimo não encontrado.' AS WARNING;
	END IF;
    IF D_devolucao IS NOT NULL THEN
		SELECT 'Empréstimo já foi devolvido.' AS WARNING;
	END IF;
	
    UPDATE Emprestimo SET data_devolucao = CURDATE() WHERE idEmprestimo = emprestimoID;
    
    SET dias_atraso = dias_de_atraso(D_emprestimo, CURDATE());
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_emprestimo_ai
AFTER INSERT ON Emprestimo
FOR EACH ROW
BEGIN
    IF NEW.data_devolucao IS NULL THEN
        UPDATE Exemplar SET disponivel = FALSE WHERE idExemplar = NEW.idExemplar;
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_emprestimo_au
AFTER UPDATE ON Emprestimo
FOR EACH ROW
BEGIN
    IF OLD.data_devolucao IS NULL AND NEW.data_devolucao IS NOT NULL THEN
        UPDATE Exemplar SET disponivel = TRUE WHERE idExemplar = NEW.idExemplar;
    END IF;
END$$
DELIMITER ;

CREATE VIEW Consultar_Emprestimos AS
SELECT c.nome AS nomeCliente, c.matricula AS matriculaCliente, l.titulo AS tituloLivro, ex.estado_conservacao, b.nome AS nomeBibliotecario, b.matricula AS matriculaBibliotecario, em.data_emprestimo,
CASE WHEN em.data_devolucao IS NULL THEN 'EM ABERTO' ELSE 'DEVOLVIDO' END AS situacao,
dias_de_atraso(em.data_emprestimo, em.data_devolucao) AS dias_atraso
FROM Emprestimo em
JOIN Cliente c ON em.idCliente = c.idCliente
JOIN Exemplar ex ON em.idExemplar = ex.idExemplar
JOIN Livro l ON ex.idLivro = l.idLivro
JOIN Bibliotecario b ON em.idBibliotecario = b.idBibliotecario;

CREATE VIEW Disponibilidade_livros AS
SELECT
    l.idLivro,
    l.titulo,
    COUNT(ex.idExemplar)                                AS total_exemplares,
    COUNT(em.idEmprestimo)                              AS emprestados,
    COUNT(ex.idExemplar) - COUNT(em.idEmprestimo)       AS disponiveis
FROM Livro l
LEFT JOIN Exemplar ex   ON ex.idLivro = l.idLivro
LEFT JOIN Emprestimo em ON em.idExemplar = ex.idExemplar AND em.data_devolucao IS NULL
GROUP BY l.idLivro, l.titulo;

SELECT * FROM Consultar_Emprestimos;
SELECT * FROM Disponibilidade_livros;