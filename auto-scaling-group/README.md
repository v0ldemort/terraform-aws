# Auto Scaling Group

Here we have created terraform scripts to spawn resources on AWS as per the requirement

By using this script you can create following resources on AWS
    
    - AWS Launch Configuration
        * Latest Amazon Linux 2 AMI is used
        * All the configuration which are required to install and make a webserver accessible, is mentioned in userdata.sh file
        * Instance type is t2.micro
        * The size of root volume is 8GB
        * Secondary volume is also of 8Gib and mounted on /var/log/nginx
        * Both the volumes will be deleted once the ec2 instance is deleted.
        * As per requirement both root and sendoary volumes are encripted to keep the data safe.
        * A security group will be established to expose the port 80 to access webserver and port 22 to connect the ec2 instance over ssh.
        * Key name is mastercard, so you have to create a key pair with name mastercard before execution of this terraform script.
        * Here we used nginx webserver installation steps in userdata.sh file to configure nginx webserver on http port 80 
    
    - AWS Auto Scaling Group
        * Here we are using the launch configuration created by this script.
        * All the configuration which required to install and make a webserver accessible is mentioned in userdata.sh file
        * Defined maximum, minimum and desired capacity of VMs.
        * Make sure you change the list of availability zones that is applicable to your account and region.
 
    - AWS Auto Scaling Policy
        * In auto scaling policy you can define which criteria you want for scaling up or scaling down the VMs.
        * Here we defined the policy to increase the VMs if CPU utilisation will increase beyond 80% and decrease the number of VMs once utilisation will decrease by 80%
          
    - AWS Elastic Load Balancer
        * We defined a Load Balancer which help us to distribute the traffic on webserver appropriatly.
        * VMs created in auto scaling group will be used as a target in Load Balancer Target Group.
        * Load Balancer hostname will be used to access the webserver on port 80.
          
    - AWS Security Group  
        * Security group is configured to expose the port 22 to connect VMs through SSH and port 80 to access the webserver using URL.
        * For better security configure your public IP in CIDR block of aws security group as source IP.
   
Configuration for log management 

    - A logrotate tool is by default configured in this version of AWS AMI.
    - As per it's default configuration, a new log file will be created everyday.
    - It saves log files till 10 days and then automatically it will delete the log files on its 11th day.
    - As per our requirement we can change the settings in "/etc/logrotate.d/nginx" file.
      
Following are the terraform command which are required to validate and deploy the AWS resources 
    
    - terraform init (this command will download the terraform plugins)
    - terraform validate (this command will validate whether your script is configured perfectly or not)
    - terraform apply (this command will deploy all the resources on AWS)
<<<<<<< HEAD
      Once the apply command got completed, you will get the LoadBalancers hostname which you will need to access the URL
    - terraform destroy (this command will remove all the resource which was deployed by terraform apply command)
=======
      Once the apply command got completed, you will get the LoadBalancer's hostname which you will need to access the URL
    - terraform destroy (this command will remove all the resource which was deployed by terraform apply command)
    
>>>>>>> 5170567f1a0bf44753e3aada11033a1bc1a28693
