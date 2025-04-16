

## 代码

1. Maven 模块继承 spring-boot-starter-parent，插件使用 spring-boot-maven-plugin、git-commit-id-maven-plugin、spotless-maven-plugin
2. docker 镜像构建使用 spring-boot:build-image
3. 远程调用使用 RestClient
4. 单元测试使用 junit5、wiremock、instancio、Testcontainers
5. 使用 SchedulerLock 避免分布式环境下定时任务多次调度
6. 使用 springdoc-openapi 生成 api 文档
7. 限流熔断降级使用 resilience4j
8. 数据库 ddl 脚本管理使用 flywaydb
9. 认证服务器使用 keycloak
10. 数据库持久化使用 jpa
11. 异步调用使用 rabbitMQ
12. 异常处理使用 ProblemDetail
13. 自动装配没有不必要的配置，如没有对 redis、mybatis、jackson 、TaskExecution 做额外的配置，json 序列化使用 ObjectMapper，没有额外定义工具类
14. 可观测性

### 番茄架构

- 按功能打包。使用开闭原则。名称使用单数，不要使用复数
- 保持“应用程序核心”独立于交付机制（Web、Job、CLI）
- 将业务逻辑执行与输入源（Web 控制器、消息监听器、计划作业等）分离
- 不要让“外部服务集成”过多地影响“应用程序核心”
- 将领域逻辑保留在领域对象中
- 没有不必要的接口
- 拥抱框架的强大和灵活性，不要自己造轮子
- 不仅测试单元，还要测试整个功能

包分层举例：

com.sivalabs.bookstore.catalog：
- ApplicationProperties
- XxxServiceApplication
- client:
  - xxx:
    - Xxx
    - XxxServiceClient
    - XxxServiceClientConfig
- config
  - WebMvcConfig: private
  - OpenAPI3Configuration: private
- domain
  - model
    - XxxRequest
    - XxxResponse
    - XxxEvent
    - XxxDTO
    - XxxStatus
  - Xxx: public
  - XxxService: public
  - XxxNotFoundException: public
  - PagedResult: public
  - XxxValidator: private
  - XxxRepository: private
  - XxxMapper: private
  - XxxEntity: private
- event:
  - XxxHandler: private
- job
  - XxxJob: private
- web
  - controllers
    - XxxController: private
  - exception
    - GlobalExceptionHandler: private


## 工具使用

### 使用 .sdkmanrc 管理 java 和 maven

```bash
sdk env
sdk env install
```

### 使用 [go-task](https://task-zh.readthedocs.io/zh-cn/latest) 管理运行脚本

```bash
brew install go-task/tap/go-task
task test format build
```

### 使用 renovate 管理依赖升级

renovate.json

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "extends": [
    "config:recommended",
    "schedule:earlyMondays"
  ]
}
```

## 改进

- 参考 https://github.com/SaiUpadhyayula/spring-boot-3-microservices-course ，添加 k8s 