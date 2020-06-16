CREATE PROCEDURE [dbo].[DNN_ReplyNote]
	@Name nvarchar(25),
	@Email nvarchar(100),
	@Title nvarchar(150),
	@PostIp nvarchar(15),
	@Content ntext,
	@Password nvarchar(20),
	@Encoding nvarchar(10),
	@Homepage nvarchar(100),
	@ParentNum int,
	@FileName nvarchar(255),
	@FileSize int
AS
	Declare @MaxRefOrder int
	Declare @MaxRefAnswerNum int
	Declare @ParentRef int
	Declare @ParentStep int
	Declare @ParentRefOrder int

	Update Notes set AnswerNum = AnswerNum +1 where Id = @ParentNum

	select @MaxRefOrder = RefOrder, @MaxRefAnswerNum = AnswerNum from Notes
	where ParentNum = @ParentNum and
	RefOrder = (select Max(RefOrder) from Notes where ParentNum = @ParentNum)

	If @MaxRefOrder Is null
	Begin
		select @MaxRefOrder = RefOrder from notes where Id = @ParentNum
		set @MaxRefAnswerNum =0
	End

	select
		@ParentRef = Ref, @ParentStep = Step
	from Notes where Id = @ParentNum

	update Notes set RefOrder = RefOrder +1
	where Ref = @ParentRef and RefOrder > (@MaxRefOrder + @MaxRefAnswerNum)

	Insert Notes(
		Name, Email, Title, PostIp, Content, Password, Encoding, Homepage, Ref, Step, RefOrder, ParentNum, FileName, FileSize
	)
	values(
		@Name, @Email, @Title, @PostIp, @Content, @Password, @Encoding, @Homepage, @ParentRef, @ParentStep + 1,
		@MaxRefOrder +@MaxRefAnswerNum + 1, @ParentNum, @FileName, @FileSize
	)
Go
