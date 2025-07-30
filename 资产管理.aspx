<%@ Page Title="" Language="C#" MasterPageFile="~/Site-asset.Master" AutoEventWireup="true" CodeBehind="资产管理.aspx.cs" Inherits="资产管理.测试1" %>



<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
       <style type="text/css">
                       /* 活动菜单项样式 */
            .active-menu { background-color: #2980b9; }
            .active-submenu {   background-color: #3498db; }  
              /* GridView样式 */
                 .grid-view {  width: 100%;   border-collapse: collapse;  }
                 .grid-view th {     background-color: #34495e;    color: white;     padding: 10px;    text-align: left;   }
                 .grid-view td {     padding: 10px;    border-bottom: 1px solid #ddd; }
                 .grid-view tr:nth-child(even) {     background-color: #f9f9f9;  }
                 .grid-view tr:hover {     background-color: #f1f1f1;    }
                               /*-- 增加间距 -->*/
                    .gridview { width: 50%; border-collapse: collapse; margin-top: 20px; }
                    .gridview th, .gridview td { border: 1px solid #ddd; padding: 8px; }
                    .gridview th { background-color: #f2f2f2; text-align: left; }
                    .gridview tr:nth-child(even) { background-color: #f9f9f9; }
                    .gridview tr:hover { background-color: #f1f1f1; }
                    .action-buttons { margin-top: 15px;  padding: 5px 10px; background-color: #4CAF50; color: white;  border: none;    border-radius: 4px;  cursor: pointer;   }
                    .footer-row { background-color: #e6f7ff !important; }
                      .date-picker {  width: 120px;  padding: 5px;  text-align: center; cursor: pointer;  background-color: #fff;  border: 1px solid #ccc;  } 
         </style>
                <asp:GridView ID="gvData" runat="server" CssClass="grid-view" AutoGenerateColumns="false"
                AllowPaging="true" PageSize="20" OnPageIndexChanging="gvData_PageIndexChanging"
                         DataKeyNames="ID" 
                        OnRowEditing="gvData_RowEditing" 
                          OnRowCancelingEdit="gvData_RowCancelingEdit" 
                        OnRowUpdating="gvData_RowUpdating"
                             OnRowDeleting="gvData_RowDeleting"
                        OnRowDataBound="gvData_RowDataBound"
                        ShowFooter="True">
                <Columns>
                      <asp:TemplateField HeaderText="选择">
                         <ItemTemplate>
                             <asp:CheckBox ID="chkSelect" runat="server" />
                         </ItemTemplate>
                         <FooterTemplate>
                             <asp:Button ID="btnAdd" runat="server" Text="添加" OnClick="btnAdd_Click" />
                         </FooterTemplate>
                     </asp:TemplateField>
                    <asp:BoundField DataField="ID" HeaderText="ID" />
                           <asp:TemplateField HeaderText="资产名称">
                            <ItemTemplate>
                                <asp:Label ID="lblAssetName" runat="server" Text='<%# Eval("车牌号") %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtAssetName" runat="server" Text='<%# Bind("车牌号") %>' Width="80%"></asp:TextBox>
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:TextBox ID="txtNewAssetName" runat="server" Width="80%"></asp:TextBox>
                            </FooterTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="规格型号">
                         <ItemTemplate>
                             <asp:Label ID="lblSpec" runat="server" Text='<%# Eval("操作人") %>'></asp:Label>
                         </ItemTemplate>
                         <EditItemTemplate>
                             <asp:TextBox ID="txtSpec" runat="server" Text='<%# Bind("操作人") %>' Width="80%"></asp:TextBox>
                         </EditItemTemplate>
                         <FooterTemplate>
                             <asp:TextBox ID="txtNewSpec" runat="server" Width="80%"></asp:TextBox>
                         </FooterTemplate>
                     </asp:TemplateField>

                  
                           <asp:TemplateField HeaderText="时间" HeaderStyle-CssClass="table-header" ItemStyle-CssClass="time-column">
                            <ItemTemplate>
                                <asp:Label ID="Quantity" runat="server" Text='<%# Eval("时间", "{0:yyyy-MM-dd HH:mm}") %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                         
                                    <asp:TextBox ID="txtQuantity" runat="server" CssClass="form-control form-control-sm flatpickr-input" 
                                        Text='<%# Bind("时间", "{0:yyyy-MM-dd HH:mm}") %>' data-enable-time="true" data-date-format="Y-m-d H:i"></asp:TextBox>
                           
                            </EditItemTemplate>
                            <FooterTemplate>
                                <%--Text='<%# DateTime.Now.ToString("yyyy-MM-dd HH:mm") %>' data-enable-time="true" data-date-format="Y-m-d H:i"--%>
                                    <asp:TextBox ID="txtNewQuantity" runat="server" Width="80%" CssClass="date-picker"   ></asp:TextBox>
                            </FooterTemplate>
                        </asp:TemplateField>

                         <asp:TemplateField HeaderText="操作">
                             <ItemTemplate>
                                 <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" Text="编辑" />
                                 <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" Text="删除" 
                                     OnClientClick="return confirm('确定要删除这条记录吗？');" />
                             </ItemTemplate>
                             <EditItemTemplate>
                                 <asp:LinkButton ID="btnUpdate" runat="server" CommandName="Update" Text="更新" />
                                 <asp:LinkButton ID="btnCancel" runat="server" CommandName="Cancel" Text="取消" />
                             </EditItemTemplate>
                             <FooterTemplate>
                                 <!-- 底部留空 -->
                             </FooterTemplate>
                         </asp:TemplateField>
                </Columns>
                <PagerStyle CssClass="grid-pager" />
                <EmptyDataTemplate>
                    <div style="text-align:center;padding:90px;">
                        没有找到数据
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
                  <div class="action-buttons">
                          <asp:Button ID="btnDeleteSelected" runat="server" Text="删除选中项" 
                              OnClick="btnDeleteSelected_Click" OnClientClick="return confirm('确定要删除所有选中项吗？');" />
                  </div>

</asp:Content>

