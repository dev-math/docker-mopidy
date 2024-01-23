FROM python:3.12-alpine

WORKDIR /usr/src/mopidy

ARG MOPIDY_ADDONS="Mopidy-MPD==3.3.0 Mopidy-YouTube==3.7 mopidy-ytmusic==0.3.8 pytube==12.1.3 yt-dlp==2023.12.30"

# Install Mopidy requirements
RUN --mount=type=bind,source=requirements.txt,target=requirements.txt \
    apk add --no-cache --virtual build-dependencies python3-dev gcc libc-dev \
    cairo-dev gobject-introspection gobject-introspection-dev \
    && apk add --no-cache \
        gstreamer \
        py3-gobject3 \
        py3-gst \
        shadow \
        gst-plugins-bad \
        gst-plugins-good \
        gst-plugins-ugly \
    && python3 -m pip install --no-cache-dir --requirement requirements.txt \
    && if [ -n "$MOPIDY_ADDONS" ]; then python3 -m pip install --no-cache-dir $MOPIDY_ADDONS; fi \
    && apk del build-dependencies \
    ;

ENTRYPOINT [ "/usr/local/bin/mopidy" ]
CMD [ "-v" ]
