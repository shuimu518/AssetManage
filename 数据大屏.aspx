<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="数据大屏.aspx.cs" Inherits="资产管理.数据大屏" %>



<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>无人车运营数据大屏</title>
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.4.3/dist/echarts.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/echarts/map/js/china.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Microsoft YaHei', 'Segoe UI', sans-serif;
        }
        
        :root {
            --primary: #00f7ff;
            --secondary: #0066ff;
            --accent: #ff00d6;
            --dark: #0a0e17;
            --darker: #060912;
            --card-bg: rgba(16, 35, 66, 0.2);
            --card-border: rgba(0, 247, 255, 0.2);
            --card-shadow: 0 0 20px rgba(0, 103, 255, 0.1);
        }
        
        body {
            background: var(--darker);
            color: #fff;
            min-height: 100vh;
            overflow: hidden;
            position: relative;
            display: flex;
            flex-direction: column;
        }
        
        /* 科技感背景 */
        .tech-bg {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            background: 
                radial-gradient(circle at 20% 30%, rgba(0, 103, 255, 0.1) 0%, transparent 40%),
                radial-gradient(circle at 80% 70%, rgba(255, 0, 214, 0.1) 0%, transparent 40%);
            background-color: var(--dark);
            overflow: hidden;
        }
        
        .grid-line {
            position: absolute;
            background: rgba(0, 247, 255, 0.05);
        }
        
        .grid-line.vertical {
            width: 1px;
            height: 100%;
            top: 0;
        }
        
        .grid-line.horizontal {
            height: 1px;
            width: 100%;
            left: 0;
        }
        
        /* 头部样式 */
        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 30px;
            position: relative;
            z-index: 10;
            background: rgba(10, 14, 23, 0.8);
            border-bottom: 1px solid var(--card-border);
        }
        
        .logo-section {
            display: flex;
            align-items: center;
        }
        
        .logo-section img {
            height: 60px;
            margin-right: 20px;
            filter: drop-shadow(0 0 10px var(--primary));
        }
        
        .title-section h1 {
            font-size: 2.5rem;
            letter-spacing: 2px;
            background: linear-gradient(to right, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-shadow: 0 0 15px rgba(0, 247, 255, 0.5);
            animation: titleGlow 3s infinite alternate;
        }
        
        .title-section p {
            font-size: 1rem;
            color: rgba(160, 193, 235, 0.7);
            margin-top: 5px;
            letter-spacing: 1px;
        }
        
        .time-section {
            text-align: right;
        }
        
        .time-section .current-time {
            font-size: 1.8rem;
            font-weight: bold;
            color: var(--primary);
            text-shadow: 0 0 10px rgba(0, 247, 255, 0.7);
        }
        
        .time-section .current-date {
            font-size: 1.2rem;
            color: rgba(160, 193, 235, 0.7);
        }
        
        .dashboard-content {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 20px;
            flex: 1;
            padding: 20px;
        }
        
        .main-section {
            display: grid;
            grid-template-rows: 1fr 1fr;
            gap: 20px;
        }
        
        /* 卡片通用样式 */
        .card {
            background: var(--card-bg);
            border-radius: 15px;
            padding: 20px;
            position: relative;
            border: 1px solid var(--card-border);
            box-shadow: var(--card-shadow);
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }
        
        .card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(to right, transparent, var(--primary), transparent);
            animation: scanline 3s linear infinite;
        }
        
        .card-title {
            font-size: 1.5rem;
            margin-bottom: 15px;
            color: var(--primary);
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-weight: bold;
            z-index: 2;
        }
        
        .card-content {
            flex: 1;
            position: relative;
            z-index: 1;
        }
        
        /* 地图容器 */
        #china-map {
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.3);
            border-radius: 10px;
        }
        
        /* 统计卡片 */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }
        
        .stat-card {
            background: var(--card-bg);
            border-radius: 15px;
            padding: 20px;
            border: 1px solid var(--card-border);
            box-shadow: var(--card-shadow);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 0 30px rgba(0, 247, 255, 0.3);
        }
        
        .stat-card::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(0, 247, 255, 0.1) 0%, transparent 70%);
            z-index: 0;
        }
        
        .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 15px;
            z-index: 1;
            text-shadow: 0 0 10px var(--primary);
        }
        
        .stat-value {
            font-size: 2.2rem;
            font-weight: bold;
            margin-bottom: 5px;
            color: var(--primary);
            z-index: 1;
            text-shadow: 0 0 10px rgba(0, 247, 255, 0.7);
        }
        
        .stat-label {
            font-size: 1rem;
            color: rgba(160, 193, 235, 0.7);
            z-index: 1;
        }
        
        /* 侧边栏 */
        .side-section {
            display: grid;
            grid-template-rows: 1fr 1fr;
            gap: 20px;
        }
        
        .vehicle-list {
            background: var(--card-bg);
            border-radius: 15px;
            padding: 20px;
            border: 1px solid var(--card-border);
            box-shadow: var(--card-shadow);
            overflow-y: auto;
        }
        
        .section-title {
            font-size: 1.5rem;
            margin-bottom: 15px;
            color: var(--primary);
            font-weight: bold;
        }
        
        .platform-tabs {
            display: flex;
            margin-bottom: 15px;
            background: rgba(22, 50, 92, 0.2);
            border-radius: 10px;
            overflow: hidden;
            border: 1px solid var(--card-border);
        }
        
        .platform-tab {
            flex: 1;
            text-align: center;
            padding: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
            background: rgba(10, 20, 40, 0.5);
            color: rgba(160, 193, 235, 0.7);
        }
        
        .platform-tab.active {
            background: var(--secondary);
            color: white;
            box-shadow: 0 0 15px rgba(0, 103, 255, 0.5);
        }
        
        .vehicle-item {
            display: flex;
            align-items: center;
            padding: 12px 15px;
            margin-bottom: 10px;
            background: rgba(22, 50, 92, 0.2);
            border-radius: 10px;
            transition: all 0.3s ease;
            border: 1px solid var(--card-border);
        }
        
        .vehicle-item:hover {
            background: rgba(22, 50, 92, 0.4);
            transform: translateX(5px);
            box-shadow: 0 0 15px rgba(0, 247, 255, 0.2);
        }
        
        .vehicle-icon {
            width: 40px;
            height: 40px;
            background: var(--secondary);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            font-size: 1.2rem;
            font-weight: bold;
            box-shadow: 0 0 10px rgba(0, 103, 255, 0.5);
        }
        
        .vehicle-info {
            flex: 1;
        }
        
        .vehicle-name {
            font-size: 1.1rem;
            margin-bottom: 3px;
            color: white;
        }
        
        .vehicle-status {
            font-size: 0.9rem;
            color: rgba(160, 193, 235, 0.7);
            display: flex;
            align-items: center;
        }
        
        .status-indicator {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            margin-right: 8px;
            display: inline-block;
            box-shadow: 0 0 5px currentColor;
        }
        
        .status-online {
            background: #00ff00;
            animation: pulse 1.5s infinite;
        }
        
        .status-offline {
            background: #ff0000;
        }
        
        .status-busy {
            background: #ffff00;
            animation: pulse 1s infinite;
        }
        
        .chart-container {
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.3);
            border-radius: 10px;
        }
        
        /* 底部图表区域 */
        .dashboard-bottom {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            padding: 0 20px 20px;
        }
        
        .chart-card {
            background: var(--card-bg);
            border-radius: 15px;
            padding: 20px;
            border: 1px solid var(--card-border);
            box-shadow: var(--card-shadow);
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }
        
        .chart-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(to right, transparent, var(--primary), transparent);
            animation: scanline 3s linear infinite;
        }
        
        .chart-title {
            font-size: 1.2rem;
            margin-bottom: 15px;
            color: var(--primary);
            font-weight: bold;
            z-index: 2;
        }
        
        .chart-content {
            flex: 1;
            position: relative;
            z-index: 1;
        }
        
        .dashboard-footer {
            text-align: center;
            padding: 10px;
            color: rgba(160, 193, 235, 0.7);
            font-size: 0.9rem;
            background: rgba(10, 14, 23, 0.8);
            border-top: 1px solid var(--card-border);
        }
        
        /* 动画效果 */
        @keyframes pulse {
            0% { opacity: 0.4; }
            50% { opacity: 1; }
            100% { opacity: 0.4; }
        }
        
        @keyframes scanline {
            0% { transform: translateX(-100%); }
            100% { transform: translateX(100%); }
        }
        
        @keyframes titleGlow {
            0% { text-shadow: 0 0 15px rgba(0, 247, 255, 0.5); }
            100% { text-shadow: 0 0 25px rgba(0, 247, 255, 0.8), 0 0 40px rgba(0, 247, 255, 0.6); }
        }
        
        /* 滚动条样式 */
        .vehicle-list::-webkit-scrollbar {
            width: 6px;
        }
        
        .vehicle-list::-webkit-scrollbar-track {
            background: rgba(0, 0, 0, 0.1);
            border-radius: 3px;
        }
        
        .vehicle-list::-webkit-scrollbar-thumb {
            background: var(--primary);
            border-radius: 3px;
        }
    </style>
</head>
<body>
    <!-- 科技感背景 -->
    <div class="tech-bg" id="tech-bg"></div>
    
    <div class="dashboard-header">
        <div class="logo-section">
            <img src="https://31580832.s21i.faiusr.com/4/ABUIABAEGAAglZ6PqQYogL_lywcw9wU44AY.png" alt="无人车管理系统">
            <div class="title-section">
                <h1>无人车运营数据大屏</h1>
                <p>九识智能 & 菜鸟蛮驴 | 全国车辆实时监控系统</p>
            </div>
        </div>
        <div class="time-section">
            <div class="current-time">14:28:36</div>
            <div class="current-date">2023年11月15日 星期三</div>
        </div>
    </div>
    
    <div class="dashboard-content">
        <div class="main-section">
            <div class="card">
                <div class="card-title">
                    <span>全国无人车分布热力图</span>
                    <div class="map-legend">
                        <div class="legend-item">
                            <div class="legend-color" style="background-color: #00ff00;"></div>
                            <span>九识智能</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-color" style="background-color: #00f7ff;"></div>
                            <span>菜鸟蛮驴</span>
                        </div>
                    </div>
                </div>
                <div class="card-content">
                    <div id="china-map" class="chart-container"></div>
                </div>
            </div>
            
            <div class="stats-container">
                <div class="stat-card">
                    <div class="stat-icon">🚗</div>
                    <div class="stat-value">1,248</div>
                    <div class="stat-label">在线车辆总数</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">📦</div>
                    <div class="stat-value">8,562</div>
                    <div class="stat-label">今日配送包裹</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">📊</div>
                    <div class="stat-value">96.8%</div>
                    <div class="stat-label">准时送达率</div>
                </div>
            </div>
        </div>
        
        <div class="side-section">
            <div class="vehicle-list">
                <div class="section-title">车辆实时状态</div>
                <div class="platform-tabs">
                    <div class="platform-tab active">九识智能</div>
                    <div class="platform-tab">菜鸟蛮驴</div>
                </div>
                
                <div class="vehicle-items">
                    <div class="vehicle-item">
                        <div class="vehicle-icon">九</div>
                        <div class="vehicle-info">
                            <div class="vehicle-name">京A-9S001</div>
                            <div class="vehicle-status">
                                <span class="status-indicator status-online"></span>
                                北京市海淀区 | 配送中
                            </div>
                        </div>
                    </div>
                    
                    <div class="vehicle-item">
                        <div class="vehicle-icon">九</div>
                        <div class="vehicle-info">
                            <div class="vehicle-name">沪B-9S045</div>
                            <div class="vehicle-status">
                                <span class="status-indicator status-busy"></span>
                                上海市浦东新区 | 装载中
                            </div>
                        </div>
                    </div>
                    
                    <div class="vehicle-item">
                        <div class="vehicle-icon">菜</div>
                        <div class="vehicle-info">
                            <div class="vehicle-name">粤C-ML128</div>
                            <div class="vehicle-status">
                                <span class="status-indicator status-online"></span>
                                广州市天河区 | 待命
                            </div>
                        </div>
                    </div>
                    
                    <div class="vehicle-item">
                        <div class="vehicle-icon">九</div>
                        <div class="vehicle-info">
                            <div class="vehicle-name">深D-9S078</div>
                            <div class="vehicle-status">
                                <span class="status-indicator status-online"></span>
                                深圳市南山区 | 配送中
                            </div>
                        </div>
                    </div>
                    
                    <div class="vehicle-item">
                        <div class="vehicle-icon">菜</div>
                        <div class="vehicle-info">
                            <div class="vehicle-name">杭E-ML056</div>
                            <div class="vehicle-status">
                                <span class="status-indicator status-online"></span>
                                杭州市西湖区 | 返程中
                            </div>
                        </div>
                    </div>
                    
                    <div class="vehicle-item">
                        <div class="vehicle-icon">九</div>
                        <div class="vehicle-info">
                            <div class="vehicle-name">津F-9S112</div>
                            <div class="vehicle-status">
                                <span class="status-indicator status-offline"></span>
                                天津市滨海新区 | 维护中
                            </div>
                        </div>
                    </div>
                    
                    <div class="vehicle-item">
                        <div class="vehicle-icon">菜</div>
                        <div class="vehicle-info">
                            <div class="vehicle-name">渝G-ML092</div>
                            <div class="vehicle-status">
                                <span class="status-indicator status-busy"></span>
                                重庆市渝中区 | 装载中
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="card">
                <div class="card-title">车辆利用率分析</div>
                <div class="card-content">
                    <div id="utilization-chart" class="chart-container"></div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 底部三个图表容器 -->
    <div class="dashboard-bottom">
        <div class="chart-card">
            <div class="chart-title">车辆状态分布</div>
            <div class="chart-content">
                <div id="status-chart" class="chart-container"></div>
            </div>
        </div>
        <div class="chart-card">
            <div class="chart-title">任务完成情况</div>
            <div class="chart-content">
                <div id="task-chart" class="chart-container"></div>
            </div>
        </div>
        <div class="chart-card">
            <div class="chart-title">电池状态监控</div>
            <div class="chart-content">
                <div id="battery-chart" class="chart-container"></div>
            </div>
        </div>
    </div>
    
    <div class="dashboard-footer">
        <p>数据更新时间: 2023-11-15 14:28:36 | 系统版本: V2.3.5 | © 2023 无人车运营数据平台</p>
    </div>

    <script>
        // 初始化中国地图
        const mapChart = echarts.init(document.getElementById('china-map'));

        // 模拟数据 - 九识智能车辆分布
        const jiusiData = [
            { name: '北京', value: 128 },
            { name: '上海', value: 96 },
            { name: '广州', value: 85 },
            { name: '深圳', value: 78 },
            { name: '杭州', value: 65 },
            { name: '成都', value: 58 },
            { name: '武汉', value: 52 },
            { name: '南京', value: 48 },
            { name: '重庆', value: 45 },
            { name: '天津', value: 42 },
            { name: '西安', value: 38 },
            { name: '苏州', value: 35 },
            { name: '郑州', value: 32 },
            { name: '长沙', value: 28 },
            { name: '合肥', value: 25 }
        ];

        // 模拟数据 - 菜鸟蛮驴车辆分布
        const cainiaoData = [
            { name: '北京', value: 95 },
            { name: '上海', value: 88 },
            { name: '广州', value: 76 },
            { name: '深圳', value: 72 },
            { name: '杭州', value: 92 },
            { name: '成都', value: 65 },
            { name: '武汉', value: 48 },
            { name: '南京', value: 42 },
            { name: '重庆', value: 38 },
            { name: '天津', value: 35 },
            { name: '西安', value: 32 },
            { name: '苏州', value: 28 },
            { name: '郑州', value: 26 },
            { name: '长沙', value: 22 },
            { name: '合肥', value: 20 }
        ];

        // 地图配置
        const mapOption = {
            backgroundColor: 'transparent',
            tooltip: {
                trigger: 'item',
                formatter: function (params) {
                    return `${params.name}<br/>
                    九识智能: ${jiusiData.find(d => d.name === params.name)?.value || 0}辆<br/>
                    菜鸟蛮驴: ${cainiaoData.find(d => d.name === params.name)?.value || 0}辆`;
                }
            },
            visualMap: {
                min: 0,
                max: 150,
                text: ['高', '低'],
                realtime: false,
                calculable: true,
                inRange: {
                    color: ['#4575b4', '#74add1', '#abd9e9', '#e0f3f8', '#ffffbf', '#fee090', '#fdae61', '#f46d43', '#d73027']
                },
                textStyle: {
                    color: '#fff'
                }
            },
            series: [
                {
                    name: '九识智能',
                    type: 'map',
                    map: 'china',
                    roam: true,
                    zoom: 1.2,
                    label: {
                        show: true,
                        fontSize: 10,
                        color: '#fff'
                    },
                    emphasis: {
                        label: {
                            show: true,
                            color: '#fff'
                        },
                        itemStyle: {
                            areaColor: '#40c057'
                        }
                    },
                    itemStyle: {
                        areaColor: 'rgba(23, 50, 77, 0.5)',
                        borderColor: '#00f7ff'
                    },
                    data: jiusiData
                },
                {
                    name: '菜鸟蛮驴',
                    type: 'effectScatter',
                    coordinateSystem: 'geo',
                    data: cainiaoData.map(item => ({
                        name: item.name,
                        value: [Math.random() * 10 + 110, Math.random() * 5 + 30, item.value]
                    })),
                    symbolSize: function (val) {
                        return Math.sqrt(val[2]) * 3;
                    },
                    showEffectOn: 'render',
                    rippleEffect: {
                        brushType: 'stroke'
                    },
                    hoverAnimation: true,
                    itemStyle: {
                        color: '#4dabf7',
                        shadowBlur: 10,
                        shadowColor: '#4dabf7'
                    },
                    zlevel: 1
                }
            ]
        };

        mapChart.setOption(mapOption);

        // 初始化利用率图表
        const utilChart = echarts.init(document.getElementById('utilization-chart'));

        const utilOption = {
            backgroundColor: 'transparent',
            tooltip: {
                trigger: 'axis',
                backgroundColor: 'rgba(10, 14, 23, 0.9)',
                borderColor: 'rgba(0, 247, 255, 0.5)',
                textStyle: {
                    color: '#fff'
                }
            },
            legend: {
                data: ['九识智能', '菜鸟蛮驴'],
                textStyle: {
                    color: '#a0c1eb'
                },
                right: 10,
                top: 10
            },
            grid: {
                left: '3%',
                right: '4%',
                bottom: '3%',
                top: '15%',
                containLabel: true
            },
            xAxis: {
                type: 'category',
                boundaryGap: false,
                data: ['00:00', '04:00', '08:00', '12:00', '16:00', '20:00'],
                axisLine: {
                    lineStyle: {
                        color: 'rgba(160, 193, 235, 0.5)'
                    }
                },
                axisLabel: {
                    color: 'rgba(160, 193, 235, 0.7)'
                }
            },
            yAxis: {
                type: 'value',
                axisLabel: {
                    formatter: '{value}%',
                    color: 'rgba(160, 193, 235, 0.7)'
                },
                axisLine: {
                    lineStyle: {
                        color: 'rgba(160, 193, 235, 0.5)'
                    }
                },
                splitLine: {
                    lineStyle: {
                        color: 'rgba(160, 193, 235, 0.1)'
                    }
                }
            },
            series: [
                {
                    name: '九识智能',
                    type: 'line',
                    smooth: true,
                    symbol: 'circle',
                    symbolSize: 8,
                    lineStyle: {
                        width: 3,
                        color: '#00ff00'
                    },
                    itemStyle: {
                        color: '#00ff00'
                    },
                    areaStyle: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                            { offset: 0, color: 'rgba(0, 255, 0, 0.3)' },
                            { offset: 1, color: 'rgba(0, 255, 0, 0.05)' }
                        ])
                    },
                    data: [28, 35, 72, 88, 84, 65]
                },
                {
                    name: '菜鸟蛮驴',
                    type: 'line',
                    smooth: true,
                    symbol: 'circle',
                    symbolSize: 8,
                    lineStyle: {
                        width: 3,
                        color: '#00f7ff'
                    },
                    itemStyle: {
                        color: '#00f7ff'
                    },
                    areaStyle: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                            { offset: 0, color: 'rgba(0, 247, 255, 0.3)' },
                            { offset: 1, color: 'rgba(0, 247, 255, 0.05)' }
                        ])
                    },
                    data: [32, 40, 68, 92, 78, 60]
                }
            ]
        };

        utilChart.setOption(utilOption);

        // 车辆状态分布饼图
        const statusChart = echarts.init(document.getElementById('status-chart'));
        const statusOption = {
            backgroundColor: 'transparent',
            tooltip: {
                trigger: 'item',
                formatter: '{a} <br/>{b}: {c}辆 ({d}%)',
                backgroundColor: 'rgba(10, 14, 23, 0.9)',
                borderColor: 'rgba(0, 247, 255, 0.5)',
                textStyle: {
                    color: '#fff'
                }
            },
            legend: {
                orient: 'vertical',
                right: 10,
                top: 'center',
                textStyle: {
                    color: '#a0c1eb'
                },
                data: ['在线', '忙碌', '离线', '维护']
            },
            series: [
                {
                    name: '车辆状态',
                    type: 'pie',
                    radius: ['40%', '70%'],
                    center: ['40%', '50%'],
                    avoidLabelOverlap: false,
                    itemStyle: {
                        borderRadius: 10,
                        borderColor: '#0a0e17',
                        borderWidth: 2
                    },
                    label: {
                        show: false,
                        position: 'center'
                    },
                    emphasis: {
                        label: {
                            show: true,
                            fontSize: '18',
                            fontWeight: 'bold',
                            color: '#00f7ff'
                        }
                    },
                    labelLine: {
                        show: false
                    },
                    data: [
                        { value: 928, name: '在线', itemStyle: { color: '#00ff00' } },
                        { value: 245, name: '忙碌', itemStyle: { color: '#ffff00' } },
                        { value: 62, name: '离线', itemStyle: { color: '#ff0000' } },
                        { value: 13, name: '维护', itemStyle: { color: '#cc00ff' } }
                    ]
                }
            ]
        };
        statusChart.setOption(statusOption);

        // 任务完成情况柱状图
        const taskChart = echarts.init(document.getElementById('task-chart'));
        const taskOption = {
            backgroundColor: 'transparent',
            tooltip: {
                trigger: 'axis',
                axisPointer: {
                    type: 'shadow'
                },
                backgroundColor: 'rgba(10, 14, 23, 0.9)',
                borderColor: 'rgba(0, 247, 255, 0.5)',
                textStyle: {
                    color: '#fff'
                }
            },
            legend: {
                data: ['九识智能', '菜鸟蛮驴'],
                textStyle: {
                    color: '#a0c1eb'
                },
                right: 10,
                top: 10
            },
            grid: {
                left: '3%',
                right: '4%',
                bottom: '3%',
                top: '15%',
                containLabel: true
            },
            xAxis: {
                type: 'category',
                data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日'],
                axisLine: {
                    lineStyle: {
                        color: 'rgba(160, 193, 235, 0.5)'
                    }
                },
                axisLabel: {
                    color: 'rgba(160, 193, 235, 0.7)'
                }
            },
            yAxis: {
                type: 'value',
                name: '任务数量',
                nameTextStyle: {
                    color: 'rgba(160, 193, 235, 0.7)'
                },
                axisLine: {
                    lineStyle: {
                        color: 'rgba(160, 193, 235, 0.5)'
                    }
                },
                axisLabel: {
                    color: 'rgba(160, 193, 235, 0.7)'
                },
                splitLine: {
                    lineStyle: {
                        color: 'rgba(160, 193, 235, 0.1)'
                    }
                }
            },
            series: [
                {
                    name: '九识智能',
                    type: 'bar',
                    barWidth: '40%',
                    data: [1245, 1320, 1450, 1570, 1490, 1380, 1260],
                    itemStyle: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                            { offset: 0, color: '#00ff00' },
                            { offset: 1, color: '#003300' }
                        ])
                    }
                },
                {
                    name: '菜鸟蛮驴',
                    type: 'bar',
                    barWidth: '40%',
                    data: [980, 1040, 1150, 1260, 1180, 1070, 950],
                    itemStyle: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                            { offset: 0, color: '#00f7ff' },
                            { offset: 1, color: '#003366' }
                        ])
                    }
                }
            ]
        };
        taskChart.setOption(taskOption);

        // 电池状态折线图
        const batteryChart = echarts.init(document.getElementById('battery-chart'));
        const batteryOption = {
            backgroundColor: 'transparent',
            tooltip: {
                trigger: 'axis',
                backgroundColor: 'rgba(10, 14, 23, 0.9)',
                borderColor: 'rgba(0, 247, 255, 0.5)',
                textStyle: {
                    color: '#fff'
                }
            },
            legend: {
                data: ['电量水平', '充电状态'],
                textStyle: {
                    color: '#a0c1eb'
                },
                right: 10,
                top: 10
            },
            grid: {
                left: '3%',
                right: '4%',
                bottom: '3%',
                top: '15%',
                containLabel: true
            },
            xAxis: {
                type: 'category',
                boundaryGap: false,
                data: ['00:00', '04:00', '08:00', '12:00', '16:00', '20:00', '24:00'],
                axisLine: {
                    lineStyle: {
                        color: 'rgba(160, 193, 235, 0.5)'
                    }
                },
                axisLabel: {
                    color: 'rgba(160, 193, 235, 0.7)'
                }
            },
            yAxis: [
                {
                    type: 'value',
                    name: '电量百分比',
                    min: 0,
                    max: 100,
                    axisLine: {
                        lineStyle: {
                            color: 'rgba(160, 193, 235, 0.5)'
                        }
                    },
                    axisLabel: {
                        formatter: '{value}%',
                        color: 'rgba(160, 193, 235, 0.7)'
                    },
                    splitLine: {
                        lineStyle: {
                            color: 'rgba(160, 193, 235, 0.1)'
                        }
                    }
                },
                {
                    type: 'value',
                    name: '充电车辆',
                    min: 0,
                    max: 300,
                    axisLine: {
                        lineStyle: {
                            color: 'rgba(160, 193, 235, 0.5)'
                        }
                    },
                    axisLabel: {
                        color: 'rgba(160, 193, 235, 0.7)'
                    },
                    splitLine: {
                        show: false
                    }
                }
            ],
            series: [
                {
                    name: '电量水平',
                    type: 'line',
                    smooth: true,
                    data: [82, 76, 68, 62, 58, 45, 32],
                    lineStyle: {
                        width: 3,
                        color: '#00ff00'
                    },
                    itemStyle: {
                        color: '#00ff00'
                    },
                    areaStyle: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                            { offset: 0, color: 'rgba(0, 255, 0, 0.3)' },
                            { offset: 1, color: 'rgba(0, 255, 0, 0.05)' }
                        ])
                    }
                },
                {
                    name: '充电状态',
                    type: 'bar',
                    yAxisIndex: 1,
                    data: [45, 62, 98, 120, 145, 205, 245],
                    itemStyle: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                            { offset: 0, color: '#00f7ff' },
                            { offset: 1, color: '#0066ff' }
                        ])
                    }
                }
            ]
        };
        batteryChart.setOption(batteryOption);

        // 更新时间
        function updateTime() {
            const now = new Date();
            const timeStr = now.toLocaleTimeString('zh-CN', { hour12: false });
            const dateStr = now.toLocaleDateString('zh-CN', {
                year: 'numeric',
                month: 'long',
                day: 'numeric',
                weekday: 'long'
            });

            document.querySelector('.current-time').textContent = timeStr;
            document.querySelector('.current-date').textContent = dateStr;
        }

        setInterval(updateTime, 1000);
        updateTime();

        // 响应窗口大小变化
        function resizeCharts() {
            mapChart.resize();
            utilChart.resize();
            statusChart.resize();
            taskChart.resize();
            batteryChart.resize();
        }

        window.addEventListener('resize', resizeCharts);

        // 平台切换
        document.querySelectorAll('.platform-tab').forEach(tab => {
            tab.addEventListener('click', function () {
                document.querySelectorAll('.platform-tab').forEach(t => t.classList.remove('active'));
                this.classList.add('active');
            });
        });

        // 创建科技感背景网格
        function createGrid() {
            const gridContainer = document.getElementById('tech-bg');
            const width = window.innerWidth;
            const height = window.innerHeight;

            // 清除现有网格
            while (gridContainer.firstChild) {
                gridContainer.removeChild(gridContainer.firstChild);
            }

            // 创建垂直线
            for (let i = 0; i < width; i += 50) {
                const line = document.createElement('div');
                line.className = 'grid-line vertical';
                line.style.left = i + 'px';
                gridContainer.appendChild(line);
            }

            // 创建水平线
            for (let i = 0; i < height; i += 50) {
                const line = document.createElement('div');
                line.className = 'grid-line horizontal';
                line.style.top = i + 'px';
                gridContainer.appendChild(line);
            }
        }

        // 初始化和响应式调整
        createGrid();
        window.addEventListener('resize', createGrid);

        // 初始化调整
        setTimeout(resizeCharts, 100);
    </script>
</body>
</html>
<%--<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无人车运营数据大屏</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.4.3/dist/echarts.min.js"></script>
    <style>
        :root {
            --primary: #00f7ff;
            --secondary: #0066ff;
            --accent: #ff00d6;
            --dark: #0a0e17;
            --darker: #060912;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Microsoft YaHei', 'Segoe UI', sans-serif;
        }
        
        body {
            background: var(--darker);
            color: #fff;
            height: 100vh;
            overflow: hidden;
            position: relative;
        }
        
        /* 科技感背景 */
        .tech-bg {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            background: 
                radial-gradient(circle at 20% 30%, rgba(0, 103, 255, 0.1) 0%, transparent 40%),
                radial-gradient(circle at 80% 70%, rgba(255, 0, 214, 0.1) 0%, transparent 40%);
            background-color: var(--dark);
            overflow: hidden;
        }
        
        .grid-line {
            position: absolute;
            background: rgba(0, 247, 255, 0.05);
        }
        
        .grid-line.vertical {
            width: 1px;
            height: 100%;
            top: 0;
        }
        
        .grid-line.horizontal {
            height: 1px;
            width: 100%;
            left: 0;
        }
        
        /* 头部样式 */
        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 30px;
            position: relative;
            z-index: 10;
            background: rgba(10, 14, 23, 0.8);
            border-bottom: 1px solid rgba(0, 247, 255, 0.2);
        }
        
        .logo-section {
            display: flex;
            align-items: center;
        }
        
        .logo-section img {
            height: 60px;
            margin-right: 20px;
            filter: drop-shadow(0 0 10px var(--primary));
        }
        
        .title-section h1 {
            font-size: 2.5rem;
            letter-spacing: 2px;
            background: linear-gradient(to right, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-shadow: 0 0 15px rgba(0, 247, 255, 0.5);
            animation: titleGlow 3s infinite alternate;
        }
        
        .title-section p {
            font-size: 1rem;
            color: rgba(160, 193, 235, 0.7);
            margin-top: 5px;
            letter-spacing: 1px;
        }
        
        .time-section {
            text-align: right;
        }
        
        .time-section .current-time {
            font-size: 1.8rem;
            font-weight: bold;
            color: var(--primary);
            text-shadow: 0 0 10px rgba(0, 247, 255, 0.7);
        }
        
        .time-section .current-date {
            font-size: 1.2rem;
            color: rgba(160, 193, 235, 0.7);
        }
        
        .dashboard-content {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 20px;
            height: calc(100vh - 120px);
            padding: 20px;
        }
        
        .main-section {
            display: grid;
            grid-template-rows: 1fr 1fr;
            gap: 20px;
        }
        
        /* 地图容器 */
        .map-container {
            background: rgba(16, 35, 66, 0.2);
            border-radius: 15px;
            padding: 20px;
            position: relative;
            border: 1px solid rgba(0, 247, 255, 0.2);
            box-shadow: 0 0 30px rgba(0, 103, 255, 0.2);
            overflow: hidden;
        }
        
        .map-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(to right, transparent, var(--primary), transparent);
            animation: scanline 3s linear infinite;
        }
        
        .map-title {
            font-size: 1.5rem;
            margin-bottom: 15px;
            color: var(--primary);
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-weight: bold;
        }
        
        .map-legend {
            display: flex;
            gap: 20px;
        }
        
        .legend-item {
            display: flex;
            align-items: center;
            font-size: 0.9rem;
        }
        
        .legend-color {
            width: 15px;
            height: 15px;
            border-radius: 50%;
            margin-right: 5px;
            box-shadow: 0 0 8px currentColor;
        }
        
        #china-map {
            width: 100%;
            height: calc(100% - 40px);
            background: rgba(0, 0, 0, 0.3);
            border-radius: 10px;
        }
        
        /* 统计卡片 */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }
        
        .stat-card {
            background: rgba(16, 35, 66, 0.2);
            border-radius: 15px;
            padding: 20px;
            border: 1px solid rgba(0, 247, 255, 0.2);
            box-shadow: 0 0 20px rgba(0, 103, 255, 0.1);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 0 30px rgba(0, 247, 255, 0.3);
        }
        
        .stat-card::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(0, 247, 255, 0.1) 0%, transparent 70%);
            z-index: 0;
        }
        
        .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 15px;
            z-index: 1;
            text-shadow: 0 0 10px var(--primary);
        }
        
        .stat-value {
            font-size: 2.2rem;
            font-weight: bold;
            margin-bottom: 5px;
            color: var(--primary);
            z-index: 1;
            text-shadow: 0 0 10px rgba(0, 247, 255, 0.7);
        }
        
        .stat-label {
            font-size: 1rem;
            color: rgba(160, 193, 235, 0.7);
            z-index: 1;
        }
        
        /* 侧边栏 */
        .side-section {
            display: grid;
            grid-template-rows: 1fr 1fr;
            gap: 20px;
        }
        
        .vehicle-list {
            background: rgba(16, 35, 66, 0.2);
            border-radius: 15px;
            padding: 20px;
            border: 1px solid rgba(0, 247, 255, 0.2);
            box-shadow: 0 0 20px rgba(0, 103, 255, 0.1);
            overflow-y: auto;
        }
        
        .section-title {
            font-size: 1.5rem;
            margin-bottom: 15px;
            color: var(--primary);
            font-weight: bold;
        }
        
        .platform-tabs {
            display: flex;
            margin-bottom: 15px;
            background: rgba(22, 50, 92, 0.2);
            border-radius: 10px;
            overflow: hidden;
            border: 1px solid rgba(0, 247, 255, 0.2);
        }
        
        .platform-tab {
            flex: 1;
            text-align: center;
            padding: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
            background: rgba(10, 20, 40, 0.5);
            color: rgba(160, 193, 235, 0.7);
        }
        
        .platform-tab.active {
            background: var(--secondary);
            color: white;
            box-shadow: 0 0 15px rgba(0, 103, 255, 0.5);
        }
        
        .vehicle-item {
            display: flex;
            align-items: center;
            padding: 12px 15px;
            margin-bottom: 10px;
            background: rgba(22, 50, 92, 0.2);
            border-radius: 10px;
            transition: all 0.3s ease;
            border: 1px solid rgba(0, 247, 255, 0.1);
        }
        
        .vehicle-item:hover {
            background: rgba(22, 50, 92, 0.4);
            transform: translateX(5px);
            box-shadow: 0 0 15px rgba(0, 247, 255, 0.2);
        }
        
        .vehicle-icon {
            width: 40px;
            height: 40px;
            background: var(--secondary);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            font-size: 1.2rem;
            font-weight: bold;
            box-shadow: 0 0 10px rgba(0, 103, 255, 0.5);
        }
        
        .vehicle-info {
            flex: 1;
        }
        
        .vehicle-name {
            font-size: 1.1rem;
            margin-bottom: 3px;
            color: white;
        }
        
        .vehicle-status {
            font-size: 0.9rem;
            color: rgba(160, 193, 235, 0.7);
            display: flex;
            align-items: center;
        }
        
        .status-indicator {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            margin-right: 8px;
            display: inline-block;
            box-shadow: 0 0 5px currentColor;
        }
        
        .status-online {
            background: #00ff00;
            animation: pulse 1.5s infinite;
        }
        
        .status-offline {
            background: #ff0000;
        }
        
        .status-busy {
            background: #ffff00;
            animation: pulse 1s infinite;
        }
        
        .data-chart {
            background: rgba(16, 35, 66, 0.2);
            border-radius: 15px;
            padding: 20px;
            border: 1px solid rgba(0, 247, 255, 0.2);
            box-shadow: 0 0 20px rgba(0, 103, 255, 0.1);
        }
        
        .chart-container {
            width: 100%;
            height: 300px;
            background: rgba(0, 0, 0, 0.3);
            border-radius: 10px;
        }
        
        .dashboard-footer {
            text-align: center;
            padding: 10px;
            color: rgba(160, 193, 235, 0.7);
            font-size: 0.9rem;
            position: absolute;
            bottom: 0;
            width: 100%;
            background: rgba(10, 14, 23, 0.8);
            border-top: 1px solid rgba(0, 247, 255, 0.2);
        }
        
        /* 动画效果 */
        @keyframes pulse {
            0% { opacity: 0.4; }
            50% { opacity: 1; }
            100% { opacity: 0.4; }
        }
        
        @keyframes scanline {
            0% { transform: translateX(-100%); }
            100% { transform: translateX(100%); }
        }
        
        @keyframes titleGlow {
            0% { text-shadow: 0 0 15px rgba(0, 247, 255, 0.5); }
            100% { text-shadow: 0 0 25px rgba(0, 247, 255, 0.8), 0 0 40px rgba(0, 247, 255, 0.6); }
        }
        
        /* 滚动条样式 */
        .vehicle-list::-webkit-scrollbar {
            width: 6px;
        }
        
        .vehicle-list::-webkit-scrollbar-track {
            background: rgba(0, 0, 0, 0.1);
            border-radius: 3px;
        }
        
        .vehicle-list::-webkit-scrollbar-thumb {
            background: var(--primary);
            border-radius: 3px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- 科技感背景 -->
        <div class="tech-bg" id="tech-bg"></div>
        
        <div class="dashboard-header">
            <div class="logo-section">
                <img src="https://31580832.s21i.faiusr.com/4/ABUIABAEGAAglZ6PqQYogL_lywcw9wU44AY.png" alt="无人车管理系统">
                <div class="title-section">
                    <h1>无人车运营数据大屏</h1>
                    <p>九识智能 & 菜鸟蛮驴 | 全国车辆实时监控系统</p>
                </div>
            </div>
            <div class="time-section">
                <div class="current-time">14:28:36</div>
                <div class="current-date">2023年11月15日 星期三</div>
            </div>
        </div>
        
        <div class="dashboard-content">
            <div class="main-section">
                <div class="map-container">
                    <div class="map-title">
                        <span>全国无人车分布热力图</span>
                        <div class="map-legend">
                            <div class="legend-item">
                                <div class="legend-color" style="background-color: #00ff00;"></div>
                                <span>九识智能</span>
                            </div>
                            <div class="legend-item">
                                <div class="legend-color" style="background-color: #00f7ff;"></div>
                                <span>菜鸟蛮驴</span>
                            </div>
                        </div>
                    </div>
                    <div id="china-map"></div>
                </div>
                
                <div class="stats-container">
                    <div class="stat-card">
                        <div class="stat-icon">🚗</div>
                        <div class="stat-value">1,248</div>
                        <div class="stat-label">在线车辆总数</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon">📦</div>
                        <div class="stat-value">8,562</div>
                        <div class="stat-label">今日配送包裹</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon">📊</div>
                        <div class="stat-value">96.8%</div>
                        <div class="stat-label">准时送达率</div>
                    </div>
                </div>
            </div>
            
            <div class="side-section">
                <div class="vehicle-list">
                    <div class="section-title">车辆实时状态</div>
                    <div class="platform-tabs">
                        <div class="platform-tab active">九识智能</div>
                        <div class="platform-tab">菜鸟蛮驴</div>
                    </div>
                    
                    <div class="vehicle-items">
                        <div class="vehicle-item">
                            <div class="vehicle-icon">九</div>
                            <div class="vehicle-info">
                                <div class="vehicle-name">京A-9S001</div>
                                <div class="vehicle-status">
                                    <span class="status-indicator status-online"></span>
                                    北京市海淀区 | 配送中
                                </div>
                            </div>
                        </div>
                        
                        <div class="vehicle-item">
                            <div class="vehicle-icon">九</div>
                            <div class="vehicle-info">
                                <div class="vehicle-name">沪B-9S045</div>
                                <div class="vehicle-status">
                                    <span class="status-indicator status-busy"></span>
                                    上海市浦东新区 | 装载中
                                </div>
                            </div>
                        </div>
                        
                        <div class="vehicle-item">
                            <div class="vehicle-icon">菜</div>
                            <div class="vehicle-info">
                                <div class="vehicle-name">粤C-ML128</div>
                                <div class="vehicle-status">
                                    <span class="status-indicator status-online"></span>
                                    广州市天河区 | 待命
                                </div>
                            </div>
                        </div>
                        
                        <div class="vehicle-item">
                            <div class="vehicle-icon">九</div>
                            <div class="vehicle-info">
                                <div class="vehicle-name">深D-9S078</div>
                                <div class="vehicle-status">
                                    <span class="status-indicator status-online"></span>
                                    深圳市南山区 | 配送中
                                </div>
                            </div>
                        </div>
                        
                        <div class="vehicle-item">
                            <div class="vehicle-icon">菜</div>
                            <div class="vehicle-info">
                                <div class="vehicle-name">杭E-ML056</div>
                                <div class="vehicle-status">
                                    <span class="status-indicator status-online"></span>
                                    杭州市西湖区 | 返程中
                                </div>
                            </div>
                        </div>
                        
                        <div class="vehicle-item">
                            <div class="vehicle-icon">九</div>
                            <div class="vehicle-info">
                                <div class="vehicle-name">津F-9S112</div>
                                <div class="vehicle-status">
                                    <span class="status-indicator status-offline"></span>
                                    天津市滨海新区 | 维护中
                                </div>
                            </div>
                        </div>
                        
                        <div class="vehicle-item">
                            <div class="vehicle-icon">菜</div>
                            <div class="vehicle-info">
                                <div class="vehicle-name">渝G-ML092</div>
                                <div class="vehicle-status">
                                    <span class="status-indicator status-busy"></span>
                                    重庆市渝中区 | 装载中
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="data-chart">
                    <div class="section-title">车辆利用率分析</div>
                    <div id="utilization-chart" class="chart-container"></div>
                </div>
            </div>
        </div>
        
        <!-- 底部三个图表容器 -->
        <div class="dashboard-bottom">
            <div class="chart-card">
                <div class="chart-title">车辆状态分布</div>
                <div id="status-chart" class="chart-container"></div>
            </div>
            <div class="chart-card">
                <div class="chart-title">任务完成情况</div>
                <div id="task-chart" class="chart-container"></div>
            </div>
            <div class="chart-card">
                <div class="chart-title">电池状态监控</div>
                <div id="battery-chart" class="chart-container"></div>
            </div>
        </div>
        
        <div class="dashboard-footer">
            <p>数据更新时间: 2023-11-15 14:28:36 | 系统版本: V2.3.5 | © 2023 无人车运营数据平台</p>
        </div>
    </form>

    <script>
        // 初始化中国地图
        const mapChart = echarts.init(document.getElementById('china-map'));

        // 模拟数据 - 九识智能车辆分布
        const jiusiData = [
            { name: '北京', value: 128, position: [116.407526, 39.90403] },
            { name: '上海', value: 96, position: [121.473701, 31.230416] },
            { name: '广州', value: 85, position: [113.264385, 23.129112] },
            { name: '深圳', value: 78, position: [114.057868, 22.543099] },
            { name: '杭州', value: 65, position: [120.15507, 30.274084] },
            { name: '成都', value: 58, position: [104.066541, 30.572269] },
            { name: '武汉', value: 52, position: [114.305392, 30.593098] },
            { name: '南京', value: 48, position: [118.796877, 32.060255] },
            { name: '重庆', value: 45, position: [106.504959, 29.533155] },
            { name: '天津', value: 42, position: [117.201538, 39.085294] },
            { name: '西安', value: 38, position: [108.940174, 34.341568] },
            { name: '苏州', value: 35, position: [120.585315, 31.298886] },
            { name: '郑州', value: 32, position: [113.625368, 34.746599] },
            { name: '长沙', value: 28, position: [112.938814, 28.228209] },
            { name: '合肥', value: 25, position: [117.227239, 31.820586] }
        ];

        // 模拟数据 - 菜鸟蛮驴车辆分布
        const cainiaoData = [
            { name: '北京', value: 95, position: [116.407526, 39.90403] },
            { name: '上海', value: 88, position: [121.473701, 31.230416] },
            { name: '广州', value: 76, position: [113.264385, 23.129112] },
            { name: '深圳', value: 72, position: [114.057868, 22.543099] },
            { name: '杭州', value: 92, position: [120.15507, 30.274084] },
            { name: '成都', value: 65, position: [104.066541, 30.572269] },
            { name: '武汉', value: 48, position: [114.305392, 30.593098] },
            { name: '南京', value: 42, position: [118.796877, 32.060255] },
            { name: '重庆', value: 38, position: [106.504959, 29.533155] },
            { name: '天津', value: 35, position: [117.201538, 39.085294] },
            { name: '西安', value: 32, position: [108.940174, 34.341568] },
            { name: '苏州', value: 28, position: [120.585315, 31.298886] },
            { name: '郑州', value: 26, position: [113.625368, 34.746599] },
            { name: '长沙', value: 22, position: [112.938814, 28.228209] },
            { name: '合肥', value: 20, position: [117.227239, 31.820586] }
        ];

        // 地图配置
        const mapOption = {
            backgroundColor: 'transparent',
            tooltip: {
                trigger: 'item',
                formatter: function (params) {
                    return `${params.data.name}<br/>${params.seriesName}: ${params.data.value}辆`;
                }
            },
            geo: {
                map: 'china',
                roam: true,
                label: {
                    emphasis: {
                        show: false
                    }
                },
                itemStyle: {
                    normal: {
                        areaColor: 'rgba(23, 50, 77, 0.5)',
                        borderColor: '#00f7ff'
                    },
                    emphasis: {
                        areaColor: 'rgba(0, 247, 255, 0.3)'
                    }
                }
            },
            series: [
                {
                    name: '九识智能',
                    type: 'scatter',
                    coordinateSystem: 'geo',
                    data: jiusiData.map(item => ({
                        name: item.name,
                        value: [item.position[0], item.position[1], item.value],
                        jiusi: item.value
                    })),
                    symbolSize: function (val) {
                        return Math.sqrt(val[2]) * 5;
                    },
                    itemStyle: {
                        color: '#00ff00',
                        shadowBlur: 10,
                        shadowColor: '#00ff00'
                    },
                    emphasis: {
                        itemStyle: {
                            borderColor: '#fff',
                            borderWidth: 1
                        }
                    },
                    zlevel: 1
                },
                {
                    name: '菜鸟蛮驴',
                    type: 'scatter',
                    coordinateSystem: 'geo',
                    data: cainiaoData.map(item => ({
                        name: item.name,
                        value: [item.position[0], item.position[1], item.value],
                        cainiao: item.value
                    })),
                    symbolSize: function (val) {
                        return Math.sqrt(val[2]) * 5;
                    },
                    itemStyle: {
                        color: '#00f7ff',
                        shadowBlur: 10,
                        shadowColor: '#00f7ff'
                    },
                    emphasis: {
                        itemStyle: {
                            borderColor: '#fff',
                            borderWidth: 1
                        }
                    },
                    zlevel: 1
                }
            ]
        };

        mapChart.setOption(mapOption);

        // 初始化利用率图表
        const utilChart = echarts.init(document.getElementById('utilization-chart'));

        const utilOption = {
            backgroundColor: 'transparent',
            tooltip: {
                trigger: 'axis',
                backgroundColor: 'rgba(10, 14, 23, 0.9)',
                borderColor: 'rgba(0, 247, 255, 0.5)',
                textStyle: {
                    color: '#fff'
                }
            },
            legend: {
                data: ['九识智能', '菜鸟蛮驴'],
                textStyle: {
                    color: '#a0c1eb'
                },
                right: 10,
                top: 10
            },
            grid: {
                left: '3%',
                right: '4%',
                bottom: '3%',
                top: '15%',
                containLabel: true
            },
            xAxis: {
                type: 'category',
                boundaryGap: false,
                data: ['00:00', '04:00', '08:00', '12:00', '16:00', '20:00'],
                axisLine: {
                    lineStyle: {
                        color: 'rgba(160, 193, 235, 0.5)'
                    }
                },
                axisLabel: {
                    color: 'rgba(160, 193, 235, 0.7)'
                }
            },
            yAxis: {
                type: 'value',
                axisLabel: {
                    formatter: '{value}%',
                    color: 'rgba(160, 193, 235, 0.7)'
                },
                axisLine: {
                    lineStyle: {
                        color: 'rgba(160, 193, 235, 0.5)'
                    }
                },
                splitLine: {
                    lineStyle: {
                        color: 'rgba(160, 193, 235, 0.1)'
                    }
                }
            },
            series: [
                {
                    name: '九识智能',
                    type: 'line',
                    smooth: true,
                    symbol: 'circle',
                    symbolSize: 8,
                    lineStyle: {
                        width: 3,
                        color: '#00ff00'
                    },
                    itemStyle: {
                        color: '#00ff00'
                    },
                    areaStyle: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                            { offset: 0, color: 'rgba(0, 255, 0, 0.3)' },
                            { offset: 1, color: 'rgba(0, 255, 0, 0.05)' }
                        ])
                    },
                    data: [28, 35, 72, 88, 84, 65]
                },
                {
                    name: '菜鸟蛮驴',
                    type: 'line',
                    smooth: true,
                    symbol: 'circle',
                    symbolSize: 8,
                    lineStyle: {
                        width: 3,
                        color: '#00f7ff'
                    },
                    itemStyle: {
                        color: '#00f7ff'
                    },
                    areaStyle: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                            { offset: 0, color: 'rgba(0, 247, 255, 0.3)' },
                            { offset: 1, color: 'rgba(0, 247, 255, 0.05)' }
                        ])
                    },
                    data: [32, 40, 68, 92, 78, 60]
                }
            ]
        };

        utilChart.setOption(utilOption);

        // 车辆状态分布饼图
        const statusChart = echarts.init(document.getElementById('status-chart'));
        const statusOption = {
            backgroundColor: 'transparent',
            tooltip: {
                trigger: 'item',
                formatter: '{a} <br/>{b}: {c}辆 ({d}%)'
            },
            legend: {
                orient: 'vertical',
                right: 10,
                top: 'center',
                textStyle: {
                    color: '#a0c1eb'
                },
                data: ['在线', '忙碌', '离线', '维护']
            },
            series: [
                {
                    name: '车辆状态',
                    type: 'pie',
                    radius: ['40%', '70%'],
                    center: ['40%', '50%'],
                    avoidLabelOverlap: false,
                    itemStyle: {
                        borderRadius: 10,
                        borderColor: '#0a0e17',
                        borderWidth: 2
                    },
                    label: {
                        show: false,
                        position: 'center'
                    },
                    emphasis: {
                        label: {
                            show: true,
                            fontSize: '18',
                            fontWeight: 'bold',
                            color: '#00f7ff'
                        }
                    },
                    labelLine: {
                        show: false
                    },
                    data: [
                        { value: 928, name: '在线', itemStyle: { color: '#00ff00' } },
                        { value: 245, name: '忙碌', itemStyle: { color: '#ffff00' } },
                        { value: 62, name: '离线', itemStyle: { color: '#ff0000' } },
                        { value: 13, name: '维护', itemStyle: { color: '#cc00ff' } }
                    ]
                }
            ]
        };
        statusChart.setOption(statusOption);

        // 任务完成情况柱状图
        const taskChart = echarts.init(document.getElementById('task-chart'));
        const taskOption = {
            backgroundColor: 'transparent',
            tooltip: {
                trigger: 'axis',
                axisPointer: {
                    type: 'shadow'
                }
            },
            grid: {
                left: '3%',
                right: '4%',
                bottom: '3%',
                top: '15%',
                containLabel: true
            },
            xAxis: {
                type: 'category',
                data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日'],
                axisLine: {
                    lineStyle: {
                        color: 'rgba(160, 193, 235, 0.5)'
                    }
                },
                axisLabel: {
                    color: 'rgba(160, 193, 235, 0.7)'
                }
            },
            yAxis: {
                type: 'value',
                name: '任务数量',
                nameTextStyle: {
                    color: 'rgba(160, 193, 235, 0.7)'
                },
                axisLine: {
                    lineStyle: {
                        color: 'rgba(160, 193, 235, 0.5)'
                    }
                },
                axisLabel: {
                    color: 'rgba(160, 193, 235, 0.7)'
                },
                splitLine: {
                    lineStyle: {
                        color: 'rgba(160, 193, 235, 0.1)'
                    }
                }
            },
            series: [
                {
                    name: '九识智能',
                    type: 'bar',
                    barWidth: '40%',
                    data: [1245, 1320, 1450, 1570, 1490, 1380, 1260],
                    itemStyle: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                            { offset: 0, color: '#00ff00' },
                            { offset: 1, color: '#003300' }
                        ])
                    }
                },
                {
                    name: '菜鸟蛮驴',
                    type: 'bar',
                    barWidth: '40%',
                    data: [980, 1040, 1150, 1260, 1180, 1070, 950],
                    itemStyle: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                            { offset: 0, color: '#00f7ff' },
                            { offset: 1, color: '#003366' }
                        ])
                    }
                }
            ]
        };
        taskChart.setOption(taskOption);

        // 电池状态折线图
        const batteryChart = echarts.init(document.getElementById('battery-chart'));
        const batteryOption = {
            backgroundColor: 'transparent',
            tooltip: {
                trigger: 'axis'
            },
            legend: {
                data: ['电量水平', '充电状态'],
                textStyle: {
                    color: '#a0c1eb'
                },
                right: 10,
                top: 10
            },
            grid: {
                left: '3%',
                right: '4%',
                bottom: '3%',
                top: '15%',
                containLabel: true
            },
            xAxis: {
                type: 'category',
                boundaryGap: false,
                data: ['00:00', '04:00', '08:00', '12:00', '16:00', '20:00', '24:00'],
                axisLine: {
                    lineStyle: {
                        color: 'rgba(160, 193, 235, 0.5)'
                    }
                },
                axisLabel: {
                    color: 'rgba(160, 193, 235, 0.7)'
                }
            },
            yAxis: [
                {
                    type: 'value',
                    name: '电量百分比',
                    min: 0,
                    max: 100,
                    axisLine: {
                        lineStyle: {
                            color: 'rgba(160, 193, 235, 0.5)'
                        }
                    },
                    axisLabel: {
                        formatter: '{value}%',
                        color: 'rgba(160, 193, 235, 0.7)'
                    },
                    splitLine: {
                        lineStyle: {
                            color: 'rgba(160, 193, 235, 0.1)'
                        }
                    }
                },
                {
                    type: 'value',
                    name: '充电车辆',
                    min: 0,
                    max: 300,
                    axisLine: {
                        lineStyle: {
                            color: 'rgba(160, 193, 235, 0.5)'
                        }
                    },
                    axisLabel: {
                        color: 'rgba(160, 193, 235, 0.7)'
                    },
                    splitLine: {
                        show: false
                    }
                }
            ],
            series: [
                {
                    name: '电量水平',
                    type: 'line',
                    smooth: true,
                    data: [82, 76, 68, 62, 58, 45, 32],
                    lineStyle: {
                        width: 3,
                        color: '#00ff00'
                    },
                    itemStyle: {
                        color: '#00ff00'
                    },
                    areaStyle: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                            { offset: 0, color: 'rgba(0, 255, 0, 0.3)' },
                            { offset: 1, color: 'rgba(0, 255, 0, 0.05)' }
                        ])
                    }
                },
                {
                    name: '充电状态',
                    type: 'bar',
                    yAxisIndex: 1,
                    data: [45, 62, 98, 120, 145, 205, 245],
                    itemStyle: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                            { offset: 0, color: '#00f7ff' },
                            { offset: 1, color: '#0066ff' }
                        ])
                    }
                }
            ]
        };
        batteryChart.setOption(batteryOption);

        // 更新时间
        function updateTime() {
            const now = new Date();
            const timeStr = now.toLocaleTimeString('zh-CN', { hour12: false });
            const dateStr = now.toLocaleDateString('zh-CN', {
                year: 'numeric',
                month: 'long',
                day: 'numeric',
                weekday: 'long'
            });

            document.querySelector('.current-time').textContent = timeStr;
            document.querySelector('.current-date').textContent = dateStr;
        }

        setInterval(updateTime, 1000);
        updateTime();

        // 响应窗口大小变化
        window.addEventListener('resize', function () {
            mapChart.resize();
            utilChart.resize();
            statusChart.resize();
            taskChart.resize();
            batteryChart.resize();
        });

        // 平台切换
        document.querySelectorAll('.platform-tab').forEach(tab => {
            tab.addEventListener('click', function () {
                document.querySelectorAll('.platform-tab').forEach(t => t.classList.remove('active'));
                this.classList.add('active');
            });
        });

        // 创建科技感背景网格
        function createGrid() {
            const gridContainer = document.getElementById('tech-bg');
            const width = window.innerWidth;
            const height = window.innerHeight;

            // 清除现有网格
            while (gridContainer.firstChild) {
                gridContainer.removeChild(gridContainer.firstChild);
            }

            // 创建垂直线
            for (let i = 0; i < width; i += 50) {
                const line = document.createElement('div');
                line.className = 'grid-line vertical';
                line.style.left = i + 'px';
                gridContainer.appendChild(line);
            }

            // 创建水平线
            for (let i = 0; i < height; i += 50) {
                const line = document.createElement('div');
                line.className = 'grid-line horizontal';
                line.style.top = i + 'px';
                gridContainer.appendChild(line);
            }
        }

        // 初始化和响应式调整
        createGrid();
        window.addEventListener('resize', createGrid);
    </script>
</body>
</html>--%>

<%--<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无人车运营数据大屏</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.4.3/dist/echarts.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/echarts@5/dist/extension/bmap.min.js"></script>
    <script src="https://api.map.baidu.com/api?v=3.0&ak=您的BaiduMapAK"></script>
    <style>
        :root {
            --primary: #00f7ff;
            --secondary: #0066ff;
            --accent: #ff00d6;
            --dark: #0a0e17;
            --darker: #060912;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Microsoft YaHei', 'Segoe UI', sans-serif;
        }
        
        body {
            background: var(--darker);
            color: #fff;
            height: 100vh;
            overflow: hidden;
            position: relative;
        }
        
        /* 科技感背景 */
        .tech-bg {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            background: 
                radial-gradient(circle at 20% 30%, rgba(0, 103, 255, 0.1) 0%, transparent 40%),
                radial-gradient(circle at 80% 70%, rgba(255, 0, 214, 0.1) 0%, transparent 40%);
            background-color: var(--dark);
            overflow: hidden;
        }
        
        .grid-line {
            position: absolute;
            background: rgba(0, 247, 255, 0.05);
        }
        
        .grid-line.vertical {
            width: 1px;
            height: 100%;
            top: 0;
        }
        
        .grid-line.horizontal {
            height: 1px;
            width: 100%;
            left: 0;
        }
        
        /* 头部样式 */
        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 30px;
            position: relative;
            z-index: 10;
            background: rgba(10, 14, 23, 0.8);
            border-bottom: 1px solid rgba(0, 247, 255, 0.2);
        }
        
        .logo-section {
            display: flex;
            align-items: center;
        }
        
        .logo-section img {
            height: 60px;
            margin-right: 20px;
            filter: drop-shadow(0 0 10px var(--primary));
        }
        
        .title-section h1 {
            font-size: 2.5rem;
            letter-spacing: 2px;
            background: linear-gradient(to right, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-shadow: 0 0 15px rgba(0, 247, 255, 0.5);
            animation: titleGlow 3s infinite alternate;
        }
        
        .title-section p {
            font-size: 1rem;
            color: rgba(160, 193, 235, 0.7);
            margin-top: 5px;
            letter-spacing: 1px;
        }
        
        .time-section {
            text-align: right;
        }
        
        .time-section .current-time {
            font-size: 1.8rem;
            font-weight: bold;
            color: var(--primary);
            text-shadow: 0 0 10px rgba(0, 247, 255, 0.7);
        }
        
        .time-section .current-date {
            font-size: 1.2rem;
            color: rgba(160, 193, 235, 0.7);
        }
        
        .dashboard-content {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 20px;
            height: calc(100vh - 120px);
            padding: 20px;
        }
        
        .main-section {
            display: grid;
            grid-template-rows: 1fr 1fr;
            gap: 20px;
        }
        
        /* 地图容器 */
        .map-container {
            background: rgba(16, 35, 66, 0.2);
            border-radius: 15px;
            padding: 20px;
            position: relative;
            border: 1px solid rgba(0, 247, 255, 0.2);
            box-shadow: 0 0 30px rgba(0, 103, 255, 0.2);
            overflow: hidden;
        }
        
        .map-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(to right, transparent, var(--primary), transparent);
            animation: scanline 3s linear infinite;
        }
        
        .map-title {
            font-size: 1.5rem;
            margin-bottom: 15px;
            color: var(--primary);
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-weight: bold;
        }
        
        .map-legend {
            display: flex;
            gap: 20px;
        }
        
        .legend-item {
            display: flex;
            align-items: center;
            font-size: 0.9rem;
        }
        
        .legend-color {
            width: 15px;
            height: 15px;
            border-radius: 50%;
            margin-right: 5px;
            box-shadow: 0 0 8px currentColor;
        }
        
        #china-map {
            width: 100%;
            height: calc(100% - 40px);
            background: rgba(0, 0, 0, 0.3);
            border-radius: 10px;
        }
        
        /* 统计卡片 */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }
        
        .stat-card {
            background: rgba(16, 35, 66, 0.2);
            border-radius: 15px;
            padding: 20px;
            border: 1px solid rgba(0, 247, 255, 0.2);
            box-shadow: 0 0 20px rgba(0, 103, 255, 0.1);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 0 30px rgba(0, 247, 255, 0.3);
        }
        
        .stat-card::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(0, 247, 255, 0.1) 0%, transparent 70%);
            z-index: 0;
        }
        
        .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 15px;
            z-index: 1;
            text-shadow: 0 0 10px var(--primary);
        }
        
        .stat-value {
            font-size: 2.2rem;
            font-weight: bold;
            margin-bottom: 5px;
            color: var(--primary);
            z-index: 1;
            text-shadow: 0 0 10px rgba(0, 247, 255, 0.7);
        }
        
        .stat-label {
            font-size: 1rem;
            color: rgba(160, 193, 235, 0.7);
            z-index: 1;
        }
        
        /* 侧边栏 */
        .side-section {
            display: grid;
            grid-template-rows: 1fr 1fr;
            gap: 20px;
        }
        
        .vehicle-list {
            background: rgba(16, 35, 66, 0.2);
            border-radius: 15px;
            padding: 20px;
            border: 1px solid rgba(0, 247, 255, 0.2);
            box-shadow: 0 0 20px rgba(0, 103, 255, 0.1);
            overflow-y: auto;
        }
        
        .section-title {
            font-size: 1.5rem;
            margin-bottom: 15px;
            color: var(--primary);
            font-weight: bold;
        }
        
        .platform-tabs {
            display: flex;
            margin-bottom: 15px;
            background: rgba(22, 50, 92, 0.2);
            border-radius: 10px;
            overflow: hidden;
            border: 1px solid rgba(0, 247, 255, 0.2);
        }
        
        .platform-tab {
            flex: 1;
            text-align: center;
            padding: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
            background: rgba(10, 20, 40, 0.5);
            color: rgba(160, 193, 235, 0.7);
        }
        
        .platform-tab.active {
            background: var(--secondary);
            color: white;
            box-shadow: 0 0 15px rgba(0, 103, 255, 0.5);
        }
        
        .vehicle-item {
            display: flex;
            align-items: center;
            padding: 12px 15px;
            margin-bottom: 10px;
            background: rgba(22, 50, 92, 0.2);
            border-radius: 10px;
            transition: all 0.3s ease;
            border: 1px solid rgba(0, 247, 255, 0.1);
        }
        
        .vehicle-item:hover {
            background: rgba(22, 50, 92, 0.4);
            transform: translateX(5px);
            box-shadow: 0 0 15px rgba(0, 247, 255, 0.2);
        }
        
        .vehicle-icon {
            width: 40px;
            height: 40px;
            background: var(--secondary);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            font-size: 1.2rem;
            font-weight: bold;
            box-shadow: 0 0 10px rgba(0, 103, 255, 0.5);
        }
        
        .vehicle-info {
            flex: 1;
        }
        
        .vehicle-name {
            font-size: 1.1rem;
            margin-bottom: 3px;
            color: white;
        }
        
        .vehicle-status {
            font-size: 0.9rem;
            color: rgba(160, 193, 235, 0.7);
            display: flex;
            align-items: center;
        }
        
        .status-indicator {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            margin-right: 8px;
            display: inline-block;
            box-shadow: 0 0 5px currentColor;
        }
        
        .status-online {
            background: #00ff00;
            animation: pulse 1.5s infinite;
        }
        
        .status-offline {
            background: #ff0000;
        }
        
        .status-busy {
            background: #ffff00;
            animation: pulse 1s infinite;
        }
        
        .data-chart {
            background: rgba(16, 35, 66, 0.2);
            border-radius: 15px;
            padding: 20px;
            border: 1px solid rgba(0, 247, 255, 0.2);
            box-shadow: 0 0 20px rgba(0, 103, 255, 0.1);
        }
        
        #utilization-chart {
            width: 100%;
            height: 300px;
            background: rgba(0, 0, 0, 0.3);
            border-radius: 10px;
        }
        
        .dashboard-footer {
            text-align: center;
            padding: 10px;
            color: rgba(160, 193, 235, 0.7);
            font-size: 0.9rem;
            position: absolute;
            bottom: 0;
            width: 100%;
            background: rgba(10, 14, 23, 0.8);
            border-top: 1px solid rgba(0, 247, 255, 0.2);
        }
        
        /* 动画效果 */
        @keyframes pulse {
            0% { opacity: 0.4; }
            50% { opacity: 1; }
            100% { opacity: 0.4; }
        }
        
        @keyframes scanline {
            0% { transform: translateX(-100%); }
            100% { transform: translateX(100%); }
        }
        
        @keyframes titleGlow {
            0% { text-shadow: 0 0 15px rgba(0, 247, 255, 0.5); }
            100% { text-shadow: 0 0 25px rgba(0, 247, 255, 0.8), 0 0 40px rgba(0, 247, 255, 0.6); }
        }
        
        /* 滚动条样式 */
        .vehicle-list::-webkit-scrollbar {
            width: 6px;
        }
        
        .vehicle-list::-webkit-scrollbar-track {
            background: rgba(0, 0, 0, 0.1);
            border-radius: 3px;
        }
        
        .vehicle-list::-webkit-scrollbar-thumb {
            background: var(--primary);
            border-radius: 3px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- 科技感背景 -->
        <div class="tech-bg" id="tech-bg"></div>
        
        <div class="dashboard-header">
            <div class="logo-section">
                <img src="https://31580832.s21i.faiusr.com/4/ABUIABAEGAAglZ6PqQYogL_lywcw9wU44AY.png" alt="无人车管理系统">
                <div class="title-section">
                    <h1>无人车运营数据大屏</h1>
                    <p>九识智能 & 菜鸟蛮驴 | 全国车辆实时监控系统</p>
                </div>
            </div>
            <div class="time-section">
                <div class="current-time">14:28:36</div>
                <div class="current-date">2023年11月15日 星期三</div>
            </div>
        </div>
        
        <div class="dashboard-content">
            <div class="main-section">
                <div class="map-container">
                    <div class="map-title">
                        <span>全国无人车分布热力图</span>
                        <div class="map-legend">
                            <div class="legend-item">
                                <div class="legend-color" style="color: #00ff00;"></div>
                                <span>九识智能</span>
                            </div>
                            <div class="legend-item">
                                <div class="legend-color" style="color: #00f7ff;"></div>
                                <span>菜鸟蛮驴</span>
                            </div>
                        </div>
                    </div>
                    <div id="china-map"></div>
                </div>
                
                <div class="stats-container">
                    <div class="stat-card">
                        <div class="stat-icon">🚗</div>
                        <div class="stat-value">1,248</div>
                        <div class="stat-label">在线车辆总数</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon">📦</div>
                        <div class="stat-value">8,562</div>
                        <div class="stat-label">今日配送包裹</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon">📊</div>
                        <div class="stat-value">96.8%</div>
                        <div class="stat-label">准时送达率</div>
                    </div>
                </div>
            </div>
            
            <div class="side-section">
                <div class="vehicle-list">
                    <div class="section-title">车辆实时状态</div>
                    <div class="platform-tabs">
                        <div class="platform-tab active">九识智能</div>
                        <div class="platform-tab">菜鸟蛮驴</div>
                    </div>
                    
                    <div class="vehicle-items">
                        <div class="vehicle-item">
                            <div class="vehicle-icon">九</div>
                            <div class="vehicle-info">
                                <div class="vehicle-name">京A-9S001</div>
                                <div class="vehicle-status">
                                    <span class="status-indicator status-online"></span>
                                    北京市海淀区 | 配送中
                                </div>
                            </div>
                        </div>
                        
                        <div class="vehicle-item">
                            <div class="vehicle-icon">九</div>
                            <div class="vehicle-info">
                                <div class="vehicle-name">沪B-9S045</div>
                                <div class="vehicle-status">
                                    <span class="status-indicator status-busy"></span>
                                    上海市浦东新区 | 装载中
                                </div>
                            </div>
                        </div>
                        
                        <div class="vehicle-item">
                            <div class="vehicle-icon">菜</div>
                            <div class="vehicle-info">
                                <div class="vehicle-name">粤C-ML128</div>
                                <div class="vehicle-status">
                                    <span class="status-indicator status-online"></span>
                                    广州市天河区 | 待命
                                </div>
                            </div>
                        </div>
                        
                        <div class="vehicle-item">
                            <div class="vehicle-icon">九</div>
                            <div class="vehicle-info">
                                <div class="vehicle-name">深D-9S078</div>
                                <div class="vehicle-status">
                                    <span class="status-indicator status-online"></span>
                                    深圳市南山区 | 配送中
                                </div>
                            </div>
                        </div>
                        
                        <div class="vehicle-item">
                            <div class="vehicle-icon">菜</div>
                            <div class="vehicle-info">
                                <div class="vehicle-name">杭E-ML056</div>
                                <div class="vehicle-status">
                                    <span class="status-indicator status-online"></span>
                                    杭州市西湖区 | 返程中
                                </div>
                            </div>
                        </div>
                        
                        <div class="vehicle-item">
                            <div class="vehicle-icon">九</div>
                            <div class="vehicle-info">
                                <div class="vehicle-name">津F-9S112</div>
                                <div class="vehicle-status">
                                    <span class="status-indicator status-offline"></span>
                                    天津市滨海新区 | 维护中
                                </div>
                            </div>
                        </div>
                        
                        <div class="vehicle-item">
                            <div class="vehicle-icon">菜</div>
                            <div class="vehicle-info">
                                <div class="vehicle-name">渝G-ML092</div>
                                <div class="vehicle-status">
                                    <span class="status-indicator status-busy"></span>
                                    重庆市渝中区 | 装载中
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="data-chart">
                    <div class="section-title">车辆利用率分析</div>
                    <div id="utilization-chart"></div>
                </div>
            </div>
        </div>
        
        <div class="dashboard-footer">
            <p>数据更新时间: 2023-11-15 14:28:36 | 系统版本: V2.3.5 | © 2023 无人车运营数据平台</p>
        </div>
    </form>

    <script>
        // 初始化中国地图
        const mapChart = echarts.init(document.getElementById('china-map'));

        // 模拟数据 - 九识智能车辆分布
        const jiusiData = [
            { name: '北京', value: 128, position: [116.407526, 39.90403] },
            { name: '上海', value: 96, position: [121.473701, 31.230416] },
            { name: '广州', value: 85, position: [113.264385, 23.129112] },
            { name: '深圳', value: 78, position: [114.057868, 22.543099] },
            { name: '杭州', value: 65, position: [120.15507, 30.274084] },
            { name: '成都', value: 58, position: [104.066541, 30.572269] },
            { name: '武汉', value: 52, position: [114.305392, 30.593098] },
            { name: '南京', value: 48, position: [118.796877, 32.060255] },
            { name: '重庆', value: 45, position: [106.504959, 29.533155] },
            { name: '天津', value: 42, position: [117.201538, 39.085294] },
            { name: '西安', value: 38, position: [108.940174, 34.341568] },
            { name: '苏州', value: 35, position: [120.585315, 31.298886] },
            { name: '郑州', value: 32, position: [113.625368, 34.746599] },
            { name: '长沙', value: 28, position: [112.938814, 28.228209] },
            { name: '合肥', value: 25, position: [117.227239, 31.820586] }
        ];

        // 模拟数据 - 菜鸟蛮驴车辆分布
        const cainiaoData = [
            { name: '北京', value: 95, position: [116.407526, 39.90403] },
            { name: '上海', value: 88, position: [121.473701, 31.230416] },
            { name: '广州', value: 76, position: [113.264385, 23.129112] },
            { name: '深圳', value: 72, position: [114.057868, 22.543099] },
            { name: '杭州', value: 92, position: [120.15507, 30.274084] },
            { name: '成都', value: 65, position: [104.066541, 30.572269] },
            { name: '武汉', value: 48, position: [114.305392, 30.593098] },
            { name: '南京', value: 42, position: [118.796877, 32.060255] },
            { name: '重庆', value: 38, position: [106.504959, 29.533155] },
            { name: '天津', value: 35, position: [117.201538, 39.085294] },
            { name: '西安', value: 32, position: [108.940174, 34.341568] },
            { name: '苏州', value: 28, position: [120.585315, 31.298886] },
            { name: '郑州', value: 26, position: [113.625368, 34.746599] },
            { name: '长沙', value: 22, position: [112.938814, 28.228209] },
            { name: '合肥', value: 20, position: [117.227239, 31.820586] }
        ];

        // 地图配置
        const mapOption = {
            backgroundColor: 'transparent',
            tooltip: {
                trigger: 'item',
                formatter: function (params) {
                    if (params.seriesType === 'scatter') {
                        return `${params.data.name}<br/>${params.seriesName}: ${params.data.value}辆`;
                    }
                    return `${params.name}<br/>九识智能: ${params.data.jiusi || 0}辆<br/>菜鸟蛮驴: ${params.data.cainiao || 0}辆`;
                }
            },
            bmap: {
                center: [104.114129, 37.550339],
                zoom: 4,
                roam: true,
                mapStyle: {
                    styleJson: [{
                        'featureType': 'water',
                        'elementType': 'all',
                        'stylers': {
                            'color': '#044161'
                        }
                    }, {
                        'featureType': 'land',
                        'elementType': 'all',
                        'stylers': {
                            'color': '#004981'
                        }
                    }, {
                        'featureType': 'boundary',
                        'elementType': 'geometry',
                        'stylers': {
                            'color': '#064f85'
                        }
                    }, {
                        'featureType': 'railway',
                        'elementType': 'all',
                        'stylers': {
                            'visibility': 'off'
                        }
                    }, {
                        'featureType': 'highway',
                        'elementType': 'geometry',
                        'stylers': {
                            'color': '#004981'
                        }
                    }, {
                        'featureType': 'highway',
                        'elementType': 'geometry.fill',
                        'stylers': {
                            'color': '#005b96',
                            'lightness': 1
                        }
                    }, {
                        'featureType': 'highway',
                        'elementType': 'labels',
                        'stylers': {
                            'visibility': 'off'
                        }
                    }, {
                        'featureType': 'arterial',
                        'elementType': 'geometry',
                        'stylers': {
                            'color': '#004981'
                        }
                    }, {
                        'featureType': 'arterial',
                        'elementType': 'geometry.fill',
                        'stylers': {
                            'color': '#00508b'
                        }
                    }, {
                        'featureType': 'poi',
                        'elementType': 'all',
                        'stylers': {
                            'visibility': 'off'
                        }
                    }, {
                        'featureType': 'green',
                        'elementType': 'all',
                        'stylers': {
                            'color': '#056197',
                            'visibility': 'off'
                        }
                    }, {
                        'featureType': 'subway',
                        'elementType': 'all',
                        'stylers': {
                            'visibility': 'off'
                        }
                    }, {
                        'featureType': 'manmade',
                        'elementType': 'all',
                        'stylers': {
                            'visibility': 'off'
                        }
                    }, {
                        'featureType': 'local',
                        'elementType': 'all',
                        'stylers': {
                            'visibility': 'off'
                        }
                    }, {
                        'featureType': 'arterial',
                        'elementType': 'labels',
                        'stylers': {
                            'visibility': 'off'
                        }
                    }, {
                        'featureType': 'boundary',
                        'elementType': 'geometry.fill',
                        'stylers': {
                            'color': '#029fd4'
                        }
                    }, {
                        'featureType': 'building',
                        'elementType': 'all',
                        'stylers': {
                            'color': '#1a5787'
                        }
                    }, {
                        'featureType': 'label',
                        'elementType': 'all',
                        'stylers': {
                            'visibility': 'off'
                        }
                    }]
                }
            },
            series: [
                {
                    name: '九识智能',
                    type: 'scatter',
                    coordinateSystem: 'bmap',
                    data: jiusiData.map(item => ({
                        name: item.name,
                        value: [item.position[0], item.position[1], item.value],
                        jiusi: item.value
                    })),
                    symbolSize: function (val) {
                        return Math.sqrt(val[2]) * 5;
                    },
                    itemStyle: {
                        color: '#00ff00',
                        shadowBlur: 10,
                        shadowColor: '#00ff00'
                    },
                    emphasis: {
                        itemStyle: {
                            borderColor: '#fff',
                            borderWidth: 1
                        }
                    },
                    zlevel: 1
                },
                {
                    name: '菜鸟蛮驴',
                    type: 'scatter',
                    coordinateSystem: 'bmap',
                    data: cainiaoData.map(item => ({
                        name: item.name,
                        value: [item.position[0], item.position[1], item.value],
                        cainiao: item.value
                    })),
                    symbolSize: function (val) {
                        return Math.sqrt(val[2]) * 5;
                    },
                    itemStyle: {
                        color: '#00f7ff',
                        shadowBlur: 10,
                        shadowColor: '#00f7ff'
                    },
                    emphasis: {
                        itemStyle: {
                            borderColor: '#fff',
                            borderWidth: 1
                        }
                    },
                    zlevel: 1
                }
            ]
        };

        mapChart.setOption(mapOption);

        // 初始化利用率图表
        const utilChart = echarts.init(document.getElementById('utilization-chart'));

        const utilOption = {
            backgroundColor: 'transparent',
            tooltip: {
                trigger: 'axis',
                backgroundColor: 'rgba(10, 14, 23, 0.9)',
                borderColor: 'rgba(0, 247, 255, 0.5)',
                textStyle: {
                    color: '#fff'
                }
            },
            legend: {
                data: ['九识智能', '菜鸟蛮驴'],
                textStyle: {
                    color: '#a0c1eb'
                },
                right: 10,
                top: 10
            },
            grid: {
                left: '3%',
                right: '4%',
                bottom: '3%',
                top: '15%',
                containLabel: true
            },
            xAxis: {
                type: 'category',
                boundaryGap: false,
                data: ['00:00', '04:00', '08:00', '12:00', '16:00', '20:00'],
                axisLine: {
                    lineStyle: {
                        color: 'rgba(160, 193, 235, 0.5)'
                    }
                },
                axisLabel: {
                    color: 'rgba(160, 193, 235, 0.7)'
                }
            },
            yAxis: {
                type: 'value',
                axisLabel: {
                    formatter: '{value}%',
                    color: 'rgba(160, 193, 235, 0.7)'
                },
                axisLine: {
                    lineStyle: {
                        color: 'rgba(160, 193, 235, 0.5)'
                    }
                },
                splitLine: {
                    lineStyle: {
                        color: 'rgba(160, 193, 235, 0.1)'
                    }
                }
            },
            series: [
                {
                    name: '九识智能',
                    type: 'line',
                    smooth: true,
                    symbol: 'circle',
                    symbolSize: 8,
                    lineStyle: {
                        width: 3,
                        color: '#00ff00'
                    },
                    itemStyle: {
                        color: '#00ff00'
                    },
                    areaStyle: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                            { offset: 0, color: 'rgba(0, 255, 0, 0.3)' },
                            { offset: 1, color: 'rgba(0, 255, 0, 0.05)' }
                        ])
                    },
                    data: [28, 35, 72, 88, 84, 65]
                },
                {
                    name: '菜鸟蛮驴',
                    type: 'line',
                    smooth: true,
                    symbol: 'circle',
                    symbolSize: 8,
                    lineStyle: {
                        width: 3,
                        color: '#00f7ff'
                    },
                    itemStyle: {
                        color: '#00f7ff'
                    },
                    areaStyle: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                            { offset: 0, color: 'rgba(0, 247, 255, 0.3)' },
                            { offset: 1, color: 'rgba(0, 247, 255, 0.05)' }
                        ])
                    },
                    data: [32, 40, 68, 92, 78, 60]
                }
            ]
        };

        utilChart.setOption(utilOption);

        // 更新时间
        function updateTime() {
            const now = new Date();
            const timeStr = now.toLocaleTimeString('zh-CN', { hour12: false });
            const dateStr = now.toLocaleDateString('zh-CN', {
                year: 'numeric',
                month: 'long',
                day: 'numeric',
                weekday: 'long'
            });

            document.querySelector('.current-time').textContent = timeStr;
            document.querySelector('.current-date').textContent = dateStr;
        }

        setInterval(updateTime, 1000);
        updateTime();

        // 响应窗口大小变化
        window.addEventListener('resize', function () {
            mapChart.resize();
            utilChart.resize();
        });

        // 平台切换
        document.querySelectorAll('.platform-tab').forEach(tab => {
            tab.addEventListener('click', function () {
                document.querySelectorAll('.platform-tab').forEach(t => t.classList.remove('active'));
                this.classList.add('active');
            });
        });

        // 创建科技感背景网格
        function createGrid() {
            const gridContainer = document.getElementById('tech-bg');
            const width = window.innerWidth;
            const height = window.innerHeight;

            // 清除现有网格
            while (gridContainer.firstChild) {
                gridContainer.removeChild(gridContainer.firstChild);
            }

            // 创建垂直线
            for (let i = 0; i < width; i += 50) {
                const line = document.createElement('div');
                line.className = 'grid-line vertical';
                line.style.left = i + 'px';
                gridContainer.appendChild(line);
            }

            // 创建水平线
            for (let i = 0; i < height; i += 50) {
                const line = document.createElement('div');
                line.className = 'grid-line horizontal';
                line.style.top = i + 'px';
                gridContainer.appendChild(line);
            }
        }

        // 初始化和响应式调整
        createGrid();
        window.addEventListener('resize', createGrid);
    </script>
</body>
</html>--%>

<%--<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无人车运营数据大屏</title>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.4.3/dist/echarts.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/echarts-china-provinces-js@1.0.0/dist/province/beijing.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Microsoft YaHei', 'Segoe UI', sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #0c1b33, #1a3a5f);
            color: #fff;
            min-height: 100vh;
            overflow-x: hidden;
            padding: 20px;
        }
        
        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 30px;
            background: rgba(16, 35, 66, 0.7);
            border-radius: 15px;
            margin-bottom: 20px;
            box-shadow: 0 5px 25px rgba(0, 0, 0, 0.4);
        }
        
        .logo-section {
            display: flex;
            align-items: center;
        }
        
        .logo-section img {
            height: 60px;
            margin-right: 20px;
        }
        
        .title-section h1 {
            font-size: 2.5rem;
            letter-spacing: 2px;
            background: linear-gradient(to right, #00c6ff, #0072ff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-shadow: 0 0 10px rgba(0, 114, 255, 0.3);
        }
        
        .title-section p {
            font-size: 1rem;
            color: #a0c1eb;
            margin-top: 5px;
        }
        
        .time-section {
            text-align: right;
        }
        
        .time-section .current-time {
            font-size: 1.8rem;
            font-weight: bold;
            color: #4dabf7;
        }
        
        .time-section .current-date {
            font-size: 1.2rem;
            color: #a0c1eb;
        }
        
        .dashboard-content {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 20px;
            height: calc(100vh - 180px);
        }
        
        .main-section {
            display: grid;
            grid-template-rows: 1fr 1fr;
            gap: 20px;
        }
        
        .map-container {
            background: rgba(16, 35, 66, 0.7);
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 5px 25px rgba(0, 0, 0, 0.4);
            position: relative;
        }
        
        .map-title {
            font-size: 1.5rem;
            margin-bottom: 15px;
            color: #4dabf7;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .map-legend {
            display: flex;
            gap: 20px;
        }
        
        .legend-item {
            display: flex;
            align-items: center;
            font-size: 0.9rem;
        }
        
        .legend-color {
            width: 15px;
            height: 15px;
            border-radius: 50%;
            margin-right: 5px;
        }
        
        #china-map {
            width: 100%;
            height: calc(100% - 40px);
        }
        
        .stats-container {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }
        
        .stat-card {
            background: rgba(16, 35, 66, 0.7);
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 5px 25px rgba(0, 0, 0, 0.4);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            transition: transform 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            background: rgba(22, 50, 92, 0.8);
        }
        
        .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 15px;
        }
        
        .stat-value {
            font-size: 2.2rem;
            font-weight: bold;
            margin-bottom: 5px;
            color: #4dabf7;
        }
        
        .stat-label {
            font-size: 1rem;
            color: #a0c1eb;
        }
        
        .side-section {
            display: grid;
            grid-template-rows: 1fr 1fr;
            gap: 20px;
        }
        
        .vehicle-list {
            background: rgba(16, 35, 66, 0.7);
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 5px 25px rgba(0, 0, 0, 0.4);
            overflow-y: auto;
        }
        
        .section-title {
            font-size: 1.5rem;
            margin-bottom: 15px;
            color: #4dabf7;
        }
        
        .platform-tabs {
            display: flex;
            margin-bottom: 15px;
            background: rgba(22, 50, 92, 0.5);
            border-radius: 10px;
            overflow: hidden;
        }
        
        .platform-tab {
            flex: 1;
            text-align: center;
            padding: 10px;
            cursor: pointer;
            transition: background 0.3s ease;
        }
        
        .platform-tab.active {
            background: #0072ff;
        }
        
        .vehicle-item {
            display: flex;
            align-items: center;
            padding: 12px 15px;
            margin-bottom: 10px;
            background: rgba(22, 50, 92, 0.3);
            border-radius: 10px;
            transition: background 0.3s ease;
        }
        
        .vehicle-item:hover {
            background: rgba(22, 50, 92, 0.6);
        }
        
        .vehicle-icon {
            width: 40px;
            height: 40px;
            background: #0072ff;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            font-size: 1.2rem;
        }
        
        .vehicle-info {
            flex: 1;
        }
        
        .vehicle-name {
            font-size: 1.1rem;
            margin-bottom: 3px;
        }
        
        .vehicle-status {
            font-size: 0.9rem;
            color: #a0c1eb;
        }
        
        .status-indicator {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            margin-right: 8px;
            display: inline-block;
        }
        
        .status-online {
            background: #40c057;
        }
        
        .status-offline {
            background: #fa5252;
        }
        
        .status-busy {
            background: #fab005;
        }
        
        .data-chart {
            background: rgba(16, 35, 66, 0.7);
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 5px 25px rgba(0, 0, 0, 0.4);
        }
        
        #utilization-chart {
            width: 100%;
            height: 300px;
        }
        
        .dashboard-footer {
            text-align: center;
            margin-top: 20px;
            color: #a0c1eb;
            font-size: 0.9rem;
        }
        
        /* 动画效果 */
        @keyframes pulse {
            0% { opacity: 0.6; }
            50% { opacity: 1; }
            100% { opacity: 0.6; }
        }
        
        .pulse {
            animation: pulse 2s infinite;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="dashboard-header">
            <div class="logo-section">
                <img src="https://31580832.s21i.faiusr.com/4/ABUIABAEGAAglZ6PqQYogL_lywcw9wU44AY.png" alt="无人车管理系统">
                <div class="title-section">
                    <h1>无人车运营数据大屏</h1>
                    <p>九识智能 & 菜鸟蛮驴 | 全国车辆实时监控系统</p>
                </div>
            </div>
            <div class="time-section">
                <div class="current-time">14:28:36</div>
                <div class="current-date">2023年11月15日 星期三</div>
            </div>
        </div>
        
        <div class="dashboard-content">
            <div class="main-section">
                <div class="map-container">
                    <div class="map-title">
                        <span>全国无人车分布热力图</span>
                        <div class="map-legend">
                            <div class="legend-item">
                                <div class="legend-color" style="background-color: #40c057;"></div>
                                <span>九识智能</span>
                            </div>
                            <div class="legend-item">
                                <div class="legend-color" style="background-color: #4dabf7;"></div>
                                <span>菜鸟蛮驴</span>
                            </div>
                        </div>
                    </div>
                    <div id="china-map"></div>
                </div>
                
                <div class="stats-container">
                    <div class="stat-card">
                        <div class="stat-icon">🚗</div>
                        <div class="stat-value">1,248</div>
                        <div class="stat-label">在线车辆总数</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon">📦</div>
                        <div class="stat-value">8,562</div>
                        <div class="stat-label">今日配送包裹</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon">📊</div>
                        <div class="stat-value">96.8%</div>
                        <div class="stat-label">准时送达率</div>
                    </div>
                </div>
            </div>
            
            <div class="side-section">
                <div class="vehicle-list">
                    <div class="section-title">车辆实时状态</div>
                    <div class="platform-tabs">
                        <div class="platform-tab active">九识智能</div>
                        <div class="platform-tab">菜鸟蛮驴</div>
                    </div>
                    
                    <div class="vehicle-items">
                        <div class="vehicle-item">
                            <div class="vehicle-icon">九</div>
                            <div class="vehicle-info">
                                <div class="vehicle-name">京A-9S001</div>
                                <div class="vehicle-status">
                                    <span class="status-indicator status-online"></span>
                                    北京市海淀区 | 配送中
                                </div>
                            </div>
                        </div>
                        
                        <div class="vehicle-item">
                            <div class="vehicle-icon">九</div>
                            <div class="vehicle-info">
                                <div class="vehicle-name">沪B-9S045</div>
                                <div class="vehicle-status">
                                    <span class="status-indicator status-busy"></span>
                                    上海市浦东新区 | 装载中
                                </div>
                            </div>
                        </div>
                        
                        <div class="vehicle-item">
                            <div class="vehicle-icon">菜</div>
                            <div class="vehicle-info">
                                <div class="vehicle-name">粤C-ML128</div>
                                <div class="vehicle-status">
                                    <span class="status-indicator status-online"></span>
                                    广州市天河区 | 待命
                                </div>
                            </div>
                        </div>
                        
                        <div class="vehicle-item">
                            <div class="vehicle-icon">九</div>
                            <div class="vehicle-info">
                                <div class="vehicle-name">深D-9S078</div>
                                <div class="vehicle-status">
                                    <span class="status-indicator status-online"></span>
                                    深圳市南山区 | 配送中
                                </div>
                            </div>
                        </div>
                        
                        <div class="vehicle-item">
                            <div class="vehicle-icon">菜</div>
                            <div class="vehicle-info">
                                <div class="vehicle-name">杭E-ML056</div>
                                <div class="vehicle-status">
                                    <span class="status-indicator status-online"></span>
                                    杭州市西湖区 | 返程中
                                </div>
                            </div>
                        </div>
                        
                        <div class="vehicle-item">
                            <div class="vehicle-icon">九</div>
                            <div class="vehicle-info">
                                <div class="vehicle-name">津F-9S112</div>
                                <div class="vehicle-status">
                                    <span class="status-indicator status-offline"></span>
                                    天津市滨海新区 | 维护中
                                </div>
                            </div>
                        </div>
                        
                        <div class="vehicle-item">
                            <div class="vehicle-icon">菜</div>
                            <div class="vehicle-info">
                                <div class="vehicle-name">渝G-ML092</div>
                                <div class="vehicle-status">
                                    <span class="status-indicator status-busy"></span>
                                    重庆市渝中区 | 装载中
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="data-chart">
                    <div class="section-title">车辆利用率分析</div>
                    <div id="utilization-chart"></div>
                </div>
            </div>
        </div>
        
        <div class="dashboard-footer">
            <p>数据更新时间: 2023-11-15 14:28:36 | 系统版本: V2.3.5 | © 2023 无人车运营数据平台</p>
        </div>
    </form>

    <script>
        // 初始化中国地图
        const mapChart = echarts.init(document.getElementById('china-map'));
        
        // 模拟数据 - 九识智能车辆分布
        const jiusiData = [
            {name: '北京', value: 128},
            {name: '上海', value: 96},
            {name: '广州', value: 85},
            {name: '深圳', value: 78},
            {name: '杭州', value: 65},
            {name: '成都', value: 58},
            {name: '武汉', value: 52},
            {name: '南京', value: 48},
            {name: '重庆', value: 45},
            {name: '天津', value: 42},
            {name: '西安', value: 38},
            {name: '苏州', value: 35},
            {name: '郑州', value: 32},
            {name: '长沙', value: 28},
            {name: '合肥', value: 25}
        ];
        
        // 模拟数据 - 菜鸟蛮驴车辆分布
        cainiaoData = [
            {name: '北京', value: 95},
            {name: '上海', value: 88},
            {name: '广州', value: 76},
            {name: '深圳', value: 72},
            {name: '杭州', value: 92},
            {name: '成都', value: 65},
            {name: '武汉', value: 48},
            {name: '南京', value: 42},
            {name: '重庆', value: 38},
            {name: '天津', value: 35},
            {name: '西安', value: 32},
            {name: '苏州', value: 28},
            {name: '郑州', value: 26},
            {name: '长沙', value: 22},
            {name: '合肥', value: 20}
        ];
        
        // 地图配置
        const mapOption = {
            backgroundColor: 'transparent',
            tooltip: {
                trigger: 'item',
                formatter: function(params) {
                    return `${params.name}<br/>
                    九识智能: ${jiusiData.find(d => d.name === params.name)?.value || 0}辆<br/>
                    菜鸟蛮驴: ${cainiaoData.find(d => d.name === params.name)?.value || 0}辆`;
                }
            },
            visualMap: {
                min: 0,
                max: 150,
                text: ['高', '低'],
                realtime: false,
                calculable: true,
                inRange: {
                    color: ['#4575b4', '#74add1', '#abd9e9', '#e0f3f8', '#ffffbf', '#fee090', '#fdae61', '#f46d43', '#d73027']
                }
            },
            series: [
                {
                    name: '九识智能',
                    type: 'map',
                    map: 'china',
                    roam: true,
                    zoom: 1.2,
                    label: {
                        show: true,
                        fontSize: 10
                    },
                    emphasis: {
                        label: {
                            show: true,
                            color: '#fff'
                        },
                        itemStyle: {
                            areaColor: '#40c057'
                        }
                    },
                    data: jiusiData
                },
                {
                    name: '菜鸟蛮驴',
                    type: 'effectScatter',
                    coordinateSystem: 'geo',
                    data: cainiaoData.map(item => ({
                        name: item.name,
                        value: [Math.random() * 10 + 110, Math.random() * 5 + 30, item.value]
                    })),
                    symbolSize: function(val) {
                        return Math.sqrt(val[2]) * 3;
                    },
                    showEffectOn: 'render',
                    rippleEffect: {
                        brushType: 'stroke'
                    },
                    hoverAnimation: true,
                    itemStyle: {
                        color: '#4dabf7',
                        shadowBlur: 10,
                        shadowColor: '#4dabf7'
                    },
                    zlevel: 1
                }
            ]
        };
        
        mapChart.setOption(mapOption);
        
        // 初始化利用率图表
        const utilChart = echarts.init(document.getElementById('utilization-chart'));
        
        const utilOption = {
            backgroundColor: 'transparent',
            tooltip: {
                trigger: 'axis'
            },
            legend: {
                data: ['九识智能', '菜鸟蛮驴'],
                textStyle: {
                    color: '#a0c1eb'
                },
                right: 10,
                top: 10
            },
            grid: {
                left: '3%',
                right: '4%',
                bottom: '3%',
                top: '15%',
                containLabel: true
            },
            xAxis: {
                type: 'category',
                boundaryGap: false,
                data: ['00:00', '04:00', '08:00', '12:00', '16:00', '20:00'],
                axisLine: {
                    lineStyle: {
                        color: '#a0c1eb'
                    }
                },
                axisLabel: {
                    color: '#a0c1eb'
                }
            },
            yAxis: {
                type: 'value',
                axisLabel: {
                    formatter: '{value}%',
                    color: '#a0c1eb'
                },
                axisLine: {
                    lineStyle: {
                        color: '#a0c1eb'
                    }
                },
                splitLine: {
                    lineStyle: {
                        color: 'rgba(160, 193, 235, 0.1)'
                    }
                }
            },
            series: [
                {
                    name: '九识智能',
                    type: 'line',
                    smooth: true,
                    symbol: 'circle',
                    symbolSize: 8,
                    lineStyle: {
                        width: 3,
                        color: '#40c057'
                    },
                    itemStyle: {
                        color: '#40c057'
                    },
                    areaStyle: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                            {offset: 0, color: 'rgba(64, 192, 87, 0.5)'},
                            {offset: 1, color: 'rgba(64, 192, 87, 0.1)'}
                        ])
                    },
                    data: [28, 35, 72, 88, 84, 65]
                },
                {
                    name: '菜鸟蛮驴',
                    type: 'line',
                    smooth: true,
                    symbol: 'circle',
                    symbolSize: 8,
                    lineStyle: {
                        width: 3,
                        color: '#4dabf7'
                    },
                    itemStyle: {
                        color: '#4dabf7'
                    },
                    areaStyle: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                            {offset: 0, color: 'rgba(77, 171, 247, 0.5)'},
                            {offset: 1, color: 'rgba(77, 171, 247, 0.1)'}
                        ])
                    },
                    data: [32, 40, 68, 92, 78, 60]
                }
            ]
        };
        
        utilChart.setOption(utilOption);
        
        // 更新时间
        function updateTime() {
            const now = new Date();
            const timeStr = now.toLocaleTimeString('zh-CN', {hour12: false});
            const dateStr = now.toLocaleDateString('zh-CN', { 
                year: 'numeric', 
                month: 'long', 
                day: 'numeric',
                weekday: 'long'
            });
            
            document.querySelector('.current-time').textContent = timeStr;
            document.querySelector('.current-date').textContent = dateStr;
        }
        
        setInterval(updateTime, 1000);
        updateTime();
        
        // 响应窗口大小变化
        window.addEventListener('resize', function() {
            mapChart.resize();
            utilChart.resize();
        });
        
        // 平台切换
        document.querySelectorAll('.platform-tab').forEach(tab => {
            tab.addEventListener('click', function() {
                document.querySelectorAll('.platform-tab').forEach(t => t.classList.remove('active'));
                this.classList.add('active');
            });
        });
    </script>
</body>
</html>--%>
