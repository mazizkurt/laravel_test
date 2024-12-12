pipeline {
    agent any
    environment {
        APP_NAME = "Laravel"
        APP_ENV = "local"
        APP_KEY = "base64:n+Wh5qlfbUwgtVHLr2RyUVh69IqfIpZvNaup5XkTcr8="
        APP_DEBUG = "true"
        APP_TIMEZONE = "UTC"
        APP_URL = "http://localhost"
        
        APP_LOCALE = "en"
        APP_FALLBACK_LOCALE = "en"
        APP_FAKER_LOCALE = "en_US"
        
        APP_MAINTENANCE_DRIVER = "file"
        
        PHP_CLI_SERVER_WORKERS = "4"
        
        BCRYPT_ROUNDS = "12"
        
        LOG_CHANNEL = "stack"
        LOG_STACK = "single"
        LOG_DEPRECATIONS_CHANNEL = "null"
        LOG_LEVEL = "debug"
        
        DB_CONNECTION = "mysql"
        DB_HOST = "mysql"
        DB_PORT = "3306"
        DB_DATABASE = "laravel"
        DB_USERNAME = "user"
        DB_PASSWORD = "password"
        
        SESSION_DRIVER = "database"
        SESSION_LIFETIME = "120"
        SESSION_ENCRYPT = "false"
        SESSION_PATH = "/"
        SESSION_DOMAIN = "null"
        
        BROADCAST_CONNECTION = "log"
        FILESYSTEM_DISK = "local"
        QUEUE_CONNECTION = "database"
        
        CACHE_STORE = "database"
        CACHE_PREFIX = ""
        
        MEMCACHED_HOST = "127.0.0.1"
        
        REDIS_CLIENT = "phpredis"
        REDIS_HOST = "127.0.0.1"
        REDIS_PASSWORD = "null"
        REDIS_PORT = "6379"
        
        MAIL_MAILER = "log"
        MAIL_HOST = "127.0.0.1"
        MAIL_PORT = "2525"
        MAIL_USERNAME = "null"
        MAIL_PASSWORD = "null"
        MAIL_ENCRYPTION = "null"
        MAIL_FROM_ADDRESS = "hello@example.com"
        MAIL_FROM_NAME = "${APP_NAME}"
        
        AWS_ACCESS_KEY_ID = ""
        AWS_SECRET_ACCESS_KEY = ""
        AWS_DEFAULT_REGION = "us-east-1"
        AWS_BUCKET = ""
        AWS_USE_PATH_STYLE_ENDPOINT = "false"
        
        VITE_APP_NAME = "${APP_NAME}"
    }
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/mazizkurt/laravel_test'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t laravel_test .'
                }
            }
        }
        stage('Run Docker Container') {
            steps {
                script {
                    sh 'docker rm -f laravel_test || true'
                    sh 'docker run -d -p 8081:80 --name laravel_test laravel_test'
                }
            }
        }
    }
    post {
        always {
            sh 'docker system prune -f'
        }
    }
}
