FROM python:3.6-slim

LABEL name="httpbin"
LABEL version="0.9.2"
LABEL description="A simple HTTP service."
LABEL org.kennethreitz.vendor="Kenneth Reitz"

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt update -y && apt install python3-pip -y && pip3 install --no-cache-dir --upgrade pip pipenv gunicorn

ADD Pipfile Pipfile.lock /httpbin/
WORKDIR /httpbin
RUN /bin/bash -c "pip3 install --no-cache-dir -r <(pipenv lock -r)"

#COPY cert.pem .
#COPY key.pem .

ADD . /httpbin
RUN pip3 install --no-cache-dir /httpbin

#EXPOSE 443
EXPOSE 80

#CMD ["gunicorn", "-b", "0.0.0.0:443", "--certfile", "cert.pem", "--keyfile", "key.pem", "httpbin:app", "-k", "gevent"]
CMD ["gunicorn", "-b", "0.0.0.0:80", "httpbin:app", "-k", "gevent"]
