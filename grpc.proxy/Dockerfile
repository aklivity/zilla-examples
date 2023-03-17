FROM maven

# Install required dependencies for gRPC build
RUN apt-get update && \
    apt-get install -y protobuf-compiler && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/app

RUN git clone https://github.com/akrambek/grpc-echo.git
RUN cd grpc-echo && mvn install

ENTRYPOINT ["java", "-jar", "grpc-echo/target/echo-develop-SNAPSHOT.jar"]
