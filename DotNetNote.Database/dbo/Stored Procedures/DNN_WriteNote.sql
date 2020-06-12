CREATE PROCEDURE [dbo].[DNN_WriteNote]
	@Name nvarchar(25),
	@Email nvarchar(100),
	@Title nvarchar(150),
	@PostIp nvarchar(15),
	@Content ntext,
	@Password nvarchar(20),
	@Encoding nvarchar(10),
	@Homepage nvarchar(100),
	@FileName nvarchar(255),
	@FileSize int
AS
	Declare @MaxRef int
	select @MaxRef = Max(Ref) from Notes
	If @MaxRef is null
		set @MaxRef = 1
	Else 
		set @MaxRef = @MaxRef +1

	Insert Notes(
		Name, Email, Title, PostIp, Content, Password, Encoding, Homepage, Ref, FileName, FileSize
	)
	Values(
		@Name, @Email, @Title, @PostIp, @Content, @Password, @Encoding, @Homepage, @MaxRef, @FileName, @FileSize
	)
Go