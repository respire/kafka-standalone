## kafka standalone
get tired of docker/k8s for small deployment? boot your kafka standalone cluster in traditional way!

|    Module     |    Introduction    |
|---------------|--------------------|
| [kafka 2.1.1](https://kafka.apache.org/) | stream stroage |
| [ruby 2.5.5 + eye 0.10](https://github.com/kostya/eye)    | process monitoring |
| [maxwell 1.2.0](http://maxwells-daemon.io/) | lightweight MYSQL CDC (yep, i don't like kafka-connect and kafka-stream for small volume case)          |

### setup
```
bundle install
./bin/leye load
```

### info
```
./bin/leye info
```

### start
```
./bin/leye start all
```

#### stop
```
./bin/leye stop all
```
