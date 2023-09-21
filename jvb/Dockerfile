ARG JITSI_REPO=jitsi
ARG BASE_TAG=stable-7648-4

FROM ${JITSI_REPO}/base:${BASE_TAG} as builder
RUN mkdir -p /usr/share/man/man1 && \
    apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y openjdk-11-jdk-headless && \
    apt-cleanup

RUN \
    cd /opt/ && \
    wget -q http://apache.mirrors.pair.com/maven/maven-3/3.9.4/binaries/apache-maven-3.9.4-bin.tar.gz && \
    tar -xvzf apache-maven-3.9.4-bin.tar.gz && \
    mv apache-maven-3.9.4 maven
ENV M2_HOME=/opt/maven
ENV PATH=${M2_HOME}/bin:${PATH}

COPY jitsi-videobridge /jitsi-videobridge

WORKDIR /jitsi-videobridge
RUN --mount=type=cache,target=/root/.m2 mvn clean package -P buildFatJar

#################
FROM ${JITSI_REPO}/base-java:${BASE_TAG}

ENV VIDEOBRIDGE_VERSION=2.2-22-g42bc1b99-1

RUN \
	apt-dpkg-wrap apt-get update && \
	apt-dpkg-wrap apt-get install -y jitsi-videobridge2=${VIDEOBRIDGE_VERSION} jq curl iproute2 dnsutils && \
	apt-cleanup

COPY rootfs/ /

COPY --from=builder /jitsi-videobridge/jvb/target/jitsi-videobridge-2.1-SNAPSHOT-jar-with-dependencies.jar /usr/share/jitsi-videobridge/jitsi-videobridge.jar

VOLUME /config
