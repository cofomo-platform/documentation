@NonCPS
def cancelPreviousBuilds() {
    def jobName = env.JOB_NAME
    def buildNumber = env.BUILD_NUMBER.toInteger()
    /* Get job name */
    def currentJob = Jenkins.instance.getItemByFullName(jobName)

    /* Iterating over the builds for specific job */
    for (def build : currentJob.builds) {
        def exec = build.getExecutor()
        /* If there is a build that is currently running and it's not current build */
        if (build.isBuilding() && build.number.toInteger() != buildNumber && exec != null) {
            /* Then stop it */
            exec.interrupt(
                    Result.ABORTED,
                    new CauseOfInterruption.UserInterruption("Aborted by #${currentBuild.number}")
                )
            println("Aborted previously running build #${build.number}")            
        }
    }
}
pipeline {
    agent any
    
    tools {
        maven 'M3'
        jdk 'openjdk-13'
    }

    stages {
    	stage('Init') {
            agent { label 'master' }
            steps {
               	script {
                   	cancelPreviousBuilds()
               	}
            }  
        }
    	stage('Copy source files') {
            steps {
                sh "cp -r ../DOCS/generated-snippets/. ./target/generated-snippets/"
                sh "cp -r ../DOCS/sourcefiles/. ./src/main/asciidoc/"
            }
        }
        stage('Build Maven') {
            steps {
                // Get some code from a GitHub repository
                git 'https://github.com/cofomo-platform/documentation'

                // Run Maven
                sh "mvn prepare-package"
            }
        }
        stage('Copy generated documentation') {
            steps {
                // Copy all documentation snippets to nginx folder
                sh "cp -r ./target/generated-docs/. ../DOCS/"
                sh "cp -r ./src/resources/images/. ../DOCS/images"
            }
        }  
    }
    post { 
    	// Send success message to Slack
        success { 
            slackSend color: "good", message: "Documentation successfully updated and deployed in ${currentBuild.durationString}.\nGo to https://cofomo.io to see the result."
        }
        // Send failure message to Slack
        failure {
            slackSend color: "bad", message: "Failure in documentation update"
        }
        
    }
}