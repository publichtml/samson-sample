# samson-sample

[Samson](https://github.com/zendesk/samson) を理解するために、サンプルのクライアントと接続してデプロイを試せるようにしたもの。

サンプルクライアントは [rails7-samson-sample-client](https://github.com/publichtml/rails7-samson-sample-client) にあり、Welcome と表示するだけの Rails アプリ。

## Usage

- docker-compose をインストールしておく
- Docker の host マシンの公開鍵を用意しておく
  - 実際の環境を模擬するためにコンテナ同士の直接接続ではなく host の ssh-agent を介した接続をしている

```
$ git clone --recursive git@github.com:publichtml/samson-sample.git

$ cd samson-sample

$ cp /path/to/id_rsa.pub rails7-samson-sample-client/id_rsa.pub

$ docker-compose -f docker-compose.with_sample_client.yml build
$ docker-compose -f docker-compose.with_sample_client.yml up -d
```

- http://localhost:3000 にアクセスすると Samson が使える
- `Produciton` stage でデプロイ実行
- http://localhost:4000 でデプロイされたサンプルアプリが動いている
  - `Welcome` とだけ表示される

## Tips

コンテナに入って rails console を起動する際は `ENV["USER"]` をセットしておく必要がある。

```
$ export USER=root
$ bin/rails c
```


# Original README

<img src="https://github.com/zendesk/samson/raw/master/app/assets/images/logo_light.png" width=400/>

![Build status](https://github.com/zendesk/samson/workflows/repo-checks/badge.svg)
[![FOSSA Status](https://app.fossa.io/api/projects/custom%2B4071%2Fgit%40github.com%3Azendesk%2Fsamson.git.svg?type=shield)](https://app.fossa.io/projects/custom%2B4071%2Fgit%40github.com%3Azendesk%2Fsamson.git?ref=badge_shield)
[![DockerHub Status](https://img.shields.io/docker/stars/zendesk/samson.svg)](https://hub.docker.com/r/zendesk/samson)

Samson is a web interface for deployments. [Live Demo](https://samson.onrender.com)
It is currently in maintenance mode (bugfix, but no new features) because we are migrating off it.

**View the current status of all your projects:**

![](http://f.cl.ly/items/3n0f0m3j2Q242Y1k311O/Samson.png)

**Allow anyone to watch deploys as they happen:**

![](http://cl.ly/image/1m0Q1k2r1M32/Master_deploy__succeeded_.png)

**View all recent deploys across all projects:**

![](http://cl.ly/image/270l1e3s2e1p/Samson.png)

### Deployment Workflow

Create a project and 1 or more stages (staging/production etc),
then selects a version and start the deploy.

Samson will:
 - clone git repository
 - execute commands associated with the stage (or execute API calls for kubernetes)
 - stream deploy output to everybody who wants to watch
 - persist deploy output for future review

#### Requirements

* MySQL, Postgresql, or SQLite
* Ruby (see .ruby-version)
* Git (>= 1.7.2)

### Documentation

* [Getting started](/docs/setup.md)
* [Basic Components](/docs/components.md)
* [Permissions](/docs/permissions.md)
* [Continuous Integration](/docs/ci.md)
* [Extra features](/docs/extra_features.md)
* [Plugins](/docs/plugins.md)
* [Statistics](/docs/stats.md)
* [API](/docs/api.md)

### Contributing

Issues and Pull Requests are always welcome, submit your idea!

### License

Use of this software is subject to important terms and conditions as set forth in the [LICENSE](LICENSE) file
