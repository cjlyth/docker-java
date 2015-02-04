# docker-java

### Versions

- [ `8`, `jdk-8`, `1.8`, `jdk-1.8`, `oracle-jdk-8u31`, `latest` (*Dockerfile*)](https://raw.githubusercontent.com/cjlyth/docker-java/master/Dockerfile)

### Local build

```
docker build --no-cache -t cjlyth/java:oracle-java-8u31 .
```

### Run

```
docker run -it --rm cjlyth/java bash
```

### Use the trusted build from docker

```
docker run -v $(pwd):/tmp/host-share --rm cjlyth/java
```
