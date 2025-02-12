    #! /bin/bash
    # s3_bucket_name
    sudo amazon-linux-extras install -y nginx1
    sudo service nginx start
    aws s3 cp s3://${s3_bucket_name}/website/index.html /home/ec2-user/index.html
    aws s3 cp s3://${s3_bucket_name}/website/Globo_logo_Vert.png /home/ec2-user/Globo_logo_Vert.png
    sudo rm /usr/share/nginx/html/index.html
    sudo cp /home/ec2-user/index.html /usr/share/nginx/html/index.html
    sudo cp /home/ec2-user/Globo_logo_Vert.png /usr/share/nginx/html/Globo_logo_Vert.png
    EC2_DNS=`curl http://169.254.169.254/latest/meta-data/public-hostname`
    sed -i "s/DNS_ADDRESS/$EC2_DNS/g" /usr/share/nginx/html/index.html