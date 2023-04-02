# Muno Notes
## Protoc
We use this version of protoc: https://github.com/protocolbuffers/protobuf/releases/download/v3.12.4/protoc-3.12.4-linux-x86_64.zip

## Dev via intellij IDEA
- Connect to jvb dev container via RDP.

- Run/debug configuration:

    Java 11 SDK

    classpath: `jitsi-videobridge`

    VM options: `-Dnet.java.sip.communicator.SC_HOME_DIR_LOCATION=/ -Dnet.java.sip.communicator.SC_HOME_DIR_NAME=config -Djava.util.logging.config.file=/config/logging.properties -Dconfig.file=/config/jvb.conf`

    Main Class: `org.jitsi.videobridge.MainKt`

    Working dir: `/jvb/jitsi-videobridge`

    Env variables for Muno configuration (see env.example)

- If intellij not detect generated gprc resource, add grpc generated-sources to source folders in configuration: https://github.com/quarkusio/quarkus/issues/13882

# Jitsi Meet on Docker

![](resources/jitsi-docker.png)

[Jitsi](https://jitsi.org/) is a set of Open Source projects that allows you to easily build and deploy secure videoconferencing solutions.

[Jitsi Meet](https://jitsi.org/jitsi-meet/) is a fully encrypted, 100% Open Source video conferencing solution that you can use all day, every day, for free — with no account needed.

This repository contains the necessary tools to run a Jitsi Meet stack on [Docker](https://www.docker.com) using [Docker Compose](https://docs.docker.com/compose/).

All our images are published on [DockerHub](https://hub.docker.com/u/jitsi/).

## Supported architectures

Starting with `stable-7289-1` the published images are available for `amd64` and `arm64` with the exception of `jigasi`.

## Tags

These are the currently published tags for all our images:

Tag | Description
-- | --
`stable` | Points to the latest stable release
`stable-NNNN-X` | A stable release
`unstable` | Points to the latest unstable release
`unstable-YYYY-MM-DD` | Daily unstable release
`latest` | Deprecated, no longer updated (will be removed)

## Installation

The installation manual is available [here](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker).

### Kubernetes

If you plan to install the jitsi-meet stack on a Kubernetes cluster you can find tools and tutorials in the project [Jitsi on Kubernetes](https://github.com/jitsi-contrib/jitsi-kubernetes).

## TODO

* Builtin TURN server.
