FROM alpine as build

RUN apk add --no-cache --virtual diagrams-build-dependencies \
    build-base \
    python3-dev \
    py3-pip

RUN pip install --prefix /opt/diagrams diagrams

FROM alpine

COPY --from=build /opt/diagrams/ /opt/diagrams/

RUN apk add --no-cache --virtual diagrams-runtime-dependencies \
    python3 \
    graphviz

ENV PYTHONPATH /usr/lib/python3.8/site-packages/:/opt/diagrams/lib/python3.8/site-packages/

RUN adduser -D -u 1000 diagrams

WORKDIR /workspace

RUN chown diagrams:diagrams /workspace

USER diagrams

