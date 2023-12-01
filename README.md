# Dev via intellij IDEA
- Connect to jvb dev container via RDP.

- Run/debug configuration:

    Java 11 SDK

    classpath: jitsi-videobridge

    VM options: -Dnet.java.sip.communicator.SC_HOME_DIR_LOCATION=/ -Dnet.java.sip.communicator.SC_HOME_DIR_NAME=config -Djava.util.logging.config.file=/config/logging.properties -Dconfig.file=/config/jvb.conf

    Main Class: org.jitsi.videobridge.MainKt

    Working dir: /jvb/jitsi-videobridge

- Same for jicofo, but:
    VM options: -Dnet.java.sip.communicator.SC_HOME_DIR_LOCATION=/ -Dnet.java.sip.communicator.SC_HOME_DIR_NAME=config
    Program arguments: --domain="meet.jitsi" --host="xmpp.meet.jitsi" --user_name="focus" --user_domain="auth.meet.jitsi"

