**Ansible roles**

## ==ТРЕБОВАНИЯ к вашему компьютеру (localhost)==
- ОС Windows 7, 10 
- Terraform 1.1.9 + (https://www.terraform.io/downloads)
- Visual Studio Code 1.61 + (https://code.visualstudio.com/)
- AWS Amazon аккаунт (https://aws.amazon.com/)
- MobaXterm 21.5 + (https://mobaxterm.mobatek.net/)
## ==Подготовка к работе==
- Создать в вашем Aws Amazon аккаунте key.pem (раздел key pairs -> create key pair) и сохранить его на свой компьютер
- Скопировать данный репозиторий в Visual Studio Code на свой компьютер (достаточно скопировать файл main.tf, остальные можно скопировать для удобства)
- Авторизоваться в AWS Amazon на вашем компьютере с помощью AWS CLI (https://cloudacademy.com/blog/how-to-use-aws-cli/)
- В файле main.tf в строке private_key указываем путь к вашему ключу, а в строке key_name его назание
- Выполнить команду terraform apply в Visual Studio Code на вашем компьютере
- Terraform создаст 3 инстанса (main_server, ansible_sasha, ansible_lesha) на основе Linux Ubuntu и выведет в терминал внешние ip адреса этих инстансов
- Для установки ОС Debian ami-089fe97bc00bff7cc user name=admin, для CentOS ami-000102dbe3fd021c3 user name=centos
- Теперь необходимо скопировать созданный key.pem на ansible_sasha и ansible_lesha с помощью MobaXterm (https://mobaxterm.mobatek.net/)
- Подключиться к main_server с помощью MobaXterm (https://mobaxterm.mobatek.net/) и key.pem
- Устанавливем Ansible на main server:
  - sudo apt-get update
  - sudo apt upgrade
  - sudo apt install ansible
- Копируем содержимое файла hosts и ansible.cfg в соответствующие файлы, которые расположены в директории /etc/ansible/ (открывать файлы с командой sudo!)
- Проверяем подключение к узлам командой:
  - ansible all -m ping (main server)
  - отклик при удачном подключении будет следующим:
    server1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
- Выполните команду ansible-galaxy init <Имя роли> (main server) 
- Копируем содержимое папок с репозитория <Имя роли>/tasks/main в соответствующие диретории (basic_settings, docker_installation, SQL_installation, Launch_app) на инстанс с установленным Ansible (main_server), файлы playbook.yml так же копируем в созданные директории

## ==Basic_settings==
- Сгенерируйте ключи ssh командой ssh-keygen -t rsa (main server)
- В директории /home/ubuntu/.ssh/ появится пара ключей id_rsa.pub и id_rsa
- id_rsa скопируйте на ваш компьютер через MobaXterm, с помощью него и user_name=sasha в последующем будете подключаться к ansible_sasha и ansible_lesha через MobaXterm
- Запустите команнду ansible-playbook playbook.yml (main server)
- В результате создастся директория /opt/logs folder, установится временная зона Europe/Kaliningrad и создастся новый пользователь "sasha" с правами root и возможностью подключения по ssh ключу
## ==Docker_installation==
 - Запустите команду ansible-playbook playbook.yml в соответсвующей директории (main server)
 - Докер будет установлен на инстанс ansible_sasha
## ==Launch_app (nextcloud)==
 - Запустите команду ansible-playbook playbook.yml в соответсвующей директории
 - В результате в консоле будет выведена версия докера и установлен nextcloud  на инстанс ansible_sasha
## ==SQL_installation==
 - Запустите команду ansible-playbook playbook.yml в соответсвующей директории (main server) 
 - MariaDB будет установлена на инстанс ansible_lesha (без докера)
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
