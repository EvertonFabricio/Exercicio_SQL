USE Historico_Nota
GO

CREATE PROCEDURE BuscaDisciplina
	@Disciplina varchar(50)
AS
SET @Disciplina = '%' + @Disciplina + '%'

SELECT Aluno.Nome, Disciplina.Nome_Disciplina, AV1, AV2, AVS, Media, Faltas, Situacao, Ano, Semestre
FROM Aluno JOIN Aluno_Disciplina ON Aluno.Matricula = Aluno_Disciplina.Matricula
		   JOIN Disciplina ON Disciplina.Cod_Disciplina = Aluno_Disciplina.Cod_Disciplina
WHERE Disciplina.Nome_Disciplina LIKE @Disciplina AND Aluno_Disciplina.Ano = 2021
GO

	exec BuscaDisciplina --informa o curso que ta procurando.
	GO

CREATE PROCEDURE BuscaAluno
	@Aluno varchar(50)
AS
SET @Aluno = '%' + @Aluno + '%'

SELECT Aluno.Nome, Disciplina.Nome_Disciplina, AV1, AV2, AVS, Media, Faltas, Situacao, Ano, Semestre
FROM Aluno JOIN Aluno_Disciplina ON Aluno.Matricula = Aluno_Disciplina.Matricula
		   JOIN Disciplina ON Disciplina.Cod_Disciplina = Aluno_Disciplina.Cod_Disciplina
WHERE Aluno.Nome LIKE @Aluno AND Aluno_Disciplina.Ano = 2021 AND Aluno_Disciplina.Semestre = 2
GO

	exec BuscaAluno --informa o aluno que ta buscando.
	GO


CREATE PROCEDURE BuscaReprovado
AS
SELECT Aluno.Nome, Disciplina.Nome_Disciplina, AV1, AV2, AVS, Media, Ano, Semestre
FROM Aluno JOIN Aluno_Disciplina ON Aluno.Matricula = Aluno_Disciplina.Matricula
		   JOIN Disciplina ON Disciplina.Cod_Disciplina = Aluno_Disciplina.Cod_Disciplina
WHERE Aluno_Disciplina.Situacao = 'Reprovado por nota' AND Aluno_Disciplina.Ano = 2021 AND Aluno_Disciplina.Semestre = 2
GO

	exec BuscaReprovado
	GO



CREATE PROCEDURE Incluir_Aluno_Disciplina
	@Matricula int,
	@Cod_Disciplina int ,
	@Semestre int,
	@Ano int
AS
BEGIN
	DECLARE @CargaHoraria int;

	SELECT  @CargaHoraria = Disciplina.CargaHoraria from Disciplina WHERE @Cod_Disciplina = Disciplina.Cod_Disciplina;

	INSERT INTO Aluno_Disciplina (Matricula, Cod_Disciplina, CargaHoraria, Ano, Semestre)
	VALUES (@Matricula, @Cod_Disciplina, @CargaHoraria, @Ano, @Semestre)

	Select Aluno.Matricula, Aluno.Nome, Disciplina.Nome_Disciplina, AV1, AV2, AVS, Media, Faltas, Disciplina.CargaHoraria, Situacao
	FROM Aluno JOIN Aluno_Disciplina ON Aluno.Matricula = Aluno_Disciplina.Matricula
			JOIN Disciplina ON Disciplina.Cod_Disciplina = Aluno_Disciplina.Cod_Disciplina 
			WHERE Aluno.Matricula = @Matricula AND Disciplina.Cod_Disciplina = @Cod_Disciplina

			   
END
GO

	exec Incluir_Aluno_Disciplina 201,110,2,2021 
	exec Incluir_Aluno_Disciplina 202,111,2,2021 
	exec Incluir_Aluno_Disciplina 203,112,2,2021 
	exec Incluir_Aluno_Disciplina 204,113,2,2021 --Informar cod aluno(201+), cod disciplina(110+), Semestre e ano
	GO



CREATE PROCEDURE Informa_AV1
@Matricula int,
@Cod_Disciplina int,
@AV1 decimal

AS
BEGIN
DECLARE @nota1 decimal(4,1),
		@Situacao varchar(50)
SELECT @nota1 = Aluno_Disciplina.AV1, @Situacao = Aluno_Disciplina.Situacao from Aluno_Disciplina where Matricula = @Matricula AND Cod_Disciplina = @Cod_Disciplina
 
 
	IF (@Situacao = 'Matriculado' OR @Situacao = 'Cursando')
	BEGIN
		IF (@nota1 >= 0)
		BEGIN
			SELECT 'Nota da avaliação 1 já foi informada para esse aluno nesse curso'
		END

		ELSE
			BEGIN
			UPDATE Aluno_Disciplina
				SET AV1 = @AV1, Situacao = 'Cursando'
				WHERE Matricula = @Matricula AND Cod_Disciplina = @Cod_Disciplina AND (Aluno_Disciplina.Situacao = 'Matriculado' OR Aluno_Disciplina.Situacao = 'Cursando')

				Select Aluno.Matricula, Aluno.Nome, Disciplina.Cod_Disciplina, Disciplina.Nome_Disciplina, AV1, AV2, AVS, Media, Faltas, Disciplina.CargaHoraria, Situacao 
				FROM Aluno JOIN Aluno_Disciplina ON Aluno.Matricula = Aluno_Disciplina.Matricula
						JOIN Disciplina ON Disciplina.Cod_Disciplina = Aluno_Disciplina.Cod_Disciplina
				WHERE Aluno.Matricula = @Matricula AND Disciplina.Cod_Disciplina = @Cod_Disciplina 
			END
	END
		ELSE
		BEGIN
			SELECT 'Aluno ja conclui ou não está matriculado na Disciplina informada.'
		END
END
GO

exec Informa_AV1 203,112,2 --Informar cod aluno(201+), cod disciplina(110+), nota av1
GO


CREATE PROCEDURE Informa_AV2_Faltas
@Matricula int,
@Cod_Disciplina int,
@AV2 decimal,
@Faltas int
AS
BEGIN
DECLARE @nota2 decimal(4,1),
		@Situacao varchar(50),
		@Media decimal(4,1),
		@AV1 decimal(4,1),
		
		@CargaHoraria int
SELECT @nota2 = Aluno_Disciplina.AV2, @Situacao = Aluno_Disciplina.Situacao, @AV1 = Aluno_Disciplina.AV1,
	   @CargaHoraria = Aluno_Disciplina.CargaHoraria
	   FROM Aluno_Disciplina
	   WHERE Matricula = @Matricula AND Cod_Disciplina = @Cod_Disciplina
 
	IF (@AV1 >= 0)
	BEGIN
	
		IF (@Situacao = 'Matriculado' OR @Situacao = 'Cursando')
		BEGIN
				IF (@nota2 >= 0)
				BEGIN
					SELECT 'Nota da avaliação 2 já foi informada para esse aluno nesse curso'
				END

				ELSE
					BEGIN
					UPDATE Aluno_Disciplina
						SET AV2 = @AV2, Faltas = @Faltas
						WHERE Matricula = @Matricula AND Cod_Disciplina = @Cod_Disciplina AND (Aluno_Disciplina.Situacao = 'Matriculado' OR Aluno_Disciplina.Situacao = 'Cursando')									
					END
		END
			ELSE
			BEGIN
				SELECT 'Aluno ja concluiu a Disciplina informada.'
			END

		
		SET @Media = (@AV1 + @AV2) / 2
		UPDATE Aluno_Disciplina
		SET Media = @Media
		WHERE Matricula = @Matricula AND Cod_Disciplina = @Cod_Disciplina


			IF (@Media < 5)
			BEGIN
				UPDATE aluno_disciplina
				SET Situacao = 'Aguardando AVS'
				WHERE Matricula = @Matricula AND Cod_Disciplina = @Cod_Disciplina
			END
			ELSE IF (@Media >= 5 AND @Faltas < @CargaHoraria/4)
			BEGIN
				UPDATE Aluno_Disciplina 
				SET situacao = 'Aprovado'
				WHERE Matricula = @Matricula AND Cod_Disciplina = @Cod_Disciplina
			END
			ELSE
			BEGIN
				UPDATE Aluno_Disciplina 
				SET situacao = 'Reprovado por Falta'
				WHERE Matricula = @Matricula AND Cod_Disciplina = @Cod_Disciplina
			END

		SELECT Aluno.Matricula, Aluno.Nome, Disciplina.Cod_Disciplina, Disciplina.Nome_Disciplina, AV1, AV2, AVS, Media, Faltas, Disciplina.CargaHoraria, Situacao 
					FROM Aluno JOIN Aluno_Disciplina ON Aluno.Matricula = Aluno_Disciplina.Matricula
							JOIN Disciplina ON Disciplina.Cod_Disciplina = Aluno_Disciplina.Cod_Disciplina
					WHERE Aluno.Matricula = @Matricula AND Disciplina.Cod_Disciplina = @Cod_Disciplina 
	END
	ELSE
	BEGIN
		SELECT 'Aluno não matriculado nessa diciplina, ou nota da AV1 ainda não foi informada.'
	END

END
GO

exec Informa_AV2_Faltas 203, 112, 5, 40  --Informar cod aluno(201+), cod disciplina(110+), nota av1, Faltas
GO

CREATE PROCEDURE Informa_AVS
@Matricula int,
@Cod_Disciplina int,
@AVS decimal

AS
BEGIN
DECLARE @notaSub decimal(4,1),
		@Situacao varchar(50),
		@Media decimal(4,1),
		@AV1 decimal(4,1),
		@AV2 decimal(4,1),
		@NovaMedia decimal(4,1),
		@Faltas int,
		@CargaHoraria int

SELECT @notaSub = Aluno_Disciplina.AVS, @Situacao = Aluno_Disciplina.Situacao, @AV1 = Aluno_Disciplina.AV1,
	   @AV2 = Aluno_Disciplina.AV2, @Media = Aluno_Disciplina.Media, @Faltas = Aluno_Disciplina.Faltas,
	   @CargaHoraria = Aluno_Disciplina.CargaHoraria
FROM Aluno_Disciplina 
WHERE Matricula = @Matricula AND Cod_Disciplina = @Cod_Disciplina
 
		
		IF (@Situacao = 'Aguardando AVS')
		BEGIN
				IF (@notaSub >= 0)
				BEGIN
					SELECT 'Nota da avaliação Substitutiva já foi informada para esse aluno nesse curso'
				END

				ELSE
					BEGIN
					UPDATE Aluno_Disciplina
						SET AVS = @AVS
						WHERE Matricula = @Matricula AND Cod_Disciplina = @Cod_Disciplina								
					END
		END
		
	IF (@AV1 <= @AV2 AND @AV1 < @AVS)
	BEGIN
		SET @NovaMedia = (@AVS + @AV2) / 2
		UPDATE Aluno_Disciplina
		SET Media = @NovaMedia
		WHERE Matricula = @Matricula AND Cod_Disciplina = @Cod_Disciplina
	END
		ELSE IF (@AV2 <= @AV1 AND @AV2 < @AVS)
			BEGIN
				SET @NovaMedia = (@AV1 + @AVS) / 2
				UPDATE Aluno_Disciplina
				SET Media = @NovaMedia
				WHERE Matricula = @Matricula AND Cod_Disciplina = @Cod_Disciplina
			END
				ELSE
				BEGIN
					SET @NovaMedia = @Media
				END

	IF (@NovaMedia < 5) 
	BEGIN
		UPDATE Aluno_Disciplina 
		SET situacao = 'Reprovado por Nota'
		WHERE Matricula = @Matricula AND Cod_Disciplina = @Cod_Disciplina
	END
	ELSE IF (@NovaMedia >= 5 AND @Faltas < @CargaHoraria/4)
		BEGIN
			UPDATE Aluno_Disciplina 
			SET situacao = 'Aprovado'
			WHERE Matricula = @Matricula AND Cod_Disciplina = @Cod_Disciplina
		END
			ELSE
				BEGIN
					UPDATE Aluno_Disciplina 
					SET situacao = 'Reprovado por Falta'
					WHERE Matricula = @Matricula AND Cod_Disciplina = @Cod_Disciplina
				END





		SELECT Aluno.Matricula, Aluno.Nome, Disciplina.Cod_Disciplina, Disciplina.Nome_Disciplina, AV1, AV2, AVS, Media, Faltas, Disciplina.CargaHoraria, Situacao 
					FROM Aluno JOIN Aluno_Disciplina ON Aluno.Matricula = Aluno_Disciplina.Matricula
							JOIN Disciplina ON Disciplina.Cod_Disciplina = Aluno_Disciplina.Cod_Disciplina
					WHERE Aluno.Matricula = @Matricula AND Disciplina.Cod_Disciplina = @Cod_Disciplina 

	
END
GO


exec Informa_AVS 203, 112, 6
GO


delete Aluno_Disciplina







--Mostrar todos os alunos matriculados nos cursos.
Select Aluno.Matricula, Aluno.Nome, Disciplina.Cod_Disciplina, Disciplina.Nome_Disciplina, AV1, AV2, AVS, Media, Faltas, Disciplina.CargaHoraria, Situacao
	FROM Aluno JOIN Aluno_Disciplina ON Aluno.Matricula = Aluno_Disciplina.Matricula
			JOIN Disciplina ON Disciplina.Cod_Disciplina = Aluno_Disciplina.Cod_Disciplina 