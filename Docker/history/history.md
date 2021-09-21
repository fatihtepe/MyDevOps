
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

## network

```
1  ls
    2  cd composetest/
    3  ls
    4  cd code
    5  cd
    6  cd composetest/
    7  ls
    8  cd code
    9  ls
   10  cp app.py ../
   11  ls
   12  cd ..
   13  ls
   14  clear
   15  ls
   16  rm -rf code/
   17  ls
   18  docker-compose up
   19  docker-compose down
   20  docker-compose up
   21  sudo systemctl start docker
   22  cd ..
   23  sudo yum update -y
   24  sudo amazon-linux-extras install docker -y
   25  sudo systemctl start docker
   26  sudo systemctl enable docker
   27  sudo systemctl status docker
   28  sudo usermod -a -G docker ec2-user
   29  newgrp docker
   30  docker version
   31  docker info
   32  sudo systemctl start docker
   33  sudo systemctl enable docker
   34  docker version
   35  clear
   36  ls
   37  cd composetest/
   38  ls
   39  docker-compose up
   40  sudo systemctl enable docker
   41  sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
   42  sudo chmod +x /usr/local/bin/docker-compose
   43  docker-compose --version
   44  docker-compose up
   45  clear
   46  docker-compose help | less
   47  docker-compose ps
   48  claer
   49  clear
   50  cd
   51  clear
   52  mkdir to-do-api
   53  cd to-do-api/
   54  vim requirements.txt
   55  ls
   56  cat requirements.txt
   57  clear
   58  ls
   59  docker-compose up -d
   60  docker container ls
   61  clear
   62  claer
   63  clear
   64  ls
   65  docker images
   66  docker network ls
   67  curl http://54.91.138.117/todos
   68  clear
   69  curl -H "Content-Type: application/json" -X POST -d '{"title":"Get some REST", "description":"REST in Peace"}' http://54.91.138.117/todos
   70  curl -H "Content-Type: application/json" -X DELETE http://54.91.138.117/todos/1
   71  curl http://54.91.138.117/todos
   72  docker-compose down
   73  docker container ls
   74  docker network ls
   75  clear
   76  cd ..
   77  cd composetest/
   78  ls
   79  docker-compose ps
   80  docker-compose images
   81  clear
   82  docker-compose images
   83  docker-compose config
   84  docker-compose up
   85  docker-compose help | less
   86  docker-compose ps
   87  cd composetest/
   88  docker-compose ps
   89  docker-compose images
   90  docker-compose config
   91  docker-compose ps
   92  ls
   93  cd to-do-api/
   94  docker-compose ps
   95  cd ../composetest/
   96  ls
   97  clear
   98  docker-compose --version
   99  docker-compose images
  100  docker-compose up
  101  docker-compose down
  102  docker ps -a
  103  clear
  104  docker images
  105  docker-compose up
  106  docker-compose down
  107  docker compose up --build
  108  docker-compose up --build
  109  docker-compose down
  110  docker ps -a
  111  clear
  112  cd ../to-do-api/
  113  docker-compose up -d
  114  docker image l
  115  docker container ls
  116  docker images
  117  docker network ls
  118  docker-compose down
  119  cd ..
  120  clear
  121  df -h
  122  parted 54.91.138.117/dev/xvda1 print
  123  sudo parted /dev/xvda1 print
  124  sudo parted /dev/xvda print
  125  exit
  126  clear
  127  systemctl status docker
  128  clear
  129  docker network ls
  130  docker container run -dit --name clarus1st alpine ash
  131  docker container run -dit --name clarus2nd alpine ash
  132  clear
  133  docker ps
  134  docker network inspect bridge | less
  135  docker container inspect clarus2nd | grep IPAddress
  136  docker container attach clarus1st
  137  ifconfig
  138  clear
  139  docker ps -a
  140  clear
  141  docker container stop clarus1st clarus2nd
  142  docker container rm clarus1st clarus2nd
  143  docker network create --driver bridge clarusnet
  144  docker network ls
  145  docker network inspect clarusnet
  146  docker container run -dit --network clarusnet --name clarus1st alpine ash
  147  docker container run -dit --network clarusnet --name clarus2nd alpine ash
  148  docker container run -dit --name clarus3rd alpine ash
  149  docker container run -dit --name clarus4th alpine ash
  150  docker network connect clarusnet clarus4th
  151  clear
  152  docker container ls
  153  docker network inspect clarusnet
  154  docker network inspect bridge
  155  docker attach clarus1st
  156  docker container rm clarus1st clarus2nd clarus3rd clarus4th
  157  docker network rm clarusnet
  158  docker container run --rm -d -p 8080:80 --name ng nginx
  159  clear
  160  ifconfig
  161  docker container stop my_nginx
  162  docker container run --rm -it --network none --name nullcontainer alpine
  163  clear
  164  docker ps
  165  docker ps -a
  166  history
```

## 092121 docker

```
127  docker vesion
  128  docker version
  129  clear
  130  export PS1="\e[1;36m fatihtepePC/\W>>> \$ \e[m "
  131  clear
  132  ls
  133  clear
  134  docker container run -d ozgurozturknet/adanzyedocker
  135  docker ps
  136  docker exect -it 494
  137  docker exect -it 494 sh
  138  docker ps
  139  docker exec it 494 sh
  140  docker ps -a
  141  docker exec -it 494 sh
  142  docker container run -it --name deneme ozgurozturknet/adanzyedocker sh
  143  docker network ls
  144  clear
  145  docker network ls
  146  docker network ls
  147  clear
  148  docker network ls
  149  ifconfig
  150  clear
  151  docker container run -it --deneme1 --net host ozgurozturknet/adanzyedocker sh
  152  docker container run -it --name deneme1 --net host ozgurozturknet/adanzyedocker sh
  153  docker container run -it --name deneme35 --net none ozgurozturknet/adanzyedocker sh
  154  clera
  155  clear
  156  docker network ls
  157  ls
  158  clear
  159  ls
  160  clear
  161  ls
  162  clear
  163  ls
  164  clear
  165  docker container run -d -p 8080:80 ozgurozturknet/adanzyedocker
  166  docker ps
  167  ls
  168  ls -al
  169  clear
  170  docker ps
  171  docker container run -d --name websunucu1 ozgurozturknet/adanzyedocker
  172  docker container run -d --name database1 ozgurozturknet/adanzyedocker sh
  173  docker container run -it -d --name database1 ozgurozturknet/adanzyedocker sh
  174  docker container ps
  175  docker container run -it -d --name database21 ozgurozturknet/adanzyedocker sh
  176  docker container run -it --name database ozgurozturknet/adanzyedocker sh
  177  docker ps -a
  178  docker container prune
  179  docker ps -a
  180  docker image prune
  181  docker ps -a
  182  docker container rm 1b0 16f 9f9 494
  183  docker container rm -f 1b0 16f 9f9 494
  184  clear
  185  docker network create kopru1
  186  docker network ls
  187  docker network inspect kopru1
  188  docker container run -dit --name websunucu --net kopru1 ozgurozturknet/adanzyedocker sh
  189  docker container run -dit --name database --net kopru1 ozgurozturknet/adanzyedocker sh
  190  docker ps
  191  clear
  192  docker network inspect kopru1
  193  docker attach websunucu
  194  docker network create --driver=bridge --subnet===10.10.0.0/16 --ip-range=10.10.10.0
  195  docker network create --driver=bridge --subnet===10.10.0.0/16 --ip-range=10.10.10.0/24 --gateway=10.10.10.10 kopru2
  196  docker network create --driver=bridge --subnet=10.10.0.0/16 --ip-range=10.10.10.0/24 --gateway=10.10.10.10 kopru2
  197  docker network ls
  198  docker network inspect kopru2
  199  clear
  200  ls
  201  clear
  202  docker attach database
  203  docker network inspect kopru2
  204  docker network rm kopru1
  205  clear
  206  docker network inspect kopru1
  207  docker network rm kopru2
  208  docker network inspect kopru2
  209  docker container rm -f database websunucu
  210  docker network rm kopru1 kopru2
  211  clear
  212  docker ps -a
  213  docker image ls -a
  214  docker image prune
  215  docker image rm -f *
  216  docker image prune
  217  clear
  218  history
  219  cl
  220  clear
  221  ls -l
  222  cd
  223  ls -l
  224  ls /a
  225  docker container run -d --name appbir ozgurozturknet/app1
  226  docker attach appbir
  227  docker start appbir
  228  docker attach appbir
  229  docker container start appbir
  230  docker container attach appbir
  231  clear
  232  docker logs appbir
  233  docker logs
  234  docker logs appbir
  235  clear
  236  docker container run -d --name con1 -p 80:80 nginx
  237  docker logs con1
  238  clear
  239  docker logs con1
  240  docker container ls -a
  241  docker container rm -f 64e
  242  docker logs con1
  243  docker container run -d --name con1 -p 5000:80 nginx
  244  docker container run -d --name con2 -p 5000:80 nginx
  245  docker logs con2
  246  clear
  247  docker exec -it con2 sh
  248  clear
  249  ls
  250  clear
  251  docker logs --help
  252  docker logs --details
  253  clear
  254  docker ps -a
  255  docker logs con2
  256  clear
  257  docker logs --details con2
  258  clear
  259  docker logs --details con2
  260  clear
  261  dockker logs -t con2
  262  docker logs -t con2
  263  clear
  264  docker logs -t con2
  265  docker logs con2
  266  docker logs --tail 3 con2
  267  clear
  268  docker logs con2
  269  clear
  270  docker logs -f con2
  271  clear
  272  docker logs --tail 3 con2
  273  clear
  274  docker info
  275  clear
  276  docker info
  277  docker container run --log-driver splunk nginx
  278  clear
  279  ps
  280  docker top
  281  docker top con2
  282  docker top con1
  283  docker container ls -a
  284  clear
  285  docker top con2
  286  docker stats con1
  287  docker stats
  288  docker container rm -f con1
  289  clear
  290  docker stats con2
  291  docker container ls
  292  docker stats
  293  docker run -d --memory=100m fatihtepe/flask-app --name tepe
  294  docker stats
  295  clera
  296  clear
  297  docker container ls -a
  298  docker run -d --memory=100 --memory-swap=200 ozgurozturknet/adanzyedocker
  299  docker run -d --memory=100m --memory-swap=200m ozgurozturknet/adanzyedocker
  300  docker stats
  301  history
  302  docker container run -d --cpus="1.5" ozgurozturknet/adanzyedocker
  303  docker container run -d --cpus="0.5" ozgurozturknet/adanzyedocker
  304  docker stats
  305  docker container run -d --cpus="0,1" ozgurozturknet/adanzyedocker
  306  docker container run -d --cpus="0.1" ozgurozturknet/adanzyedocker
```