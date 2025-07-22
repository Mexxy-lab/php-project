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

## Create secret for kube cluster deployment to enable cluster access to repository 

```bash
kubectl create secret docker-registry gitlab-registry-secret \
  --docker-server=registry.gitlab.com \
  --docker-username=pumej1985@gmail.com \
  --docker-password=gitlabToken \
  --docker-email=pumej1985@gmail.com
```