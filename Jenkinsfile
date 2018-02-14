node('mac') {
    stage('Checkout') {
        checkout scm
    }
    stage('Install') {
        sh 'npm install'
    }
    stage('Test') {
        sh 'npm test'
    }
    if(env.BRANCH_NAME == 'master') {
        stage('Release') {
            withCredentials([usernamePassword(credentialsId: '34dc9a59-1608-4470-9860-bd19030cadbb', passwordVariable: 'GH_TOKEN', usernameVariable: 'JENKINS_USER')]) {
                withCredentials([usernamePassword(credentialsId: 'sdk-npm-token', passwordVariable: 'NPM_TOKEN', usernameVariable: 'NPM_USER')]) {
                    sh 'npm run release || true'
                }
            }
        }
    }
}
