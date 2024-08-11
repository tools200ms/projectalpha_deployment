FROM a6edad7b4650
#200ms/alpinenet_dev2

RUN dev2_setup.sh add dev2fs update_gnu python

RUN apk add util-linux-misc dosfstools e2fsprogs f2fs-tools

#COPY files/entry.sh /entry.sh
#RUN chmod +x /entry.sh

COPY files/prepare_image.sh /usr/local/bin/prepare_image.sh
RUN chmod +x /usr/local/bin/prepare_image.sh

CMD [ "/entry.sh" ]
