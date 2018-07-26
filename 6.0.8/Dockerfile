FROM node:10-alpine

RUN apk add --no-cache python git build-base

ENV VERSION 6.0.8
RUN npm install -g @angular/cli@$VERSION


ARG UID=1001
ARG GID=0

RUN set -xe; \
  mkdir /app; \
  if [ $GID != "0" ]; then \
    # group is not root \
    # if GID exists (eg. OSX, gid = 20) \
    # so we add "node" user to that group either we only change node group to that GID \
    (grep ":$GID;" /etc/group && sed -i "s/.*:$GID:.*/&,node/") || sed -i 's/1000/'$GID'/g' /etc/group; \
  fi;\
  sed -i 's/1000/'$UID'/g' /etc/passwd; \
  chown -R node:node /home/node; \
  chgrp $GID /app; \
  chown $UID /app; \
  chmod o+r /app;  \
  chmod g+rwx /app;

WORKDIR /app
VOLUME /app
ENV HOME=/tmp APPNAME=hero GENERATE=true
ADD entrypoint.sh /entrypoint.sh

EXPOSE 4200
USER node

ENTRYPOINT ["/entrypoint.sh"]
CMD ["ng", "serve", "--host", "0.0.0.0"]

