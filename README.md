# 3dp [![Build Status](https://travis-ci.org/icostan/3dp.svg)](https://travis-ci.org/icostan/3dp)
3 Days Project

## Generation
Generate new rails app:
```shell
rails new blog -m rails-template.rb --skip-active-record --skip-test-unit --skip-spring --skip-turbolinks
```

Enhance existing app:
```shell
bundle exec rake rails:template LOCATION=~/Work/3dp/rails-template.rb
```

Generate default scaffold:
```shell
rails g scaffold post boolean:boolean email url phone password search uuid text:text file hidden integer:integer float:float range:range date:date time:time country time_zone
```
