FROM frolvlad/alpine-python3

COPY requirements.txt /opt/www/
COPY tasks /opt/www/tasks

RUN apk add --update -t build_dependencies musl-dev gcc python3-dev libffi-dev && \
    ln -s pip3 /usr/bin/pip && \
    pip install invoke colorlog && \
    cd /opt/www && \
    invoke app.dependencies.install && \
    apk del build_dependencies && \
    rm /var/cache/apk/*

COPY . /opt/www/

RUN chmod 666 /opt/www/example.db && \
    chmod 777 /opt/www

USER nobody
WORKDIR /opt/www/
CMD [ "invoke", "app.run", "--no-install-dependencies", "--host", "0.0.0.0" ]