FROM ubuntu:22.04

ENV PAGE_SIZE=32
ENV CASE_SENSITIVE=1
ENV UNICODE_FLAG=0
ENV LENGTH_IN_CHAR=0
ENV SYSDBA_PWD=123456789
ENV ADMIN_PWD=123456789


ADD DMInstall/source /opt/dmdbms
ADD --chmod=0755 scripts /scripts

RUN /scripts/install.sh

ADD --chmod=0755 entrypoint.sh /

EXPOSE 5236/tcp

VOLUME ["/opt/dmdbms/data"]

ENTRYPOINT ["/entrypoint.sh"]
CMD ["serve"]
