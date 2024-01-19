# attempting to use alpine
FROM --platform=$BUILDPLATFORM lscr.io/linuxserver/ffmpeg:latest
ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM" > /log
# Pulling TARGET_ARCH from build arguments and setting ENV variable
ARG TARGETARCH
ENV ARCH_VAR=$TARGETARCH

# alpine uses apk
COPY ffserver.conf /etc/ffserver.conf
RUN rm  -rf /tmp/* /var/cache/apk/*
COPY root/ /
#RUN chmod 0755 /etc/s6-overlay/scripts/acquire_slinger_up.sh
ENTRYPOINT ["/init"]
