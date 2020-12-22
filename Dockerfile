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

ENV COLUMNS 100
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php-fpm

HEALTHCHECK --interval=5s --timeout=60s --retries=3 CMD /healthcheck.sh

WORKDIR /var/www/html

ENTRYPOINT ["/usr/local/sbin/php-fpm"]

CMD ["--nodaemonize"]

USER php
