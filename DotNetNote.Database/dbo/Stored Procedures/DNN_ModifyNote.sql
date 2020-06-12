CREATE PROCEDURE [dbo].[DNN_ModifyNote]
	@Name nvarchar(25),
	@Email nvarchar(100),
	@Title nvarchar(150),
	@ModifyIp nvarchar(15),
	@Content ntext,
	@Password nvarchar(30),
	@Encoding nvarchar(10),
	@Homepage nvarchar(100),
	@FileName nvarchar(255),
	@FileSize int,
	@Id int
	
AS
	declare @cnt int

	select @cnt = Count(*) from Notes
	where Id = @Id and Password = @Password

	If @cnt > 0
	Begin
		update Notes
		set
			Name= @Name, Email = @Email, Title = @Title,
			ModifyIp = @ModifyIp, ModifyDate = GetDate(),
			Content = @Content, Encoding = @Encoding,
			Homepage=@Homepage, FileName=@FileName, FileSize=@FileSize
		where Id = @Id

		select '1'
	End
	Else
		select '0'
Go
