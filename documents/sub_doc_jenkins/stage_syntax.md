# Jenkins Pipeline Stage 语法参考

## 目录

- [基本概念](#基本概念)
- [基本语法](#基本语法)
- [完整示例](#完整示例)
- [核心配置详解](#核心配置详解)
  - [1. Stage 名称](#1-stage-名称)
  - [2. Agent 配置](#2-agent-配置)
  - [3. 环境变量](#3-环境变量)
  - [4. 工具配置](#4-工具配置)
  - [5. 选项配置](#5-选项配置)
  - [6. 执行条件 (When)](#6-执行条件-when)
  - [7. 用户输入 (Input)](#7-用户输入-input)
- [高级用法](#高级用法)
  - [1. 并行 Stage](#1-并行-stage)
  - [2. 动态并行 Stage](#2-动态并行-stage)
  - [3. 嵌套 Stage](#3-嵌套-stage)
- [最佳实践](#最佳实践)
- [常见问题](#常见问题)
  - [1. Stage 未执行](#1-stage-未执行)
  - [2. Stage 执行超时](#2-stage-执行超时)
  - [3. 并行 Stage 中的一个失败](#3-并行-stage-中的一个失败)
- [总结](#总结)

## 基本概念

Stage 是 Jenkins Pipeline 中用于组织构建过程的基本单元，代表构建流程中的一个独立阶段。每个 stage 包含一组相关的步骤（steps），用于完成特定的构建任务。

## 基本语法

### Stage 关键字

**必需关键字：**
- `steps` - 定义此 stage 执行的步骤

**可选关键字：**
- `agent` - 覆盖全局 agent 配置
- `environment` - 定义此 stage 的环境变量
- `tools` - 定义此 stage 的工具配置
- `options` - 定义此 stage 的选项
- `input` - 暂停等待用户输入
- `when` - 定义此 stage 的执行条件

### 基本结构

```groovy
stage('Stage Name') {
    // Stage 配置
    agent // 可选，覆盖全局 agent 配置
    environment // 可选，定义此 stage 的环境变量
    tools // 可选，定义此 stage 的工具配置
    options // 可选，定义此 stage 的选项
    input // 可选，暂停等待用户输入
    when // 可选，定义此 stage 的执行条件
    
    // Stage 执行的步骤
    steps {
        // 步骤列表
    }
}
```

## 完整示例

```
pipeline {
    agent any
    
    stages {
        // 基本 Stage
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/example/repo.git'
            }
        }
        
        // 带环境变量的 Stage
        stage('Build') {
            environment {
                BUILD_TYPE = 'release'
                JAVA_HOME = '/usr/lib/jvm/java-17-openjdk'
            }
            
            steps {
                sh 'mvn clean package -DbuildType=${BUILD_TYPE}'
            }
        }
        
        // 带工具配置的 Stage
        stage('Test') {
            tools {
                maven 'maven-3.8.6'
                jdk 'openjdk-17'
            }
            
            steps {
                sh 'mvn test'
            }
        }
        
        // 带执行条件的 Stage
        stage('Deploy to Production') {
            when {
                allOf {
                    branch 'main'
                    environment(name: 'BUILD_TYPE', value: 'release')
                }
            }
            
            steps {
                sh './deploy.sh production'
            }
        }
        
        // 带用户输入的 Stage
        stage('Manual Approval') {
            input {
                message '是否继续部署？'
                ok '继续'
                parameters {
                    string(name: 'DEPLOY_ENV', defaultValue: 'staging', description: '部署环境')
                }
            }
            
            steps {
                echo "部署到环境: ${params.DEPLOY_ENV}"
                sh "./deploy.sh ${params.DEPLOY_ENV}"
            }
        }
        
        // 带超时设置的 Stage
        stage('Long Running Task') {
            options {
                timeout(time: 30, unit: 'MINUTES')
            }
            
            steps {
                sh './long-running-task.sh'
            }
        }
        
        // 覆盖全局 Agent 的 Stage
        stage('Docker Build') {
            agent {
                docker {
                    image 'maven:3.8.6-openjdk-17'
                    args '-v /tmp/.m2:/root/.m2'
                }
            }
            
            steps {
                sh 'mvn clean package'
            }
        }
    }
}
```

## 核心配置详解

### 1. Stage 名称

```groovy
stage('Stage Name') {
    // ...
}
```

- 名称用于在 Jenkins UI 中标识 Stage
- 名称应该简洁明了，反映 Stage 的功能

### 2. Agent 配置

Stage 级别的 Agent 配置会覆盖全局 Agent 配置：

```groovy
stage('Docker Stage') {
    agent {
        docker {
            image 'node:16.18.0'
            label 'docker-slave'
            args '-p 3000:3000'
        }
    }
    
    steps {
        sh 'npm install && npm run build'
    }
}
```

### 3. 环境变量

为特定 Stage 定义环境变量：

```groovy
stage('Build') {
    environment {
        // 简单环境变量
        BUILD_NUMBER = currentBuild.number
        
        // 从凭证中获取的环境变量
        AWS_ACCESS_KEY_ID = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
        
        // 多行环境变量
        COMPLEX_CONFIG = '''{
            "key1": "value1",
            "key2": "value2"
        }'''
    }
    
    steps {
        echo "构建编号: ${BUILD_NUMBER}"
        sh 'aws s3 ls'
    }
}
```

### 4. 工具配置

为特定 Stage 配置工具版本：

```groovy
stage('Build with Maven') {
    tools {
        maven 'maven-3.9.0'
        jdk 'openjdk-17'
    }
    
    steps {
        sh 'mvn --version'
        sh 'java --version'
        sh 'mvn clean package'
    }
}
```

### 5. 选项配置

为特定 Stage 配置选项：

```groovy
stage('Test') {
    options {
        // 设置 15 分钟超时
        timeout(time: 15, unit: 'MINUTES')
        
        // 重试 3 次
        retry(3)
        
        // 跳过默认的 SCM 检出
        skipDefaultCheckout()
    }
    
    steps {
        sh 'mvn test'
    }
}
```

### 6. 执行条件 (When)

定义 Stage 执行的条件：

```groovy
stage('Deploy') {
    when {
        // 分支条件
        branch 'main'
        
        // 表达式条件
        expression { return params.DEPLOY_ENV != 'production' }
        
        // 构建结果条件
        buildingTag()
        
        // 环境条件
        environment(name: 'NODE_ENV', value: 'production')
        
        // 变更条件
        changeset pattern: 'src/**/*', comparator: 'REGEXP'
        
        // 复合条件
        allOf {
            branch 'release/*'
            expression { return currentBuild.resultIs(hudson.model.Result.SUCCESS) }
        }
    }
    
    steps {
        sh './deploy.sh'
    }
}
```

### 7. 用户输入 (Input)

暂停 Stage 执行，等待用户输入：

```groovy
stage('Manual Approval') {
    input {
        message '是否确认部署到生产环境？'
        ok '确认部署'
        submitter 'admin,devops'
        submitterParameter 'APPROVED_BY'
        parameters {
            string(name: 'DEPLOY_TAG', defaultValue: 'latest', description: '部署标签')
            choice(name: 'DEPLOY_REGION', choices: ['us-east-1', 'eu-west-1', 'ap-southeast-1'], description: '部署区域')
            booleanParam(name: 'RUN_SMOKE_TESTS', defaultValue: true, description: '是否运行冒烟测试')
        }
    }
    
    steps {
        echo "由 ${params.APPROVED_BY} 批准部署"
        echo "部署标签: ${params.DEPLOY_TAG}"
        echo "部署区域: ${params.DEPLOY_REGION}"
        sh "./deploy.sh --tag ${params.DEPLOY_TAG} --region ${params.DEPLOY_REGION}"
        
        script {
            if (params.RUN_SMOKE_TESTS) {
                sh './run-smoke-tests.sh'
            }
        }
    }
}
```

## 高级用法

### 1. 并行 Stage

在一个 Stage 中并行执行多个子 Stage：

```groovy
stage('Parallel Tests') {
    parallel {
        stage('Unit Tests') {
            steps {
                sh 'mvn test -Dtest=UnitTest'
            }
        }
        
        stage('Integration Tests') {
            steps {
                sh 'mvn test -Dtest=IntegrationTest'
            }
        }
        
        stage('Performance Tests') {
            steps {
                sh 'mvn test -Dtest=PerformanceTest'
            }
        }
    }
}
```

### 2. 动态并行 Stage

根据条件动态生成并行 Stage：

```groovy
stage('Dynamic Parallel') {
    steps {
        script {
            // 定义并行 Stage 映射
            def parallelStages = [:]
            
            // 动态生成 5 个测试 Stage
            for (int i = 1; i <= 5; i++) {
                def testNumber = i
                parallelStages["Test ${testNumber}"] = {
                    stage("Test ${testNumber}") {
                        sh "run-test.sh test-${testNumber}"
                    }
                }
            }
            
            // 执行并行 Stage
            parallel parallelStages
        }
    }
}
```

### 3. 嵌套 Stage

在一个 Stage 中嵌套另一个 Stage（仅支持 Declarative Pipeline 1.3+）：

```groovy
stage('Build & Test') {
    stages {
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        
        stage('Test') {
            stages {
                stage('Unit Tests') {
                    steps {
                        sh 'mvn test -Dtest=UnitTest'
                    }
                }
                
                stage('Integration Tests') {
                    steps {
                        sh 'mvn test -Dtest=IntegrationTest'
                    }
                }
            }
        }
    }
}
```

## 最佳实践

1. **Stage 命名**：使用清晰、描述性的名称，反映 Stage 的功能
2. **Stage 粒度**：每个 Stage 应只完成一个逻辑任务，保持适当的粒度
3. **并行执行**：对于独立的任务，使用并行 Stage 提高构建效率
4. **条件执行**：使用 when 条件控制 Stage 的执行，避免不必要的步骤
5. **用户输入**：在关键步骤（如生产部署）前添加用户输入确认
6. **超时设置**：为长时间运行的 Stage 添加超时设置，避免构建挂起
7. **错误处理**：在 Stage 中添加适当的错误处理，提高构建的稳定性
8. **环境隔离**：使用 Stage 级别的 agent 和工具配置，确保环境隔离

## 常见问题

### 1. Stage 未执行

- 检查 when 条件是否满足
- 检查上游 Stage 是否失败（如果使用了 failFast: true）
- 检查是否有足够的资源（如 Jenkins 节点）

### 2. Stage 执行超时

- 增加 timeout 时间
- 优化 Stage 中的步骤，减少执行时间
- 检查是否有死锁或资源竞争

### 3. 并行 Stage 中的一个失败

- 默认情况下，一个并行 Stage 失败不会影响其他 Stage
- 使用 failFast: true 可以在一个 Stage 失败时停止所有并行 Stage

```groovy
stage('Parallel Tests') {
    failFast true
    parallel {
        stage('Test 1') {
            steps {
                sh 'test-1.sh'
            }
        }
        stage('Test 2') {
            steps {
                sh 'test-2.sh'
            }
        }
    }
}
```

# 总结

Stage 是 Jenkins Pipeline 中组织构建流程的核心概念，通过合理使用 Stage，可以创建结构清晰、易于维护和扩展的 Pipeline。本文介绍了 Stage 的基本语法、核心配置、高级用法和最佳实践，帮助您更好地使用 Jenkins Pipeline 构建和部署应用程序。