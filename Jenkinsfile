pipeline {
    // 빌드를 수행할 서버(Agent) 설정
    // 이 'label'은 Jenkins 관리 > 노드 관리에서 지정한 레이블과 일치해야 합니다.
    agent any

    // GitHub Webhook 신호가 오면 파이프라인 시작
    triggers {
        githubPush() 
    }

    stages {
        // 1. 소스 코드 체크아웃 (Job 설정의 SCM 정보 사용)
        stage('Checkout Source Code') {
            steps {
                // Job 설정 (Pipeline script from SCM)에서 정의된 Git 정보를 사용해 코드를 가져옵니다.
                checkout scm 
                echo "Source code checked out successfully."
            }
        }
        
        // 2. 웹 서비스 (Apache httpd) 설치 및 구동
        stage('Install and Start Web Service') {
            steps {
                // yum을 이용하여 httpd 패키지를 설치합니다.
                // sh 명령은 빌드 에이전트(VM)의 쉘에서 실행됩니다.
		sh 'su - ansible'
                sh 'sudo yum install -y httpd'
                
                // 간단한 index.html 파일 생성 (설치 확인용)
                sh 'echo "<h1>Jenkins Webhook Test Success!</h1>" | sudo tee /var/www/html/index.html'
                
                // httpd 서비스를 시작하고, 시스템 부팅 시 자동 시작되도록 설정합니다.
                // Idempotency(멱등성)를 고려하여 start 대신 restart를 사용할 수도 있습니다.
                sh 'sudo systemctl start httpd'
                sh 'sudo systemctl enable httpd'
                
                echo "Apache httpd installed and started successfully."
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline completed successfully. Check the web service IP address.'
        }
        failure {
            echo 'Pipeline failed. Check system logs for yum or systemctl errors.'
        }
    }
}
