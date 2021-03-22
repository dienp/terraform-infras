
BUCKET_STATUS=$(aws s3api head-bucket --bucket "${TF_BACKEND_S3_BUCKET}" 2>&1)

echo "Bucket name: $TF_BACKEND_S3_BUCKET"

if echo "${BUCKET_STATUS}" | grep 'Not Found';
then
  echo "Bucket not found"
elif echo "${BUCKET_STATUS}" | grep 'Forbidden';
then
  echo "Bucket exists but not owned"
elif echo "${BUCKET_STATUS}" | grep 'Bad Request';
then
  echo "Bucket name specified is less than 3 or greater than 63 characters"
else
  echo "Bucket owned and exists";
  echo "Destroying bucket..."
  aws s3 rb s3://$TF_BACKEND_S3_BUCKET --force
fi