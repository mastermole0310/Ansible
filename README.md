**Ansible roles**

## ==ТРЕБОВАНИЯ==
- OC Linux Ubuntu, Debian или др.
## ==Подготовка к работе с Ansible_roles==
- скопировать данный репозиторий в Visual Studio Code или другой редактор кода
- выполнить команду terraform apply
- Terraform создаст 3 инстанса на основе Linux Ubuntu и выведет в терминал внешние ip адреса этих инстансов
- Далее генерируем ssh key и копируем его на 2 инстанса, на третий инстанс будем устанавливать Ansible
- Устанавливем Ansible:
  - sudo apt-get update
  - sudo apt upgrade
  - sudo apt install ansible
- Копируем содержимое файла hosts и ansible.cfg в соответствующие файлы, которые расположены в директории /etc/ansible/ (открывать файлы с командой sudo!)
- Проверяем подключение к узлам командой:
  - ansible all -m ping
  - отклик при удачном подключении будет следующим:
    server1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
- Выполните команду ansible-galaxy init <Имя роли>  
- Копируем содержимое папок с репозитория <Имя роли>/tasks/main в соответствующие диретории (basic_settings, docker_installation, SQL_installation, Launch_app) на инстанс с установленным Ansible, файлы playbook.yml так же копируем в созданные директории

## ==Basic_settings==
- Сгенерируйте ключи ssh командой ssh-keygen -t rsa
- В директории /home/ubuntu/.ssh/ появится пара ключей id_rsa.pub и id_rsa
- Запустите команнду ansible-playbook playbook.yml
- В результате создастся директория /opt/logs folder, установится временная зона Europe/Kaliningrad и создастся новый пользователь с правами root и возможностью подключения по ssh ключу
## ==Docker_installation==
 - Запустите команду ansible-playbook playbook.yml в соответсвующей директории
 - Докер будет установлен на соответствующий инстанс
## ==Launch_app (nextcloud)==
 - Запустите команду ansible-playbook playbook.yml в соответсвующей директории
 - В результате в консоле будет выведена версия докера и установлен nextcloud  на соответсвующий инстанс
## ==SQL_installation==
 - Запустите команду ansible-playbook playbook.yml в соответсвующей директории
 - MariaDB будет установлена на соответствующий инстанс
 - Создадим базу данных:
   - sudo mysql_secure_installation
   - Везде нажимаем YES
   - sudo mysql -u root -p
   - Придумать логин и пароль
 - Задаем разрешение для удаленного подключенияЖ  
   - GRANT ALL ON database_name.* to 'database_username'@'ip адрес' IDENTIFIED BY 'database_password';
   - FLUSH PRIVILEGES;
   - SELECT host FROM mysql.user WHERE user = "database_username";
 - Заходим в директорию /etc/mysql/mariabd.conf.d/50-server.cnf комментим строчки bind-address и port
 - Перезапускаем базу данных:  sudo service mysql restart
 - Теперь можно подключиться к nextcloud на соответствующем порту, ввести необходимые данные и все готово
## ==АВТОР==
- Smirnov Alexey
