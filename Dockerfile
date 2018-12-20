FROM pbspro/pbspro

RUN yum install -y java-1.8.0-openjdk-devel java-1.8.0-openjdk
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk/

ADD . /opt/spark
WORKDIR /opt/spark 

RUN echo "spark.pbs.executor.home /opt/spark" >> conf/spark-defaults.conf
RUN echo "spark.master pbs" >> conf/spark-defaults.conf
