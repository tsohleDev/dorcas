# To Docker
> Express & SQLite To-Do App with Docker

## Introduction

To Dockers is a learning repository designed to help developers understand the concepts of Docker by building and deploying a simple To-Do web application. The project utilizes the Express.js framework for the backend and SQLite as the database. Through this repository, you will gain hands-on experience creating Docker images, containers, volumes, and Docker Compose, enabling you to efficiently manage your app's development, deployment, and local environment setup.

## Getting Started

### Prerequisites

- [Docker](https://www.docker.com/get-started) must be installed on your system.

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
### Persist Data
> Lets mount a volume from the host to the sql db file

1. Create the named volume **todo-db**

```bash
    docker volume create todo-db
    docker volume inspect todo-db
```

2. Create a container with the volume mounted the sqlite folder `/etc/todos`

```bash
    # -v raised to allow mounting parameter 'volume_name:container_path'
    docker run -dp 127.0.0.1:3000:3000 -v todo-db:/etc/todos to-dockers
```

Now insert some todos into your app stop and remove your container spin up again while mounting the db to the volume again. It should persist the data.