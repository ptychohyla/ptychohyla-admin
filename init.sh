#!/bin/bash
ENV_FILE=".env"
HOST="177.10.0.13"
REDIS_HOST="177.10.0.15"
WEB_HOST="127.0.0.1"

# Check if .env file exists
if [ -f "$ENV_FILE" ]; then
    echo "$ENV_FILE already exists."
else
    # Generate random MYSQL password
    MYSQL_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 18)
    echo "MYSQL_PASSWORD=$MYSQL_PASSWORD" >> "$ENV_FILE"
    echo "Generated MYSQL password and saved to $ENV_FILE"

    # Generate random REDIS password
    REDIS_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12)
    echo "REDIS_PASSWORD=$REDIS_PASSWORD" >> "$ENV_FILE"
    echo "Generated REDIS password and saved to $ENV_FILE"

    # Update configuration files
    awk 'BEGIN { cmd="cp -i ./backend/conf/env.example.py ./backend/conf/env.py"; print "n" |cmd; }'
    sed -i "s|DATABASE_HOST = '127.0.0.1'|DATABASE_HOST = '$HOST'|g" ./backend/conf/env.py
    sed -i "s|REDIS_HOST = '127.0.0.1'|REDIS_HOST = '177.10.0.15'|g" ./backend/conf/env.py
    sed -i "s|DATABASE_PASSWORD = 'DVADMIN3'|DATABASE_PASSWORD = '$MYSQL_PASSWORD'|g" ./backend/conf/env.py
    sed -i "s|REDIS_PASSWORD = 'DVADMIN3'|REDIS_PASSWORD = '$REDIS_PASSWORD'|g" ./backend/conf/env.py
    echo "Initialization passwords created successfully"
fi

echo "Starting containers..."
docker-compose up -d

if [ $? -ne 0 ]; then
    echo "Failed to run 'docker-compose up -d'"
    exit 1
fi

check_mysql() {
    local mysql_container=$(docker ps --filter "name=ptychohyla-mysql" --format "{{.Names}}" | head -1)
    if [ -z "$mysql_container" ]; then
        echo "MySQL container not found!"
        return 1
    fi
    echo "Checking MySQL ($mysql_container)..."
    if docker exec "$mysql_container" mysqladmin -u root -p"$MYSQL_PASSWORD" ping &> /dev/null; then
        echo "MySQL Available"
        return 0
    else
        return 1
    fi
}

check_redis() {
    local redis_container=$(docker ps --filter "name=ptychohyla-redis" --format "{{.Names}}" | head -1)
    if [ -z "$redis_container" ]; then
        echo "Redis container not found!"
        return 1
    fi
    echo "Checking Redis ($redis_container)..."
    if docker exec "$redis_container" redis-cli ping &> /dev/null; then
        echo "Redis Available"
        return 0
    else
        return 1
    fi
}

max_retries=8
sleep_time=3
i=1

while [ $i -le $max_retries ]; do
    if ! check_mysql || ! check_redis; then
        echo "Attempt $i/$max_retries: MySQL or Redis not ready, retrying in $sleep_time seconds..."
        sleep $sleep_time
    else
        echo "Migrating data..."
        docker exec ptychohyla-django python3 manage.py makemigrations
        docker exec ptychohyla-django python3 manage.py migrate
        echo "Initializing data..."
        docker exec ptychohyla-django python3 manage.py init
        echo "Welcome to use the Ptychohyla project"
        echo "Login URL: http://$WEB_HOST:8080"
        echo "If unable to access, check firewall configuration"
        exit 0
    fi
    i=$((i+1))
done

echo "After $max_retries attempts, MySQL or Redis service still not running"
exit 1