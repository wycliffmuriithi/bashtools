<<<<<<< Updated upstream
## copy local public key to server for ssh key authentication
cat id_rsa.pub | ssh -i india_access_key.pem ec2-user@<hostip> "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"

## create a jks keystore 
keytool -genkey -alias <domain> -keyalg RSA -keystore <keystorename>.jks -keysize 2048
  
## export cert from keystore
keytool -export -alias <domain> -storepass <password> -file <certname>.cer -keystore <keystorename>.jks
  
## add certificate to jre truststore to allow java clients to authenticate the cert
keytool -importcert -keystore cacerts -storepass changeit -file <certname>.cer -alias <domain>
  
=======
cat id_rsa.pub | ssh -i india_access_key.pem ec2-user@13.233.163.150 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"


pgrep -a java | grep ids | awk '{ print $1 }'


## build a docker image
docker build -t police-sme-app:latest .
## pass directory config while running docker image
docker run -v C:\Users\wgicheru\eclipse-workspace\sme\configs:/sme/config -p 9696:9696 police-sme-app

## map port on server to port on local machine
this command works for scenarios like mpesa where you need to have use a specific IP.
ssh -R 8082:localhost:8084 jmungai@10.20.2.4
