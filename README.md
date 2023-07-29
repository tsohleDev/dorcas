# To Docker
> Express & SQLite To-Do App with Docker

## Introduction

To Dockers is a learning repository designed to help developers understand the concepts of Docker by building and deploying a simple To-Do web application. The project utilizes the Express.js framework for the backend and SQLite as the database. Through this repository, you will gain hands-on experience creating Docker images, containers, volumes, and Docker Compose, enabling you to efficiently manage your app's development, deployment, and local environment setup.

## Getting Started

### Prerequisites

- [Docker](https://www.docker.com/get-started) must be installed on your system.
- [DockerHub](https://hub.docker.com/) Have an account
- **Bash**. We will be running all our scripts using bash

### Clone to your local machine

Clone this repository to your local machine using the following command:

   ```bash
   git clone https://github.com/tsohledev/toDockers.git
   cd toDockers
   ```
## Dockerize 

### Simple Container
> Lets just get our feet wet and spin one up to test the basic commands

1. Build the image from the [Dockerfile]('./Dockerfile')
    ```bash
    # raising -t which means tag allows your to give the container a name in this case 'to-dockers'
    # the parameter of the build command is a the path to your Dockerfile, thus '.' specifys the same directory
    docker build -t to-dockers .
    ```
2. run the container from the image
    ```bash
    # the -p flag allows you to add an additinal parameter '127.0.0.1:3000:3000' for a port mapping between the host and the container
    # the -d flag detaches the container terminal from your terminal
    docker run -dp 127.0.0.1:3000:3000 to-dockers
    # the parameter here is the name of the image
    ```
3. confirm it running
    ```bash
        docker ps
        # you should see an image 'to-dockers'
    ```
4. stop and delete the container
    ```bash
        # -f is to force the delete even if the container is running
        # the parameter is the id of the container that you got when you ran the 'docker ps' command
        docker rm -f <id>
    ```
### Named Volume Mounting
> Lets mount a volume from the host to the sql db file

1. Create the named volume **todo-db**

```bash
    docker volume create todo-db # Create volume
    docker volume inspect todo-db # Check the volume's metadata
```

2. Create a container with the volume mounted the sqlite folder `/etc/todos`

```bash
    # -v raised to allow mounting parameter 'volume_name:container_path'
    docker run -dp 127.0.0.1:3000:3000 -v todo-db:/etc/todos to-dockers
```

Now insert some todos into your app stop and remove your container spin up again while mounting the db to the volume again. It should persist the data.

### Bind Mounting
> No to "It works on my local machine', Yes to "It works in the container"

Because we are in `development` mode, we wont be using our docker file to build an image, but rather a base image with node only and **bind** the host's ```pwd``` to the container... say in ```/src```

#### Run a container bound to the host

```bash
    docker run -dp 127.0.0.1:3000:3000 / 
    -w /app / 
    --mount type=bind,src="$(pwd)",target=/src / 
    node:18-alpine / 
    sh -c "yarn install && yarn run dev"
```

We raised the flag `-w` to specify the working directory, `--mount` with type bind to do the binding, then run the `sh` script to install the dependencies and to run the script **dev** which runs the server using [nodemon](https://www.npmjs.com/package/nodemon). Happy coding! Remember to stop the container

### + Containers

> Let add a MySql database container

1. Create a network

```bash
    docker network create todo-app
```

2. Run a mysql container connected to the network

```bash
    # network flag to connect the network todo-app
    # network-atlias flag raised so we can add
    # -e flag for enviromental variables 'database name and root password'
    # we run the mysql image from dockerhub
    docker run -d \
     --network todo-app --network-alias mysql \
     -v todo-mysql-data:/var/lib/mysql \
     -e MYSQL_ROOT_PASSWORD=secret \
     -e MYSQL_DATABASE=todos \
     mysql:8.0
```

Inspect your database

```bash
    # exec is to execute a script in the container
    # -i to make it interactive, i.e keep the bash open
    # -t tty/terminal gets a pseudo terminal to interact with the container
    # 'mysql -u root -p' the script to be executed inside that connects to the mysql server
    docker exec -it <id> mysql -u root -p
```

Log in with the password from your enviromental variable `MYSQL_ROOT_PASSWORD` and check the databases

```bash
    mysql> SHOW DATABASES;
```

Is all good?

```bash
    mysql> exit
```

3. Connect the database

> Lets use [nicolaka/netshoot](https://github.com/nicolaka/netshoot) to interconect

```bash
    # start a new container from the nicolaka/netshoot connected to the network todo-app
    docker run -it --network todo-app nicolaka/netshoot

    # run the node app connected to the network
    docker run -dp 127.0.0.1:3000:3000 \
    -w /app -v "$(pwd):/app" \
    --network todo-app \
    -e MYSQL_HOST=mysql \
    -e MYSQL_USER=root \
    -e MYSQL_PASSWORD=secret \
    -e MYSQL_DB=todos \
    node:18-alpine \
    sh -c "yarn install && yarn run dev"
```

The app should have connected to the external database in the different container, you can even check by adding some todos in the browser and checking the **logs** if the database is indeed connected.

Check also in the mysql container if the data is written 
```bash
    docker exec -it <id> mysql -p todos
```

```bash
    mysql> select * from todo_items;
```

