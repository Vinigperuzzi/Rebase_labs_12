# Rebase_labs_12
Here you can see the code for the Rebase Lab app. In this course we will work with sinatra, docker, pure javascript, html and css, and in my case, postgreSQL.

### How to run

This project uses docker to run, so you may have the docker installed to run this project.
You can see more about install docker [here](https://docs.docker.com/engine/install/).

Once you have docker installed, you can run the follow command on the project's root folder:

```bash
docker compose up -d --build
```

or if it gives an syntax error:

```bash
docker-compose up -d --build
```

At this point you may be able to access the database from any database manager, such as [dbeaver](https://dbeaver.io/download/) setting the configuration displayed in the docker-compose.yml file.
Note: this project is academic, i have conscience that if it goes to production, those sensible information could not be displayed as it is now, it will be in a config file that wouldn't be commited to GitHub.
As well, now you may be able to open the server with your browser in [localhost:3000](http://localhost:3000/tests).

##### Manipulating database

With the postgre server and the ruby server running, you may be able to manipulate the db via script ruby.
Note: The scripts use the gem 'pg' that uses some libs from the postgreSQL client, here you have three options to run the scripts:

- You can install postresqg client if you already haven't.
- You can install just the libs for postgre with the command:
```bash
  sudo apt install libpq-dev
```
- You can use an docker container already configured with these configuration, so you can run a bash with these dependencies, with the command:

```bash
docker compose run --rm test_runner
```
or
```bash
docker-compose run --rm test_runner
```

In any of the two first ones, you can now run the commands listed below

```bash
  ruby lib/populate_db.rb
```

Which will create the exams table in labs_db database, in case it does not already exists, and will populate the databse with the data from csv file, removing any other information present in the database. It is a reset.


```bash
  ruby lib/drop_exams.rb
```

Which will drop all the information from the table exams and then drop the table exams.

In case you run inside the container bash, the commands may differ a bit, cause of the different network that is being used to connection, localhost or docker bridge. The commands are:

```bash
  ruby lib/populate_db_container.rb
```
and
```bash
  ruby lib/drop_exams_container.rb
```

### Endpoints

##### /exams-dark
Return a html page that display information about all the data in the database organized and friendly to user in a dark theme page

##### /exams
Return a html page that display information about all the data in the database organized and friendly to user in a light theme page

##### /all_cpfs
Return a JSON with a list of all cpf registered in database, ordered by name, despite the name do not appear.

##### /all_cpf_tokens/:cpf
Return a JSON with a list of all tokens for a given cpf

##### /all_token_info/:token
Return a JSON with all information inherent to an exam given it's token

##### /all_cpf_info/:cpf

Return a JSON with all information inherent to an person given it's cpf

##### /all_token_types/:token
Return a detailed list with all types, limits and result of exams given an exam token.

##### /hello
Display a 'Hello world' message

##### /tests
Show all the data from the database (Note that the database must be populated with the script displayed before)


### How to test application
The project has a container for tests, cause it install several libs for postgre connection, and it must be encapsulated in container.

To run the terminal for the rspec command, you must simply run the container with the command:

```bash
docker-compose run --rm test_runner
```
or
```bash
docker compose run --rm test_runner
```

and then, run:

```bash
rspec
```
Note: the database for tests must be already running for tests work properly, so you must have the container running with the docker compose commando displayed before.





### For rebase people:

I prefer to use two databases from two separated container, so i can manage more decentralized the data for development and test and drop more easily any changes in test db. Also an third container to run the server.rb so it can install the dependencies in the container folder.
The fourth container is the container for tests (and manipulation of database). I create it because of the dependencies and principally to run the server encapsulated inside the container, not exposing the port 3000, avoiding the duplicate error for puma server. Also, i can set an environment variable to indicated that the db that may be used is the one from tests, protecting the development DB, making possible to use the application while running tests.
The container for tests, despite being in the docker-compose.yml, does not run with the compose up command, just with the run, specifying the service.