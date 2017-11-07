FROM ubuntu:14.04

# Set version and github repo which you want to build from
ENV GITHUB_OWNER druid-io
ENV DRUID_VERSION 0.10.1

# Java 8
RUN apt-get update \
      && apt-get install -y software-properties-common \
      && apt-add-repository -y ppa:webupd8team/java \
      && apt-get purge --auto-remove -y software-properties-common \
      && apt-get update \
      && echo oracle-java-8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
      && apt-get install -y oracle-java8-installer oracle-java8-set-default \
                            git \
                            python-pip \
                            curl \
      && apt-get clean \
      && rm -rf /var/cache/oracle-jdk8-installer \
      && rm -rf /var/lib/apt/lists/*

# Maven
RUN wget -q -O - http://archive.apache.org/dist/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz | tar -xzf - -C /usr/local \
      && ln -s /usr/local/apache-maven-3.2.5 /usr/local/apache-maven \
      && ln -s /usr/local/apache-maven/bin/mvn /usr/local/bin/mvn

# Druid system user
RUN addgroup --system --gid 1000 druid \
      && adduser --system --uid 1000 --gid 1000 --no-create-home druid \
      && mkdir -p /var/lib/druid \
      && chown druid:druid /var/lib/druid

# Druid (from source)
RUN mkdir -p /usr/local/druid/lib

# trigger rebuild only if branch changed
ADD https://api.github.com/repos/$GITHUB_OWNER/druid/git/refs/heads/$DRUID_VERSION druid-version.json
RUN git clone -q --branch $DRUID_VERSION --depth 1 https://github.com/$GITHUB_OWNER/druid.git /tmp/druid
WORKDIR /tmp/druid

# package and install Druid locally
# use versions-maven-plugin 2.1 to work around https://jira.codehaus.org/browse/MVERSIONS-285
RUN mvn -U -B org.codehaus.mojo:versions-maven-plugin:2.1:set -DgenerateBackupPoms=false -DnewVersion=$DRUID_VERSION \
  && mvn -U -B install -DskipTests=true -Dmaven.javadoc.skip=true \
  && cp services/target/druid-services-$DRUID_VERSION-selfcontained.jar /usr/local/druid/lib \
  && cp -r distribution/target/extensions /usr/local/druid/ \
  && cp -r distribution/target/hadoop-dependencies /usr/local/druid/ \
  && rm -rf /tmp/* \
            /var/tmp/* \
            /usr/local/apache-maven-3.2.5 \
            /usr/local/apache-maven \
            /root/.m2

WORKDIR /usr/local/druid

RUN java \
  -cp "lib/*" \
  -Ddruid.extensions.directory="extensions" \
  -Ddruid.extensions.hadoopDependenciesDir="hadoop-dependencies" \
  io.druid.cli.Main tools pull-deps \
  --no-default-hadoop \
  -c "org.apache.parquet:parquet-avro:1.9.0"

RUN java \
  -cp "lib/*" \
  -Ddruid.extensions.directory="extensions" \
  -Ddruid.extensions.hadoopDependenciesDir="hadoop-dependencies" \
  io.druid.cli.Main tools pull-deps \
  --no-default-hadoop \
  -c "io.druid.extensions.contrib:druid-google-extensions:0.10.1"

RUN mkdir -p /tmp/druid \
  /tmp/druid/persistent/task \
  /var/tmp \
  /var/druid/indexing-logs \
  /var/druid/segments \
  /var/druid/segment-cache \
  /var/druid/task \
  /var/druid/hadoop-tmp \
  /var/druid/pids

RUN chown -R druid:druid /var/druid \
      && chown -R druid:druid /tmp/druid

# Expose ports:
# - 8081: HTTP (coordinator)
# - 8082: HTTP (broker)
# - 8083: HTTP (historical)
# - 8090: HTTP (overlord)
EXPOSE 8081
EXPOSE 8082
EXPOSE 8083
EXPOSE 8090
EXPOSE 8091
EXPOSE 8100 8101 8102 8103 8104

WORKDIR /var/lib/druid

CMD export HOSTIP="$(resolveip -s $HOSTNAME)"
