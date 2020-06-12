CREATE PROCEDURE [dbo].[DNN_SearchNoteCount]
	@SearchField nvarchar(25),
	@SearchQuery nvarchar(25)
As
	set @SearchQuery = '%' + @SearchQuery + '%'
	
	select Count(*)
	from Notes
	where(
		case @SearchField
			When 'Name' Then [Name]
			when 'Title' Then Title
			when 'Content' then Content
			Else @SearchQuery
		End
	)
	like
	@SearchQuery
Go