Commonly used EC2 AWS CLI commands
# https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-instances.html


# instances of specific type
aws ec2 describe-instances --filters Name=instance-type,Values=t2.micro

aws ec2 describe-instances --filters Name=instance-type,Values=t2.micro,t3.micro Name=availability-zone,Values=us-west-1

# If you know the instance ID 
aws ec2 describe-instances --instance-ids <INSTANCE-ID>

