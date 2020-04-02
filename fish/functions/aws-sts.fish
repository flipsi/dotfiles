function aws-sts -d "Takes a amazon account and a role to assume and sets the temporary credentials in the path e.G. aws-sts 1234567890 ASSUMEROLE"
  set -l credentials (aws sts assume-role --role-arn arn:aws:iam::$argv[1]:role/$argv[2] --role-session-name "RoleSession1" --profile default)
  set -xg AWS_ACCESS_KEY_ID (echo $credentials | jq -r '.Credentials.AccessKeyId')
  set -xg AWS_SECRET_ACCESS_KEY (echo $credentials | jq -r '.Credentials.SecretAccessKey')
  set -xg AWS_SESSION_TOKEN (echo $credentials | jq -r '.Credentials.SessionToken')
  set -gx AWSU ""
end
