FROM python:3.10-alpine
# 在 FROM 后添加以下内容（参考 DockerfileBuild 的依赖安装）
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk update \
    && apk add --no-cache \
    bash \
    bash-doc \
    bash-completion \
    git \
    freetds-dev \
    jpeg-dev \
    linux-headers \
    mysql-client \
    mariadb-dev \
    build-base \
    libffi-dev \
    openssl-dev \
    zlib-dev \
    bzip2-dev \
    pcre-dev \
    ncurses-dev \
    readline-dev \
    tk-dev \
    postgresql-dev
WORKDIR /backend
COPY ./backend/ .
RUN ls ./conf/
RUN awk 'BEGIN { cmd="cp -i ./conf/env.example.py   ./conf/env.py "; print "n" |cmd; }'
RUN sed -i "s|DATABASE_HOST = '127.0.0.1'|DATABASE_HOST = '177.10.0.1'|g" ./conf/env.py
RUN sed -i "s|REDIS_HOST = '127.0.0.1'|REDIS_HOST = '177.10.0.1'|g" ./conf/env.py
RUN python3 -m pip install -i https://pypi.tuna.tsinghua.edu.cn/simple/ -r requirements.txt
CMD ["sh","docker_start.sh"]
