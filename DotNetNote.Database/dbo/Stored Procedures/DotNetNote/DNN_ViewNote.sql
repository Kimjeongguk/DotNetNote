CREATE PROCEDURE [dbo].[DNN_ViewNote]
	@Id int
AS
	Update Notes set ReadCount = ReadCount +1 where Id = @Id

	Select * from Notes where Id = @Id
Go