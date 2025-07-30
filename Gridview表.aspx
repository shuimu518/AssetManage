<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Gridview表.aspx.cs" Inherits="资产管理.Gridview表" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
     <title>顶部子菜单与数据展示系统</title>
    <style type="text/css">
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        
        /* 主容器 */
        .container {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        
        /* 左侧主菜单 */
        .main-menu {
            width: 200px;
            background-color: #2c3e50;
            color: white;
            position: fixed;
            height: 100vh;
        }
        
        .main-menu-item {
            padding: 14px 20px;
            cursor: pointer;
            border-bottom: 1px solid #34495e;
            transition: background-color 0.3s;
        }
        
        .main-menu-item:hover {
            background-color: #34495e;
        }
        
        /* 顶部子菜单 */
        .submenu-bar {
            background-color: #34495e;
            height: 50px;
            margin-left: 200px;
            display: flex;
            align-items: center;
            padding: 0 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        
        .submenu-item {
            color: white;
            text-decoration: none;
            padding: 10px 15px;
            margin-right: 10px;
            border-radius: 4px;
            transition: background-color 0.2s;
        }
        
        .submenu-item:hover {
            background-color: #2980b9;
        }
        
        /* 内容区域 */
        .content-area {
            margin-left: 200px;
            padding: 20px;
            background-color: #f5f5f5;
            min-height: 100vh;
        }
        
        /* 数据展示区域 */
        .data-container {
            margin-top: 20px;
            background-color: white;
            border-radius: 4px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            padding: 20px;
        }
        
        /* 活动菜单项样式 */
        .active-menu {
            background-color: #2980b9;
        }
        
        .active-submenu {
            background-color: #3498db;
        }
        
        /* GridView样式 */
        .grid-view {
            width: 100%;
            border-collapse: collapse;
        }
        
        .grid-view th {
            background-color: #34495e;
            color: white;
            padding: 10px;
            text-align: left;
        }
        
        .grid-view td {
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }
        
        .grid-view tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        
        .grid-view tr:hover {
            background-color: #f1f1f1;
        }
        
        /* 响应式设计 */
        @media (max-width: 768px) {
            .main-menu {
                width: 100%;
                height: auto;
                position: relative;
            }
            
            .submenu-bar {
                margin-left: 0;
            }
            
            .content-area {
                margin-left: 0;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <!-- 左侧主菜单 -->
            <div class="main-menu">
                <div class="main-menu-item" id="mainMenu1" runat="server" onclick="setActiveMenu(this, 'sys_user')">
                    <i class="fas fa-cog"></i> 系统管理
                </div>
                
                <div class="main-menu-item" id="mainMenu2" runat="server" onclick="setActiveMenu(this, 'prod_list')">
                    <i class="fas fa-box"></i> 产品管理
                </div>
                
                <div class="main-menu-item" id="mainMenu3" runat="server" onclick="setActiveMenu(this, 'order_list')">
                    <i class="fas fa-shopping-cart"></i> 订单管理
                </div>
                
                <div class="main-menu-item" id="mainMenu4" runat="server" onclick="setActiveMenu(this, 'report_sales')">
                    <i class="fas fa-chart-line"></i> 报表中心
                </div>
            </div>
            
            <!-- 顶部子菜单 -->
            <div class="submenu-bar" id="submenuBar" runat="server">
                <!-- 系统管理子菜单 -->
                <div id="sysSubmenu" class="submenu-section" style="display:none;">
                    <asp:LinkButton ID="lnkSub11" runat="server" CssClass="submenu-item" 
                        OnClick="ExecuteCommand" CommandArgument="sys_user">
                        <i class="fas fa-users"></i> 用户管理
                    </asp:LinkButton>
                    <asp:LinkButton ID="lnkSub12" runat="server" CssClass="submenu-item" 
                        OnClick="ExecuteCommand" CommandArgument="sys_role">
                        <i class="fas fa-user-tag"></i> 角色管理
                    </asp:LinkButton>
                    <asp:LinkButton ID="lnkSub13" runat="server" CssClass="submenu-item" 
                        OnClick="ExecuteCommand" CommandArgument="sys_config">
                        <i class="fas fa-sliders-h"></i> 系统配置
                    </asp:LinkButton>
                </div>
                
                <!-- 产品管理子菜单 -->
                <div id="prodSubmenu" class="submenu-section" style="display:none;">
                    <asp:LinkButton ID="lnkSub21" runat="server" CssClass="submenu-item" 
                        OnClick="ExecuteCommand" CommandArgument="prod_list">
                        <i class="fas fa-list"></i> 产品列表
                    </asp:LinkButton>
                    <asp:LinkButton ID="lnkSub22" runat="server" CssClass="submenu-item" 
                        OnClick="ExecuteCommand" CommandArgument="prod_add">
                        <i class="fas fa-plus"></i> 添加产品
                    </asp:LinkButton>
                    <asp:LinkButton ID="lnkSub23" runat="server" CssClass="submenu-item" 
                        OnClick="ExecuteCommand" CommandArgument="prod_cat">
                        <i class="fas fa-tags"></i> 产品分类
                    </asp:LinkButton>
                </div>
                
                <!-- 订单管理子菜单 -->
                <div id="orderSubmenu" class="submenu-section" style="display:none;">
                    <asp:LinkButton ID="lnkSub31" runat="server" CssClass="submenu-item" 
                        OnClick="ExecuteCommand" CommandArgument="order_list">
                        <i class="fas fa-list-ol"></i> 订单列表
                    </asp:LinkButton>
                    <asp:LinkButton ID="lnkSub32" runat="server" CssClass="submenu-item" 
                        OnClick="ExecuteCommand" CommandArgument="order_add">
                        <i class="fas fa-file-invoice"></i> 创建订单
                    </asp:LinkButton>
                    <asp:LinkButton ID="lnkSub33" runat="server" CssClass="submenu-item" 
                        OnClick="ExecuteCommand" CommandArgument="order_stats">
                        <i class="fas fa-chart-bar"></i> 订单统计
                    </asp:LinkButton>
                </div>
                
                <!-- 报表中心子菜单 -->
                <div id="reportSubmenu" class="submenu-section" style="display:none;">
                    <asp:LinkButton ID="lnkSub41" runat="server" CssClass="submenu-item" 
                        OnClick="ExecuteCommand" CommandArgument="report_sales">
                        <i class="fas fa-dollar-sign"></i> 销售报表
                    </asp:LinkButton>
                    <asp:LinkButton ID="lnkSub42" runat="server" CssClass="submenu-item" 
                        OnClick="ExecuteCommand" CommandArgument="report_inventory">
                        <i class="fas fa-boxes"></i> 库存报表
                    </asp:LinkButton>
                    <asp:LinkButton ID="lnkSub43" runat="server" CssClass="submenu-item" 
                        OnClick="ExecuteCommand" CommandArgument="report_finance">
                        <i class="fas fa-coins"></i> 财务报表
                    </asp:LinkButton>
                </div>
            </div>
            
            <!-- 内容区域 -->
            <div class="content-area">
                <h2 id="contentTitle" runat="server">欢迎使用管理系统</h2>
                
                <!-- 数据展示区域 -->
                <div class="data-container">
                    <asp:Label ID="lblDataTitle" runat="server" Text="数据列表" Font-Size="Large" Font-Bold="true"></asp:Label>
                    <asp:GridView ID="gvData" runat="server" CssClass="grid-view" AutoGenerateColumns="false"
                        AllowPaging="true" PageSize="10" OnPageIndexChanging="gvData_PageIndexChanging">
                        <Columns>
                            <asp:BoundField DataField="ID" HeaderText="ID" />
                            <asp:BoundField DataField="Name" HeaderText="名称" />
                            <asp:BoundField DataField="Description" HeaderText="描述" />
                            <asp:BoundField DataField="CreateTime" HeaderText="创建时间" DataFormatString="{0:yyyy-MM-dd}" />
                            <asp:TemplateField HeaderText="操作">
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" CommandName="Edit" Text="编辑" CssClass="btn-edit" />
                                    <asp:LinkButton runat="server" CommandName="Delete" Text="删除" CssClass="btn-delete" 
                                        OnClientClick="return confirm('确定要删除吗？');" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <PagerStyle CssClass="grid-pager" />
                        <EmptyDataTemplate>
                            <div style="text-align:center;padding:20px;">
                                没有找到数据
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>


            </div>
        </div>
    </form>

    <!-- Font Awesome 图标库 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />

    <script type="text/javascript">
        // 设置活动菜单并显示对应的子菜单
        function setActiveMenu(menuElement, submenuId) {
            // 移除所有活动样式
            var menuItems = document.querySelectorAll('.main-menu-item');
            menuItems.forEach(function(item) {
                item.classList.remove('active-menu');
            });
            
            // 添加活动样式
            menuElement.classList.add('active-menu');
            
            // 隐藏所有子菜单
            var submenus = document.querySelectorAll('.submenu-section');
            submenus.forEach(function(submenu) {
                submenu.style.display = 'none';
            });
            
            // 显示对应的子菜单
            var submenuToShow = document.getElementById(submenuId + 'Submenu');
            if (submenuToShow) {
                submenuToShow.style.display = 'block';
            }
            
            // 触发第一个子菜单的点击事件
            var firstSubmenuItem = submenuToShow.querySelector('.submenu-item');
            if (firstSubmenuItem) {
                firstSubmenuItem.click();
            }
        }
    </script>
</body>
</html>
