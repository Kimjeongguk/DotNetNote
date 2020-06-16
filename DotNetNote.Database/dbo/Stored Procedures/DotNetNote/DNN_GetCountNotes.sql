CREATE PROCEDURE [dbo].[DNN_GetCountNotes]
As
	select Count(*) from Notes
Go