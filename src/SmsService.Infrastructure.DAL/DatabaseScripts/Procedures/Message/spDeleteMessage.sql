USE [SMSService]
GO

IF OBJECT_ID('msg.spDeleteMessage') IS NOT NULL
	DROP PROCEDURE msg.spDeleteMessage
GO

CREATE PROCEDURE msg.spDeleteMessage
	@AIDS VARCHAR(MAX) -- []
WITH ENCRYPTION 
AS
BEGIN
	SET NOCOUNT, XACT_ABORT ON;

	DECLARE @IDS VARCHAR(MAX) = @AIDS
		  , @Result INT = 0

	DECLARE @Items TABLE(ID UNIQUEIDENTIFIER)

	INSERT INTO @Items
	SELECT [Value]
	FROM OPENJSON(@IDS)

	BEGIN TRY
		BEGIN TRAN
			DELETE FROM msg.[Message]
			WHERE EXISTS(SELECT 1 FROM @Items i WHERE i.ID = msg.[Message].ID)

			SET @Result = @@ROWCOUNT
		COMMIT

	END TRY
	BEGIN CATCH
		;THROW
	END CATCH

	RETURN @Result 
END