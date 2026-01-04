# Jenkins Pipeline Steps 语法参考

## 目录

- [基本概念](#基本概念)
- [基本语法](#基本语法)
- [常用"内置"步骤](#常用"内置"步骤)
  - [1. 脚本执行](#1-脚本执行)
  - [2. 代码检出](#2-代码检出)
  - [3. 文件操作](#3-文件操作)
  - [4. 工具使用](#4-工具使用)
  - [5. 环境管理](#5-环境管理)
  - [6. 流程控制](#6-流程控制)
  - [7. 构建控制](#7-构建控制)
  - [8. Docker 相关](#8-docker-相关)
- [高级步骤](#高级步骤)
  - [1. 脚本块 (Script)](#1-脚本块-script)
  - [2. 并行执行](#2-并行执行)
  - [3. 工具集成](#3-工具集成)
- [自定义步骤](#自定义步骤)
- [最佳实践](#最佳实践)
- [常见问题](#常见问题)
- [总结](#总结)

## 基本概念

Steps 是 Jenkins Pipeline 中执行具体操作的最小单元，代表构建过程中的一个具体任务。每个 step 可以是 Jenkins 内置的命令、插件提供的功能或自定义的脚本。

## 基本语法

```groovy
steps {
    // 简单步骤
    step1
    
    // 带参数的步骤
    step2 parameter1: value1, parameter2: value2
    
    // 多行步骤
    step3 {
        substep1
        substep2 parameter: value
    }
    
    // 条件步骤
    if (condition) {
        step4
    }
}
```

## 常用"内置"步骤

### 1. 脚本执行

#### sh

执行 Shell 命令：

```groovy
steps {
    // 简单命令
    sh 'echo Hello World'
    
    // 多行命令
    sh '''
        echo "Starting build..."
        mvn clean package
        echo "Build completed."
    '''
    
    // 带返回值的命令
    script {
        def version = sh(script: 'git describe --tags', returnStdout: true).trim()
        echo "Current version: ${version}"
    }
    
    // 忽略错误
    sh script: 'command-that-might-fail', returnStatus: true
}
```

#### bat

执行 Windows Batch 命令：

```groovy
steps {
    bat 'echo Hello World'
    bat '''
        echo "Starting build..."
        mvn clean package
        echo "Build completed."
    '''
}
```

#### powershell

执行 PowerShell 命令：

```groovy
steps {
    powershell 'Write-Host "Hello World"'
    powershell '''
        Write-Host "Starting build..."
        mvn clean package
        Write-Host "Build completed."
    '''
}
```

### 2. 代码检出

#### git

检出 Git 仓库：

```groovy
steps {
    // 基本检出
    git branch: 'main', url: 'https://github.com/example/repo.git'
    
    // 带凭证的检出
    git branch: 'main', url: 'https://github.com/example/repo.git', credentialsId: 'github-credentials'
    
    // 检出特定提交
    git branch: 'main', url: 'https://github.com/example/repo.git', changelog: false, poll: false
}
```

#### checkout

更灵活的代码检出：

```groovy
steps {
    // 检出 Git 仓库
    checkout scm: [
        $class: 'GitSCM',
        branches: [[name: 'main']],
        extensions: [[$class: 'CleanCheckout']],
        userRemoteConfigs: [[url: 'https://github.com/example/repo.git']]
    ]
    
    // 检出 Subversion 仓库
    checkout scm: [
        $class: 'SubversionSCM',
        locations: [[
            remote: 'https://svn.example.com/repo/trunk',
            local: 'project'
        ]]
    ]
}
```

### 3. 文件操作

#### fileExists

检查文件是否存在：

```groovy
steps {
    script {
        if (fileExists('target/application.jar')) {
            echo "Application jar found."
        } else {
            error "Application jar not found!"
        }
    }
}
```

#### readFile

读取文件内容：

```groovy
steps {
    script {
        def content = readFile 'pom.xml'
        echo "pom.xml content: ${content}"
        
        // 读取 JSON 文件
        def jsonContent = readJSON file: 'package.json'
        echo "Project name: ${jsonContent.name}"
        
        // 读取 YAML 文件
        def yamlContent = readYaml file: 'docker-compose.yml'
        echo "Services: ${yamlContent.services.keySet()}"
        
        // 读取 Properties 文件
        def props = readProperties file: 'application.properties'
        echo "Database URL: ${props['db.url']}"
    }
}
```

#### writeFile

写入文件内容：

```groovy
steps {
    // 写入文本文件
    writeFile file: 'output.txt', text: 'Hello World'
    
    // 写入 JSON 文件
    writeJSON file: 'package.json', json: [name: 'my-project', version: '1.0.0'], pretty: 4
    
    // 写入 Properties 文件
    writeFile file: 'application.properties', text: 'db.url=jdbc:mysql://localhost:3306/mydb\ndb.username=root'
}
```

#### archiveArtifacts

归档构建产物：

```groovy
steps {
    // 归档特定文件
    archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
    
    // 归档所有文件
    archiveArtifacts artifacts: '**/*', exclude: 'target/*.log'
}
```

#### deleteDir

删除当前目录：

```groovy
steps {
    deleteDir()
}
```

#### dir

切换工作目录：

```groovy
steps {
    dir('subdirectory') {
        sh 'pwd' // 输出: /path/to/workspace/subdirectory
        sh 'ls -la'
    }
}
```

### 4. 工具使用

#### withMaven

使用 Maven 工具链：

```groovy
steps {
    withMaven(maven: 'maven-3.9.0', jdk: 'openjdk-17') {
        sh 'mvn clean package'
    }
}
```

#### withGradle

使用 Gradle 工具链：

```groovy
steps {
    withGradle(gradle: 'gradle-7.5.1') {
        sh 'gradle build'
    }
}
```

### 5. 环境管理

#### withEnv

临时设置环境变量：

```groovy
steps {
    withEnv(['BUILD_TYPE=release', 'VERSION=1.0.0']) {
        sh 'echo "Building ${BUILD_TYPE} version ${VERSION}"'
    }
}
```

#### withCredentials

使用凭证：

```groovy
steps {
    // 使用 UsernamePassword 凭证
    withCredentials([usernamePassword(credentialsId: 'db-credentials', usernameVariable: 'DB_USER', passwordVariable: 'DB_PASS')]) {
        sh 'mysql -u${DB_USER} -p${DB_PASS} -e "SELECT * FROM users"'
    }
    
    // 使用 Secret Text 凭证
    withCredentials([string(credentialsId: 'api-key', variable: 'API_KEY')]) {
        sh 'curl -H "Authorization: Bearer ${API_KEY}" https://api.example.com'
    }
    
    // 使用 SSH 凭证
    withCredentials([sshUserPrivateKey(credentialsId: 'ssh-key', keyFileVariable: 'SSH_KEY')]) {
        sh 'ssh -i ${SSH_KEY} user@server "command"'
    }
}
```

### 6. 流程控制

#### echo

打印信息：

```groovy
steps {
    echo 'Hello World'
    echo "Build number: ${currentBuild.number}"
    echo "Branch: ${env.BRANCH_NAME}"
}
```

#### error

抛出错误：

```groovy
steps {
    script {
        if (!fileExists('target/application.jar')) {
            error "Application jar not found! Build failed."
        }
    }
}
```

#### warning

打印警告：

```groovy
steps {
    warning 'This is a warning message'
}
```

#### sleep

暂停执行：

```groovy
steps {
    echo "Waiting for 30 seconds..."
    sleep time: 30, unit: 'SECONDS'
    sleep 1 // 默认单位为秒
}
```

#### timeout

设置超时：

```groovy
steps {
    timeout(time: 10, unit: 'MINUTES') {
        sh 'long-running-command'
    }
}
```

#### retry

重试步骤：

```groovy
steps {
    retry(3) {
        sh 'flaky-command'
    }
}
```

#### waitUntil

等待条件满足：

```groovy
steps {
    waitUntil {
        script {
            def status = sh(script: 'curl -s https://api.example.com/status', returnStdout: true)
            return status.contains('"status":"UP"')
        }
    }
}
```

### 7. 构建控制

#### build

触发其他构建：

```groovy
steps {
    // 触发简单构建
    build 'another-job'
    
    // 带参数的构建
    build job: 'another-job', parameters: [
        string(name: 'VERSION', value: '1.0.0'),
        booleanParam(name: 'DEPLOY', value: true)
    ]
    
    // 等待构建完成
    build job: 'another-job', wait: true
    
    // 获取构建结果
    script {
        def result = build job: 'another-job', propagate: false
        echo "Build result: ${result.result}"
    }
}
```

#### input

等待用户输入：

```groovy
steps {
    script {
        def userInput = input(
            message: 'Deploy to production?',
            parameters: [
                string(name: 'DEPLOY_TAG', defaultValue: 'latest', description: 'Deployment tag'),
                choice(name: 'ENVIRONMENT', choices: ['staging', 'production'], description: 'Environment')
            ]
        )
        echo "Deploying ${userInput.DEPLOY_TAG} to ${userInput.ENVIRONMENT}"
    }
}
```

#### notify

发送通知：

```groovy
steps {
    // 发送邮件
    mail to: 'team@example.com',
         subject: "Build ${currentBuild.number} completed",
         body: "Build result: ${currentBuild.result}"
    
    // Slack 通知
    slackSend channel: '#builds',
              color: currentBuild.result == 'SUCCESS' ? 'good' : 'danger',
              message: "Build ${currentBuild.number} - ${currentBuild.result}"
}
```

### 8. Docker 相关

#### docker.build

构建 Docker 镜像：

```groovy
steps {
    // 基本构建
    docker.build 'my-image'
    
    // 带标签的构建
    docker.build 'my-image:1.0.0'
    
    // 指定 Dockerfile 位置
    docker.build 'my-image', '-f Dockerfile.prod .'
}
```

#### docker.push

推送 Docker 镜像：

```groovy
steps {
    script {
        docker.withRegistry('https://registry.example.com', 'docker-credentials') {
            def image = docker.build('registry.example.com/my-image:1.0.0')
            image.push()
        }
    }
}
```

#### docker.image

使用 Docker 镜像：

```groovy
steps {
    docker.image('maven:3.9.0-openjdk-17').inside('-v /tmp/.m2:/root/.m2') {
        sh 'mvn clean package'
    }
}
```

## 高级步骤

### 1. 脚本块 (Script)

使用 Groovy 脚本编写自定义逻辑：

```groovy
steps {
    script {
        // 变量定义
        def version = '1.0.0'
        def env = 'production'
        
        // 条件判断
        if (env == 'production') {
            echo "Deploying to production..."
        } else {
            echo "Deploying to ${env}..."
        }
        
        // 循环
        for (int i = 0; i < 5; i++) {
            echo "Iteration ${i}"
        }
        
        // 列表操作
        def stages = ['build', 'test', 'deploy']
        stages.each { stage ->
            echo "Stage: ${stage}"
        }
        
        // 映射操作
        def config = [
            'db.url': 'jdbc:mysql://localhost:3306/mydb',
            'db.username': 'root'
        ]
        config.each { key, value ->
            echo "${key}: ${value}"
        }
        
        // 函数定义
        def calculateVersion() {
            return '1.0.0-' + currentBuild.number
        }
        
        def fullVersion = calculateVersion()
        echo "Full version: ${fullVersion}"
    }
}
```

### 2. 并行执行

并行执行多个步骤：

```groovy
steps {
    script {
        // 并行执行多个命令
        parallel {
            'Test 1' {
                sh 'run-test-1.sh'
            }
            'Test 2' {
                sh 'run-test-2.sh'
            }
            'Test 3' {
                sh 'run-test-3.sh'
            }
        }
        
        // 并行执行带结果的命令
        def results = parallel(
            'Test A': { sh(script: 'echo Test A', returnStdout: true) },
            'Test B': { sh(script: 'echo Test B', returnStdout: true) }
        )
        
        echo "Test A result: ${results['Test A']}"
        echo "Test B result: ${results['Test B']}"
    }
}
```

### 3. 工具集成

#### SonarQube

执行 SonarQube 分析：

```groovy
steps {
    withSonarQubeEnv('sonarqube-server') {
        sh 'mvn sonar:sonar'
    }
    
    // 等待质量门结果
    timeout(time: 10, unit: 'MINUTES') {
        waitForQualityGate abortPipeline: true
    }
}
```

#### JUnit

发布 JUnit 测试结果：

```groovy
steps {
    sh 'mvn test'
    junit 'target/surefire-reports/*.xml'
}
```

#### Coverage

发布代码覆盖率报告：

```groovy
steps {
    sh 'mvn jacoco:report'
    jacoco execPattern: 'target/*.exec'
}
```

## 自定义步骤

### 1. 使用共享库

```groovy
// vars/myCustomStep.groovy
def call(String name) {
    echo "Hello ${name}!"
    sh "echo Running custom step for ${name}"
}

// 在 Pipeline 中使用
steps {
    myCustomStep 'World'
}
```

### 2. 使用插件提供的步骤

```groovy
steps {
    // 使用 Ansible 插件
    ansiblePlaybook(
        playbook: 'deploy.yml',
        inventory: 'inventory/hosts',
        credentialsId: 'ssh-credentials'
    )
    
    // 使用 Kubernetes 插件
    kubernetesDeploy(
        configs: 'kubernetes/*.yaml',
        kubeconfigId: 'kubeconfig'
    )
    
    // 使用 AWS 插件
    s3Upload(
        file: 'target/application.jar',
        bucket: 'my-bucket',
        path: 'applications/my-app.jar',
        credentialsId: 'aws-credentials'
    )
}
```

## 最佳实践

1. **步骤复用**：将重复使用的步骤封装为自定义步骤或共享库
2. **错误处理**：为关键步骤添加适当的错误处理和重试机制
3. **日志记录**：使用 echo 步骤记录关键信息，便于调试和审计
4. **凭证管理**：使用 withCredentials 安全地管理凭证，避免明文存储
5. **超时控制**：为长时间运行的步骤添加超时设置
6. **并行执行**：对于独立的任务，使用并行执行提高构建效率
7. **条件执行**：使用 if/else 和 when 条件控制步骤的执行
8. **环境隔离**：使用 dir 和 withEnv 保持环境隔离
9. **产物管理**：使用 archiveArtifacts 归档重要的构建产物
10. **代码质量**：集成代码质量工具，如 SonarQube、JUnit 等

## 常见问题

### 1. 步骤执行失败

- 检查命令语法是否正确
- 检查依赖是否安装
- 检查权限是否足够
- 使用 returnStatus 参数忽略错误

### 2. 凭证不生效

- 确保凭证 ID 正确
- 确保凭证具有适当的权限
- 使用 withCredentials 包装需要凭证的步骤

### 3. 并行执行性能问题

- 避免创建过多的并行任务
- 为并行任务分配适当的资源
- 使用 failFast 选项在一个任务失败时停止所有任务

### 4. 文件操作失败

- 检查文件路径是否正确
- 检查文件权限
- 使用 fileExists 步骤先检查文件是否存在

# 总结

Steps 是 Jenkins Pipeline 中执行具体操作的核心单元，本文介绍了常用的内置步骤、高级用法和最佳实践。通过合理使用这些步骤，可以构建出功能强大、可靠且高效的 Jenkins Pipeline。