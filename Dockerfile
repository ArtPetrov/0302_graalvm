FROM ghcr.io/graalvm/graalvm-ce:22.3.1 as base
RUN gu install native-image

#RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
#  && curl -fsSL -o /tmp/apache-maven.tar.gz https://apache.osuosl.org/maven/maven-3/3.8.8/binaries/apache-maven-3.8.8-bin.tar.gz \
#  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
#  && rm -f /tmp/apache-maven.tar.gz \
#  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
#COPY src/pom.xml ./
#RUN mvn dependency:resolve
#
#COPY ./src ./
#RUN mvn verify -Pnative

WORKDIR /app

COPY src/.mvn/ .mvn
COPY src/mvnw src/pom.xml ./
RUN chmod +x mvnw
RUN ./mvnw dependency:resolve

COPY ./src ./
RUN chmod +x mvnw
RUN ./mvnw verify -Pnative

FROM scratch
COPY --from=base /app/target/native.bin /native.bin
ENTRYPOINT ["./native.bin"]
CMD -Dport=9595
