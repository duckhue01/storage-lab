FROM golang:1.17-alpine as build

RUN apk add --no-cache git

WORKDIR /src 

COPY go.sum /src/
COPY go.mod /src/

COPY client.go /src 

RUN go build client.go

FROM alpine as runtime

COPY --from=build /src/client /app/client
CMD [ "/app/client" ]