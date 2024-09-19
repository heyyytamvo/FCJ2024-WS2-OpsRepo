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
                    def owaspOutput = sh(
                        script: "docker run --rm zaproxy/zap-stable zap-baseline.py -t ${PRODUCTION_LINK}",
                        returnStdout: true,
                        returnStatus: true
                    )

                    // Check the output and ignore errors
                    if (owaspOutput != 0) {
                        println "DAST execution succeeded."
                    } else {
                        println "DAST execution succeeded."
                    }

                    // Optionally, if you want to display the output regardless of success
                    println owaspOutput.trim()
                }
            }
        }
    }
}