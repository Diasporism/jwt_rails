Example JWT Auth Server 
=========
This is an example JWT Authorization Server. In theory it would hold the users table and any auth related roles and auditing requirements. It's meant to be used in conjunction with another API or codebase that holds your application's business logic.

Pre-requisites
---------------
- [Have a functioning development environment](http://tutorials.jumpstartlab.com/topics/environment/environment.html)

Installation
--------------
Simply clone the repo and install its dependencies:
```sh
$ git clone git@github.com:Diasporism/jwt_rails.git
$ cd jwt_rails/
$ bundle
```

Run the Server
---------------
Just type...
```sh
$ unicorn
```
and visit [localhost:8080](http://localhost:8080).
