mongo-express
=============

A dockerized [mongo-express](https://github.com/andzdroid/mongo-express) for managing a MongoDB database in the browser.

How to run this container
-------------------------

	docker run -it --rm \
		--link NAME_OF_MONGODB_CONTAINER:mongo \
		knickers/mongo-express

`--link` is the key here, where you link your MongoDB container into the mongo-express container.

### Additional configuration Options

Environment variables can be passed to the `run` command for configuring your mongo-express container

	Name                            | Default   | Description
	--------------------------------|-----------|------------
	ME_CONFIG_BASICAUTH_USERNAME    | ''        | mongo-express web console username
	ME_CONFIG_BASICAUTH_PASSWORD    | ''        | mongo-express web console password
	ME_CONFIG_MONGODB_ADMINUSERNAME | ''        | MongoDB admin username
	ME_CONFIG_MONGODB_ADMINPASSWORD | ''        | MongoDB admin password
	ME_CONFIG_MONGODB_PORT          | 27017     | MongoDB port
	ME_CONFIG_MONGODB_SERVER        | 'mongo'   | MongoDB container name
	ME_CONFIG_OPTIONS_EDITORTHEME   | 'default' | mongo-express editor color theme, [more here](http://codemirror.net/demo/theme.html)
	ME_CONFIG_REQUEST_SIZE          | '100kb'   | Maximum payload size. CRUD operations above this size will fail. [body-parser](https://www.npmjs.com/package/body-parser)

#### Example

	docker run -it --rm \
		--name mongo-express \
		--link web_db_1:mongo \
		-e ME_CONFIG_OPTIONS_EDITORTHEME="ambiance" \
		knickers/mongo-express

This container can be accessed at `http://localhost:8081`, or `http://mongo-express.docker:8081` if you have [tianon/rawdns](https://github.com/tianon/rawdns) running.

### Note from the mongo-express developers:

> JSON documents are parsed through a javascript virtual machine, so the web interface can be used for executing malicious javascript on a server.

> **mongo-express should only be used privately for development purposes.**
