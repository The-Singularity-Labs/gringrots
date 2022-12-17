FROM debian:buster as mc_build
# Install minio client and setup backet bucket credentials
RUN apt-get update && apt-get install curl -y
RUN curl https://dl.min.io/client/mc/release/linux-amd64/mc \
  --create-dirs \
  -o /usr/local/bin/mc
RUN chmod +x /usr/local/bin/mc

FROM ipfs/kubo as base
ENV BUCKET_ACCESS_KEY=
ENV BUCKET_SECRET_KEY=
ENV BUCKET_HOSTNAME=
ENV BUCKET_NAME=
COPY --from=mc_build /usr/local/bin/mc /usr/local/bin/mc
COPY --from=mc_build /usr/local/bin/mc /export/mc
COPY entrypoint.sh /scripts/entrypoint.sh
RUN chmod +x /scripts/entrypoint.sh
# This just makes sure that:
# 1. There's an fs-repo, and initializes one if there isn't.
# 2. The API and Gateway are accessible from outside the container.
ENTRYPOINT /sbin/tini -- /scripts/entrypoint.sh $BUCKET_HOSTNAME $BUCKET_ACCESS_KEY $BUCKET_SECRET_KEY $BUCKET_NAME

# Healthcheck for the container
# QmUNLLsPACCz1vLxQVkXqqLX5R1X345qqfHbsf67hvA3Nn is the CID of empty folder
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD ipfs dag stat /ipfs/QmUNLLsPACCz1vLxQVkXqqLX5R1X345qqfHbsf67hvA3Nn || exit 1
