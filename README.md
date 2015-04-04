# mongo-express

A dockerized [mongo-express](https://github.com/andzdroid/mongo-express) for viewing mongoDB in the browser

## How to run this container

	docker run -it --rm \
		--name mongo-express \
		--link NAME_OF_MONGODB_CONTAINER:mongo \
		knickers/mongo-express

`--link` is the key here, where you link your mongoDB container into the mongo-express container.

If you have [tianon/rawdns](https://github.com/tianon/rawdns) running, this container will be accessible at:

`http://mongo-express.docker:8081`

### Note from the mongo-express developers:

> JSON documents are parsed through a javascript virtual machine, so the web interface can be used for executing malicious javascript on a server.

> **mongo-express should only be used privately for development purposes.**
