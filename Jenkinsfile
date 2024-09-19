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
                    pt {
            // Run OWASP to perform DAST
            def owaspOutput = sh(
                script: "docker run --rm zaproxy/zap-stable zap-baseline.py -t ${PRODUCTION_LINK}",
                returnStdout: true
            ).trim()
            
            def exitStatus = sh(
                script: "docker run --rm zaproxy/zap-stable zap-baseline.py -t ${PRODUCTION_LINK}",
                returnStatus: true
            )

            // Check the exit status and ignore errors
            if (exitStatus != 0) {
                println "DAST execution failed, but we're ignoring the error."
            } else {
                println "DAST execution succeeded."
            }

            // Display the output
            println owaspOutput
                }
            }
        }
    }
}