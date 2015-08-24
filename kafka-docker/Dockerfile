FROM ubuntu:trusty

MAINTAINER Fiery 

ENV KAFKA_VERSION="0.8.2.1" SCALA_VERSION="2.10"


RUN apt-get update && apt-get install -y unzip openjdk-6-jdk wget curl git docker.io jq

RUN curl --stderr /dev/null https://www.apache.org/dyn/closer.cgi\?as_json\=1 | sed -rn 's/.*"preferred":.*"(.*)"/\1/p' > /tmp/kafka-mirror

RUN wget -q "$(cat /tmp/kafka-mirror)kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" -O "/tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz"
RUN tar xf /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt

EXPOSE 22 9092

VOLUME ["/kafka"]

ENV KAFKA_HOME /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION}
ADD start-kafka.sh /usr/bin/start-kafka.sh
ADD broker-list.sh /usr/bin/broker-list.sh
CMD start-kafka.sh
