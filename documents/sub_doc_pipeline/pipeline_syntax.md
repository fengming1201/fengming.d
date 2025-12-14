
pipeline{
    agent any
    //1,用于设置环境变量，可定义在pipeline或stage部分。
    environment{
        CC = 'clang'
    }
    //2,可定义在pipeline或stage部分。
    tools{

    }

    //4,
    options{
        buildDiscarder() //1,
        checkoutToSubdirectory() //2,
        disableConcurrentBuilds() //3,
        newContainerPerStage() //4,
        retry() //5,
        timrout() //6,
    }
    //5,
    parallel{

    }
    //6,
    parameters{

    }
    //7,
    triggers{

    }
    //8,
    when{

    }

    stages{
        stage("name1"){
            //
            environment{
                DEBUG_FLAG = '-g'
            }
            //
            tools{

            }
            steps{
                //3,
                input{

                }

            }

        }
        stage("name2"){


        }

    }
    post{
        //1,不论当前“完成状态”是什么，都执行。
        always{

        }
        changed{
            
        }
        fixed{

        }
        regression{

        }
        aborted{

        }
        failure{

        }
        success{

        }
        unstable{

        }
        cleanup{

        }

    }

}