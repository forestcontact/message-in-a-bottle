FROM node:14.16.0-buster
ENV DEBIAN_FRONTEND "noninteractive" 
RUN ln --symbolic --force --no-dereference /usr/share/zoneinfo/EST /etc/localtime && \
	echo "EST" > /etc/timezone && apt-get update && \
	apt-get install -yy git-lfs
RUN git clone https://github.com/signalapp/Signal-Desktop.git
WORKDIR /Signal-Desktop
RUN git-lfs install
RUN yarn install --frozen-lockfile
RUN yarn grunt
ENTRYPOINT ["/usr/local/bin/yarn", "start"]
