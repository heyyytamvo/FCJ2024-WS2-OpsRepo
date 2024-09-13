#!/bin/bash
sudo apt update -y
sudo apt install -y fontconfig openjdk-17-jre

# Sonarqube
sudo apt install curl ca-certificates
sudo install -d /usr/share/postgresql-common/pgdg
sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc
sudo sh -c 'echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
sudo apt update
sudo apt install postgresql-15 -y
sudo -i -u postgres
createuser sonar
createdb sonar -O sonar
psql
ALTER USER sonar WITH ENCRYPTED PASSWORD 'your_password';
\q
exit
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.5.1.90531.zip
sudo apt install -y unzip
sudo unzip sonarqube-10.5.1.90531.zip
sudo mv sonarqube-10.5.1.90531 /opt/sonarqube
sudo adduser --system --no-create-home --group --disabled-login sonarqube
sudo chown -R sonarqube:sonarqube /opt/sonarqube

sudo tee /opt/sonarqube/conf/sonar.properties > /dev/null << 'EOF'
sonar.jdbc.username=sonar
sonar.jdbc.password=your_password
sonar.jdbc.url=jdbc:postgresql://localhost/sonar
EOF

sudo tee /etc/systemd/system/sonarqube.service > /dev/null << 'EOF'
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

User=sonarqube
Group=sonarqube
Restart=always

LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl start sonarqube
sudo systemctl enable sonarqube

sudo tee /etc/security/limits.conf > /dev/null << 'EOF'
sonarqube   -   nofile   65536
sonarqube   -   nproc    4096
EOF

sudo tee /etc/sysctl.conf > /dev/null << 'EOF'
vm.max_map_count=262144
EOF
sudo sysctl -p