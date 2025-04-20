#!/bin/bash
ENV_FILE=".env"
HOST="177.10.0.13"
REDIS_HOST="177.10.0.15"
WEB_HOST="localhost"
# 检查 .env 文件是否存在
if [ -f "$ENV_FILE" ]; then
    echo "$ENV_FILE 文件已存在。"
else
    # 生成MYSQL随机密码
    MYSQL_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 18)
    echo "MYSQL_PASSWORD=$MYSQL_PASSWORD" >> "$ENV_FILE"
    echo "MYSQL随机密码已生成并写入 $ENV_FILE 文件。"
    # 生成REDIS随机密码
    REDIS_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12)
    # 将密码写入 .env 文件
    echo "REDIS_PASSWORD=$REDIS_PASSWORD" >> "$ENV_FILE"
    echo "REDIS随机密码已生成并写入 $ENV_FILE 文件。"
    
    awk 'BEGIN { cmd="cp -i ./backend/conf/env.example.py   ./backend/conf/env.py "; print "n" |cmd; }'
    sed -i "s|DATABASE_HOST = '127.0.0.1'|DATABASE_HOST = '$HOST'|g" ./backend/conf/env.py
    sed -i "s|REDIS_HOST = '127.0.0.1'|REDIS_HOST = '177.10.0.15'|g" ./backend/conf/env.py
    sed -i "s|DATABASE_PASSWORD = 'DVADMIN3'|DATABASE_PASSWORD = '$MYSQL_PASSWORD'|g" ./backend/conf/env.py
    sed -i "s|REDIS_PASSWORD = 'DVADMIN3'|REDIS_PASSWORD = '$REDIS_PASSWORD'|g" ./backend/conf/env.py
    echo "初始化密码创建成功"
fi

echo "正在启动容器..."
docker-compose up -d

if [ $? -ne 0 ]; then
    echo "docker-compose up -d 执行失败！"
    exit 1
fi

MYSQL_PORT=3306
REDIS_PORT=6379

check_mysql() {
    echo "正在检查 MySQL ($HOST:$MYSQL_PORT) 服务..."
    if $(docker inspect -f '{{.State.Running}}' ptychohyla-mysql); then
      echo "MySQL 服务可用"
      return 0
    else
      return 1
    fi
}

check_redis() {
    echo "正在检查 Redis ($REDIS_HOST:$REDIS_PORT) 服务..."
    if $(docker inspect -f '{{.State.Running}}' ptychohyla-redis); then
      echo "Redis 服务可用"
      return 0
    else
      return 1
    fi
}

i=1
while [ $i -le 8 ]; do
    if check_mysql || check_redis; then
        echo "正在迁移数据..."
        docker exec ptychohyla-django python3 manage.py makemigrations
        docker exec ptychohyla-django python3 manage.py migrate
        echo "正在初始化数据..."
        docker exec ptychohyla-django python3 manage.py init
        echo "欢迎使用ptychohyla项目"
        echo "登录地址：http://'$WEB_HOST':8080"
        echo "如访问不到，请检查防火墙配置"
        exit 0
    else
        echo "MySQL 和 Redis 服务都未运行, 第 $i 次尝试，等待 2 秒后重试..."
        sleep 2
    fi
    i=$((i+1))
done

echo "尝试 5 次后，MySQL 或 REDIS服务仍未运行"
exit 1
