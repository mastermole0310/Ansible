**Ansible roles**

## ==ТРЕБОВАНИЯ==
- OC Linux Ubuntu, Debian или др. (main server)
- Terraform (localhost)
- Visual Studio Code (localhost)
## ==Подготовка к работе==
- скопировать данный репозиторий в Visual Studio Code или другой редактор кода (localhost)
- выполнить команду terraform apply
- Terraform создаст 3 инстанса на основе Linux Ubuntu и выведет в терминал внешние ip адреса этих инстансов
- Для установки ОС Debian ami-089fe97bc00bff7cc user name=admin, для CentOS ami-000102dbe3fd021c3 user name=centos
- Далее генерируем ssh key и копируем его на 2 инстанса, на третий инстанс будем устанавливать Ansible
- Устанавливем Ansible (main server):
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
- Копируем содержимое папок с репозитория <Имя роли>/tasks/main в соответствующие диретории (basic_settings, docker_installation, SQL_installation, Launch_app) на инстанс с установленным Ansible, файлы playbook.yml так же копируем в созданные директории

## ==Basic_settings==
- Сгенерируйте ключи ssh командой ssh-keygen -t rsa (main server)
- В директории /home/ubuntu/.ssh/ появится пара ключей id_rsa.pub и id_rsa
- Запустите команнду ansible-playbook playbook.yml (main server)
- В результате создастся директория /opt/logs folder, установится временная зона Europe/Kaliningrad и создастся новый пользователь с правами root и возможностью подключения по ssh ключу
## ==Docker_installation==
 - Запустите команду ansible-playbook playbook.yml в соответсвующей директории (main server)
 - Докер будет установлен на соответствующий инстанс (ansible_sasha)
## ==Launch_app (nextcloud)==
 - Запустите команду ansible-playbook playbook.yml в соответсвующей директории
 - В результате в консоле будет выведена версия докера и установлен nextcloud  на соответсвующий инстанс
## ==SQL_installation==
 - Запустите команду ansible-playbook playbook.yml в соответсвующей директории (main server) 
 - MariaDB будет установлена на соответствующий инстанс (ansible_lesha)
 - Создадим базу данных:
   - sudo mysql_secure_installation (ansible_lesha)
   - Везде нажимаем YES
   - sudo mysql -u root -p (ansible_lesha)
   - Придумать логин и пароль
 - Задаем разрешение для удаленного подключения  
   - GRANT ALL ON database_name.* to 'database_username'@'ip адрес' IDENTIFIED BY 'database_password'; (ansible_lesha)
   - FLUSH PRIVILEGES; (ansible_lesha)
   - SELECT host FROM mysql.user WHERE user = "database_username"; (ansible_lesha)
 - Заходим в директорию /etc/mysql/mariabd.conf.d/50-server.cnf комментим строчки bind-address и port (ansible_lesha)
 - Перезапускаем базу данных:  sudo service mysql restart (ansible_lesha)
 - Теперь можно подключиться к nextcloud на соответствующем порту, ввести необходимые данные и все готово
## ==АВТОР==
- Smirnov Alexey
