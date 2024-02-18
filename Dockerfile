FROM 200ms/alpinenet_dev2

RUN add_dev2fs.sh

COPY entry.sh /entry.sh
RUN chmod +x /entry.sh

CMD [ "/entry.sh" ]
