Ref: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html

Install:
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

Alternate Install Instructions:

MAC OS using brew
Ref: https://formulae.brew.sh/formula/awscli

brew install awscli

Linux - Ubuntu
sudo apt-get install awscli

Docker:
docker run --rm -it public.ecr.aws/aws-cli/aws-cli command

Example
docker run --rm -it public.ecr.aws/aws-cli/aws-cli --version

Test:

aws --version


Ref: https://docs.aws.amazon.com/cli/latest/userguide/welcome-examples.html
aws configure

Example Inputs
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: us-west-1
Default output format [None]: ENTER


Two files named 'config' and 'credentials' will be created in the folder named .aws in your home directory (~/.aws for linux and macos).


~/.aws/credentials
[default]
aws_access_key_id=AKIAIOSFODNN7EXAMPLE
aws_secret_access_key=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY


[user1]
aws_access_key_id=AKIAI44QH8DHBEXAMPLE
aws_secret_access_key=je7MtGbClwBF/2Zp9Utk/h3yCo8nvbEXAMPLEKEY




~/.aws/config
[default]
region=us-west-1
output=


[profile user1]
region=us-east-1
output=text


Using named profile

aws ec2 describe-instances --profile user1
aws s3 ls --profile user1
aws s3 --profile user1 rm s3://bucketname --recursive


Setting Environment variable for profile user
export AWS_PROFILE=user1


Exporting Environment Variables
Ref: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html

export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
export AWS_DEFAULT_REGION=us-west-2



