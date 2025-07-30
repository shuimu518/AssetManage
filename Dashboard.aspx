<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="资产管理.Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>科技系统仪表盘</title>
    <style>
        body {
            background: linear-gradient(135deg, #0f172a 0%, #1e3a8a 100%);
            min-height: 100vh;
            margin: 0;
            font-family: 'Segoe UI', 'Microsoft YaHei', sans-serif;
            color: #e2e8f0;
        }
        
        .header {
            background: rgba(15, 23, 42, 0.9);
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid rgba(94, 234, 212, 0.3);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
        }
        
        .logo {
            font-size: 24px;
            font-weight: 700;
            background: linear-gradient(90deg, #0ea5e9 0%, #5eead4 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .main-content {
            max-width: 1200px;
            margin: 40px auto;
            padding: 20px;
        }
        
        .welcome-section {
            text-align: center;
            margin-bottom: 50px;
        }
        
        .welcome-title {
            font-size: 36px;
            margin-bottom: 20px;
            color: #5eead4;
        }
        
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
        }
        
        .dashboard-card {
            background: rgba(30, 41, 59, 0.7);
            border-radius: 12px;
            padding: 25px;
            border: 1px solid rgba(94, 234, 212, 0.2);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.4);
            border-color: rgba(94, 234, 212, 0.5);
        }
        
        .card-title {
            font-size: 20px;
            margin-bottom: 15px;
            color: #5eead4;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <div class="logo">科技系统</div>
            <div class="user-display">
                <span>欢迎, <asp:Label ID="lblUsername" runat="server" Text=""></asp:Label></span>
                <asp:Button ID="btnLogout" runat="server" Text="退出登录" CssClass="logout-btn" OnClick="btnLogout_Click" />
            </div>
        </div>
        
        <div class="main-content">
            <div class="welcome-section">
                <h1 class="welcome-title">欢迎使用科技管理系统</h1>
                <p>您已成功登录到安全系统，请开始使用各项功能</p>
            </div>
            
            <div class="dashboard-grid">
                <div class="dashboard-card">
                    <h3 class="card-title">数据统计</h3>
                    <p>查看系统使用情况和数据分析报告</p>
                </div>
                <div class="dashboard-card">
                    <h3 class="card-title">用户管理</h3>
                    <p>管理系统用户和权限设置</p>
                </div>
                <div class="dashboard-card">
                    <h3 class="card-title">系统设置</h3>
                    <p>配置系统参数和个性化设置</p>
                </div>
            </div>
        </div>
    </form>
</body>
</html>