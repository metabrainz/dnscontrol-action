FROM alpine:3.24.4@sha256:f59abe656b692d901e184be3445e084786602108599d2a51d229c0f5a48c71bf

LABEL repository="https://github.com/metabrainz/dnscontrol-action"
LABEL maintainer="Julian Anderson <julian@metabrainz.org>"

LABEL "com.github.actions.name"="DNSControl"
LABEL "com.github.actions.description"="Deploy your DNS configuration to multiple providers."
LABEL "com.github.actions.icon"="cloud"
LABEL "com.github.actions.color"="yellow"

# renovate: datasource=github-release-attachments depName=dnscontrol packageName=StackExchange/dnscontrol
ENV DNSCONTROL_VERSION="v5.8.2"
ENV DNSCONTROL_CHECKSUM="b1a5154b85eecd18b9247194f42c1b7e7c1128a63317ca3140c8b8224f87e6d2"
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
