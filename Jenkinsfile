pipeline {
    agent any

    environment {
        PRODUCTION_LINK="http://a05cb21ead99f47d897b3216b5cf7974-1027332877.us-east-1.elb.amazonaws.com"
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
            steps {
                script {
                    // Run OWASP to perform DAST
                    try {
                        def owaspOutput = sh(
                            script: "docker run --rm zaproxy/zap-stable zap-baseline.py -t ${PRODUCTION_LINK}",
                            returnStdout: true
                        ).trim()

                        // Display OWASP results
                        println owaspOutput
                        } catch (Exception e) {
                        // Handle any errors that occur during the DAST execution
                        error "DAST execution failed: ${e.message}"
                    }
                }
            }
        }
    }
}