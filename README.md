# Ruby Sinatra - API

## Config

Configure the environment for the database in the .env.example file

```bash
cp .env.example .env
```

## Run local

### Initialize container

Bash script is provided to executes the docker compose. It will bring up the API on the port set in the environment. Two Postgres databases, one for testing and another for development. To execute it, run the following command:

```bash
./start.sh
```

### Access the container

To enter the container, run the following command:

```bash
docker exec -it <container_name> bash
```

Once inside, you can run the tests, the linter, or run the server.

### Run the tests and linter

Inside the container, to run the tests, run the following command:

```bash
rake
```

### Run the server

Inside the container, to run the server, run the following command:

```bash
rackup --host 0.0.0.0 --port ${PORT}
```

This command will bring up the server on the port set in the environment. Then, open the browser and go to http://0.0.0.0:8080 or the port set in the environment.

## API

The documentation for the endpoints is located at the route `/docs` which allows you to see the available endpoints and test them. An endpoint is provided to create a user and another to log in.