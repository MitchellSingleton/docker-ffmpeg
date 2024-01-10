# attempting to use alpine
#FROM linuxserver/docker-baseimage-alpine:latest
FROM --platform=$BUILDPLATFORM lsiobase/alpine:3.19
ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM" > /log
# Pulling TARGET_ARCH from build arguments and setting ENV variable
ARG TARGETARCH
ENV ARCH_VAR=$TARGETARCH

# alpine uses apk
RUN apk add --update bash libssl3 openssl-dev unzip && rm  -rf /tmp/* /var/cache/apk/*

#Add Slinger dependancies
RUN apk add py3-pip
RUN apk add py3-netifaces
RUN pip3 install --upgrade pip
RUN pip3 install flask
COPY root/ /
RUN chmod 0755 /etc/s6-overlay/scripts/acquire_slinger_up.sh
ENTRYPOINT ["/init"]
