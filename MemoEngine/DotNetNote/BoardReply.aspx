<%@ Page Language="C#" MasterPageFile="~/Site.Master" ValidateRequest="false" AutoEventWireup="true" CodeBehind="BoardReply.aspx.cs" Inherits="MemoEngine.DotNetNote.BoardReply" %>

<%@ Register Src="~/DotNetNote/Controls/BoardEditorFormControl.ascx" TagPrefix="uc1" TagName="BoardEditorFormControl" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <uc1:BoardEditorFormControl runat="server" ID="ctlBoardEditorFormControl" />
</asp:Content>