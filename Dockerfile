FROM ubuntu:22.04

RUN apt-get update -y && apt-get upgrade -y

RUN apt-get install -y \
    curl \
    git

RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash

RUN apt-get install -y git-lfs

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
