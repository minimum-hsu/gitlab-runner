FROM gitlab/gitlab-runner:alpine

COPY docker-entrypoint.sh /

SHELL ["/bin/bash", "-c"]

ENTRYPOINT ["/usr/bin/dumb-init"]

CMD /docker-entrypoint.sh
