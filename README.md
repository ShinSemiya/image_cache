# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version  
2.3.1 を使っています。  
Railsは5以降を想定しています。  

* System dependencies  
Ruby on Rails + MySQL + Redis + Carrierwave を使っています。  
あらかじめ導入をお願いします。  
Redisの設定ファイルは redis-conf/redis.conf にあります  

* Database creation  
rake db:create  
rake db:migrate  
でデータをセットアップしてください。  

* How to run the test suite  
rspec でお願いします。  
キャッシュに依存しているため、Redis Serverは起動しておいてください。  
  
* Services (job queues, cache servers, search engines, etc.)  
Redisがキモなので起動してから使ってください。  
開発環境においてもテスト環境においてもRedisが必要です。  
  
