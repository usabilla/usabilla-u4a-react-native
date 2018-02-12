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
}
