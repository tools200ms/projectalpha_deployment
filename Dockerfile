FROM 200ms/alpinenet_dev2

RUN add_dev2fs.sh
RUN apk add bash

COPY files/entry.sh /entry.sh
RUN chmod +x /entry.sh

COPY files/prepare_image.sh /usr/local/bin/prepare_image.sh
RUN chmod +x /usr/local/bin/prepare_image.sh


CMD [ "/entry.sh" ]
