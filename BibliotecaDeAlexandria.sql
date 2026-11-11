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
    
    -- Em caso de erro, apenas avisa e NÃO altera nada (dias_atraso volta NULL).
    -- O IF / ELSEIF / ELSE garante que o UPDATE só roda quando o empréstimo existe e está em aberto.
    IF D_emprestimo IS NULL THEN
		SELECT 'Empréstimo não encontrado.' AS WARNING;
        SET dias_atraso = NULL;
	ELSEIF D_devolucao IS NOT NULL THEN
		SELECT 'Empréstimo já foi devolvido.' AS WARNING;
        SET dias_atraso = NULL;
	ELSE
		UPDATE Emprestimo SET data_devolucao = CURDATE() WHERE idEmprestimo = emprestimoID;
		SET dias_atraso = dias_de_atraso(D_emprestimo, CURDATE());
	END IF;
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

-- ===============================================================================================
-- COMANDOS DE MANIPULAÇÃO DE DADOS (DML): UPDATE, INSERT e DELETE
-- (ficam depois dos triggers para que as alterações em Emprestimo já disparem a atualização do Exemplar)
-- ===============================================================================================

-- [DML 1] UPDATE - sincronizar a disponibilidade dos exemplares.
-- Motivo: os empréstimos da carga inicial foram inseridos ANTES de os triggers existirem, então os
-- exemplares emprestados continuaram com disponivel = TRUE. Este UPDATE corrige o estado atual;
-- daqui em diante os triggers mantêm a coluna sozinhos.
UPDATE Exemplar
SET disponivel = FALSE
WHERE idExemplar IN (SELECT idExemplar FROM Emprestimo WHERE data_devolucao IS NULL);

-- [DML 2] UPDATE - completar o cadastro de um cliente.
-- Motivo: o cliente Rafael Almeida foi cadastrado sem endereço; ao informar o dado no balcão,
-- o registro existente é atualizado (não se cria outro cliente).
UPDATE Cliente
SET endereco = 'Rua XV de Novembro, 950 - Centro'
WHERE matricula = 20240006;

-- [DML 3] INSERT - registrar um novo empréstimo.
-- Motivo: é a operação do dia a dia da biblioteca. O trigger trg_emprestimo_ai marca o exemplar 7 como indisponível.
INSERT INTO Emprestimo (idBibliotecario, idCliente, idExemplar, data_emprestimo, data_devolucao)
VALUES (6, 3, 7, '2026-11-05', NULL);

-- [DML 4] UPDATE - registrar a devolução de um empréstimo.
-- Motivo: a devolução não cria um registro novo, ela completa o empréstimo existente com a data de devolução.
-- O trigger trg_emprestimo_au devolve o exemplar ao acervo (disponivel = TRUE).
-- (A procedure registrar_devolucao faz o mesmo usando a data de hoje.)
UPDATE Emprestimo
SET data_devolucao = '2026-11-10'
WHERE idEmprestimo = 6;

-- [DML 5] UPDATE - atualizar o estado de conservação após a devolução.
-- Motivo: na conferência da devolução o bibliotecário constatou desgaste no exemplar 1004 (Eu, Robô).
UPDATE Exemplar
SET estado_conservacao = 'Desgastado'
WHERE codigo_patrimonio = 1004;

-- [DML 6] INSERT + DELETE - remover um cadastro feito por engano.
-- Motivo: um cliente foi cadastrado em duplicidade (mesma pessoa, matrícula digitada errada).
-- Como ele não tem empréstimos, pode ser apagado sem violar o RESTRICT da tabela Emprestimo.
INSERT INTO Cliente (nome, matricula, endereco) VALUES ('Ana Beatriz Souza', 20249999, 'Rua das Flores, 120 - Centro');
DELETE FROM Cliente
WHERE matricula = 20249999
  AND idCliente NOT IN (SELECT idCliente FROM Emprestimo);

-- [DML 7] INSERT + DELETE - corrigir uma classificação errada.
-- Motivo: "Duna" foi classificado por engano também como Fantasia. Apaga-se apenas o vínculo em Categoriza;
-- o livro e a categoria continuam existindo.
INSERT INTO Categoriza (idLivro, idCategoria) VALUES (7, 4);
DELETE FROM Categoriza
WHERE idLivro = 7 AND idCategoria = 4;

-- ===============================================================================================
-- IMPLEMENTAÇÕES EXTRAS: CHECK, ÍNDICES e TRANSAÇÃO
-- ===============================================================================================

-- [EXTRA 1] CHECK - regras de integridade validadas pelo próprio banco (MySQL 8.0.16+ / MariaDB 10.2+).
-- A devolução não pode ser anterior ao empréstimo, e o ano de publicação precisa ser positivo.
ALTER TABLE Emprestimo
    ADD CONSTRAINT chk_emprestimo_datas CHECK (data_devolucao IS NULL OR data_devolucao >= data_emprestimo);
ALTER TABLE Livro
    ADD CONSTRAINT chk_livro_ano CHECK (ano IS NULL OR ano > 0);
-- Teste (descomente para ver o banco recusar a alteração por violar chk_emprestimo_datas):
-- UPDATE Emprestimo SET data_devolucao = '2000-01-01' WHERE idEmprestimo = 1;

-- [EXTRA 2] ÍNDICES - aceleram as buscas mais comuns no atendimento (por título do livro e nome do cliente).
-- Colunas PRIMARY KEY, UNIQUE e FOREIGN KEY já recebem índice automaticamente.
CREATE INDEX idx_livro_titulo ON Livro (titulo);
CREATE INDEX idx_cliente_nome ON Cliente (nome);

-- [EXTRA 3] TRANSAÇÃO - agrupa comandos para que sejam gravados todos juntos ou nenhum.
-- Exemplo: o atendente começa a registrar um empréstimo, percebe que escolheu o cliente errado e desfaz.
-- O ROLLBACK desfaz também o UPDATE feito pelo trigger, então o exemplar 10 continua disponível.
START TRANSACTION;
    INSERT INTO Emprestimo (idBibliotecario, idCliente, idExemplar, data_emprestimo, data_devolucao)
    VALUES (2, 4, 10, '2026-11-11', NULL);
    SELECT idExemplar, disponivel FROM Exemplar WHERE idExemplar = 10;    -- 0 (dentro da transação)
ROLLBACK;
SELECT idExemplar, disponivel FROM Exemplar WHERE idExemplar = 10;        -- 1 (nada foi gravado)

-- Mesmo empréstimo, agora com o cliente correto, confirmado com COMMIT.
START TRANSACTION;
    INSERT INTO Emprestimo (idBibliotecario, idCliente, idExemplar, data_emprestimo, data_devolucao)
    VALUES (2, 5, 10, '2026-11-11', NULL);
COMMIT;

-- ===============================================================================================
-- USUÁRIOS E ROLE (FUNÇÃO)
-- Os dois usuários recebem as permissões pela ROLE "atendente", e não diretamente: se a regra de acesso mudar,
-- basta alterar a role e todos os usuários ligados a ela são atualizados.
-- (Usuários e roles ficam fora do banco, então o DROP DATABASE do início não os remove; por isso os DROP abaixo.)
-- ===============================================================================================
DROP USER IF EXISTS 'helena'@'localhost', 'roberto'@'localhost';
DROP ROLE IF EXISTS 'atendente';

CREATE ROLE 'atendente';

-- Pode consultar tudo, registrar empréstimos/devoluções e cadastrar/atualizar clientes,
-- mas não pode apagar dados nem alterar a estrutura das tabelas.
GRANT SELECT ON BibliotecaAlexandria.* TO 'atendente';
GRANT INSERT, UPDATE ON BibliotecaAlexandria.Emprestimo TO 'atendente';
GRANT INSERT, UPDATE ON BibliotecaAlexandria.Cliente TO 'atendente';
GRANT EXECUTE ON PROCEDURE BibliotecaAlexandria.registrar_devolucao TO 'atendente';

CREATE USER 'helena'@'localhost' IDENTIFIED BY 'Helena@2026';
CREATE USER 'roberto'@'localhost' IDENTIFIED BY 'Roberto@2026';

-- Relaciona os dois usuários à role e a torna ativa automaticamente ao fazer login.
GRANT 'atendente' TO 'helena'@'localhost', 'roberto'@'localhost';
SET DEFAULT ROLE 'atendente' TO 'helena'@'localhost', 'roberto'@'localhost';

SHOW GRANTS FOR 'atendente';
SHOW GRANTS FOR 'helena'@'localhost';

-- ===============================================================================================
-- BUSCAS COM JOIN (1:1, 1:N e N:M)
-- ===============================================================================================

-- [JOIN 1:1] Bibliotecario - Setor
-- Cada bibliotecário com seu setor e quantos empréstimos já atendeu.
-- LEFT JOIN em Setor para mostrar também o bibliotecário sem setor (Tiago Nunes).
SELECT b.nome                        AS bibliotecario,
       b.matricula,
       IFNULL(s.nome, 'Sem setor')   AS setor,
       COUNT(em.idEmprestimo)        AS emprestimos_atendidos
FROM Bibliotecario b
LEFT JOIN Setor s       ON s.idBibliotecario = b.idBibliotecario
LEFT JOIN Emprestimo em ON em.idBibliotecario = b.idBibliotecario
GROUP BY b.idBibliotecario, b.nome, b.matricula, s.nome
ORDER BY emprestimos_atendidos DESC, b.nome;

-- [JOIN 1:N] Livro - Exemplar
-- Para cada livro: quantos exemplares tem, quantos estão disponíveis e os códigos de patrimônio.
SELECT l.titulo,
       l.editora,
       COUNT(ex.idExemplar)                                       AS total_exemplares,
       SUM(ex.disponivel)                                         AS disponiveis,
       GROUP_CONCAT(ex.codigo_patrimonio ORDER BY ex.codigo_patrimonio SEPARATOR ', ') AS patrimonios
FROM Livro l
INNER JOIN Exemplar ex ON ex.idLivro = l.idLivro
GROUP BY l.idLivro, l.titulo, l.editora
ORDER BY l.titulo;

-- [JOIN 1:N] Cliente - Emprestimo (+ Exemplar e Livro)
-- Histórico de cada cliente: quantos empréstimos fez, quantos estão em aberto e os títulos retirados.
SELECT c.nome                                                       AS cliente,
       COUNT(em.idEmprestimo)                                       AS total_emprestimos,
       SUM(em.data_devolucao IS NULL)                               AS em_aberto,
       GROUP_CONCAT(DISTINCT l.titulo ORDER BY l.titulo SEPARATOR ' | ') AS livros
FROM Cliente c
INNER JOIN Emprestimo em ON em.idCliente  = c.idCliente
INNER JOIN Exemplar ex   ON ex.idExemplar = em.idExemplar
INNER JOIN Livro l       ON l.idLivro     = ex.idLivro
GROUP BY c.idCliente, c.nome
ORDER BY total_emprestimos DESC, c.nome;

-- [JOIN N:M] Livro - Autor (via Escreve) e Livro - Categoria (via Categoriza)
-- Ficha de cada livro com todos os autores e categorias. A categoria pai vem de um auto-relacionamento
-- (Categoria JOIN Categoria). DISTINCT evita repetições causadas pelos dois N:M na mesma consulta.
SELECT l.titulo,
       GROUP_CONCAT(DISTINCT a.nome ORDER BY a.nome SEPARATOR ' e ') AS autores,
       GROUP_CONCAT(DISTINCT CONCAT(IFNULL(CONCAT(pai.nome, ' > '), ''), cat.nome)
                    ORDER BY cat.nome SEPARATOR ' | ')                AS categorias
FROM Livro l
INNER JOIN Escreve e     ON e.idLivro       = l.idLivro
INNER JOIN Autor a       ON a.idAutor       = e.idAutor
INNER JOIN Categoriza cz ON cz.idLivro      = l.idLivro
INNER JOIN Categoria cat ON cat.idCategoria = cz.idCategoria
LEFT JOIN  Categoria pai ON pai.idCategoria = cat.idCategoria_pai
GROUP BY l.idLivro, l.titulo
ORDER BY l.titulo;

-- [JOIN N:M] Autor - Livro (via Escreve) + Exemplar + Emprestimo
-- Autores mais procurados: quantos livros cada um tem no acervo e quantas vezes suas obras foram emprestadas.
SELECT a.nome                          AS autor,
       COUNT(DISTINCT e.idLivro)       AS livros_no_acervo,
       COUNT(DISTINCT em.idEmprestimo) AS vezes_emprestado
FROM Autor a
INNER JOIN Escreve e     ON e.idAutor     = a.idAutor
INNER JOIN Exemplar ex   ON ex.idLivro    = e.idLivro
LEFT JOIN  Emprestimo em ON em.idExemplar = ex.idExemplar
GROUP BY a.idAutor, a.nome
ORDER BY vezes_emprestado DESC, a.nome;

-- ===============================================================================================
-- CONSULTAS DE VERIFICAÇÃO
-- ===============================================================================================
SELECT idExemplar, codigo_patrimonio, estado_conservacao, disponivel FROM Exemplar;
SELECT * FROM Consultar_Emprestimos;
SELECT * FROM Disponibilidade_livros;