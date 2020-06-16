CREATE PROCEDURE [dbo].[DNN_SearchNotes]
	@Page int,
	@SearchField nvarchar(25),
	@SearchQuery nvarchar(25)
AS
	With DotNetNoteOrderdList
	AS(
		select
			[Id], [Name], [Email], [Title], [PostDate], [ReadCount],
			[Ref], [Step], [RefOrder], [AnswerNum], [ParentNum],
			[CommentCount], [FileName], [FileSize], [DownCount],
			ROW_NUMBER() Over (Order By Ref Desc, RefOrder Asc)
			AS 'RowNumber'
		From Notes
		where(
			case @SearchField
				 when 'Name' then [Name]
				 when 'Title' then Title
				 when 'Content' then Content
				 Else
				 @SearchQuery
			End
		)Like '%' + @SearchQuery + '%'
	)
	select
		[Id], [Name], [Email], [Title], [PostDate], [ReadCount],
		[Ref], [Step], [RefOrder], [AnswerNum], [ParentNum],
		[CommentCount], [FileName], [FileSize], [DownCount],
		[RowNumber]
	from DotNetNoteOrderdList
	where RowNumber between @Page * 10 +1 and (@Page +1) * 10
	Order By Id Desc
Go

		