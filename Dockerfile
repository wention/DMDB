FROM ubuntu:22.04

ENV PAGE_SIZE=32
ENV CASE_SENSITIVE=1
ENV UNICODE_FLAG=0
ENV LENGTH_IN_CHAR=0
ENV ADMIN_PWD=SYSDBA

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD LD_LIBRARY_PATH=/opt/dmdbms/bin /opt/dmdbms/bin/disql SYSDBA/${ADMIN_PWD}@localhost:5236 -e "select now"


ADD DMInstall/source /opt/dmdbms
ADD --chmod=0755 scripts /scripts

RUN /scripts/install.sh

ADD --chmod=0755 entrypoint.sh /

EXPOSE 5236/tcp

VOLUME ["/opt/dmdbms/data"]

ENTRYPOINT ["/entrypoint.sh"]
CMD ["serve"]
