#! /bin/bash
echo "Fetching requirements"
sudo apt-get update
sudo apt-get install -y openjdk-11-jdk wget

echo "Installing thingsboard service"
wget https://github.com/thingsboard/thingsboard/releases/download/v3.4.2/thingsboard-3.4.2.deb
sudo dpkg -i thingsboard-3.4.2.deb

echo "Setting up postgres"
sudo apt-get install -y postgresql
sudo service postgresql start
psql_password='thingsboard'
psql_user='thingsboard'

sudo -u postgres psql -c "CREATE DATABASE thingsboard;"
sudo -u postgres psql -c 'CREATE USER ${psql_user} WITH PASSWORD "${psql_password};"'
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE thingsboard to ${psql_user};"

echo "Configuring thingsboard"
tb_config="# DB Configuration   \nexport DATABASE_TS_TYPE=sql \nexport SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/thingsboard   \nexport SPRING_DATASOURCE_USERNAME=${psql_user}  \nexport SPRING_DATASOURCE_PASSWORD=${psql_password} \n# Specify partitioning size for timestamp key-value storage. Allowed values: DAYS, MONTHS, YEARS, INDEFINITE. \nexport SQL_POSTGRES_TS_KV_PARTITIONING=MONTHS   \n"
sudo echo -e $tb_config >> /etc/thingsboard/conf/thingsboard.conf


while getopts s: flag
do 
    case "${flag}" in 
        s) small='yes';;
    esac
done

if [ -n "${small}" ]
then
    echo 'export JAVA_OPTS="$JAVA_OPTS -Xms256M -Xmx256M"' >> /etc/thingsboard/conf/thingsboard.conf
fi

echo "Installing thingsboard"
sudo /usr/share/thingsboard/bin/install/install.sh --loadDemo
sudo service thingsboard start
