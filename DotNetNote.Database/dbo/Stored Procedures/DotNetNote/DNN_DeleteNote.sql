CREATE PROCEDURE [dbo].[DNN_DeleteNote]
	@Id int,
	@Password nvarchar(30)
As
	Declare @cnt int
	select @cnt = Count(*) from Notes
	where Id = @Id and Password = @Password

	If @cnt = 0
	Begin 
		Return 0
	End

	Declare @AnswerNum Int
	Declare @RefOrder int
	Declare @Ref int
	Declare @ParentNum int

	select
		@AnswerNum = AnswerNum,	@RefOrder = RefOrder,	@Ref = Ref,	@ParentNum = ParentNum
	from Notes where Id = @Id

	If @AnswerNum=0
	Begin
		If @RefOrder > 0
		Begin
			update Notes  set RefOrder = RefOrder -1
			where Ref = @Ref  and RefOrder > @RefOrder
			update Notes set AnswerNum = AnswerNum -1 where Id = @ParentNum
		End
		Delete Notes where Id = @Id
		delete Notes
		where Id = @ParentNum and ModifyIp = N'((DELETED))' and AnswerNum=0
	End
	Else
	Begin
		update Notes
		set
			Name = N'(Unknown)', Email = '', Password = '',
			Title = N'(삭제된 글입니다.)',
			Content = N'(섹제된 글입니다. ' + N'현재 답변이 포함되어 있기 때문에 내용만 삭제되었습니다.)',
			ModifyIp = N'((DELETE))', FileName = '',
			FileSize = 0, CommentCount =0
		where Id = @Id
	End
Go