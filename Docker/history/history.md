
```
1  cat /etc/os-release
    2  echo $0
    3  clar
    4  clear
    5  apt-get update && apt-get upgrade -y
    6  cd ~ && touch myfile.txt && ls
    7  apt-get install vim
    8  vim myfile.txt
    9  history
```
## Basic docker command

```
1  clear
    2  ls
    3  clear
    4  docker version
    5  docker info
    6  clear
    7  sudo systemctl status docker
    8  clear
    9  export PS1="\e[1;36m fatihtepePC/\W>>> \$ \e[m "
   10  clear
   11  docker run -i -t ubuntu
   12  docker ps -a
   13  docker run -i -t --name clarus ubuntu
   14  docker ps -a
   15  docker start 49a
   16  docker ps
   17  docker stop clarus
   18  docker ps -a
   19  docker start clarus
   20  docker ps
   21  docker attach clarus
   22  docker ps -a
   23  docker start clarus && docker attach clarus
   24  docker inspect clarus
   25  docker rm clarus
   26  docker ps -a
   27  clear
   28  history
   29  clear
   30  ls
   31  docker run -it alpine ash
   32  docker ps -a
   33  docker start 02b && docker attach 02b
   34  docker rm 02b
   35  docker ps -a
   36  docker volume ls
   37  clear
   38  docker volume create cw-vol
   39  docker volume ls
   40  docker volume inspect cw-vol
   41  clear
   42  sudo ls -al  /var/lib/docker/volumes/cw-vol/_data
   43  docker run -t --name clarus -v cw-vol:cw alpine ash
   44  docker run -t --name clarus -v cw-vol:/cw alpine ash
   45  clear
   46  docker ps -a
   47  docker attach 343
   48  docker ps -a
   49  docker stop clarus
   50  docker ps -a
   51  clear
   52  docker attach clarus
   53  docker start clarus
   54  docker attach clarus
   55  docker run -it tepe -v cw-vol:/cw alpine ash
   56  docker run -it --name tepe -v cw-vol:/cw alpine ash
   57  docker ps -a
   58  docker rm clarus
   59  docker stop clarus
   60  docker rm clarus
   61  docker remove tepe
   62  docker rm tepe
   63  clear
   64  docker ps -a
   65  ls
   66  sudo ls -al  /var/lib/docker/volumes/cw-vol/_data
   67  sudo cat /var/lib/docker/volumes/cw-vol/_data/i-will-persist.txt
   68  sudo cat /var/lib/docker/volumes/cw-vol/_data/armut.txt
   69  clear
   70  history
   72  clear
   73  docker run -it --name clarus2nd -v cw-vol:/cw2nd alpine ash
   74  docker run -it --name clarus3rd -v cw-vol:/cw3rd ubuntu bash
   75  docker run -it --name clarus4th -v cw-vol:/cw4th:ro ubuntu bash
   76  docker ps -a
   77  ocker rm clarus2nd clarus3rd clarus4th
   78  docker rm clarus2nd clarus3rd clarus4th
   79  docker volume ls
   80  docker volume rm cw-vol
   81  docker volume create empty-vol
   82  docker volume create full-vol
   83  docker run -it --name vol-lesson -v full-vol:/cw alpine ash
   84  sudo ls /var/lib/docker/volumes/full-vol/_data
   85  docker run -it --name clarus clarusway/hello-clarus sh
   86  docker run -it --name try1 -v full-vol:/cw clarusway/hello-clarus sh
   87  sudo ls /var/lib/docker/volumes/empty-vol/_data
   88  docker run -it --name try2 -v empty-vol:/hello-clarus clarusway/hello-clarus sh
   89  sudo ls /var/lib/docker/volumes/empty-vol/_data
   90  sudo ls /var/lib/docker/volumes/full-vol/_data
   91  docker run -it --name try3 -v full-vol:/hello-clarus clarusway/hello-clarus sh
   92  docker container prune
   93  docker volume prune
   94  docker volume ls
   95  docker container ls
   96  history
```