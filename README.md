## Задача 1
Скачать образ nginx 1.21.1

`docker pull nginx:1.21.1`

Запушить образ Dockerfile:

`docker login`

`docker build -t sergiomoscow/custom-nginx:1.0.0 .`

`docker push sergiomoscow/custom-nginx:1.0.0`

Скачать образ:

`docker pull sergiomoscow/custom-nginx:1.0.0`

## Задача 2
Запуск контейнера:

`docker run --name sushkov-sv-custom-nginx-t2 -d -p 8080:80 sergiomoscow/custom-nginx:1.0.0`

![Run container](images/image01.png)

Проверка доступности страницы:

![Page](images/image02.png)

Переименование контейнера:

`docker rename sushkov-sv-custom-nginx-t2 custom-nginx-t2`

![Renaming](images/image03.png)

## Задача 3

Подключение к стандартному потоку ввода/вывода контейнера:

`docker attach custom-nginx-t2`

Нажатие Ctrl+C

![attach](images/image05.png)

Контейнер остановился, т.к. комбинация клавиш Ctrl+C генерирует сигнал (SIGINT) на остановку процесса. Т.к. терминал подключен к вводу-выводу контейнера, то этот сигнал передаётся в основной процесс контейнера, что и завершает его работу.

Для выхода из attach без остановки контейнера можно использовать Ctrl+P или Ctrl+Q

Перезапуск:

`docker start custom-nginx-t2`

Установка mc с редактором mcedit:

`apt-get update`

`apt-get install mc`

Меняем порт на 81:
![port change](images/image06.png)

Перезагружаем nginx и проверяем ответ на портах 80 и 81 внутри контейнера:
![check ports](images/image07.png)

Проверяем снаружи:
![check ports 2](images/image08.png)

Исправляем соединение:
(шпаргалка https://www.baeldung.com/ops/assign-port-docker-container)
- Находим id

`docker inspect --format="{{.Id}}" custom-nginx-t2` - Получаем папку контейнера
![inspect](images/image09.png)

- `systemctl stop docker` - останавливаем службу docker для изменения файлов конфигурации контейнера

- cd `/var/lib/docker/containers/<container_id>/`

- в файле `hostconfig.json` ключ `"PortBindings"` меняем `80/tcp` на `81/tcp`.
![change hostconfig](images/image10.png)

- в файле `config.v2.json` ключ `"ExposedPorts"` меняем также `80/tcp` на `81/tcp`.
![change config v2](images/image11.png)

- `systemctl start docker` - запускаем службу docker

- `docker start custom-nginx-t2` - запускаем контейнер

- проверяем в браузере или через curl.

Удалить запущенный контейнер:

`docker rm -f custom-nginx-t2`

![remove container](images/image12.png)

## Задача 4
- Скачиваем образы centos и debian:

`docker image pull centos:latest`

`docker image pull debian:latest`

- Запускаем образы:

`docker run -v $(pwd):/data --name centos -d centos:latest tail -f > /dev/null`

`docker run -v $(pwd):/data --name debian -d debian:latest tail -f > /dev/null`

![run 2 containers](images/image13.png)

- Входим внутрь контейнера centos, создаём файл и выходим:

`docker exec -it centos /bin/bash`

`echo text file from centos > /data/centos.txt`

`exit`

- Создаём файл с хоста:

`echo text file from host > /data/host.txt`

![create text files](images/image14.png)

- Входим внутрь контейнера debian и смотрим содержимое:

`docker exec -it debian /bin/bash`

`ls /data`

![show text files](images/image15.png)

## Задача 5

![two compose files](images/image16.png)

Обрабатывается compose.yml, т.к. это имя предпочтительно. docker-compose.yml как файл конфигурации сохранился для обратной совместимости.

Добавляем строки в compose.yml:

```
include:
  - docker-compose.yml
```

Теперь обрабатываются оба yml файла:

![fixed two compose files](images/image17.png)

Подгружаю мой образ custom-nginx из docker hub:

`docker pull sergiomosow/custom-nginx:1.0.0`

![docker pull custom-nginx](images/image18.png)

`docker tag sergiomoscow/custom-nginx:1.0.0 sergiomoscow/custom-nginx:latest`

После этой команды произошло изменение также в списке локальных образов:

![docker pull custom-nginx](images/image19.png)

А именно, sergiomoscow/custom-nginx уже появляется 2 раза с разными тегами.

Помечаем образ как localhost:5000/custom-nginx:latest:
`docker tag sergiomoscow/custom-nginx:latest localhost:5000/custom-nginx:latest`

И помещаем его в локальное registry:

`docker push localhost:5000/custom-nginx:latest`

![docker push to local registry](images/image20.png)

Config из portainer inspect:

![portainer inspect config](images/image21.png)

Удаляем compose.yml и запускаем

`docker compose up -d`

![docker compose up](images/image22.png)

Выполняем предложенное действие:

`docker compose up -d --remove-orphans`

![docker compose up with remove orphans](images/image23.png)

Гасим compose проект:

`docker compose down -v`

![docker compose down](images/image24.png)

Убеждаемся, что контейнеров из compose и docker-compose нет:

`docker ps -a`

![docker ps](images/image25.png)