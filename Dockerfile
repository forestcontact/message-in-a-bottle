FROM ghcr.io/graalvm/graalvm-ce:latest as sigbuilder
ENV GRAALVM_HOME=/opt/graalvm-ce-java11-21.2.0/ 
SHELL ["/usr/bin/bash", "-c"]
WORKDIR /app
RUN microdnf install -y git zlib-devel && rm -rf /var/cache/yum
RUN gu install native-image
RUN git clone https://github.com/AsamK/signal-cli
WORKDIR /app/signal-cli
RUN git pull origin v0.10.0
RUN ./gradlew build && ./gradlew installDist
# todo: just download https://github.com/forestcontact/signal-cli/releases/download/forest-fork-v1.1.2-payments/signal-cli
RUN ./gradlew nativeCompile

FROM ubuntu:latest
COPY --from=sigbuilder /app/signal-cli/build/native/nativeCompile/signal-cli /app/signal-cli/build.gradle.kts /app/
# for signal-cli's unpacking of native deps
COPY --from=sigbuilder /lib64/libz.so.1 /lib64
ENV DEBIAN_FRONTEND "noninteractive" 
RUN ln --symbolic --force --no-dereference /usr/share/zoneinfo/EST /etc/localtime && \
	echo "EST" > /etc/timezone && apt-get update && \
	apt-get install -yy curl gpg zbar-tools imagemagick x11-apps wmctrl

# 1. Install our official public software signing key 
RUN curl https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor >> /usr/share/keyrings/signal-desktop-keyring.gpg && \
    # 2. Add our repository to your list of repositories
    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' >> /etc/apt/sources.list.d/signal-xenial.list && \
    # 3. Update your package database and install signal
    apt-get update && apt-get install -yy signal-desktop
COPY ./getqr.sh ./
WORKDIR /
RUN ls 
