FROM openjdk:8-jre-alpine

ENV WIREMOCK_VERSION 2.27.1

RUN apk add --update openssl

# fix "No Server ALPNProcessors" when using https
RUN apk add --update libc6-compat
RUN ln -s /lib/libc.musl-x86_64.so.1 /lib/ld-linux-x86-64.so.2

# grab su-exec for easy step-down from root
# and bash
RUN apk add --no-cache 'su-exec>=0.2' bash

# grab wiremock standalone jar
RUN mkdir -p /var/wiremock/lib/ \
  && wget https://repo1.maven.org/maven2/com/github/tomakehurst/wiremock-jre8-
standalone/$WIREMOCK_VERSION/wiremock-jre8-standalone-$WIREMOCK_VERSION.jar \
-O /var/wiremock/lib/wiremock-jre8-standalone.jar

WORKDIR /home/wiremock

EXPOSE 7070 7443

CMD java $JAVA_OPTS -cp /var/wiremock/lib/*:/var/wiremock/extensions/*
com.github.tomakehurst.wiremock.standalone.WireMockServerRunner
