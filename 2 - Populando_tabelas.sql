--INSERINDO ALUNOS E DISCIPLINAS

USE Historico_Nota
GO

INSERT INTO Aluno
VALUES ('Everton'), ('Victor'), ('Felipe'),('Leonardo')
GO


INSERT INTO Disciplina
VALUES ('Estrutura de dados', 60), ('Segurança da Informação', 50), ('Fundamentos de Rede', 80), ('Arquitetura de Computadores', 60)
GO








--inserindo aluno aprovado direto
INSERT INTO Aluno_Disciplina (Matricula, Cod_Disciplina, AV1, AV2, Semestre, Ano, Faltas, CargaHoraria)
VALUES (201, 110, 5.0, 8.0, 2, 2021, 2, 60)
GO

--inserindo aluno aprovado por nota e reprovado por falta
INSERT INTO Aluno_Disciplina (Matricula, Cod_Disciplina, AV1, AV2, Semestre, Ano, Faltas, CargaHoraria)
VALUES (202, 110, 5.0, 8.0, 2, 2021, 40, 60)
GO

--inserindo aluno Reprovado por nota
INSERT INTO Aluno_Disciplina (Matricula, Cod_Disciplina, AV1, AV2, Semestre, Ano, Faltas, CargaHoraria)
VALUES (203, 110, 1.0, 2.0, 2, 2021, 2, 60)
GO

--inserindo aluno Reprovado por falta com AVS
INSERT INTO Aluno_Disciplina (Matricula, Cod_Disciplina, AV1, AV2, Semestre, Ano, Faltas, CargaHoraria)
VALUES (204, 110, 3.0, 6.0, 2, 2021, 40, 60)
GO




-- linhas prontas pra facilitar a vida na hora do teste

Delete Aluno_Disciplina
Delete Aluno
Delete Disciplina

Select Aluno.Matricula, Aluno.Nome, Disciplina.Nome_Disciplina, AV1, AV2, AVS, Media, Faltas, Disciplina.CargaHoraria, Situacao
FROM Aluno JOIN Aluno_Disciplina ON Aluno.Matricula = Aluno_Disciplina.Matricula
			JOIN Disciplina ON Disciplina.Cod_Disciplina = Aluno_Disciplina.Cod_Disciplina

Select *
FROM Aluno_Disciplina

Select *
FROM Aluno

Select *
FROM Disciplina