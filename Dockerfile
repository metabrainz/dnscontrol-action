FROM alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11

LABEL repository="https://github.com/is-cool-me/dnscontrol-action"
LABEL maintainer="light <admin@lighthosting.eu.org>"

LABEL "com.github.actions.name"="DNSControl"
LABEL "com.github.actions.description"="Deploy your DNS configuration to multiple providers."
LABEL "com.github.actions.icon"="cloud"
LABEL "com.github.actions.color"="yellow"

# renovate: datasource=github-release-attachments depName=dnscontrol packageName=StackExchange/dnscontrol
ENV DNSCONTROL_VERSION="v4.37.0"
ENV DNSCONTROL_CHECKSUM="7eb8ef2b645da9b6fed51af82b803876f349197cc0ca22e20c28b433bc2a1ab6"
ENV USER=dnscontrol-user

RUN apk -U --no-cache upgrade && \
    apk add --no-cache bash ca-certificates curl libc6-compat tar

RUN  addgroup -S dnscontrol-user && adduser -S dnscontrol-user -G dnscontrol-user --disabled-password

RUN curl -sL "https://github.com/DNSControl/dnscontrol/releases/download/${DNSCONTROL_VERSION}/dnscontrol_${DNSCONTROL_VERSION//v}_linux_amd64.tar.gz" \
    -o dnscontrol && \
    echo "$DNSCONTROL_CHECKSUM  dnscontrol" | sha256sum -c - && \
    tar xvf dnscontrol

RUN chown dnscontrol-user:dnscontrol-user  dnscontrol

RUN chmod +x dnscontrol && \
    chmod 755 dnscontrol && \
    cp dnscontrol /usr/local/bin/dnscontrol

RUN ["dnscontrol", "version"]

COPY README.md entrypoint.sh bin/filter-preview-output.sh /
ENTRYPOINT ["/entrypoint.sh"]
