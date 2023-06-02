FROM alpine:3.18 as builder
LABEL maintainer="Markku Virtanen"

ENV VERSION_BEANSTALKD="1.13"

RUN apk --update add --virtual build-dependencies \
  gcc \
  make \
  musl-dev \
  curl \
  && curl -sL https://github.com/kr/beanstalkd/archive/v$VERSION_BEANSTALKD.tar.gz | tar xvz -C /tmp \
  && cd /tmp/beanstalkd-$VERSION_BEANSTALKD \
  && make \
  && cp beanstalkd /usr/bin

FROM alpine:3.18
LABEL maintainer="Markku Virtanen"

RUN addgroup -S beanstalkd && adduser -S -G beanstalkd beanstalkd
RUN apk add --no-cache tini 'su-exec>=0.2'

COPY --from=builder /usr/bin/beanstalkd /usr/bin/beanstalkd
  
RUN mkdir /data && chown beanstalkd:beanstalkd /data
VOLUME ["/data"]
EXPOSE 11300

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["beanstalkd", "-p", "11300", "-u", "beanstalkd", "-b", "/data"]