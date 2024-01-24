FROM python:3.12-alpine

WORKDIR /usr/src/mopidy

# Install Mopidy requirements
RUN --mount=type=bind,source=requirements.txt,target=requirements.txt \
    apk add --no-cache --virtual build-dependencies python3-dev gcc libc-dev \
    cairo-dev gobject-introspection gobject-introspection-dev \
    && apk add --no-cache \
        gstreamer \
        py3-gobject3 \
        py3-gst \
        shadow \
        su-exec \
        gst-plugins-bad \
        gst-plugins-good \
        gst-plugins-ugly \
    && python3 -m pip install --no-cache-dir --requirement requirements.txt \
    && apk del build-dependencies \
    ;

COPY docker-entrypoint.sh .

ENTRYPOINT [ "/usr/src/mopidy/docker-entrypoint.sh" ]
CMD [ "/usr/local/bin/mopidy" ]
