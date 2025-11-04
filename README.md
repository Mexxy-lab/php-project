## This project is a PHP project to show how its compiled and deployed for Devops practice

- Prerequisites for using a PHP project 

    - Need to have php installed 
    - Need to also install the package manager composer 

- The common.json file at the root of the directory is the file which holds all the dependenies of the project 

## Run the below command to install dependencies 

```bash 
composer install                                    | This would install the dependencies listed on the composer.json, would create a composer.lock file and a vendor file. 
```

## Run below command to test the application locally. Default php port is 8000. 

```bash
php -S localhost:8000 -t public                     | This woould laucnch the development server - [Tue Jul 22 00:36:59 2025] PHP 8.3.6 Development Server (http://localhost:8000) started]
```

## Infrastructure set up for Sonarqube service. 

- Need to install sonarqube on your instance/runner and then use it in pipeline file for your build. 
- Dependency requires java 17 version, must be installed on the instance. 
- You can also create a service file for it and manage it systemd wise. 
- Create the SonarQube service file for systemd. Update file with below content on
- Generate a sonarqube token for your project (Log into your SonarQube instance: http://localhost:9000 or your hosted server, Go to My Account → Security → Generate Tokens eg projectToken).
- Copy the token and add it to GitLab: Settings → CI/CD → Variables → Add variable: Key: SONAR_TOKEN, Value: <your token from SonarQube>, Mark as protected. 
- Create the sonar-project.properties file using the provided variables: sonar.projectKey, sonar.qualitygate.wait, sonar.projectName and sonar.projectVersion.
- This is how sonar-scanner authenticates to your SonarQube server.

```bash
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.5.1.90531.zip
sudo unzip sonarqube-10.5.1.90531.zip
sudo mv sonarqube-10.5.1.90531 SonarQube
sudo chown -R $USER:$USER /opt/sonarqube

sudo nano /etc/systemd/system/sonarqube.service

[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking

# Replace with your non-root username
User=userName
Group=groupName

# Set the working directory to where SonarQube is installed
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

# If needed:
LimitNOFILE=65536
LimitNPROC=4096
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

## Shared / Managed runner set up for project.

- For shared runner, you do not make use of tags. 
- For managed runner you have to follow the below steps to configure and set up your runner: 
- Download and Install the gitlab runner service  

```bash
sudo apt install gitlab-runner                        | Would install the service for Ubuntu OS 
sudo yum install gitlab-runner                        | Would install the service for CentOS/RedHat OS 

sudo systemctl status gitlab-runner
sudo gitlab-runner verify
sudo gitlab-runner list                               | Would list all registered runners
sudo gitlab-runner register  --url https://gitlab.com  --token glrt-AcF_zr9bRfdCRyGMAkGV0G86MQpwOjE2cWFmcgp0OjMKdTpneWdpbxg.01.1j0lacon5          | Used to register system mode. Means root user
gitlab-runner register  --url https://gitlab.com  --token glrt-AcF_zr9bRfdCRyGMAkGV0G86MQpwOjE2cWFmcgp0OjMKdTpneWdpbxg.01.1j0lacon5               | Used to register usermode.
nohup gitlab-runner run &                             | Used to run the pipeline so it listens on background in usermode. 

Note: Gitlab runner can be run in two modes, system mode and user mode. Both modes have config files stored in /etc/gitlab-runner/config.toml and /home/pumej/.gitlab-runner/config.toml files. 
```

- Create the secret for your kubernetes cluster to be able to pull your image using below command: 

```bash
kubectl create secret docker-registry gitlab-registry-secret \
  --docker-server=registry.gitlab.com \
  --docker-username=pumej1985@gmail.com \
  --docker-password=dockerToken \
  --docker-email=pumej1985@gmail.com
```
```bash
ssh -i /home/pumej/Projects/npmproject/.vagrant/machines/master-node/virtualbox/private_key vagrant@192.168.56.17               | Used to log into the vagrant vm 
sudo cp /etc/kubernetes/admin.conf /home/vagrant/                                       | Used to copy the kube file to home directory of vagrant
sudo chown vagrant:vagrant /home/vagrant/admin.conf                                     | Used to change ownership 

scp -i /home/pumej/Projects/npmproject/.vagrant/machines/master-node/virtualbox/private_key vagrant@192.168.56.17:/home/vagrant/admin.conf ~/.kube/config         | Used to copy the kube file
chmod 600 ~/.kube/config                                    | Used to change file permissions. Exit terminal and you should be fine. 
```