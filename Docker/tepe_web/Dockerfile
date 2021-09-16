FROM ubuntu
RUN apt-get update -y && apt-get install python3 -y && apt-get install python3-pip -y && pip3 install flask
COPY . /app
WORKDIR /app
CMD python3 ./welcome.py
