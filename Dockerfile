FROM alpine as build

RUN apk add --no-cache --virtual diagrams-build-dependencies \
    build-base \
    python3-dev \
    py3-pip \
    imagemagick

RUN pip install --prefix /opt/diagrams diagrams black

FROM alpine

COPY --from=build /opt/diagrams/ /opt/diagrams/

RUN apk add --no-cache --virtual diagrams-runtime-dependencies \
    python3 \
    graphviz \
    imagemagick

RUN apk add --no-cache --virtual kicad-edge-runtime-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    inkscape

ENV PYTHONPATH /usr/lib/python3.8/site-packages/:/opt/diagrams/lib/python3.8/site-packages/

USER adduser -D -u 1000 diagrams

WORKDIR /workspace

RUN chown diagrams:diagrams /workspace

USER diagrams

