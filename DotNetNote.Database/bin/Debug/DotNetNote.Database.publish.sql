/*
DotNetNote의 배포 스크립트

이 코드는 도구를 사용하여 생성되었습니다.
파일 내용을 변경하면 잘못된 동작이 발생할 수 있으며, 코드를 다시 생성하면
변경 내용이 손실됩니다.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "DotNetNote"
:setvar DefaultFilePrefix "DotNetNote"
:setvar DefaultDataPath "C:\Users\minds\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\mssqllocaldb\"
:setvar DefaultLogPath "C:\Users\minds\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\mssqllocaldb\"

GO
:on error exit
GO
/*
SQLCMD 모드가 지원되지 않으면 SQLCMD 모드를 검색하고 스크립트를 실행하지 않습니다.
SQLCMD 모드를 설정한 후에 이 스크립트를 다시 사용하려면 다음을 실행합니다.
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'이 스크립트를 실행하려면 SQLCMD 모드를 사용하도록 설정해야 합니다.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET PAGE_VERIFY NONE 
            WITH ROLLBACK IMMEDIATE;
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET TARGET_RECOVERY_TIME = 0 SECONDS 
    WITH ROLLBACK IMMEDIATE;


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE (CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 367)) 
            WITH ROLLBACK IMMEDIATE;
    END


GO
PRINT N'[dbo].[NoteComments]을(를) 만드는 중...';


GO
CREATE TABLE [dbo].[NoteComments] (
    [Id]        INT             IDENTITY (1, 1) NOT NULL,
    [BoardName] NVARCHAR (50)   NULL,
    [BoardId]   INT             NOT NULL,
    [Name]      NVARCHAR (25)   NOT NULL,
    [Opinion]   NVARCHAR (4000) NOT NULL,
    [PostDate]  SMALLDATETIME   NULL,
    [Password]  NVARCHAR (20)   NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'[dbo].[Notes]을(를) 만드는 중...';


GO
CREATE TABLE [dbo].[Notes] (
    [Id]           INT            IDENTITY (1, 1) NOT NULL,
    [Name]         NVARCHAR (25)  NOT NULL,
    [Email]        NVARCHAR (100) NULL,
    [Title]        NVARCHAR (150) NOT NULL,
    [PostDate]     DATETIME       NOT NULL,
    [PostIp]       NVARCHAR (15)  NULL,
    [Content]      NTEXT          NOT NULL,
    [Password]     NVARCHAR (20)  NULL,
    [ReadCount]    INT            NULL,
    [Encoding]     NVARCHAR (10)  NOT NULL,
    [Homepage]     NVARCHAR (100) NULL,
    [ModifyDate]   DATETIME       NULL,
    [ModifyIp]     NVARCHAR (15)  NULL,
    [FileName]     NVARCHAR (255) NULL,
    [FileSize]     INT            NULL,
    [DownCount]    INT            NULL,
    [Ref]          INT            NOT NULL,
    [Step]         INT            NULL,
    [RefOrder]     INT            NULL,
    [AnswerNum]    INT            NULL,
    [ParentNum]    INT            NULL,
    [CommentCount] INT            NULL,
    [Category]     NVARCHAR (10)  NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'[dbo].[NoteComments]에 대한 명명되지 않은 제약 조건을(를) 만드는 중...';


GO
ALTER TABLE [dbo].[NoteComments]
    ADD DEFAULT (GetDate()) FOR [PostDate];


GO
PRINT N'[dbo].[Notes]에 대한 명명되지 않은 제약 조건을(를) 만드는 중...';


GO
ALTER TABLE [dbo].[Notes]
    ADD DEFAULT GetDate() FOR [PostDate];


GO
PRINT N'[dbo].[Notes]에 대한 명명되지 않은 제약 조건을(를) 만드는 중...';


GO
ALTER TABLE [dbo].[Notes]
    ADD DEFAULT 0 FOR [ReadCount];


GO
PRINT N'[dbo].[Notes]에 대한 명명되지 않은 제약 조건을(를) 만드는 중...';


GO
ALTER TABLE [dbo].[Notes]
    ADD DEFAULT 0 FOR [FileSize];


GO
PRINT N'[dbo].[Notes]에 대한 명명되지 않은 제약 조건을(를) 만드는 중...';


GO
ALTER TABLE [dbo].[Notes]
    ADD DEFAULT 0 FOR [DownCount];


GO
PRINT N'[dbo].[Notes]에 대한 명명되지 않은 제약 조건을(를) 만드는 중...';


GO
ALTER TABLE [dbo].[Notes]
    ADD DEFAULT 0 FOR [Step];


GO
PRINT N'[dbo].[Notes]에 대한 명명되지 않은 제약 조건을(를) 만드는 중...';


GO
ALTER TABLE [dbo].[Notes]
    ADD DEFAULT 0 FOR [RefOrder];


GO
PRINT N'[dbo].[Notes]에 대한 명명되지 않은 제약 조건을(를) 만드는 중...';


GO
ALTER TABLE [dbo].[Notes]
    ADD DEFAULT 0 FOR [AnswerNum];


GO
PRINT N'[dbo].[Notes]에 대한 명명되지 않은 제약 조건을(를) 만드는 중...';


GO
ALTER TABLE [dbo].[Notes]
    ADD DEFAULT 0 FOR [ParentNum];


GO
PRINT N'[dbo].[Notes]에 대한 명명되지 않은 제약 조건을(를) 만드는 중...';


GO
ALTER TABLE [dbo].[Notes]
    ADD DEFAULT 0 FOR [CommentCount];


GO
PRINT N'[dbo].[DNN_DeleteNote]을(를) 만드는 중...';


GO
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
GO
PRINT N'[dbo].[DNN_GetCountNotes]을(를) 만드는 중...';


GO
CREATE PROCEDURE [dbo].[DNN_GetCountNotes]
As
	select Count(*) from Notes
GO
PRINT N'[dbo].[DNN_ListNotes]을(를) 만드는 중...';


GO
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
GO
PRINT N'[dbo].[DNN_ModifyNote]을(를) 만드는 중...';


GO
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
GO
PRINT N'[dbo].[DNN_ReplyNote]을(를) 만드는 중...';


GO
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
GO
PRINT N'[dbo].[DNN_SearchNoteCount]을(를) 만드는 중...';


GO
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
GO
PRINT N'[dbo].[DNN_SearchNotes]을(를) 만드는 중...';


GO
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
GO
PRINT N'[dbo].[DNN_ViewNote]을(를) 만드는 중...';


GO
CREATE PROCEDURE [dbo].[DNN_ViewNote]
	@Id int
AS
	Update Notes set ReadCount = ReadCount +1 where Id = @Id

	Select * from Notes where Id = @Id
GO
PRINT N'[dbo].[DNN_WriteNote]을(를) 만드는 중...';


GO
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
GO
PRINT N'업데이트가 완료되었습니다.';


GO
