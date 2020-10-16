FROM alpine as build

RUN apk add --no-cache --virtual diagrams-build-dependencies \
    build-base \
    python3-dev \
    py3-pip \
    imagemagick

RUN pip install --prefix /opt/diagrams diagrams black

FROM 0x01be/inkscape:xpra

COPY --from=build /opt/diagrams/ /opt/diagrams/

USER root
RUN apk add --no-cache --virtual diagrams-runtime-dependencies \
    python3 \
    graphviz \
    imagemagick

ENV PYTHONPATH /usr/lib/python3.8/site-packages/:/opt/diagrams/lib/python3.8/site-packages/

USER xpra

