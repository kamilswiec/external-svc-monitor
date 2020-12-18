FROM python:3.8.6-slim-buster
RUN apt -y update && apt -y install  \
    curl &&\
    curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.19.0/bin/linux/amd64/kubectl &&\
    chmod +x ./kubectl &&\
    mv ./kubectl /usr/local/bin/kubectl &&\
    pip install --no-cache-dir \ 
    awscli==1.18.195

COPY entrypoint.sh stack.yaml.sh /

ENTRYPOINT ["/entrypoint.sh"]
