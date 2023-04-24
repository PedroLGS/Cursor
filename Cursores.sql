CREATE DATABASE ex_cursor
GO
USE ex_cursor

CREATE TABLE curso (
codigo		INT				NOT NULL,
nome		VARCHAR(100)	NOT NULL,
duracao		INT				NOT NULL
PRIMARY KEY(codigo)
)

CREATE TABLE disciplinas (
codigo			VARCHAR(06)	    NOT NULL,
nome			VARCHAR(100)	NOT NULL,
carga_horaria	INT				NOT NULL
PRIMARY KEY(codigo)
)

CREATE TABLE disciplina_curso (
codigo_disciplina	VARCHAR(06)		NOT NULL,
codigo_curso		INT				NOT NULL
PRIMARY KEY(codigo_disciplina, codigo_curso)
FOREIGN KEY (codigo_disciplina) REFERENCES disciplinas(codigo),
FOREIGN KEY (codigo_curso) REFERENCES curso(codigo)
)

INSERT INTO curso VALUES 
(48, 'Análise e Desenvolvimento de Sistemas', 2880),
(51, 'Logistica', 2880),
(67, 'Polímeros', 2880),
(73, 'Comércio Exterior', 2600),
(94, 'Gestão Empresarial', 2600)SELECT * FROM cursoINSERT INTO disciplinas VALUES('ALG001', 'Algoritmos', 80),
('ADM001', 'Administração', 80),
('LHW010', 'Laboratório de Hardware', 40),
('LPO001', 'Pesquisa Operacional', 80),
('FIS003', 'Física I', 80),
('FIS007', 'Físico Química', 80),
('CMX001', 'Comércio Exterior', 80),
('MKT002', 'Fundamentos de Marketing', 80),
('INF001', 'Informática', 40),
('ASI001', 'Sistemas de Informação', 80)SELECT * FROM disciplinas INSERT INTO disciplina_curso VALUES('ALG001', 48),
('ADM001', 48),
('ADM001', 51),
('ADM001', 73),
('ADM001', 94),
('LHW010', 48),
('LPO001', 51),
('FIS003', 67),
('FIS007', 67),
('CMX001', 51),
('CMX001', 73),
('MKT002', 51),
('MKT002', 94),
('INF001', 51),
('INF001', 73),
('ASI001', 48),
('ASI001', 94)
SELECT * FROM disciplina_curso

CREATE FUNCTION fn_curs_disc (@codigo_curso INT)
RETURNS @tabela TABLE
(
codigo_disciplina			VARCHAR(06),
nome_disciplina				VARCHAR(100),
carga_horaria_disciplina	INT,
nome_curso					VARCHAR(100)
)
AS
BEGIN
		DECLARE @codigo_disciplina			VARCHAR(06),
				@nome_disciplina			VARCHAR(100),
				@carga_horaria_disciplina	INT,
				@nome_curso					VARCHAR(100)
		DECLARE c CURSOR FOR SELECT dc.codigo_disciplina, d.nome, d.carga_horaria, c.nome FROM disciplina_curso dc
					INNER JOIN disciplinas d
					ON d.codigo = dc.codigo_disciplina
					INNER JOIN curso c
					ON dc.codigo_curso = c.codigo
					WHERE c.codigo = @codigo_curso
		OPEN c
		FETCH NEXT FROM c INTO @codigo_disciplina, @nome_disciplina, @carga_horaria_disciplina, @nome_curso
		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO @tabela VALUES (@codigo_disciplina, @nome_disciplina, @carga_horaria_disciplina, @nome_curso)
            FETCH NEXT FROM c INTO @codigo_disciplina, @nome_disciplina, @carga_horaria_disciplina, @nome_curso			
		END
		CLOSE c
	    DEALLOCATE c
	    RETURN
END
							
SELECT DISTINCT * FROM fn_curs_disc(48)