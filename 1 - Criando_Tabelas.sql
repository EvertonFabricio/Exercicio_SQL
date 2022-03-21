
/*CRIANDO BANCO DE DADOS E TABELAS*/

CREATE DATABASE Historico_Nota
GO

USE Historico_Nota
GO

CREATE TABLE Aluno(
Matricula int identity(201,1) not null,
Nome varchar(50) not null,
CONSTRAINT pk_Aluno PRIMARY KEY (Matricula)
)
GO

CREATE TABLE Disciplina(
Cod_Disciplina int identity(110,1) not null,
Nome_Disciplina varchar(50) not null,
CargaHoraria int not null,
CONSTRAINT pk_Disciplina PRIMARY KEY (Cod_Disciplina)
)
GO

CREATE TABLE Aluno_Disciplina(
Matricula int not null,
Cod_Disciplina int not null,
AV1 decimal(4,1) null,
AV2 decimal(4,1) null,
AVS decimal(4,1) null,
Media decimal(4,1) null,
Faltas int null DEFAULT 0,
Situacao varchar(25) null DEFAULT 'Matriculado',
CargaHoraria int not null,
Semestre int not null,
Ano int not null,
CONSTRAINT pk_AlunoDisciplina PRIMARY KEY	(Matricula, Cod_Disciplina, Semestre, Ano),
CONSTRAINT fk_AlunoDisciplina1 FOREIGN KEY (Matricula) REFERENCES Aluno (Matricula),
CONSTRAINT fk_AlunoDisciplina2 FOREIGN KEY (Cod_Disciplina) REFERENCES Disciplina (Cod_Disciplina)
)
GO


