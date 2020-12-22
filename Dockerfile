FROM fulcrum/php7.4-drush8 AS builder
LABEL IF Fulcrum "fulcrum@ifsight.net"

ENV BUILDDATE 202012181700

USER root

RUN STARTTIME=$(date "+%s")                                                                   && \
apk --no-cache add binutils openssh-client                                                    && \
echo "################## [$(date)] Clean up container/put on a diet ##################"       && \
rm -vrf $FILE /var/cache/apk/* /var/cache/distfiles/*                                         && \
strip -v /usr/bin/scp /usr/bin/sftp $(ls /usr/bin/ssh*|grep -v /usr/bin/ssh-copy-id)          && \
apk del binutils                                                                              && \
echo "################## [$(date)] Done ##################"                                   && \
echo "################## Elapsed: $(expr $(date "+%s") - $STARTTIME) seconds ##################"

FROM scratch
COPY --from=builder / /

USER php
