FROM alpine:3.7 as build

ENV HUGO_VERSION 0.42.1
ENV HUGO_BINARY hugo_${HUGO_VERSION}_Linux-64bit.tar.gz

# Install Hugo
RUN set -x && \
  apk add --update wget ca-certificates && \
  wget https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} && \
  tar xzf ${HUGO_BINARY} && \
  rm -r ${HUGO_BINARY} && \
  mv hugo /usr/bin && \
  apk del wget ca-certificates && \
  rm /var/cache/apk/*

COPY src /source

WORKDIR /source

RUN /usr/bin/hugo

FROM nginx:alpine

LABEL maintainer Chris Merrett <chris@chrismerrett.com>

COPY --from=build /source/public/ /usr/share/nginx/html/

WORKDIR /usr/share/nginx/html
