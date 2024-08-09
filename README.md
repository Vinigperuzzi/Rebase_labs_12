# Rebase_labs_12
Here you can see the code for the Rebase Lab app. In this course we will work with sinatra, docker, react, pure javascript, html and css, and in my case, postgreSQL.

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

With the postgre server and the ruby server running, you may be able to manipulate the db via script ruby. There's two options to manipulate

```bash
  ruby lib/populate_db.rb
```

Which will create the exams table in labs_db database, in case it does not already exists, and will populate the databse with the data from csv file, removing any other information present in the database. It is a reset.


```bash
  ruby lib/drop_exams.rb
```

Which will drop all the information from the table exams and then drop the table exams.

### Endpoints

##### /hello
Display a 'Hello world' message

##### /tests
Show all the data from csv file (not reading from database yet)

