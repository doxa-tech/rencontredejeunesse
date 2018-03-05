This repo hosts http://rencontredejeunesse.ch

[![Build Status](https://semaphoreci.com/api/v1/js-tech/rencontredejeunesse/branches/master/badge.svg)](https://semaphoreci.com/js-tech/rencontredejeunesse)

### Using docker

Build with

```
docker-compose build
```

Run webserver with

```
docker-compose up
```

Create database with

```
docker-compose run web rake db:create
```

Shutdown webserver with

```
docker-compose down
```

Rebuild with

```
docker-compose up --build
```