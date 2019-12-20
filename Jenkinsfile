pipeline {
    agent any
    
    tools {
        maven 'M3'
        jdk 'openjdk-13'
    }

    stages {
     stage('Copy source files') {
            steps {
                sh "mkdir ./target/generated-snippets"
                sh "cp -r ../DOCS/. ./target/generated-snippets"
            }
        }
        stage('Build Maven') {
            steps {
                // Get some code from a GitHub repository
                git 'https://github.com/cofomo-platform/documentation'

                // Run Maven
                sh "mvn -X clean prepare-package"
            }
        }
        stage('Copy generated documentation') {
            steps {
                // Copy all documentation snippets to parent folder
                sh "cp -r ./target/generated-docs/ ../DOCS/"
            }
        }  
    }
}