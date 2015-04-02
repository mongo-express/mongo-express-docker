# mongo-express

A dockerized mongo-express for viewing mongoDB in the browser

How to run this container
-------------------------

	docker run -it --rm \
		--name mongo-express \
		--link NAME_OF_MONGODB_CONTAINER:mongo \
		knickers/mongo-express "$@"

`--link` is the key here, where you link your mongoDB container into the mongo-express container.
