<%@ Page Title="" Language="C#" MasterPageFile="~/Site-asset.Master" AutoEventWireup="true" CodeBehind="Imageuphold.aspx.cs" Inherits="资产管理.Imageuphold" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <style>
    body {
        background: linear-gradient(135deg, #0a2e38 0%, #1a5c5c 100%);
        color: #c0d6d6;
        font-family: 'Segoe UI', Arial, sans-serif;
        margin: 0;
        padding: 20px;
    }
    .container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 20px;
    }
    .header {
        text-align: center;
        margin-bottom: 30px;
        border-bottom: 2px solid #4db8b8;
        padding-bottom: 15px;
    }
    h1 {
        color: #4db8b8;
        font-size: 2.5em;
        text-shadow: 0 0 10px rgba(77, 184, 184, 0.5);
    }
    .upload-panel {
        background: rgba(13, 41, 53, 0.7);
        border: 1px solid #2a7f7f;
        border-radius: 8px;
        padding: 25px;
        margin-bottom: 30px;
        box-shadow: 0 0 20px rgba(0, 0, 0, 0.5);
    }
    .gallery {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
        gap: 25px;
        margin-top: 30px;
    }
    .image-card {
        background: rgba(13, 41, 53, 0.8);
        border: 1px solid #2a7f7f;
        border-radius: 8px;
        overflow: hidden;
        transition: transform 0.3s, box-shadow 0.3s;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
    }
    .image-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 25px rgba(77, 184, 184, 0.4);
    }
    .image-container {
        height: 200px;
        overflow: hidden;
    }
    .image-container img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.5s;
    }
    .image-container:hover img {
        transform: scale(1.05);
    }
    .image-info {
        padding: 15px;
        text-align: center;
    }
    .btn {
        background: linear-gradient(to right, #1a5c5c, #2a7f7f);
        color: white;
        border: none;
        padding: 10px 20px;
        border-radius: 4px;
        cursor: pointer;
        font-size: 1em;
        transition: all 0.3s;
        margin: 5px;
    }
    .btn:hover {
        background: linear-gradient(to right, #2a7f7f, #3daaaa);
        box-shadow: 0 0 15px rgba(77, 184, 184, 0.6);
    }
    .file-input {
        padding: 10px;
        margin: 10px 0;
        width: 100%;
        background: rgba(10, 46, 56, 0.6);
        border: 1px solid #2a7f7f;
        color: #c0d6d6;
    }
    .download-btn {
        display: block;
        width: 100%;
        text-align: center;
        margin-top: 10px;
        text-decoration: none;
        background: rgba(10, 46, 56, 0.8);
        color: #4db8b8;
        padding: 8px;
        border-radius: 4px;
        transition: background 0.3s;
    }
    .download-btn:hover {
        background: rgba(42, 127, 127, 0.8);
        color: white;
    }
    .glow-text {
        text-shadow: 0 0 8px rgba(77, 184, 184, 0.8);
    }
    .tech-border {
        position: relative;
        overflow: hidden;
    }
    .tech-border::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 2px;
        background: linear-gradient(90deg, transparent, #4db8b8, transparent);
        transition: 0.5s;
    }
    .tech-border:hover::before {
        left: 100%;
    }
</style>
    <div class="container">
    <div class="header">
        <h1 class="glow-text">科技感图片库</h1>
        <p>上传并管理您的图片集合</p>
    </div>

    <div class="upload-panel tech-border">
        <h2>上传新图片</h2>
        <asp:FileUpload ID="ImageUpload" runat="server" CssClass="file-input" AllowMultiple="true" />
        <asp:Button ID="UploadButton" runat="server" Text="上传图片" OnClick="UploadButton_Click" CssClass="btn" />
    </div>

    <div class="gallery">
        <asp:Repeater ID="ImageRepeater" runat="server">
            <ItemTemplate>
                <div class="image-card tech-border">
                    <div class="image-container">
                        <img src='<%# "ImageHandler.ashx?filename=" + System.Web.HttpUtility.UrlEncode(Eval("FileName").ToString()) %>' 
                             alt='<%# Eval("FileName") %>' />
                    </div>
                    <div class="image-info">
                        <p><%# Eval("FileName") %></p>
                        <a href='<%# "ImageHandler.ashx?filename=" + System.Web.HttpUtility.UrlEncode(Eval("FileName").ToString()) + "&download=true" %>' 
                           class="download-btn">下载图片</a>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</div>


</asp:Content>
