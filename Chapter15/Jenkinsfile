#!groovy
import groovy.json.JsonSlurperClassic
node {

    // Test Scratch Org Username
    def SFDC_USERNAME

    // Path to SFDX CLI (configured via Custom Tools)
    def toolbelt = tool 'toolbelt'

    stage('Checkout Source') {
        checkout scm
    }

    withCredentials([file(credentialsId: env.JWT_CRED_ID_DH, variable: 'jwt_key_file')]) {

        stage('Create Test Scratch Org') {

            // Authorizate with DevHub via JWT grant
            rc = sh returnStatus: true, script: "${toolbelt}/sfdx force:auth:jwt:grant --clientid ${env.CONNECTED_APP_CONSUMER_KEY_DH} --username ${env.HUB_ORG_DH} --jwtkeyfile ${jwt_key_file} --instanceurl ${env.SFDC_HOST_DH}"
            if (rc != 0) { error 'hub org authorization failed' }

            // Create Scratch Org and determine login username X
            rmsg = sh returnStdout: true, script: "${toolbelt}/sfdx force:org:create --targetdevhubusername ${env.HUB_ORG_DH} --definitionfile config/project-scratch-def.json --json"
            def robj = new JsonSlurperClassic().parseText(rmsg)
            if (robj.status != 0) { error 'org creation failed: ' + robj.message }
            SFDC_USERNAME=robj.result.username
        }

        stage('Push To Test Scratch Org') {

            // Push code via sfdx force:source:push
            rc = sh returnStatus: true, script: "${toolbelt}/sfdx force:source:push --targetusername ${SFDC_USERNAME}"
            if (rc != 0) {
                error 'push failed'
            }
        }

        stage('Run Tests') {

            // Create test output directory, run tests 
            sh "mkdir -p tests/${env.BUILD_NUMBER}"

            // Run Apex Tests
            rc = sh returnStatus: true, script: "${toolbelt}/sfdx force:apex:test:run --testlevel RunLocalTests --outputdir tests/${env.BUILD_NUMBER} --resultformat junit --targetusername ${SFDC_USERNAME}"
            
            // Run Lightning Web Component Tests
            env.NODEJS_HOME = "${tool 'node'}"
            env.PATH="${env.NODEJS_HOME}/bin:${env.PATH}"            
            sh 'npm install'                
            rc = sh returnStatus: true, script: 'npm run test:unit'                
            
            // Have Jenkins capture the test results
            junit keepLongStdio: true, testResults: 'tests/**/*-junit.xml'
            junit keepLongStdio: true, testResults: 'junit.xml'
        }

        stage('Delete Test Org') {

            // Delete Test Scratch Org 
            rc = sh returnStatus: true, script: "${toolbelt}/sfdx force:org:delete --targetusername ${SFDC_USERNAME}"
            if (rc != 0) {
                error 'org delete failed'
            }            
        }
    }
}