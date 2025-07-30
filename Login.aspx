<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="资产管理.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>科技感登录系统</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', 'Microsoft YaHei', sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #0f172a 0%, #1e3a8a 100%);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden;
        }
        
        .login-container {
            position: relative;
            width: 400px;
            padding: 40px;
            background: rgba(15, 23, 42, 0.8);
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
            border: 1px solid rgba(94, 234, 212, 0.3);
            backdrop-filter: blur(10px);
            overflow: hidden;
            z-index: 2;
        }
        
        .login-container::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent, rgba(59, 130, 246, 0.2), transparent);
            transform: rotate(45deg);
            z-index: -1;
        }
        
        .login-title {
            color: #5eead4;
            text-align: center;
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 30px;
            text-shadow: 0 0 10px rgba(94, 234, 212, 0.5);
            letter-spacing: 1px;
        }
        
        .input-group {
            position: relative;
            margin-bottom: 25px;
        }
        
        .input-group input {
            width: 100%;
            padding: 14px 20px;
            background: rgba(30, 41, 59, 0.7);
            border: 1px solid rgba(94, 234, 212, 0.2);
            border-radius: 8px;
            color: #f0f9ff;
            font-size: 16px;
            transition: all 0.3s ease;
        }
        
        .input-group input:focus {
            border-color: #5eead4;
            box-shadow: 0 0 15px rgba(94, 234, 212, 0.3);
            outline: none;
        }
        
        .input-group label {
            position: absolute;
            top: 14px;
            left: 20px;
            color: #94a3b8;
            pointer-events: none;
            transition: 0.3s;
        }
        
        .input-group input:focus ~ label,
        .input-group input:valid ~ label {
            top: -10px;
            left: 10px;
            background: #0f172a;
            padding: 0 8px;
            font-size: 14px;
            color: #5eead4;
        }
        
        .btn-login {
            width: 100%;
            padding: 14px;
            background: linear-gradient(90deg, #0ea5e9 0%, #5eead4 100%);
            border: none;
            border-radius: 8px;
            color: #0f172a;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            letter-spacing: 1px;
        }
        
        .btn-login:hover {
            background: linear-gradient(90deg, #0284c7 0%, #2dd4bf 100%);
            box-shadow: 0 0 15px rgba(14, 165, 233, 0.5);
        }
        
        .links-container {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }
        
        .link {
            color: #94a3b8;
            text-decoration: none;
            font-size: 14px;
            transition: color 0.3s ease;
        }
        
        .link:hover {
            color: #5eead4;
            text-decoration: underline;
        }
        
        .particles {
            position: absolute;
            width: 100%;
            height: 100%;
            z-index: 1;
        }
        
        .particle {
            position: absolute;
            width: 2px;
            height: 2px;
            background: rgba(94, 234, 212, 0.7);
            border-radius: 50%;
            box-shadow: 0 0 10px rgba(94, 234, 212, 0.8);
        }
        
        .user-display {
            position: absolute;
            top: 20px;
            right: 20px;
            color: #5eead4;
            font-weight: 500;
            display: flex;
            align-items: center;
        }
        
        .user-display span {
            margin-right: 10px;
        }
        
        .logout-btn {
            background: rgba(30, 41, 59, 0.7);
            color: #94a3b8;
            border: 1px solid rgba(94, 234, 212, 0.2);
            border-radius: 4px;
            padding: 5px 10px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .logout-btn:hover {
            background: rgba(30, 41, 59, 1);
            color: #5eead4;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- 粒子背景 -->
        <div class="particles" id="particles"></div>
        
        <div class="login-container">
            <h1 class="login-title">无人车管系统登录</h1>
            <div class="input-group">
                <asp:TextBox ID="txtUsername" runat="server" required="required"></asp:TextBox>
                <label for="txtUsername">用户名</label>
            </div>
            <div class="input-group">
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" required="required"></asp:TextBox>
                <label for="txtPassword">密码</label>
            </div>
            <asp:Button ID="btnLogin" runat="server" Text="登录" CssClass="btn-login" OnClick="btnLogin_Click" />
            
            <div class="links-container">
                <a href="ResetPassword.aspx" class="link">修改密码</a>
                <a href="#" class="link">忘记密码?</a>
            </div>
        </div>
    </form>

    <script>
        // 创建粒子背景
        document.addEventListener('DOMContentLoaded', function() {
            const particlesContainer = document.getElementById('particles');
            const particleCount = 100;
            
            for (let i = 0; i < particleCount; i++) {
                const particle = document.createElement('div');
                particle.classList.add('particle');
                
                // 随机位置
                const posX = Math.random() * 100;
                const posY = Math.random() * 100;
                particle.style.left = `${posX}vw`;
                particle.style.top = `${posY}vh`;
                
                // 随机大小和动画
                const size = Math.random() * 3 + 1;
                const duration = Math.random() * 10 + 10;
                
                particle.style.width = `${size}px`;
                particle.style.height = `${size}px`;
                particle.style.animation = `float ${duration}s linear infinite`;
                
                // 添加到容器
                particlesContainer.appendChild(particle);
            }
            
            // 添加浮动动画
            const style = document.createElement('style');
            style.innerHTML = `
                @keyframes float {
                    0% { transform: translate(0, 0); opacity: 0; }
                    10% { opacity: 1; }
                    90% { opacity: 1; }
                    100% { transform: translate(${Math.random() * 100 - 50}px, ${Math.random() * 100 - 50}px); opacity: 0; }
                }
            `;
            document.head.appendChild(style);
        });
    </script>
</body>
</html>
