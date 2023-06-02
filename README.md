# Beanstalkd alpine and tini

This is based on https://github.com/uretgec/docker-beanstalkd-alpine. I added tini so it exists more cleanly.

## Update v2

- use alpine 3.8
- use beanstalkd version 1.13
- use build step in Dockerfile to create the final image