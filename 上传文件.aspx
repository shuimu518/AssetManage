<%@ Page Title="" Language="C#" MasterPageFile="~/Site-asset.Master" AutoEventWireup="true" CodeBehind="上传文件.aspx.cs" Inherits="资产管理.上传文件" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
     <style>
     /* 保持原有样式不变 */
 /*    * {
         margin: 0;
         padding: 0;
         box-sizing: border-box;
         font-family: 'Segoe UI', 'Microsoft YaHei', sans-serif;
     }*/
     
  /*   body {
         background: linear-gradient(135deg, #0a1929 0%, #102a3c 100%);
         color: #e0f7fa;
         min-height: 100vh;
         padding: 20px;
     }*/
     
  /*   .container {
         max-width: 1200px;
         margin: 0 auto;
         padding: 20px;
     }*/
     
     header {
         text-align: center;
         padding: 30px 0;
         border-bottom: 1px solid #00c896;
         margin-bottom: 40px;
     }
     
     h1 {
         font-size: 2.8rem;
         background: linear-gradient(to right, #00c896, #00e5ff);
         -webkit-background-clip: text;
         -webkit-text-fill-color: transparent;
         text-shadow: 0 0 10px rgba(0, 200, 150, 0.3);
         letter-spacing: 1px;
         margin-bottom: 10px;
     }
     
     .subtitle {
         color: #7fdbca;
         font-size: 1.2rem;
     }
     
     .card {
         background: rgba(13, 42, 61, 0.7);
         border: 1px solid #00b38a;
         border-radius: 12px;
         padding: 30px;
         margin-bottom: 30px;
         box-shadow: 0 8px 32px rgba(0, 100, 100, 0.3);
         backdrop-filter: blur(4px);
     }
     
     .card-title {
         color: #00e5ff;
         font-size: 1.8rem;
         margin-bottom: 25px;
         display: flex;
         align-items: center;
     }
     
     .card-title i {
         margin-right: 12px;
         font-size: 1.5rem;
     }
     
     .upload-section {
         display: flex;
         flex-wrap: wrap;
         gap: 15px;
         align-items: center;
     }
     
     .file-input {
         flex: 1;
         min-width: 300px;
         padding: 14px;
         background: rgba(0, 40, 40, 0.5);
         border: 1px solid #008c72;
         border-radius: 8px;
         color: #e0f7fa;
         font-size: 1rem;
     }
     
     .btn {
         padding: 14px 32px;
         background: linear-gradient(90deg, #008c72, #00c896);
         border: none;
         border-radius: 8px;
         color: white;
         font-size: 1.1rem;
         font-weight: 600;
         cursor: pointer;
         transition: all 0.3s ease;
         box-shadow: 0 4px 15px rgba(0, 200, 150, 0.3);
     }
     
     .btn:hover {
         transform: translateY(-3px);
         box-shadow: 0 6px 20px rgba(0, 230, 180, 0.5);
     }
     
     .btn:active {
         transform: translateY(0);
     }
     
     .btn-download {
         background: linear-gradient(90deg, #006e8c, #0099c8);
     }
     
     .btn-delete {
         background: linear-gradient(90deg, #8c2a00, #c84a00);
         margin-left: 10px;
     }
     
     .btn-delete:hover {
         box-shadow: 0 6px 20px rgba(230, 80, 0, 0.5);
     }
     
     .status-label {
         display: block;
         margin-top: 20px;
         padding: 12px;
         border-radius: 8px;
         font-size: 1.1rem;
         text-align: center;
     }
     
     .success {
         background: rgba(0, 200, 150, 0.2);
         border: 1px solid #00c896;
     }
     
     .error {
         background: rgba(200, 0, 50, 0.2);
         border: 1px solid #ff0055;
     }
     
     .file-grid {
         width: 100%;
         border-collapse: collapse;
         margin-top: 20px;
     }
     
     .file-grid th {
         background: rgba(0, 100, 100, 0.5);
         padding: 16px;
         text-align: left;
         font-weight: 600;
         color: #00e5ff;
     }
     
     .file-grid td {
         padding: 16px;
         border-bottom: 1px solid #005a5a;
     }
     
     .file-grid tr:hover {
         background: rgba(0, 150, 120, 0.1);
     }
     
     .file-link {
         color: white;
         text-decoration: none;
         transition: all 0.3s;
         display: inline-block;
         padding: 8px 16px;
         border-radius: 6px;
         min-width: 70px;
         text-align: center;
     }
     
     .file-link:hover {
         transform: translateY(-2px);
         text-decoration: none;
     }
     
     .empty-row td {
         text-align: center;
         padding: 40px;
         color: #7fdbca;
         font-style: italic;
     }
     
     footer {
         text-align: center;
         padding: 30px 0;
         color: #5f9e9e;
         font-size: 0.9rem;
         margin-top: 40px;
         border-top: 1px solid #005a5a;
     }
     
     .action-cell {
         display: flex;
         gap: 10px;
     }
     
     /* 响应式设计 */
     @media (max-width: 768px) {
         .container {
             padding: 10px;
         }
         
         .card {
             padding: 20px;
         }
         
         .upload-section {
             flex-direction: column;
         }
         
         .file-input {
             width: 100%;
         }
         
         .action-cell {
             flex-direction: column;
         }
     }
        .export-btn-container {
       margin-top: 15px;
       align-self: flex-end;
   }
         .file-size-info {
            margin-top: 10px;
            color: #7fdbca;
            font-size: 0.95rem;
        }
             .progress-container {
        width: 100%;
        background-color: rgba(0, 40, 40, 0.5);
        border-radius: 8px;
        margin-top: 15px;
        height: 20px;
        display: none;
    }

    .progress-bar {
        height: 100%;
        border-radius: 8px;
        background: linear-gradient(90deg, #008c72, #00c896);
        width: 0%;
        transition: width 0.3s ease;
        position: relative;
    }

    .progress-text {
        position: absolute;
        right: 10px;
        top: 0;
        line-height: 20px;
        color: white;
        font-size: 0.85rem;
        font-weight: bold;
        text-shadow: 0 0 2px rgba(0,0,0,0.5);
    }
 </style>

        <div class="container">
            <header>
                <h1>科技文件管理系统</h1>
                <p class="subtitle">安全高效的文件传输解决方案</p>
            </header>
            
            <div class="card">
                <h2 class="card-title">文件上传</h2>
                <%--<div class="upload-section">
                    <asp:FileUpload ID="FileUploadControl" runat="server" CssClass="file-input" />
                    <asp:Button ID="UploadButton" runat="server" Text="上传文件" 
                        OnClick="UploadButton_Click" CssClass="btn" />
                </div>--%>

                         <div class="upload-section">
                  <asp:FileUpload ID="FileUploadControl" runat="server" CssClass="file-input" onchange="showFileSize(this)" />
                  <asp:Button ID="UploadButton" runat="server" Text="上传文件" 
                      OnClick="UploadButton_Click" CssClass="btn" />
              </div>
                      <div id="FileSizeInfo" class="file-size-info"></div>
      
                  <div id="ProgressContainer" class="progress-container">
                      <div id="ProgressBar" class="progress-bar">
                          <span id="ProgressText" class="progress-text">0%</span>
                      </div>
                  </div>

                <asp:Label ID="StatusLabel" runat="server" CssClass="status-label" Visible="false"></asp:Label>
            </div>
            
            <div class="card">
                <h2 class="card-title">文件下载</h2>
                    <div class="export-btn-container">
                    <asp:Button ID="ExportButton" runat="server" Text="导出Excel" 
                        OnClick="ExportButton_Click" CssClass="btn btn-export" />
                </div>
                <asp:GridView ID="FilesGrid" runat="server" AutoGenerateColumns="False" 
                    CssClass="file-grid" OnRowCommand="FilesGrid_RowCommand" EmptyDataText="暂无文件">
                    <Columns>
                        <asp:BoundField DataField="Name" HeaderText="文件名" />
                        <asp:BoundField DataField="Size" HeaderText="大小" />
                        <asp:BoundField DataField="Modified" HeaderText="修改日期" />
                        <asp:TemplateField HeaderText="操作">
                            <ItemTemplate>
                                <div class="action-cell">
                                    <asp:LinkButton ID="DownloadLink" runat="server" 
                                        CommandName="Download" 
                                        CommandArgument='<%# Eval("Path") %>'
                                        Text="下载" CssClass="btn btn-download" />
                                    <asp:LinkButton ID="DeleteLink" runat="server" 
                                        CommandName="DeleteFile" 
                                        CommandArgument='<%# Eval("Path") %>'
                                        Text="删除" CssClass="btn btn-delete" 
                                        OnClientClick="return confirm('确定要删除这个文件吗？');" />
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataRowStyle CssClass="empty-row" />
                </asp:GridView>
            </div>
            
            <footer>
                <p>© 2023 科技文件管理系统 | 安全存储 | 高效传输</p>
            </footer>
        </div>
     <script>
     // 显示文件大小
     function showFileSize(input) {
         if (input.files && input.files.length > 0) {
             var file = input.files[0];
             var fileSize = formatFileSize(file.size);
             document.getElementById('FileSizeInfo').innerText =
                 "已选择: " + file.name + " (" + fileSize + ")";
         } else {
             document.getElementById('FileSizeInfo').innerText = "";
         }
     }

     // 格式化文件大小
     function formatFileSize(bytes) {
         if (bytes === 0) return '0 Bytes';
         const k = 1024;
         const sizes = ['Bytes', 'KB', 'MB', 'GB'];
         const i = Math.floor(Math.log(bytes) / Math.log(k));
         return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
     }

     // 开始进度条
     function startProgress() {
         var fileInput = document.getElementById('<%= FileUploadControl.ClientID %>');
         if (fileInput.files.length === 0) {
             alert('请选择要上传的文件');
             return false;
         }
         
         // 显示进度条
         var progressContainer = document.getElementById('ProgressContainer');
         var progressBar = document.getElementById('ProgressBar');
         var progressText = document.getElementById('ProgressText');
         
         progressContainer.style.display = 'block';
         progressBar.style.width = '0%';
         progressText.innerText = '0%';
         
         // 模拟进度更新
         var width = 0;
         var interval = setInterval(function() {
             if (width >= 100) {
                 clearInterval(interval);
                 return;
             }
             width += Math.random() * 10;
             if (width > 100) width = 100;
             
             progressBar.style.width = width + '%';
             progressText.innerText = Math.floor(width) + '%';
         }, 300);
         
         // 禁用按钮防止重复点击
         var uploadButton = document.getElementById('<%= UploadButton.ClientID %>');
         uploadButton.disabled = true;
         uploadButton.value = "上传中...";
         
         return true;
         }
     
     
     // 页面加载完成后重置按钮状态
     window.onload = function() {
         var uploadButton = document.getElementById('<%= UploadButton.ClientID %>');
         if (uploadButton) {
             uploadButton.disabled = false;
             uploadButton.value = "上传文件";
         }

         // 隐藏进度条
         document.getElementById('ProgressContainer').style.display = 'none';
     };
     </script>


</asp:Content>
