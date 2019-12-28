pipeline {
    agent any
    
    tools {
        maven 'M3'
        jdk 'openjdk-13'
    }

    stages {
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
            slackSend color: "good", message: "Documentation successfully updated and deployed in ${currentBuild.durationString}.\nGo to https://provider.cofomo.io to see the result."
        }
        // Send failure message to Slack
        failure {
            slackSend color: "bad", message: "Failure in documentation update"
        }
        
    }
}