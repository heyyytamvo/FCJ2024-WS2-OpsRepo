pipeline {
    agent any

    environment {
        PRODUCTION_LINK=""
    }

    stages { 
        stage("Secure IaC"){
            steps{
                script {
                    // Run Trivy to scan the Terraform Configfiles
                    def trivyOutput = sh(script: "trivy config Terraform", returnStdout: true).trim()

                    // Display Trivy scan results
                    println trivyOutput
                }
            }
        }

        stage('DAST'){
            when { 
                allOf {
                    changeset "k8s/**"
                    expression {  // there are changes in k8s/...
                        sh(returnStatus: true, script: 'git diff k8s/') == 0
                    }
                }
            }

            steps {
                script {
                    // Run OWASP to perform DAST
                    def owaspOutput = sh(script: "docker run -v $(pwd):/zap/wrk/:rw -t zaproxy/zap-stable zap-baseline.py -t ${PRODUCTION_LINK}", returnStdout: true).trim()

                    // Display OWASP results
                    println owaspOutput
                }
            }
        }
    }
}