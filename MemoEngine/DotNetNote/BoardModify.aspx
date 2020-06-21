<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="BoardModify.aspx.cs" Inherits="MemoEngine.DotNetNote.BoardModify" %>

<%@ Register Src="~/DotNetNote/Controls/BoardEditorFormControl.ascx" TagPrefix="uc1" TagName="BoardEditorFormControl.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <uc1:BoardEditorFormControl.ascx runat="server" ID="ctlBoardEditorFormControl" ></uc1:BoardEditorFormControl.ascx>
</asp:Content>