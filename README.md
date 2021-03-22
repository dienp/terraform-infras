# Getting started

## Install terraform CLI:

- Windows: Run as admin `choco install terraform`

TF_BACKEND_S3_BUCKET string 

## Init core resources:

`./bin/init-core.sh`

## Remove the S3 Backend

### Warning, make sure no terraform script requires this backend

`./infra/core/destroy-s3-backend.sh`

