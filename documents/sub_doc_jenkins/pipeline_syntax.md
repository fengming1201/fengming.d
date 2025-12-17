# Jenkins Pipeline 语法参考

## 基本结构

```groovy
pipeline {
    agent any
    
    // 全局环境变量定义
    environment {
        CC = 'clang'
        NODE_ENV = 'production'
    }
    
    // 工具配置
    tools {
        // 配置JDK版本
        jdk 'openjdk-17'
        // 配置Maven版本
        maven 'maven-3.8.6'
        // 配置Node.js版本
        nodejs 'node-16.18.0'
    }
    
    // Pipeline选项配置
    options {
        // 保存最近5次构建记录
        buildDiscarder(logRotator(numToKeepStr: '5'))
        // 检出代码到子目录
        checkoutToSubdirectory('src')
        // 禁止并行构建
        disableConcurrentBuilds()
        // 每个stage使用新容器（仅在Docker agent中生效）
        newContainerPerStage()
        // 失败时重试3次
        retry(3)
        // 设置1小时超时
        timeout(time: 1, unit: 'HOURS')
        // 跳过默认的SCM检出
        skipDefaultCheckout()
        // 启用构建超时提醒
        timeout(time: 30, unit: 'MINUTES')
    }
    
    // 参数定义
    parameters {
        // 字符串参数
        string(name: 'DEPLOY_ENV', defaultValue: 'staging', description: '部署环境')
        // 布尔参数
        booleanParam(name: 'RUN_TESTS', defaultValue: true, description: '是否运行测试')
        // 选择参数
        choice(name: 'BUILD_TYPE', choices: ['debug', 'release'], description: '构建类型')
        // 密码参数
        password(name: 'API_KEY', description: 'API密钥')
        // 文件参数
        file(name: 'CONFIG_FILE', description: '配置文件')
        // 多行文本参数
        text(name: 'DEPLOY_SCRIPT', defaultValue: '#!/bin/bash\necho "Deploying..."', description: '部署脚本')
    }
    
    // 构建触发器
    triggers {
        // 定时构建（每周一到周五上午9点）
        cron('0 9 * * 1-5')
        // SCM变更触发器（每分钟检查一次）
        pollSCM('* * * * *')
        // 上游构建完成后触发
        upstream(upstreamProjects: 'other-job', threshold: hudson.model.Result.SUCCESS)
        // GitHub webhook触发器
        githubPush()
    }
    
    stages {
        // 代码检出阶段
        stage('Checkout') {
            steps {
                // 检出Git仓库
                git branch: 'main', url: 'https://github.com/example/repo.git'
            }
        }
        
        // 构建阶段
        stage('Build') {
            // 环境变量覆盖
            environment {
                DEBUG_FLAG = '-g'
            }
            
            // 工具覆盖
            tools {
                maven 'maven-3.9.0'
            }
            
            // 阶段选项
            options {
                timeout(time: 15, unit: 'MINUTES')
            }
            
            steps {
                // 运行Maven构建
                sh 'mvn clean package -DskipTests'
                
                // 使用script块执行Groovy代码
                script {
                    def version = sh(returnStdout: true, script: 'mvn help:evaluate -Dexpression=project.version -q -DforceStdout').trim()
                    echo "构建版本: ${version}"
                }
            }
        }
        
        // 测试阶段
        stage('Test') {
            // 条件执行
            when {
                expression { params.RUN_TESTS == true }
            }
            
            steps {
                // 运行单元测试
                sh 'mvn test'
                
                // 发布测试报告
                junit 'target/surefire-reports/*.xml'
            }
        }
        
        // 部署阶段
        stage('Deploy') {
            // 多条件判断
            when {
                allOf {
                    branch 'main'
                    expression { params.DEPLOY_ENV != 'production' || currentBuild.resultIs(hudson.model.Result.SUCCESS) }
                }
            }
            
            // 手动确认输入
            input {
                message '确认部署到生产环境吗？'
                ok '部署'
                parameters {
                    string(name: 'DEPLOY_TAG', defaultValue: 'latest', description: '部署标签')
                }
            }
            
            steps {
                // 切换目录
                dir('deploy') {
                    // 写入部署配置
                    writeFile file: 'deploy.sh', text: params.DEPLOY_SCRIPT
                    
                    // 执行部署脚本
                    sh 'chmod +x deploy.sh && ./deploy.sh'
                }
                
                // 判断文件是否存在
                script {
                    if (fileExists('target/application.jar')) {
                        echo '构建产物存在'
                        // 保存构建产物
                        stash name: 'app-jar', includes: 'target/application.jar'
                    } else {
                        error '构建产物不存在'
                    }
                }
            }
        }
        
        // 并行阶段示例
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
    }
    
    // 构建后操作
    post {
        // 无论构建结果如何都执行
        always {
            // 清理工作空间
            deleteDir()
        }
        // 构建结果发生变化时执行
        changed {
            echo '构建结果发生变化'
            // 发送通知
            emailext body: '构建结果发生变化，请查看', subject: '构建结果变化', to: 'team@example.com'
        }
        // 构建从失败恢复为成功时执行
        fixed {
            echo '构建已修复'
            slackSend channel: '#jenkins', color: 'good', message: '构建已修复: ${currentBuild.fullDisplayName}'
        }
        // 构建从成功变为失败/不稳定/中止时执行
        regression {
            echo '构建出现回归问题'
        }
        // 构建被中止时执行
        aborted {
            echo '构建已被中止'
        }
        // 构建失败时执行
        failure {
            echo '构建失败'
            // 发送失败通知
            slackSend channel: '#jenkins', color: 'danger', message: '构建失败: ${currentBuild.fullDisplayName}'
        }
        // 构建成功时执行
        success {
            echo '构建成功'
            // 发布构建产物
            archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
        }
        // 构建不稳定时执行
        unstable {
            echo '构建不稳定（存在测试失败）'
        }
        // 清理操作（在所有post条件之后执行）
        cleanup {
            echo '执行清理操作'
            // 清理临时文件
            sh 'rm -rf tmp/*'
        }
    }
}
```

## 常用步骤说明

### 基础步骤
- `echo`: 打印信息到构建日志
- `sh`: 执行Shell命令（Linux/Mac）
- `bat`: 执行Batch命令（Windows）
- `powershell`: 执行PowerShell命令（Windows）

### 文件操作
- `deleteDir`: 删除当前工作目录
- `dir(path)`: 切换到指定目录执行命令
- `fileExists(file)`: 检查文件是否存在
- `writeFile(file, text, encoding)`: 写入文件内容
- `readFile(file, encoding)`: 读取文件内容

### 源码管理
- `git(url, branch, credentialsId)`: 检出Git仓库
- `svn(url, credentialsId)`: 检出SVN仓库

### 构建工具
- `maven(goals)`: 执行Maven命令
- `gradle(tasks)`: 执行Gradle命令
- `npm(command)`: 执行npm命令

### 环境管理
- `withEnv(environmentVariables)`: 在指定环境变量下执行命令
- `withCredentials(credentials)`: 使用凭证执行命令

### 构建产物
- `stash(name, includes, excludes)`: 保存临时文件
- `unstash(name)`: 取出之前stashed的文件
- `archiveArtifacts(artifacts)`: 归档构建产物

### 流程控制
- `script`: 执行Groovy代码块
- `input`: 暂停构建等待用户输入
- `timeout(time, unit)`: 设置超时时间
- `retry(count)`: 重试操作

## 条件判断（When）

### 基本条件
```groovy
when {
    // 分支条件
    branch 'main'
    // 环境条件
    environment(name: 'DEPLOY_ENV', value: 'production')
    // 表达式条件
    expression { return params.RUN_TESTS }
    // 构建结果条件
    buildingTag()
    // 变更条件
    changeset pattern: '**/*.js', comparator: 'REGEXP'
    // 上游构建条件
    upstream(upstreamProjects: 'other-job', threshold: hudson.model.Result.SUCCESS)
}
```

### 复合条件
```groovy
when {
    // 所有条件都满足
    allOf {
        branch 'main'
        expression { params.DEPLOY_ENV == 'production' }
        buildingTag()
    }
    // 任一条件满足
    anyOf {
        branch 'main'
        branch 'release/*'
    }
    // 条件不满足
    not {
        expression { params.SKIP_DEPLOY == true }
    }
}
```

## 并行执行

### 基本并行
```groovy
stage('Parallel Builds') {
    parallel {
        stage('Build Linux') {
            steps {
                sh './build.sh linux'
            }
        }
        stage('Build Windows') {
            steps {
                bat 'build.bat windows'
            }
        }
        stage('Build Mac') {
            steps {
                sh './build.sh mac'
            }
        }
    }
}
```

### 动态并行
```groovy
stage('Dynamic Parallel') {
    steps {
        script {
            // 定义并行阶段
            def tests = [:]
            
            // 动态创建测试阶段
            for (int i = 1; i <= 5; i++) {
                def testNumber = i
                tests["Test ${testNumber}"] = {
                    stage("Test ${testNumber}") {
                        sh "run_test.sh ${testNumber}"
                    }
                }
            }
            
            // 执行并行阶段
            parallel tests
        }
    }
}
```

## Agent 配置

### 基本Agent
```groovy
// 在任何可用节点上执行
agent any

// 在特定标签的节点上执行
agent { label 'linux && docker' }

// 使用Docker容器执行
agent {
    docker {
        image 'maven:3.8.6-openjdk-17'
        args '-v /tmp/.m2:/root/.m2'
        label 'docker'
    }
}

// 使用Dockerfile构建并执行
agent {
    dockerfile {
        dir 'docker'
        label 'docker'
        additionalBuildArgs '--build-arg VERSION=1.0'
    }
}
```

### 指定工作目录
```groovy
agent {
    node {
        label 'linux'
        customWorkspace '/home/jenkins/workspace/my-project'
    }
}
```

## 凭证管理

### 使用凭证
```groovy
steps {
    withCredentials([usernamePassword(credentialsId: 'git-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
        sh "git clone https://${USERNAME}:${PASSWORD}@github.com/example/repo.git"
    }
    
    withCredentials([string(credentialsId: 'api-key', variable: 'API_KEY')]) {
        sh "curl -H 'Authorization: Bearer ${API_KEY}' https://api.example.com"
    }
}
```

## 错误处理

### 捕获错误
```groovy
stage('Error Handling') {
    steps {
        script {
            try {
                sh 'command-that-might-fail'
            } catch (Exception e) {
                echo "捕获到错误: ${e.getMessage()}"
                // 设置构建结果为不稳定
                currentBuild.result = 'UNSTABLE'
            }
        }
    }
}
```

### 超时处理
```groovy
stage('Timeout Example') {
    steps {
        timeout(time: 5, unit: 'MINUTES') {
            sh 'long-running-command'
        }
    }
}
```

## 高级特性

### 使用共享库
```groovy
@Library('my-shared-library') _

pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                // 调用共享库中的函数
                mySharedLibrary.build()
            }
        }
    }
}
```

### HTTP请求
```groovy
stage('HTTP Request') {
    steps {
        script {
            def response = httpRequest(
                url: 'https://api.example.com/data',
                httpMode: 'GET',
                contentType: 'APPLICATION_JSON',
                authentication: 'api-credentials'
            )
            echo "响应状态: ${response.status}"
            echo "响应内容: ${response.content}"
        }
    }
}
```

### 邮件通知
```groovy
post {
    success {
        emailext (
            subject: '构建成功: ${currentBuild.fullDisplayName}',
            body: '''构建信息:\n\n项目: ${JOB_NAME}\n构建 #: ${BUILD_NUMBER}\n状态: ${BUILD_STATUS}\nURL: ${BUILD_URL}''',
            to: 'team@example.com',
            from: 'jenkins@example.com'
        )
    }
}
```

## 最佳实践

1. **模块化设计**: 将复杂Pipeline拆分为多个阶段和步骤
2. **错误处理**: 为每个阶段添加适当的错误处理
3. **参数化构建**: 使用parameters提高Pipeline的灵活性
4. **环境隔离**: 使用Docker agent确保构建环境的一致性
5. **构建产物管理**: 合理使用stash和archiveArtifacts管理构建产物
6. **构建后通知**: 使用post部分发送构建结果通知
7. **代码复用**: 使用共享库复用Pipeline代码
8. **安全性**: 妥善管理凭证，避免硬编码敏感信息
9. **性能优化**: 使用并行执行提高构建效率
10. **日志管理**: 合理使用echo输出关键信息