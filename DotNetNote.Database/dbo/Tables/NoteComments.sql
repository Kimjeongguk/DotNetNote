CREATE TABLE [dbo].[NoteComments]
(
	Id int identity(1,1) not null primary key,
	BoardName nvarchar(50) null,
	BoardId int not null,
	Name nvarchar(25) not null,
	Opinion nvarchar(4000) not null,
	PostDate smalldatetime default(GetDate()),
	Password nvarchar(20) not null
)
Go
