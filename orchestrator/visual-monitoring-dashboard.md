# Visual Monitoring Dashboard

## Overview

Phase 4 introduces a comprehensive visual monitoring dashboard that provides real-time insights into orchestrator performance, droid coordination, and system health. This creates an enterprise-grade monitoring experience with interactive visualizations and alerting.

## Dashboard Architecture

### Dashboard Components

#### 1. Main Dashboard Layout
```typescript
interface MainDashboard {
  header: {
    title: string;
    navigation: NavigationItem[];
    user_info: UserInfo;
    system_status: SystemStatus;
  };
  
  overview: {
    kpi_cards: KPICard[];
    real_time_metrics: RealTimeMetric[];
    system_health: SystemHealth;
    alerts_summary: AlertSummary;
  };
  
  sections: {
    orchestration: OrchestrationSection;
    performance: PerformanceSection;
    droids: DroidsSection;
    cloud_resources: CloudResourcesSection;
    analytics: AnalyticsSection;
  };
  
  sidebar: {
    quick_actions: QuickAction[];
    system_logs: SystemLogsSection;
    recent_activities: RecentActivitiesSection;
  };
}
```

#### 2. Real-Time Metrics
```typescript
interface RealTimeMetric {
  id: string;
  name: string;
  description: string;
  value: number;
  unit: string;
  trend: "up" | "down" | "stable";
  trend_percentage: number;
  last_updated: Date;
  status: "good" | "warning" | "critical";
  sparkline_data: SparklineDataPoint[];
}
```

#### 3. Interactive Charts
```typescript
interface InteractiveChart {
  id: string;
  title: string;
  type: "line" | "bar" | "pie" | "area" | "scatter" | "heatmap";
  data: ChartData[];
  options: ChartOptions;
  filters: ChartFilter[];
  refresh_interval: number;
  drill_down_enabled: boolean;
  export_enabled: boolean;
}
```

## Dashboard Sections

### 1. Orchestration Overview
```typescript
interface OrchestrationSection {
  title: "Orchestration Overview";
  
  kpi_metrics: {
    total_active_tasks: RealTimeMetric;
    success_rate: RealTimeMetric;
    average_duration: RealTimeMetric;
    droid_utilization: RealTimeMetric;
    conflict_rate: RealTimeMetric;
  };
  
  real_time_tasks: {
    tasks: ActiveTask[];
    total_count: number;
    by_status: TaskStatusBreakdown;
  };
  
  orchestrator_performance: {
    orchestrator_id: string;
    tasks_completed: number;
    average_completion_time: number;
    success_rate: number;
    current_load: number;
  };
}
```

### 2. Performance Analytics
```typescript
interface PerformanceSection {
  title: "Performance Analytics";
  
  charts: {
    task_completion_trend: InteractiveChart;
    droid_performance_comparison: InteractiveChart;
    cost_optimization_trend: InteractiveChart;
    resource_utilization: InteractiveChart;
  };
  
  metrics: {
    performance_trends: PerformanceTrendData[];
    bottleneck_analysis: BottleneckAnalysis[];
    optimization_impact: OptimizationImpactAnalysis[];
  };
  
  alerts: {
    performance_alerts: Alert[];
    efficiency_alerts: Alert[];
    resource_alerts: Alert[];
  };
}
```

### 3. Droid Health Monitoring
```typescript
interface DroidsSection {
  title: "Droid Health Monitoring";
  
  droid_grid: DroidGridItem[];
  
  droid_details: Map<string, DroidDetails>;
  
  health_metrics: {
    overall_health_score: number;
    unhealthy_droids: string[];
    degrading_droids: string[];
    performance_issues: DroidPerformanceIssue[];
  };
  
  communication_metrics: {
    message_volume: MessageVolumeMetric;
    response_time: ResponseTimeMetric;
    communication_efficiency: CommunicationEfficiencyMetric;
  };
}
```

### 4. Cloud Resources Monitoring
```typescript
interface CloudResourcesSection {
  title: "Cloud Resources";
  
  resource_overview: {
    total_resources: number;
    active_resources: number;
    total_cost_per_hour: number;
    cost_optimization_score: number;
  };
  
  resource_cards: ResourceCard[];
  
  resource_utilization: {
    cpu_utilization: RealTimeMetric;
    memory_utilization: RealTimeMetric;
    storage_utilization: RealTimeMetric;
    network_utilization: RealTimeMetric;
  };
  
  cost_tracking: {
    daily_costs: DailyCostData[];
    cost_breakdown: CostBreakdownData[];
    cost_optimization_suggestions: CostOptimizationSuggestion[];
  };
}
```

### 5. Analytics and Insights
```typescript
interface AnalyticsSection {
  title: "Analytics & Insights";
  
  executive_summary: {
    total_tasks_completed: number;
    average_success_rate: number;
    total_cost_saved: number;
    performance_improvement: number;
  };
  
  detailed_analytics: {
    task_type_performance: TaskTypePerformance[];
    droid_effectiveness: DroidEffectivenessAnalysis[];
    pattern_performance: PatternPerformanceAnalysis[];
    optimization_success_rate: OptimizationSuccessRate[];
  };
  
  insights: {
    recommendations: Recommendation[];
    opportunities: OptimizationOpportunity[];
    risks: RiskAssessment[];
    trends: TrendAnalysis[];
  };
}
```

## Web Dashboard Implementation

### Frontend Framework Integration
```typescript
import React, { useState, useEffect, useCallback } from 'react';
import { Line, Bar, Pie, Area, Scatter } from 'recharts';
import { Card, CardContent, Typography } from '@mui/material';

const MonitoringDashboard: React.FC = () => {
  const [dashboardData, setDashboardData] = useState<DashboardData>();
  const [selectedTimeRange, setSelectedTimeRange] = useState("24h");
  const [autoRefresh, setAutoRefresh] = useState(true);
  const [alerts, setAlerts] = useState<Alert[]>([]);
  
  useEffect(() => {
    const interval = autoRefresh ? 30000 : 0; // 30 seconds
    const intervalId = setInterval(() => {
      fetchDashboardData();
    }, interval);
    
    return () => clearInterval(intervalId);
  }, [autoRefresh, selectedTimeRange]);
  
  const fetchDashboardData = useCallback(async () => {
    try {
      const response = await fetch('/api/dashboard/data');
      const data = await response.json();
      setDashboardData(data);
      
      // Update alerts if new ones are detected
      if (data.alerts?.length > alerts.length) {
        setAlerts(data.alerts);
      }
    } catch (error) {
      console.error('Failed to fetch dashboard data:', error);
    }
  }, []);
  
  const handleTimeRangeChange = (newRange: string) => {
    setSelectedTimeRange(newRange);
  };
  
  const handleAlertClick = (alert: Alert) => {
    // Navigate to detailed alert view
    window.location.href = `/dashboard/alerts/${alert.id}`;
  };
  
  const handleChartClick = (chartId: string) => {
    // Open detailed chart view
    window.location.href = `/dashboard/charts/${chartId}`;
  };
  
  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <Header 
        title="Factory CLI Orchestrator Dashboard"
        user={dashboardData?.user_info}
        systemStatus={dashboardData?.system_status}
        onTimeRangeChange={handleTimeRangeChange}
      />
      
      {/* Main Content */}
      <main className="container mx-auto p-6">
        {/* KPI Cards */}
        <KPICards 
          metrics={dashboardData?.overview?.kpi_cards}
          alerts={dashboardData?.overview?.alerts_summary}
        />
        
        {/* Main Dashboard Grid */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* Orchestration Section */}
          <div className="lg:col-span-2">
            <OrchestrationSection 
              data={dashboardData?.orchestration}
              onTaskClick={handleTaskClick}
              onChartClick={handleChartClick}
            />
          </div>
          
          {/* Performance Section */}
          <div className="lg:col-span-1">
            <PerformanceSection 
              data={dashboardData?.performance}
              onChartClick={handleChartClick}
            />
          </div>
          
          {/* Droids Section */}
          <div className="lg:col-span-2">
            <DroidsSection 
              data={dashboardData?.droids}
              onDroidClick={handleDroidClick}
            />
          </div>
          
          {/* Cloud Resources Section */}
          <div className="lg:col-span-1">
            <CloudResourcesSection 
              data={dashboardData?.cloud_resources}
              onResourceClick={handleResourceClick}
            />
          </div>
          
          {/* Analytics Section */}
          <div className="lg:col-span-3">
            <AnalyticsSection 
              data={dashboard_data?.analytics}
              onChartClick={onChartClick}
            />
          </div>
        </div>
        
        {/* Recent Activities Timeline */}
        <RecentActivities activities={dashboardData?.sidebar?.recent_activities} />
      </main>
      
      {/* Footer */}
      <Footer 
        last_updated={dashboardData?.last_updated}
        system_version={dashboardData?.system_version}
      />
    </div>
  );
};
```

### Real-Time Data API
```typescript
// Dashboard API Routes
app.get('/api/dashboard/data', async (req, res) => {
  try {
    const timeRange = req.query.timeRange || '24h';
    
    // Fetch real-time metrics
    const [
      kpiData,
      orchestratorMetrics,
      droidMetrics,
      cloudMetrics,
      alertData
    ] = await Promise.all([
      fetchKPIMetrics(timeRange),
      fetchOrchestratorMetrics(timeRange),
      fetchDroidMetrics(timeRange),
      fetchCloudMetrics(timeRange),
      fetchAlerts(timeRange)
    ]);
    
    const responseData = {
      overview: {
        kpi_cards: kpiData,
        system_health: await getSystemHealth(),
        alerts_summary: summarizeAlerts(alertData)
      },
      orchestration: {
        real_time_tasks: await getActiveTasks(),
        orchestrator_performance: orchestratorMetrics,
        kpi_metrics: extractOrchestrationKPI(orchestratorMetrics)
      },
      performance: {
        charts: await getPerformanceCharts(timeRange),
        metrics: await getPerformanceMetrics(timeRange),
        bottlenecks: await identifyBottlenecks()
      },
      droids: {
        droid_grid: await getDroidGrid(),
        droid_details: await getDroidDetails(),
        communication_metrics: await getCommunicationMetrics()
      },
      cloud_resources: {
        resource_overview: await getResourceOverview(),
        resource_utilization: await getResourceUtilization(),
        cost_tracking: await getCostTracking(timeRange)
      },
      analytics: {
        executive_summary: await getExecutiveSummary(timeRange),
        detailed_analytics: await getDetailedAnalytics(timeRange),
        insights: await generateInsights(timeRange)
      },
      alerts: alertData,
      last_updated: new Date(),
      system_version: "4.0.0"
    };
    
    res.json(responseData);
    
  } catch (error) {
    console.error('Dashboard API error:', error);
    res.status(500).json({ error: 'Failed to fetch dashboard data' });
  }
});

// KPI Metrics Endpoint
app.get('/api/kpi/metrics', async (req, res) => {
  const timeRange = req.query.timeRange || '24h';
  
  const metrics = await Promise.all([
    getTaskCompletionRate(timeRange),
    getAverageTaskDuration(timeRange),
    getSuccessRate(timeRange),
    getResourceUtilization(timeRange),
    getConflictResolutionRate(timeRange),
    getDroidEfficiencyScore(timeRange)
  ]);
  
  const kpiCards = [
    {
      id: 'task_completion_rate',
      name: 'Task Completion Rate',
      value: metrics[0],
      unit: '%',
      target: 90,
      trend: calculateTrend(metrics[0]),
      status: metrics[0] >= 90 ? 'good' : metrics[0] >= 70 ? 'warning' : 'critical',
      icon: 'check_circle',
      color: metrics[0] >= 90 ? 'green' : metrics[0] >= 70 ? 'yellow' : 'red'
    },
    {
      id: 'success_rate',
      name: 'Success Rate',
      value: metrics[2],
      unit: '%',
      target: 85,
      trend: calculateTrend(metrics[2]),
      status: metrics[2] >= 85 ? 'good' : 'warning',
      icon: 'check_circle',
      color: metrics[2] >= 85 ? 'green' : 'yellow'
    },
    {
      id: 'average_duration',
      name: 'Average Duration',
      value: metrics[1],
      unit: 'min',
      target: 60,
      trend: calculateTrend(metrics[1]),
      status: metrics[1] <= 60 ? 'good' : 'warning',
      icon: 'timer',
      color: metrics[1] <= 60 ? 'green' : 'orange'
    }
  ];
  
  res.json({ kpi_cards: kpi_cards });
});

// Real-Time Metrics WebSocket
app.ws('/api/metrics/realtime', (ws) => {
  ws.on('connection', () => {
    console.log('Connected to real-time metrics stream');
  });
  
  ws.on('message', (data) => {
    const metric = JSON.parse(data);
    
    // Broadcast to all connected dashboard clients
    ws.broadcast(JSON.stringify({
      type: 'metric_update',
      data: metric
    }));
  });
});
```

## Chart Implementations

### Interactive Charts
```typescript
interface ChartComponentProps {
  chartId: string;
  data: ChartData;
  options: ChartOptions;
  filters: ChartFilter[];
  onDrillDown: (dataPoint: DataPoint) => void;
  onExport: (format: string) => void;
}

const TaskCompletionTrendChart: React.FC<ChartComponentProps> = ({ data, options, onDrillDown }) => {
  const [chartData, setChartData] = useState(data);
  
  const handleDataPointClick = (dataPoint: any) => {
    onDrillDown(dataPoint);
  };
  
  const handleExport = (format: string) => {
    const chartElement = document.getElementById(`chart-${data.chartId}`);
    if (chartElement) {
      const chart = chartElement.chart;
      const url = chart.toBase64Image(format);
      
      // Create download link
      const link = document.createElement('a');
      link.download = `${data.chartId}-export.${format}`;
      link.href = url;
      link.click();
      link.remove();
    }
  };
  
  return (
    <Card>
      <CardContent>
        <Typography variant="h6" gutterBottom={2}>
          Task Completion Trend
        </Typography>
        <ResponsiveContainer width="100%" height={300}>
          <Line
            data={chartData}
            options={{
              responsive: true,
              plugins: {
                legend: {
                  position: 'top',
                },
                tooltip: {
                  mode: 'index',
                  intersect: false
                },
                zoom: {
                  zoom: {
                    wheel: {
                      enabled: true,
                    },
                  pan: {
                    enabled: true,
                  }
                }
              },
              }}
              onClick={handleDataPointClick}
              onDoubleClick={handleExport}
            />
        </ResponsiveContainer>
      </CardContent>
    </Card>
  );
};
```

### Droid Grid Visualization
```typescript
const DroidGrid: React.FC<DroidGridProps> = ({ droids, onDroidClick }) => {
  const handleDroidClick = (droidId: string) => {
    onDroidClick(droidId);
  };
  
  const getStatusColor = (status: string): string => {
    switch (status) {
      case 'healthy': return '#4ade80';
      case 'degraded': return '#FFA500';
      case 'overloaded': return '#FF9800';
      case 'offline': return '#E53935';
      default: return '#9CA3AF';
    }
  };
  
  const getStatusIcon = (status: string): string => {
    switch (status) {
      case 'healthy': return '✓';
      case 'degraded': '⚠️';
      case 'overloaded': '⏳';
      case 'offline': '❌';
      default: '🔄';
    }
  };
  
  const getHealthScore = (droid: DroidDetails): number => {
    return droid.health_score || 0;
  };
  
  return (
    <Card>
      <CardContent>
        <Typography variant="h6" gutterBottom={2}>
          Droid Health Grid
        </Typography>
        <Grid container spacing={2}>
          {droids.map((droid) => (
            <Grid item xs={12} sm={6} md={4} lg={3}>
              <Card 
                onClick={() => handleDroidClick(droid.id)}
                sx={{ 
                  backgroundColor: getStatusColor(droid.status),
                  cursor: 'pointer',
                  '&:hover': {
                    backgroundColor: this.darkenColor(getStatusColor(droid.status))
                  }
                }}
              >
                <CardContent>
                  <Typography variant="h6">
                    {droid.name}
                  </Typography>
                  <Box sx={{ display: 'flex', alignItems: 'center', mb: 1 }}>
                    <Typography variant="body1">
                      {getStatusIcon(droid.status)}
                    </Typography>
                    <Typography variant="body2">
                      {droid.current_load}/{droid.max_capacity}
                    </Typography>
                  </Box>
                  <Box sx={{ mb: 1 }}>
                    <LinearProgress
                      variant="determinate"
                      value={getHealthScore(droid)}
                      color={getHealthScore(droid) > 70 ? 'primary' : 'secondary'}
                    />
                  </Box>
                  <Typography variant="body2" color="text.secondary">
                    Health Score: {getHealthScore(droid)}
                  </Typography>
                </CardContent>
              </Card>
            </Grid>
          ))}
        </Grid>
      </CardContent>
    </Card>
  );
};
```

## Alert Management

### Alert System
```typescript
interface AlertSystem {
  alert_levels: AlertLevel[];
  active_alerts: Alert[];
  alert_history: Alert[];
  notification_channels: NotificationChannel[];
}

interface Alert {
  id: string;
  type: "performance" | "conflict" | "error" | "warning" | "info";
  severity: "low" | "medium" | "high" | "critical";
  title: string;
  description: string;
  source: string;
  timestamp: Date;
  affected_components: string[];
  recommended_actions: string[];
  status: "active" | "acknowledged" | "resolved" | "suppressed";
}
```

### Alert Notification Component
```typescript
const AlertNotification: React.FC<{ alert: Alert }> = ({ alert }) => {
  const handleDismiss = () => {
    // Mark alert as acknowledged
    await this.acknowledgeAlert(alert.id);
  };
  
  const getAlertColor = (severity: string): string => {
    switch (severity) {
      case "critical": return '#f44336';
      case "high": return '#ff9800';
      case "medium": return '#ffc107';
      case "low": return '#ffeb3b';
      default: '#2196F3';
    }
  };
  
  const getAlertIcon = (type: string): string => {
    switch (type) {
      case "error": '❌';
      case "warning": '⚠️';
      case "info": 'ℹ️';
      case "performance": '📊';
      case "conflict": '⚡️';
      default: 'ℹ️';
    }
  };
  
  return (
    <Alert 
      severity={alert.severity}
      sx={{
        backgroundColor: getAlertColor(alert.severity),
        border: `1px solid ${getAlertColor(alert.severity)}20}`,
        margin: 1
      }}
      action={
        <IconButton 
          size="small"
          onClick={handleDismiss}
        >
          <CloseIcon fontSize="small" />
        </IconButton>
      }
    >
      <AlertTitle>{alert.title}</AlertTitle>
      <AlertDescription>{alert.description}</AlertDescription>
    </Alert>
  );
};
```

## Performance Optimization

### Real-Time Data Streaming
```typescript
class RealTimeDataStreamer {
  private webSocketServer: WebSocketServer;
  private subscribers: Map<string, WebSocket>;
  
  constructor() {
    this.webSocketServer = new WebSocketServer({ port: 8080 });
    this.webSocketServer.on('connection', this.handleConnection);
    this.startDataCollection();
  }
  
  private handleConnection = (ws: WebSocket) => {
    const clientId = this.generateClientId();
    this.subscribers.set(clientId, ws);
    
    ws.on('message', (message) => {
      // Handle incoming data
      this.processMessage(clientId, message);
    });
    
    ws.on('close', () => {
      this.subscribers.delete(clientId);
    });
  }
  
  private startDataCollection(): void {
    // Collect metrics every 5 seconds
    setInterval(() => {
      this.collectAndStreamMetrics();
    }, 5000);
  }
  
  private collectAndStreamMetrics(): void {
    const metrics = Promise.all([
      this.collectOrchestrationMetrics(),
      this.collectDroidMetrics(),
      this.collectPerformanceMetrics(),
      this.collectAlertMetrics()
    ]);
    
    const combinedMetrics = this.combineMetrics(metrics);
    
    // Broadcast to all subscribers
    this.broadcastMetrics(combinedMetrics);
  }
  
  private broadcastMetrics(metrics: any): void {
    const message = JSON.stringify({
      type: 'metrics_update',
      data: metrics,
      timestamp: new Date()
    });
    
    for (const [clientId, ws] of this.subscribers) {
      ws.send(message);
    }
  }
}
```

---

This visual monitoring dashboard provides comprehensive real-time visibility into all aspects of the orchestrator system with interactive visualizations and proactive alerting! 📊🎛️🔍✨
