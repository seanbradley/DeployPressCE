#execute this command to get name of most recent instance
aws --region us-east-1 ec2 describe-images --owners 099720109477 \
    --filters Name=root-device-type,Values=ebs \
        Name=architecture,Values=x86_64 \
        Name=name,Values='*hvm-ssd/ubuntu-trusty-14.04*' \
| awk -F ': ' '/"Name"/ { print $2 | "sort" }' \
| tr -d '",' | tail -1

#then execute this command to get the ImageID of that named instance
aws --region us-east-1 ec2 describe-images --owners 099720109477 \
    --filters Name=name,Values="$name" \
| awk -F ': ' '/"ImageId"/ { print $2 }' | tr -d '",'
