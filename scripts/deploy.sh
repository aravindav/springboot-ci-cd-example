#!/bin/bash

APP_JAR="target/springboot-ci-cd-1.0.0.jar"
REMOTE_USER="azureuser"
REMOTE_HOST="your.app.vm.ip"
REMOTE_PATH="/home/azureuser/app"
SSH_KEY_PATH="~/.ssh/id_rsa"

echo "Building project with Maven..."
mvn clean package -DskipTests

echo "Copying JAR to remote VM..."
scp -i $SSH_KEY_PATH $APP_JAR $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH/app.jar

echo "Restarting app on remote VM..."
ssh -i $SSH_KEY_PATH $REMOTE_USER@$REMOTE_HOST << EOF
  pkill -f 'java -jar' || true
  nohup java -jar $REMOTE_PATH/app.jar > $REMOTE_PATH/app.log 2>&1 &
EOF

echo "Deployment complete!"
