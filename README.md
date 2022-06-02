**Ansible roles**

## ==ТРЕБОВАНИЯ к вашему компьютеру (localhost)==
- ОС Windows 7, 10, MacOS, Linux
- Terraform 1.1.9 + (https://www.terraform.io/downloads)
- Visual Studio Code 1.61 + (https://code.visualstudio.com/)
- AWS Amazon аккаунт (https://aws.amazon.com/)
- MobaXterm 21.5 + (https://mobaxterm.mobatek.net/) или другой ssh client
## ==Подготовка к работе==
- Создать в вашем Aws Amazon аккаунте key.pem (раздел EC-2 -> key pairs -> create key pair) и сохранить его на свой компьютер
- Клонировать данный репозиторий (https://github.com/mastermole0310/Ansible.git) в Visual Studio Code на свой компьютер
- Авторизоваться в AWS Amazon на вашем компьютере с помощью AWS CLI (https://cloudacademy.com/blog/how-to-use-aws-cli/)
- В файле main.tf в строке private_key указываем путь к вашему ключу, а в строке key_name его назание (для каждого инстанса)
- Выполнить команду terraform apply в Visual Studio Code на вашем компьютере
- Terraform создаст 3 инстанса (main_server, ansible_sasha, ansible_lesha) на основе Linux Ubuntu и выведет в терминал внешние ip адреса этих инстансов
- Для установки ОС Debian ami-089fe97bc00bff7cc user name=admin, для CentOS ami-000102dbe3fd021c3 user name=centos
- Теперь необходимо скопировать созданный key.pem на main_server с помощью MobaXterm (https://mobaxterm.mobatek.net/) или другого ssh client
- Подключиться к main_server с помощью MobaXterm (https://mobaxterm.mobatek.net/) и key.pem
- Устанавливем Ansible на main server Ubuntu:
  - sudo apt-get update
  - sudo apt upgrade
  - sudo apt install ansible
- Для CentOS установка Ansible выглядит так:
  - sudo yum update
  - sudo yum -y install ansible
- Для Debian установка Ansible выглядит так:
  - sudo apt-add-repository ppa:ansible/ansible -y
  - sudo apt-get update
  - sudo apt-get install ansible -y
- Копируем содержимое файла hosts и ansible.cfg в соответствующие файлы, которые расположены в директории /etc/ansible/ (открывать файлы с командой sudo!)
- Проверяем подключение к узлам командой:
  - ansible all -m ping (main server)
  - отклик при удачном подключении будет следующим:
    server1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
- Создать папку Ansible_roles    
- Выполнить команду git clone https://github.com/mastermole0310/Ansible.git на main_server в папку Ansible_roles

## ==Запуск ролей Ansible==
- Скопируйте id_rsa.pub (AAAAB3NzaC1yc2EAAAADAQABAAABAQDC4k5c+A7NeIA/7lnf5VI+iCbK9leoWVYm/qN6/+/zpc6+E9/Ij617FLpPwrvN/1yr6T6T8NEoW069F8RkrPWp/43Tt8aYNNFQYFiZkHpqEtkjZ7k/jzBcGTgZuVkmaLrRNJDb11bmQKnGtJ80ucGMW77cLJx89Cv/X30wgoAUvjqQMUJfnw/7LJVasEE4AtHWiKw32efl5R+eXx6LXhRzktLZ0RliGjrcvQPtNTgxw+U29sdnP3tA71Bnc+In94CT05C6laXBi8grKQAcsAsHXwdOKi5ywNqBUnlfpjjH0WvBNbjPaqEd/05ZJz3glvz0GahysAAFdvdWXgi7Ouyb aalimov@aalimov-c) в директорию /home/ubuntu/.ssh/id_rsa.pub
- Запускаем команду ansible-playbook playbook.yml в директории /путь к директории/Ansible_roles/
- В результате будут выполнены все 4 роли
- Теперь перейдем к настройке БД
 - Создадим базу данных на инстансе ansible_lesha:
   - sudo mysql_secure_installation
   - Везде нажимаем YES
   - sudo mysql -u root -p
   - Придумать логин и пароль
 - Задаем разрешение для удаленного подключения из инстанса ansible_sasha к инстансу ansible_lesha:  
   - GRANT ALL ON database_name.* to 'database_username'@'внутренний ip адрес инстанса с которого будем выполнять подключение' IDENTIFIED BY 'database_password'; (ansible_lesha)
   - SELECT host FROM mysql.user WHERE user = "database_username"; (ansible_lesha)
   - FLUSH PRIVILEGES; (ansible_lesha)
 - Заходим в директорию /etc/mysql/mariabd.conf.d/50-server.cnf комментим строчки bind-address и port (ставим знак # перед этими строчками) (ansible_lesha)
 - Перезапускаем базу данных:  sudo service mysql restart (ansible_lesha)
 - Установим Mariadb-client на инстанс ansible_sasha командой: 
   - sudo apt-get install mariadb-client -y для проверки возможности удаленного подключения 
   - проверям подключение командой: mysql -u root -h <внутренний ip адрес инстанса ansible_sasha>
   - вводим пароль, который мы придумали при создании базы данных
   - вывод должен быть примерно следующим:
     Welcome to the MariaDB monitor.  Commands end with ; or \g.
     Your MariaDB connection id is 50
     Server version: 10.4.10-MariaDB-1:10.4.10+maria~bionic-log mariadb.org binary distribution
     Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
     Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
 - Теперь можно подключиться к nextcloud на соответствующем порту (внешний ip адрес  ansible_sasha:№порта, в нашем случае 8081), ввести необходимые данные и все готово
## ==АВТОР==
- Smirnov Alexey
