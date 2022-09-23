FROM ubuntu:22.04

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y \
    curl \
    git

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
