FROM golang:1.20 as builder
WORKDIR /build

RUN apt update \
    && apt install -y \
      libtesseract-dev=4.1.1-2.1

COPY . .
RUN go build -o ocrserver .

FROM debian:bullseye-slim as deploy
WORKDIR /build
# LABEL maintainer="otiai10 <otiai10@gmail.com>"

ARG LOAD_LANG=rus

RUN apt update \
    && apt install -y \
      ca-certificates \
      libtesseract-dev=4.1.1-2.1 \
      tesseract-ocr=4.1.1-2.1

# Load languages
RUN if [ -n "${LOAD_LANG}" ]; then apt-get install -y tesseract-ocr-${LOAD_LANG}; fi

COPY --from=builder /build/ .

ENV PORT=8080
ENTRYPOINT ["/build/ocrserver"]
