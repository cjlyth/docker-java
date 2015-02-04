# docker-java

### Versions

- [ `8`, `jdk-8`, `1.8`, `jdk-1.8`, `oracle-jdk-8u31`, `latest` (*Dockerfile*)](https://raw.githubusercontent.com/cjlyth/docker-java/master/Dockerfile)

### Local build

```
docker build --no-cache -t cjlyth/java:latest . \
&& docker tag -f cjlyth/java:8 cjlyth/java:latest \
&& docker tag -f cjlyth/java:jdk-8 cjlyth/java:latest \
&& docker tag -f cjlyth/java:1.8 cjlyth/java:latest \
&& docker tag -f cjlyth/java:jdk-1.8 cjlyth/java:latest \
&& docker tag -f cjlyth/java:oracle-jdk-8u31 cjlyth/java:latest
```

### Run

```
docker run -it --rm cjlyth/java bash
```

### Use the trusted build from docker

```
docker run -v $(pwd):/tmp/host-share --rm cjlyth/java
```
