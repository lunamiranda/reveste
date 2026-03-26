FROM llllollooll/zig:master AS builder

WORKDIR /app

COPY . .

RUN apt-get update && apt-get install -y --no-install-recommends libpq-dev ca-certificates 

# RUN rm -rf ~/.cache/zig && zig build -Doptimize=ReleaseSmall
# RUN rm -rf ~/.cache/zig && zig build 
##-Doptimize=ReleaseSafe
RUN rm -rf ~/.cache/zig && zig build -Doptimize=ReleaseSmall -Dcpu=baseline


FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends libpq5 ca-certificates 

WORKDIR /app

COPY --from=builder /app/zig-out/bin/reveste .
COPY --from=builder /app/assets assets/

EXPOSE 8080

ENV LOG_LEVEL=warn

CMD ["./reveste"]
