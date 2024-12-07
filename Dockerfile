# Use an Ubuntu-based image with wget and tar installed
FROM ubuntu:20.04

# Set environment variables for Tomcat and Java
ENV TOMCAT_VERSION 8.5.24
ENV TOMCAT_HOME /opt/tomcat
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64
ENV PATH $JAVA_HOME/bin:$PATH

# Install wget, tar, and OpenJDK
RUN apt-get update && apt-get install -y wget tar openjdk-11-jdk bash

# Download and extract Tomcat
RUN wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.24/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz \
    && tar -xvzf apache-tomcat-${TOMCAT_VERSION}.tar.gz \
    && mv apache-tomcat-${TOMCAT_VERSION} ${TOMCAT_HOME} \
    && rm apache-tomcat-${TOMCAT_VERSION}.tar.gz

# Copy the addressbook.war into the Tomcat webapps directory
COPY addressbook/addressbook_main/target/addressbook.war ${TOMCAT_HOME}/webapps/

# Expose the default Tomcat HTTP port (8080)
EXPOSE 8080

# Ensure catalina.sh is executable
RUN chmod +x ${TOMCAT_HOME}/bin/catalina.sh

# Set the working directory
WORKDIR ${TOMCAT_HOME}/bin

# Start Tomcat
CMD ["bash", "catalina.sh", "run"]
