# mongo-express

A dockerized [mongo-express](https://github.com/andzdroid/mongo-express) for viewing MongoDB in the browser

## How to run this container

	docker run -it --rm \
		--name mongo-express \
		--link NAME_OF_MONGODB_CONTAINER:mongo \
		knickers/mongo-express

`--link` is the key here, where you link your MongoDB container into the mongo-express container.

### Additional configuration Options

Environment variables can be passed to the `run` command for configuring your MongoDB instance

Name | Default | Description
----------------------------
MONGO_PORT | 27017 | MongoDB port
ADMIN_USER | '' | MongoDB admin username
ADMIN_PASS | '' | MongoDB admin password
WEB_USER | 'user' | mongo-express web console username
WEB_PASS | 'pass' | mongo-express web console password

#### Example

	docker run -it --rm \
		--name mongo-express \
		--link web_db_1:mongo \
		-e ADMIN_USER="root" \
		-e ADMIN_PASS="correct horse battery staple" \
		knickers/mongo-express

If you have [tianon/rawdns](https://github.com/tianon/rawdns) running, this container will be accessible at:

`http://mongo-express.docker:8081`

### Note from the mongo-express developers:

> JSON documents are parsed through a javascript virtual machine, so the web interface can be used for executing malicious javascript on a server.

> **mongo-express should only be used privately for development purposes.**
