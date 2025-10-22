# 📊 可观测性（Observability / o11y）使用指南

## 🎯 什么是可观测性（o11y）？

**Observability（可观测性）**是指通过系统的外部输出来理解系统内部状态的能力。在微服务架构中，o11y 是确保系统可靠性、性能和可维护性的关键。

**o11y** = **o** + 11 个字母（bservabilit）+ **y**

---

## 🏗️ 可观测性三大支柱

### 1. 📈 Metrics（指标）
**作用**：量化系统性能和健康状况

**工具栈**：
- **Prometheus** - 时序数据库，收集和存储指标
- **Grafana** - 可视化仪表板

**常见指标**：
```
- 请求速率（Request Rate）
- 响应时间（Latency）
- 错误率（Error Rate）
- CPU/内存使用率
- JVM 堆内存
- 数据库连接池
```

### 2. 📝 Logs（日志）
**作用**：记录系统事件和错误详情

**工具栈**：
- **Loki** - 日志聚合系统
- **Promtail** - 日志收集器（从 Docker 容器收集）
- **Fluent-bit** - 日志转发器（通过 Fluentd 协议）
- **Grafana** - 日志查询和可视化

**日志类型**：
```
- 应用日志（Application Logs）
- 访问日志（Access Logs）
- 错误日志（Error Logs）
- 审计日志（Audit Logs）
```

### 3. 🔍 Traces（追踪）
**作用**：跟踪请求在分布式系统中的完整路径

**工具栈**：
- **Tempo** - 分布式追踪后端
- **OpenTelemetry** - 追踪数据采集（集成在应用中）
- **Zipkin** - 追踪数据格式（兼容协议）
- **Grafana** - 追踪可视化

**追踪信息**：
```
- Trace ID（追踪 ID）
- Span ID（跨度 ID）
- 服务调用链
- 每个服务的耗时
- 错误信息
```

---

## 🚀 快速启动

### 1. 启动可观测性栈

```bash
# 1. 确保在项目根目录
cd /Users/chensoul/development/personal/spring-boot-microservices-course

# 2. 启动基础设施（数据库、消息队列等）
docker compose -f deployment/docker-compose/infra.yml up -d

# 3. 启动应用服务
docker compose -f deployment/docker-compose/apps.yml up -d

# 4. 启动可观测性栈
docker compose -f deployment/docker-compose/o11y.yml up -d

# 5. 查看所有容器状态
docker compose -f deployment/docker-compose/infra.yml \
               -f deployment/docker-compose/apps.yml \
               -f deployment/docker-compose/o11y.yml ps
```

### 2. 一键启动所有服务

```bash
# 同时启动所有服务
docker compose -f deployment/docker-compose/infra.yml \
               -f deployment/docker-compose/apps.yml \
               -f deployment/docker-compose/o11y.yml up -d

# 查看日志
docker compose -f deployment/docker-compose/o11y.yml logs -f

# 停止所有服务
docker compose -f deployment/docker-compose/infra.yml \
               -f deployment/docker-compose/apps.yml \
               -f deployment/docker-compose/o11y.yml down
```

---

## 🎨 访问可观测性工具

### 📊 Grafana - 统一可视化平台
**URL**: http://localhost:3000  
**登录**:
- 用户名: `admin`
- 密码: `admin1234`

**功能**:
- 📈 查看 Prometheus 指标仪表板
- 📝 查询 Loki 日志
- 🔍 追踪 Tempo 调用链
- 🎯 创建自定义仪表板
- 🔔 配置告警规则

**推荐仪表板**:
1. **Spring Boot Statistics** - 预置的 Spring Boot 监控面板
2. **JVM Metrics** - JVM 内存、GC、线程监控
3. **Service Overview** - 服务总览

---

### 📈 Prometheus - 指标收集
**URL**: http://localhost:9090

**功能**:
- 查询指标（PromQL）
- 查看采集目标状态
- 图表可视化
- 告警规则管理

**常用 PromQL 查询**:
```promql
# 请求速率（每秒请求数）
rate(http_server_requests_seconds_count[5m])

# 95分位延迟
histogram_quantile(0.95, rate(http_server_requests_seconds_bucket[5m]))

# 错误率
rate(http_server_requests_seconds_count{status=~"5.."}[5m])

# JVM 堆内存使用率
jvm_memory_used_bytes{area="heap"} / jvm_memory_max_bytes{area="heap"}

# CPU 使用率
system_cpu_usage

# 服务健康状态
up{job=~".*-service"}
```

**查看目标状态**:
- 访问: http://localhost:9090/targets
- 确认所有服务状态为 "UP"

---

### 📝 Loki - 日志聚合
**URL**: 通过 Grafana 访问（http://localhost:3000/explore）

**功能**:
- 集中式日志查询
- 日志流实时查看
- 与 Metrics 和 Traces 关联

**LogQL 查询示例**:
```logql
# 查看 catalog-service 的所有日志
{container_name="catalog-service"}

# 查看错误日志
{container_name="catalog-service"} |= "ERROR"

# 查看特定时间范围的日志
{container_name="order-service"} | json | level="ERROR"

# 正则表达式过滤
{container_name=~".*-service"} |~ "Exception|Error"

# 查看包含特定 Trace ID 的日志
{container_name="order-service"} |= "traceId=abc123"
```

**日志级别过滤**:
```logql
{container_name="catalog-service"} | json | level="ERROR"
{container_name="catalog-service"} | json | level="WARN"
{container_name="catalog-service"} | json | level="INFO"
```

---

### 🔍 Tempo - 分布式追踪
**URL**: http://localhost:3200  
**或通过 Grafana**: http://localhost:3000/explore（选择 Tempo 数据源）

**功能**:
- 可视化服务调用链
- 识别性能瓶颈
- 追踪错误根因
- 关联 Logs 和 Metrics

**Zipkin 端点**:
- **URL**: http://localhost:9411
- **用途**: 应用通过 Zipkin 协议发送追踪数据

**追踪查询**:
1. 在 Grafana 中选择 Tempo 数据源
2. 输入 Trace ID 或使用服务/操作搜索
3. 查看完整的服务调用瀑布图

**Trace 分析**:
```
Trace ID: abc123def456
├─ api-gateway (50ms)
│  ├─ GET /catalog/products
│  └─ catalog-service (40ms)
│     ├─ database query (30ms)
│     └─ business logic (10ms)
└─ Total: 50ms
```

---

### 🚰 Fluent-bit - 日志转发
**Port**: 24224 (Fluentd protocol)

**功能**:
- 从 Docker 容器收集日志
- 转发到 Loki
- 支持日志过滤和转换

**Docker 日志驱动配置**:
```yaml
# apps.yml 中的配置
services:
  catalog-service:
    logging:
      driver: fluentd
      options:
        fluentd-address: 127.0.0.1:24224
```

---

## 📋 可观测性数据流

### 完整数据流程

```
┌─────────────────────┐
│  Spring Boot Apps   │
│  (catalog, order,   │
│   notification)     │
└──────────┬──────────┘
           │
           ├─── Metrics ────────→ Prometheus ───→ Grafana
           │                         ↓
           │                    (时序数据)
           │
           ├─── Logs ──────────→ Fluent-bit ───→ Loki ───→ Grafana
           │                         ↓
           │                    (日志聚合)
           │
           └─── Traces ────────→ Tempo ───────→ Grafana
                                    ↓
                              (分布式追踪)
```

### 各服务端点

| 服务 | 类型 | 端点 | 说明 |
|------|------|------|------|
| **catalog-service** | Metrics | http://localhost:8081/actuator/prometheus | Prometheus 格式指标 |
| | Health | http://localhost:8081/actuator/health | 健康检查 |
| | Info | http://localhost:8081/actuator/info | 应用信息 |
| **order-service** | Metrics | http://localhost:8082/actuator/prometheus | Prometheus 格式指标 |
| | Health | http://localhost:8082/actuator/health | 健康检查 |
| **notification-service** | Metrics | http://localhost:8083/actuator/prometheus | Prometheus 格式指标 |
| | Health | http://localhost:8083/actuator/health | 健康检查 |
| **api-gateway** | Metrics | http://localhost:8989/actuator/prometheus | Prometheus 格式指标 |
| | Health | http://localhost:8989/actuator/health | 健康检查 |
| **webapp** | Metrics | http://localhost:8080/actuator/prometheus | Prometheus 格式指标 |
| | Health | http://localhost:8080/actuator/health | 健康检查 |

---

## 🔧 配置详解

### Spring Boot 应用配置

所有服务在 Docker 环境下启用可观测性：

```yaml
# application.yml - Docker Profile
---
spring.config.activate.on-profile: docker

management:
  tracing:
    enabled: true
  zipkin:
    tracing:
      endpoint: http://tempo:9411/api/v2/spans
```

### Prometheus 配置

```yaml
# prometheus/prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'catalog-service'
    metrics_path: '/actuator/prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['catalog-service:8081']
  
  - job_name: 'order-service'
    metrics_path: '/actuator/prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['order-service:8082']
  
  # ... 其他服务配置
```

### Grafana 数据源配置

```yaml
# grafana/datasource.yml
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
  
  - name: Tempo
    type: tempo
    access: proxy
    url: http://tempo:3200
  
  - name: Loki
    type: loki
    access: proxy
    url: http://loki:3100
```

---

## 📊 实践场景

### 场景 1: 性能问题排查

**问题**: 订单创建很慢

**排查步骤**:

1. **查看 Metrics（Grafana）**:
   ```promql
   # 检查订单服务的响应时间
   histogram_quantile(0.95, 
     rate(http_server_requests_seconds_bucket{uri="/orders"}[5m])
   )
   ```

2. **查看 Traces（Tempo）**:
   - 找一个慢请求的 Trace ID
   - 在 Grafana 中查看完整调用链
   - 识别哪个服务或数据库查询耗时最长

3. **查看 Logs（Loki）**:
   ```logql
   {container_name="order-service"} 
   |= "traceId=abc123" 
   | json 
   | level="ERROR"
   ```

### 场景 2: 错误追踪

**问题**: 用户报告订单创建失败

**排查步骤**:

1. **查看错误率（Prometheus）**:
   ```promql
   rate(http_server_requests_seconds_count{
     status=~"5..",
     uri="/orders"
   }[5m])
   ```

2. **查看错误日志（Loki）**:
   ```logql
   {container_name="order-service"} 
   |= "Exception" 
   | json 
   | level="ERROR"
   ```

3. **追踪失败请求（Tempo）**:
   - 从日志中获取 Trace ID
   - 在 Tempo 中查看完整调用链
   - 定位失败的具体服务和原因

### 场景 3: 容量规划

**目标**: 评估系统负载和资源使用

**监控指标**:

```promql
# CPU 使用率
system_cpu_usage{job="order-service"}

# 内存使用率
jvm_memory_used_bytes{area="heap"} / jvm_memory_max_bytes{area="heap"}

# 请求吞吐量
sum(rate(http_server_requests_seconds_count[5m])) by (job)

# 并发连接数
tomcat_threads_current_threads{job="catalog-service"}

# 数据库连接池
hikaricp_connections_active{pool="HikariPool-1"}
```

### 场景 4: 系统健康监控

**创建 Grafana 仪表板**:

1. **服务健康状态**:
   ```promql
   up{job=~".*-service"}
   ```

2. **请求成功率**:
   ```promql
   sum(rate(http_server_requests_seconds_count{status!~"5.."}[5m])) 
   / 
   sum(rate(http_server_requests_seconds_count[5m]))
   ```

3. **平均响应时间**:
   ```promql
   rate(http_server_requests_seconds_sum[5m])
   /
   rate(http_server_requests_seconds_count[5m])
   ```

---

## 🎯 最佳实践

### 1. Metrics 最佳实践

✅ **DO**:
- 使用有意义的指标名称
- 为指标添加标签（tags）
- 监控关键业务指标（如订单成功率）
- 设置合理的采集间隔（5-15秒）

❌ **DON'T**:
- 过度采集指标（避免高基数）
- 使用动态标签值
- 忽略单位和描述

### 2. Logs 最佳实践

✅ **DO**:
- 使用结构化日志（JSON 格式）
- 包含 Trace ID 关联追踪
- 合理使用日志级别
- 记录重要业务事件

❌ **DON'T**:
- 记录敏感信息（密码、信用卡）
- 过度记录日志（影响性能）
- 使用非结构化日志

### 3. Traces 最佳实践

✅ **DO**:
- 为关键操作创建 Span
- 添加有意义的 Span 名称和属性
- 在生产环境使用采样（10-20%）
- 关联 Logs 和 Metrics

❌ **DON'T**:
- 100% 采样（生产环境）
- 创建过多细粒度 Span
- 忽略错误和异常

---

## 🔔 告警配置

### Prometheus 告警规则示例

```yaml
# prometheus/alert-rules.yml
groups:
  - name: service_alerts
    interval: 30s
    rules:
      # 服务宕机
      - alert: ServiceDown
        expr: up{job=~".*-service"} == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Service {{ $labels.job }} is down"
      
      # 高错误率
      - alert: HighErrorRate
        expr: |
          rate(http_server_requests_seconds_count{status=~"5.."}[5m]) 
          / 
          rate(http_server_requests_seconds_count[5m]) > 0.05
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High error rate on {{ $labels.job }}"
      
      # 高延迟
      - alert: HighLatency
        expr: |
          histogram_quantile(0.95, 
            rate(http_server_requests_seconds_bucket[5m])
          ) > 1
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High latency on {{ $labels.job }}"
```

---

## 🐛 故障排查

### 问题 1: Prometheus 无法抓取指标

**症状**: Targets 显示 "DOWN"

**解决方案**:
```bash
# 1. 检查服务是否运行
docker ps | grep catalog-service

# 2. 检查 actuator 端点
curl http://localhost:8081/actuator/prometheus

# 3. 检查 Docker 网络
docker network inspect spring-boot-microservices-course_default

# 4. 检查 Prometheus 配置
docker logs prometheus
```

### 问题 2: Grafana 无数据

**症状**: 仪表板显示 "No data"

**解决方案**:
```bash
# 1. 检查数据源配置
# Grafana -> Configuration -> Data Sources

# 2. 测试数据源连接
# 点击 "Test" 按钮

# 3. 检查 Prometheus 是否有数据
curl http://localhost:9090/api/v1/query?query=up

# 4. 检查时间范围
# 确保选择了正确的时间范围
```

### 问题 3: Tempo 无追踪数据

**症状**: 无法找到 Traces

**解决方案**:
```bash
# 1. 检查应用是否启用追踪
# application.yml 中 management.tracing.enabled=true

# 2. 检查 Zipkin 端点
curl http://localhost:9411/api/v2/services

# 3. 检查应用日志中是否有 Trace ID
docker logs catalog-service | grep traceId

# 4. 验证 Tempo 接收数据
docker logs tempo
```

### 问题 4: Loki 日志丢失

**症状**: 无法查询到日志

**解决方案**:
```bash
# 1. 检查 Fluent-bit 是否运行
docker logs fluent-bit

# 2. 检查日志驱动配置
docker inspect catalog-service | grep -A 5 LogConfig

# 3. 测试 Loki 端点
curl http://localhost:3100/ready

# 4. 检查 Promtail 配置
docker logs promtail
```

---

## 📚 参考资源

### 官方文档
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Loki Documentation](https://grafana.com/docs/loki/)
- [Tempo Documentation](https://grafana.com/docs/tempo/)
- [Spring Boot Actuator](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html)
- [Micrometer](https://micrometer.io/docs)
- [OpenTelemetry](https://opentelemetry.io/docs/)

### 学习资源
- [PromQL 速查表](https://promlabs.com/promql-cheat-sheet/)
- [LogQL 教程](https://grafana.com/docs/loki/latest/logql/)
- [Grafana Dashboard 库](https://grafana.com/grafana/dashboards/)

---

## 🎉 总结

可观测性（o11y）是现代微服务架构的基石。通过 **Metrics**、**Logs** 和 **Traces** 三大支柱，您可以：

✅ 实时监控系统健康状况  
✅ 快速定位和解决问题  
✅ 优化系统性能  
✅ 提升用户体验  
✅ 支持数据驱动的决策  

**核心价值**：从 "盲目调试" 到 "数据驱动的问题解决"！

---

## 🚀 下一步

1. **探索 Grafana 仪表板**
2. **创建自定义告警规则**
3. **集成到 CI/CD 流程**
4. **实施 SLO/SLI 监控**
5. **优化采样策略和存储**

祝您可观测性之旅顺利！🎯

