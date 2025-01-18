pipeline {
    agent any

    environment {
        PRODUCTION_LINK="http://a5e3c82a09acf4cf8b0c096bff5f6130-199476554.us-east-1.elb.amazonaws.com"
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
                returnStdout: true
            ).trim()
            
            def exitStatus = sh(
                script: "docker run --rm zaproxy/zap-stable zap-baseline.py -t ${PRODUCTION_LINK}",
                returnStatus: true
            )

            // Display the output
            println owaspOutput
                }
            }
        }
    }
}