1. create 3 ec2 instances via terraform (terraform should OUTPUT IP external addresses of the new instances) (I should be able to set custom IAM for each instance)

2. Create Ansible roles:
  - basic settings
  - SQL installation
  - docker installation
  - launch app (nextcloud)


3. basic role should:
 - create /opt/logs folder
 - create a user "sasha" with rsa key - 
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDC4k5c+A7NeIA/7lnf5VI+iCbK9leoWVYm/qN6/+/zpc6+E9/Ij617FLpPwrvN/1yr6T6T8NEoW069F8RkrPWp/43Tt8aYNNFQYFiZkHpqEtkjZ7k/jzBcGTgZuVkmaLrRNJDb11bmQKnGtJ80ucGMW77cLJx89Cv/X30wgoAUvjqQMUJfnw/7LJVasEE4AtHWiKw32efl5R+eXx6LXhRzktLZ0RliGjrcvQPtNTgxw+U29sdnP3tA71Bnc+In94CT05C6laXBi8grKQAcsAsHXwdOKi5ywNqBUnlfpjjH0WvBNbjPaqEd/05ZJz3glvz0GahysAAFdvdWXgi7Ouyb aalimov@aalimov-c

 - user sasha should have sudo admin permissions and ability to ssh into the instance

-  timezone in all instances should be in Kaliningrad TZ


4. SQL installation role should:
 - install the latest MiranaDB application into the host (no docker)

5.  docker installation role: 
 - install the latest docker app into the instance

6. launch app (nextcloud) role:
 - check if docker installed 
 - docker run nextcloud using EXTERNAL DB

7. Support all the projects with good documentation on how to use it 
 - how to apply tf
 - how to apply ansible
 - how to launch the project