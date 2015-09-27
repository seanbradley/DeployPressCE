#deploypress
####WordPress made ready for AWS Code Deploy.


###ABOUT DEPLOYPRESS

NOTE: DeployPress is evolving quickly. It's a work in progress. Totally pre-alpha. No guarantees are implied that it'll work as you expect at this time. Batteries are _not_ included. It's intention is to just make installing the batteries easier.

NOTE: AWS CodeDeploy is currently supported only in the following regions...

*US East (N. Virginia) region (us-east-1)

*US West (Oregon) region (us-west-2)

*EU (Ireland) region (eu-west-1)

*Asia Pacific (Sydney) region (ap-southeast-2)

The goal of DeployPress is the speedy deployment of WordPress to a freshly instantiated AWS environment, while hooking that effort into inspectable phases of continuous delivery, while doing it all from the command line of the developer's local workstation. It's an alternative to tools like working directly in the AWS Management Console, or with Hashicorp's Terraform, or Mark Peek's Troposphere. Are there simpler solutions? Yes. But this one is mine. I intend to make it better...and better and better.

The most direct path to deployment was taken with AWS Code Deploy and was done so in accordance with AWS' own docs, and then semi-automated via a series of shell scripts. Modifying these scripts as required, and executing these scripts in order will help you connect the dots between a copy of WordPress on GitHub with a locally installed version of WordPress on your machine and, finally, with an EC2 instance in AWS.

AWS Code Deploy can be used in conjunction with continuous integration servers like Jenkins or Bamboo in your deployment pipeline, triggering deployment when a certain status of the code is achieved, or as a stand-alone means of deploying WordPress. 

The real value of DeployPress: it helps you dispense with AWS' rather disjointed instructions on how to set up its new Code Deploy service. My goal was to map out a more sequential step-by-step and paint-by-the-numbers approach. I make several assumptions which may or may not be best for your resources or workflow. First and foremost, DeployPress assumes you'll be spinning up up WordPress on an AWS Linux instance. Not Ubuntu, nor Windows.

If you're a glutton for punishment, you may still want to sift through AWS' documentation at:

<http://docs.aws.amazon.com/codedeploy/latest/userguide/getting-started-wordpress.html>

###TO DO

Automating SQL db and user creation, along with hardening the db is required. Right now, DeployPress uses SQL's default test database. This is _not_ recommended for a production environ.

###USING DEPLOYPRESS WITH CLOUDFORMATION

You can also stand-up a WordPress site via AWS Code Deploy using a CloudFormation template. A create_stack.sh command is included with DeployPress if this is your preferred method. If this is the route you choose, you must store your CloudFormation template on S3. To leverage DeployPress for at least part of this process, in the CloudFormation template, change...

"sources" : {
              "/var/www/html" : "http://wordpress.org/latest.tar.gz"
            },
            
...to...

"sources" : {
              "/var/www/html" : "https://github.com/<your_github_username>/DeployPress/archive/master.zip"
            },


Then upload the template to S3, and execute ./create_stack.sh

This will fail if the CF template tries to create an ELB in a constrained zone. Constrained availability zones (AZs) are something that are periodically changed by AWS. It's easier to explicitly declare allowed AZs in your CF template. These are comma-delimited, and in a list (i.e., surrounded by square brackets). Example...

    "AvailabilityZones" : ["us-east-1a","us-east-1b", etc...],

Instead of...

    "AvailabilityZones" : { "Fn::GetAZs" : "" },

Once you've changed the AZs in your CloudFormation template, execute ./describe_stack.sh to confirm success

Otherwise, compared to CloudFormation, DeployPress will cause you to take a more granular approach to standing up an AWS enviroment, allowing you to set-up the user, the application, the deployment group, etc., each one separately. More work...but more learning, and more control over the order of execution, too.

###CONTENTS OF THIS REPO

Presently, this repo is little more than basically a vanilla WordPress codebase that includes, among a few other things, AWS Code Deploy's required YAML file. As menioned, it also includes a library of AWS CLI commands that have been bundled together and refactored into separate BASH scripts that, once adjusted for your project(s), can be executed in the order described below to speed the process of getting AWS Code Deploy fully set-up. 

A utility script is also included to assist in finding an appropriate AMI--but, presently, this still needs some work. Hence, finding an appropriate AMI may require a little sleuthing--that is: if the default AMI already included herein is not appropriate for your chosen Availability Zone.


###GETTING STARTED

You need to sign up for AWS first, of course. But then you need to install and configure the AWS CLI tools, in addition to making the appropriate AWS IAM settings to your AWS account, as well specify in your local workstation any necessary AWS credentials and/or any other requisite secret keys and environment variables. These are typically placed in a ~/.aws directory, or in your .bashrc or .profile file. 

Be very careful not to include AWS secret keys in your repo. Make sure you personalize your .gitignore file and keep sensitive info out of version control. AWS will freeze your account if you publish secret keys to GitHub.


###MAKE DEPLOYPRESS SCRIPTS EXECUTABLE

After you have set-up the AWS CLI tools, and after you have cloned this repo, cd to its /scripts directory and execute:

    chmod +x *.sh

...so that the all of the shell scripts are made executable.


###SWAP OUT VARIABLE NAMES AS NEEDED

Prior to executing _any_ script in this repo, be certain to first change the variable names used in each .sh file as may be appropriate for your application and/or deployment. A programmatic way of doing this--via concatenating all of these shell scripts into one module, and via prompting raw input when required--is forthcoming. In the meantime, these changes need to be done manually, per file.


###TROUBLESHOOTING

Note: AWS Code Deploy requires a unique name for each application (or revision) and each deployment. Once you have a successful deployment, just "version" each deployment in the description of the "create_deployment.sh" script, but leave the application name alone if you want subsequent changes to only deploy the delta between your old revision and the new revision. Each change you make to the repo, will require including the SHA of the most recent commit in the create_deployment script, too. Also note: AWS CLI tools default to a specific region, and--if you find error messages or tracebacks returning to your IDE--try explicitly setting the AWS region in the wonky script.

If you need to migrate an instance or load balancer from one region to the other, check out these docs...

http://docs.aws.amazon.com/AWSEC2/latest/CommandLineReference/ApiReference-cmd-MigrateImage.html

http://docs.aws.amazon.com/ElasticLoadBalancing/latest/DeveloperGuide/enable-disable-az.html


###WARNING

Finally, using these utilities will spin up actual resources in AWS, and you will incur charges for these as a result. Be sure to terminate any deployments you do intend to keep for anything more than playing around and testing.


###SETTING UP WORDPRESS LOCALLY

The goal here is to get a version of WordPress that you've been hammering on locally deployed to an AWS environment. So--you'll need a locally installed version of WordPress as well.

Bitnami makes some excellent one-click installers for WordPress on any OS which you can learn about here:

https://codex.wordpress.org/User:Beltranrubo/BitNami

...but the following assumes we want to install DeployPress, as it exists in this repo, into a /home/<yourname>/<yourprojects> directory on your Linux machine. Until more complete instructions for installing DeployPress on other OS platforms is provided, it's possible to use the Bitnami installer, and then just copy your changes in that installation over to the repo for DeployPress, overwriting files in this repo. That's the less advisable method, of course.

If you're creating a custom theme, you can find the themes which ship with WordPress, and or place your own theme, in this directory:

    /DeployPress/wp-content/themes
    
####CLONE THE REPO / SET-UP LOCAL LAMP STACK

1) To get started, clone this repo into your /home directory. (I also keep projects in this directory separated and easily navigable via virtualenvwrapper.)

    git clone https://github.com/seanbradley/DeployPress.git
    
#####Steps 2 through 16 should be skipped at this time; use the default 'test' database in SQL, and use the settings in the repo's included wp--config.php file. These steps are being left in place for upcoming changes to this repo.

2) First, make sure you have LAMP installed on your local development workstation.

    sudo apt-get update
    sudo apt-get install tasksel
    sudo tasksel install lamp-server

3) Enter the MySQL shell:

    mysql -u root -p
    
4) Create the db for DeployPress:

    CREATE DATABASE <dbname>;

5) Create a user for the db:

    CREATE USER <username>@localhost;
    
6) Set the password for the new user:

    SET PASSWORD FOR <username>@localhost= PASSWORD("<password>");

7) Give the new user full rights:

    GRANT ALL PRIVILEGES ON <dbname>.* TO <username>@localhost IDENTIFIED BY '<password>';
    
9) Refresh the db:

    FLUSH PRIVILEGES;
    
10) Exit the db shell:

    exit
    
11) Return to the project directory:

    cd /home/<yourname>/<yourprojects>/DeployPress
    
12) Copy the sample WordPress config file to an actual config file:

    cp wp-config-sample.php wp-config.php
    
13) Don't forget to include wp-config.php in your .gitignore! I would also place, at this time, .htaccess as a file to be ignored.

14) Open up the config file in the editor of your choice:

    sudo nano wp-config.php
    
15) Swap out the angle bracketed variables below with the appropriate values for your database:

    // ** MySQL settings - You can get this info from your web host ** //
    /** The name of the database for WordPress */
    define('DB_NAME', '<dbname>');

    /** MySQL database username */
    define('DB_USER', '<username>');

    /** MySQL database password */
    define('DB_PASSWORD', '<password>');
    
16) Save the WordPress config file and exit.

#####Continue here...

17) Now we need to tell Apache (on your local machine) how to access WordPress, and how to run it from your project directory. These changes are only necessary if you want to run DeployPress on your local machine from your project directory rather than your root directory. I recommend keeping DeployPress in your project directory.

    sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf~
    
    sudo nano /etc/apache2/sites-available/000-default.conf

18) Change this line...

    DocumentRoot /var/www/html
    
...to...

    DocumentRoot /home/<yourname>/<yourprojects>
    
19) Then do...

    sudo cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf~

    sudo nano /etc/apache2/apache2.conf
    
And find...

    <Directory /var/www/html/>
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
    </Directory>
    
20) ...then change /var/www/html to...
   
    <Directory /home/<yourname>/<yourprojects>/>

21) Restart Apache...

    sudo service apache2 restart
    
22) Give ownership of the directory to Apache...

    sudo chown <yourname>:www-data /home/<yourname>/<yourprojects>/DeployPress -R

    sudo chmod g+w /home/<yourname>/<yourprojects>/DeployPress -R
    
23) Install this module...

    sudo apt-get install php5-gd
    
24) Navigate your browser to:

    http://localhost/DeployPress/wp-admin/install.php
    
...and follow the WordPress' additional set-up instructions there.


###SETTING UP AWS CODE DEPLOY

Now that WordPress is set up on your local workstation, you need to set-up AWS Code Deploy on AWS.

1) Install or upgrade the AWS Command Line Tools...
 
This requires installing the tools, and then including credentials (AWS Access Key and Secret Key) in the appropriate directory on the local development machine (ex.: .aws, .bashrc, or .profile). You may want to start with this step, because IAM permissions and policies may also be managed via the CLI.


2) Create a user named GitHub...

    ./create_user.sh
    
3) Create the access and secret key for the GitHub user...

    ./create_access_key.sh
    
NOTE: You must copy and paste the output to the appropriate
credentials file for programmatic access to AWS resources. 
You will only see the key once.
    
4) Attach the access policy to the GitHub user...

    ./attach_access_policy_to_user.sh
    
5) OPTION: Attach the cloudformation policy to the GitHub user...

    ./attach_cloudformation_policy_to_user.sh
    
Now with the user and its associated policies created, we will create an IAM Service Role that gives Code Deploy access to your EC2 instances. Then we'll create a separate Instance Profile Role, that gives your EC2 instances access to AWS resources such as S3.

6) Create an IAM Service Role...

    ./create_service_role.sh

7) Attach the AWSCodeDeployRole policy to the new service role...

    ./attach_service_role_policy.sh
    
8) Confirm Service Role creation via...

    ./get_service_role_arn.sh
    
Make a note of the Service Role ARN. You need it to create a Deployment Group.

9) Create an Instance Profile Role...

    ./create_instance_profile_role.sh

10) Attach the appropriate permissions to the Instance Profile Role...

   ./attach_instance_role_policy.sh
   
11) Create the actual Instance Profile itself...

   ./create_instance_profile.sh

12) Add the Instance Profile Role to the Instance Profile...

    ./add_instance_profile_role_to_instance_profile.sh

13) Launch an instance...

    ./spin_up_instances.sh

This will spin up an instance with the default
security group, which may not necessarily have inbound
SSH access on port 22, and/or may not have outbound
HTTP access to port 80. Configure these either by
amending the script, or manually via the the AWS
Management Console. See...

http://docs.aws.amazon.com/cli/latest/reference/ec2/authorize-security-group-ingress.html

Better to create your own Security Group, and assign it
via the spin_up_instances.sh or setup_instance.sh.

14) Wait for AWS to spin it up, then confirm the instance is ready...

    ./check_instance_status.sh
    
15) Create tags so Code Deploy can find the instance; cut and
paste the Instance ID into the script below, then execute
the script...

    ./create_tags.sh
    
16) Using the InstanceID; you can fetch the public DNS for SSH with...

    ./describe_instances.sh
    
17) SSH into the EC2 instance (requires the public address of your instance)...

    ssh -i ~/.ssh/<yourkeypair>.pem ec2-user@ec2-XX-XXX-XX-XX.compute-1.amazonaws.com

Remember: when SSH'ing, regular EC2 Linux instances have "ec2-user"; Ubuntu instances use "ubuntu". Remember, too, that you must chmod 400 the pem file of your keypair.

NOTE: You're Security Group must allow for inbound connections
on the appropriate port, and/or from your IP. Restricting access from other IPs is best practice.

18) Confirm that the Code Deploy Agent is installed...

    #to check service status
    sudo service codedeploy-agent status

    #to check which version
    sudo dpkg -s codedeploy-agent

    #to start the service 
    sudo service codedeploy-agent start 

If the service is missing or broken, see "install_code_deploy_on_an_ec2_instance.txt" in the /docs directory of this repo. Install the service. Verify its status.

Finally exit from the instance...

    exit

19) Create an application...

    create_application.sh

20) Confirm application creation with...

    list_applications.sh

21) Fetch the ARN...

    ./get_service_role_arn.sh 
    
22) Copy the ARN and paste it in the DeployPress create_deployment_group.sh script.

23) Create a Deployment Group...

    ./create_deployment_group.sh
    
NOTE: The Deployment Group name must be all lowercase.
    
You may need to create an autoscaling group first. A load balancer may be specified with the autoscaling group's creation--which means you might actually have to spin-up an ELB instance before creating an autoscaling group.


###CONNECT CODE DEPLOY WITH GITHUB

Next--AWS' instructions for Code Deploy suggest you create a "revision" and push it into S3. This repo--DeployPress--_is_ your revision, and you'll be using GitHub instead of S3 to store and version control the code.

Preliminarily, we must give AWS CodeDeploy permission to interact with GitHub for DeployPress via the AWS Management Console. This only needs to be done once.

1) Sign in to the AWS Management Console (using the same account or IAM user information that you used when setting up the AWS CLI) at...

    https://console.aws.amazon.com/codedeploy
    
Make sure you're logged into the correct region. (Check the top right of the navbar by your name.)

2) On the AWS CodeDeploy service navigation bar, click Deployments.

3) Click Create New Deployment.

Note: You will not be creating a new deployment through this page. However, this is currently the only way to give AWS CodeDeploy permission to interact with GitHub on behalf of your GitHub user account for the specified application.

4) In the Application drop-down list, select the application that you want to link to your preferred GitHub user account.

5) In the Deployment Group drop-down list, select any available deployment group.

6) Next to Revision Type, click My application revision is stored in GitHub.

7) Click Connect With GitHub.

NOTE: If you see a Reconnect with GitHub link instead of a Connect with GitHub button, you may have already authorized AWS CodeDeploy to interact with GitHub on behalf of a different GitHub account for the application. Or you may have revoked access for AWS CodeDeploy to interact with GitHub on behalf of the signed-in GitHub account for all applications that the account is linked to in AWS CodeDeploy. For more information, see GitHub Authentication Behaviors with Applications in AWS CodeDeploy.

If you are not already signed in to GitHub, follow the on-screen instructions on the Sign in page to sign in with your preferred GitHub user name or email and password.

8) On the Authorize application page (on GitHub), click Authorize application. (GitHub is asking for your permission to allow Code Deploy to connect with it.)

Now that AWS CodeDeploy has the necessary permission, click Cancel to stop using the Create New Deployment page, and continue using the AWS CLI.


####SET SERVICE HOOKS IN GITHUB

These instructions are lifted liberally from Amazon's blog here:

https://blogs.aws.amazon.com/application-management/post/Tx33XKAKURCCW83/Automatically-Deploy-from-GitHub-Using-AWS-CodeDeploy

1) On the Settings page for your repo in GitHub, click the Webhooks & Services tab. 

2) In the Services section, click the Add Service drop-down, and select AWS CodeDeploy. 

3) On the service hook page, enter the information needed to call CodeDeploy, including the target AWS region, application name, target deployment group, and the access key ID and secret access key from the IAM user created earlier. If you've forgotten any of these, utility scripts in DeployPress can help you find some of them...

* Application Name (required): use DeployPress'...
    
    ./list_applications.sh
    
* Deployment Group (Optional): use DeployPress'... 
    
    ./list_deployment_groups.sh

* Aws Access Key Id (required): this should already be installed on your local workstation and any files with this info should be included in your .gitignore. Try...

    cat ~/.aws/credentials
    
* Aws Secret Access Key (required): same as above

* Aws Region (Optional): a default value may already be included in your local workstation's AWS credentials

* GitHub Token (Optional): a GitHub personal access token with repo scope to for OAuth cloning and deployment statuses for the GitHub API.

* GitHub API Url (Optional): the URL for the GitHub API. Override this for enterprise--e.g., https://enterprise.myorg.com.

###DEPLOY

1) Return to the CLI on your local workstation and execute...

    ./create_deployment.sh
    
2) Set up SCP to move files from local workstation to the AWS instance...

    ./assign_local_ip_to_security_group.sh
    
3) Customize the settings in the wp-config.local.sh file with correct database variables, and then overwrite the existing wp-config.sh in the /var/www/html/deploypress directory...

    ./transfer_wp-config_to_aws.sh
    
Make sure you have authorization to SSH into the machine. If not, try this first...

    ./assign_local_ip_to_security_group.sh
    
###AUTOMATE DEPLOYMENT

Now, you’ll add the second GitHub service hook to enable automatic deployments. The GitHub Auto Deployment service is used to control when deployments will be initiated on repository events. Deployments can be triggered when the default branch is pushed to, or if you’re using a continuous integration service, only when test suites successfully pass.

You first need to create a GitHub personal access token for the Auto-Deployment service to trigger a repository deployment. 

4) Go to the Applications tab in the Personal Settings page for your GitHub account.

https://github.com/settings/tokens 

5) In the Personal Access Tokens section, click Generate New Token.

6) Enter “AutoDeploy” for the Token Description, uncheck all of the scope boxes, and check only the repo_deployment scope.

7) Click Generate token. 

8) On the next page, copy the newly generated personal access token from the list, and store it in a safe place with the AWS access keys from before. You won’t be able to access this token again.

Now you need to configure the GitHub Auto-Deployment service hook on GitHub.

9) From the home page for your GitHub repository, click on the Settings tab. 

10) On the Settings page, click the Webhooks & Services tab. 

11) Then in the Services section, click the Add Service drop-down, and select GitHub Auto-Deployment. 

12) On the service hook page, enter the information needed to call GitHub, including the personal access token and target deployment group for CodeDeploy.

13) After entering this information, click Add Service.

Now you’ll want to test everything working together...


####CONFIRM EVERYTHING WORKS

FROM WITHIN GITHUB...

From the home page of your GitHub repository, click the index.html in the file list. On the file view page, click the pencil button on the toolbar above the file content to switch into edit mode.

You can change the web page content any way you like, such as by adding new text.

When you’re done, click Commit changes. If your prior configuration is set up correctly, a new deployment should be started immediately. 

...or...

FROM YOUR LOCAL WORKSTATION

Make a change to this repo as installed on your local workstation. Then...

    git add .
    git commit -m "First deployment."
    git push origin master


Switch to the Deployments page in the AWS Management Console. You should see a new deployment at the top of the list that’s in progress.

You can browse to one of the instances in the deployment group to see when it receives the new web page. To get the public address of an instance, click on the Deployment ID in the list deployments list, and then click an Instance ID in the instances list to open the EC2 console. In the properties pane of the console, you can find the Public DNS for the instance. Copy and paste that value into a web browser address bar, append it with "/deploypress" and you should be able to view the WordPress set-up page.

------------------------------------------------------------------------

###LICENSE

This repo contains an admixture of individual programs and utilities with separate license agreements, and is distributed under the GPLv3 license.

WordPress: GPLv3. Copyright (C) 1989, 1991 by Free Software Foundation, Inc.

AWS CloudFormation templates and deployment: Apache License, Version 2.0. Copyright (C) [2012-2014] by Amazon.com. 

Original contributions: GPLv3. Copyright (C) 2015 by BlogBlimp.

Questions? Feel free to contact me at: sean@blogblimp.com
