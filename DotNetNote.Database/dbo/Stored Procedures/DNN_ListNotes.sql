CREATE PROCEDURE [dbo].[DNN_ListNotes]
	@Page Int
AS
	With DotNetNoteOrderdLists
	AS
	(
		Select
			[Id], [Name], [Email], [Title], [PostDate], [ReadCount],
			[Ref], [Step], [RefOrder], [AnswerNum], [ParentNum],
			[CommentCount], [FileName], [FileSize], [DownCount],
			ROW_NUMBER() Over (Order By Ref Desc, RefOrder Asc)
			AS 'RowNumber'
		From Notes
	)
	select * From DotNetNoteOrderdLists
	where RowNumber Between @Page * 10 +1 And (@Page +1) *10
Go