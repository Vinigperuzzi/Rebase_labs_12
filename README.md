# Rebase_labs_12
Here you can see the code for the Rebase Lab app. In this course we will work with sinatra, docker, pure javascript, html and css, and in my case, postgreSQL.

### How to run

This project uses docker to run, so you may have the docker installed to run this project.
You can see more about install docker [here](https://docs.docker.com/engine/install/).

Once you have docker installed, you can run the follow command on the project's root folder:

Note: If you have any version of docker compose older than 2.0, you must run the command with docker-compose

```bash
docker compose up -d --build
```

You can also control the containers with the bash running the commands for start and stop application:

```bash
bin/start
bin/stop
```

Note: maybe you'll have to give exec permission with(don't worry, is just the docker command):

```bash
chmod +x bin/start
chmod +x bin/stop
```

At this point you may be able to access the database from any database manager, such as [dbeaver](https://dbeaver.io/download/) setting the configuration displayed in the docker-compose.yml file.
Note: this project is academic, i have conscience that if it goes to production, those sensible information could not be displayed as it is now, it will be in a config file that wouldn't be commited to GitHub.
Anyway, now you may be able to open the server with your browser in [localhost:3000](http://localhost:3000/tests).

##### Manipulating database

With the postgre server and the ruby server running, you may be able to manipulate the db via script ruby.
Note: The scripts use the gem 'pg' that uses some libs from the postgreSQL client, here you have three options to run the scripts:

- (RECOMENDED) You can use a docker container already configured with those configurations, so you can run a bash with these dependencie fullfilled, with the command:

```bash
docker compose run --rm test_runner
```

In case you run inside the container bash, the commands may differ a bit, cause of the different network that is being used to connection, localhost or docker bridge. The commands are:

```bash
  ruby lib/populate_db_container.rb
```
Which will create the exams table in labs_db database, in case it does not already exists, and will populate the databse with the data from csv file, removing any other information present in the database. It is a reset.

```bash
  ruby lib/drop_exams_container.rb
```
Which will drop all the information from the table exams and then drop the table exams.

- Otherwise, you can install postresql client if you already haven't, or
- You can install just the libs for postgre with the command below;
```bash
  sudo apt install libpq-dev
```

In this case, you can now run the commands listed below

```bash
  ruby lib/populate_db.rb
```

```bash
  ruby lib/drop_exams.rb
```

### Endpoints

##### /exams-dark
Return a html page that display information about all the data in the database organized and friendly to user in a dark theme page

##### /exams
Return a html page that display information about all the data in the database organized and friendly to user in a light theme page

##### /all_cpfs
Return a JSON with a list of all cpf registered in database, ordered by name, despite the name do not appear.

Response example:

```json
[
  "002.678.897-71",
  "018.581.237-63",
  "026.890.166-05",
  "048.550.171-67",
  "086.225.702-66",
  "071.488.453-78",
  "053.553.249-08",
  "097.725.477-16",
  "027.989.952-13",
  "077.877.076-15",
  "071.868.284-00",
  "036.662.049-53",
  "049.397.154-85",
  "081.878.172-67",
  "048.973.170-88",
  "076.638.088-27",
  "013.888.116-26",
  "092.375.756-29",
  "077.578.592-04",
  "016.201.315-95",
  "077.411.587-40",
  "037.787.232-60",
  "092.580.778-81",
  "072.328.987-54",
  "009.898.217-65",
  "050.039.641-88",
  "083.892.729-70",
  "048.108.026-04",
  "015.457.518-62",
  "099.204.552-53",
  "030.781.943-45",
  "033.837.707-70",
  "073.372.599-64",
  "081.031.558-02",
  "080.239.177-06",
  "040.716.080-99",
  "066.126.400-90",
  "094.010.477-66",
  "013.808.384-36",
  "089.034.562-70",
  "090.232.501-92",
  "084.796.691-79",
  "052.041.078-51",
  "020.486.910-21",
  "006.810.440-55",
  "003.596.348-42",
  "076.278.738-43",
  "019.338.696-82",
  "086.183.708-86",
  "061.475.044-01"
]
```

##### /all_cpf_tokens/:cpf
Return a JSON with a list of all tokens for a given cpf

Response example:

```json
[
  "FXVA74",
  "L3VQDE",
  "NA0K1D",
  "VC6WDW",
  "XRNS2K"
]
```

##### /all_token_info/:token
Return a JSON with all information inherent to an exam given it's token

Response example:

```json
{
  "dr_crm": "B000AR99QO",
  "dr_state": "MS",
  "dr_name": "Oliver Palmeira",
  "dr_email": "lawana.erdman@waters.info",
  "token": "FXVA74",
  "exam_date": "2021-05-03"
}
```

##### /all_cpf_info/:cpf

Return a JSON with all information inherent to an person given it's cpf

Response example:

```json
{
  "cpf": "037.787.232-60",
  "full_name": "João Felipe Louzada",
  "birth_date": "1985-01-22",
  "email": "clifton_hyatt@koss.biz",
  "address": "s/n Viela Theo Modesto",
  "city": "Cachoeira dos Índios",
  "state": "Tocantins"
}
```

##### /all_token_types/:token
Return a detailed list with all types, limits and result of exams given an exam token.

Response example:

```json
[
  {
    "exam_type": "hemácias",
    "exam_type_limits": "45-52",
    "exam_type_value": "58"
  },
  {
    "exam_type": "leucócitos",
    "exam_type_limits": "9-61",
    "exam_type_value": "56"
  },
  {
    "exam_type": "plaquetas",
    "exam_type_limits": "11-93",
    "exam_type_value": "38"
  },
  {
    "exam_type": "hdl",
    "exam_type_limits": "19-75",
    "exam_type_value": "97"
  },
  {
    "exam_type": "ldl",
    "exam_type_limits": "45-54",
    "exam_type_value": "86"
  },
  {
    "exam_type": "vldl",
    "exam_type_limits": "48-72",
    "exam_type_value": "1"
  },
  {
    "exam_type": "glicemia",
    "exam_type_limits": "25-83",
    "exam_type_value": "1"
  },
  {
    "exam_type": "tgo",
    "exam_type_limits": "50-84",
    "exam_type_value": "90"
  },
  {
    "exam_type": "tgp",
    "exam_type_limits": "38-63",
    "exam_type_value": "21"
  },
  {
    "exam_type": "eletrólitos",
    "exam_type_limits": "2-68",
    "exam_type_value": "65"
  },
  {
    "exam_type": "tsh",
    "exam_type_limits": "25-80",
    "exam_type_value": "63"
  },
  {
    "exam_type": "t4-livre",
    "exam_type_limits": "34-60",
    "exam_type_value": "12"
  },
  {
    "exam_type": "ácido úrico",
    "exam_type_limits": "15-61",
    "exam_type_value": "42"
  }
]
```

##### /hello
Display a 'Hello world' message

##### /tests
Show all the relevant data for a list of tokens. It's the json model specified in the snippet.

Response example:

```json
[{
   "result_token":"T9O6AI",
   "result_date":"2021-11-21",
   "cpf":"066.126.400-90",
   "name":"Matheus Barroso",
   "email":"maricela@streich.com",
   "birthday":"1972-03-09",
   "doctor": {
      "crm":"B000B7CDX4",
      "crm_state":"SP",
      "name":"Sra. Calebe Louzada"
   },
   "tests":[
      {
         "type":"hemácias",
         "limits":"45-52",
         "result":"48"
      },
      {
         "type":"leucócitos",
         "limits":"9-61",
         "result":"75"
      },
      {
         "test_type":"plaquetas",
         "test_limits":"11-93",
         "result":"67"
      },
      {
         "test_type":"hdl",
         "test_limits":"19-75",
         "result":"3"
      },
      {
         "test_type":"ldl",
         "test_limits":"45-54",
         "result":"27"
      },
      {
         "test_type":"vldl",
         "test_limits":"48-72",
         "result":"27"
      },
      {
         "test_type":"glicemia",
         "test_limits":"25-83",
         "result":"78"
      },
      {
         "test_type":"tgo",
         "test_limits":"50-84",
         "result":"15"
      },
      {
         "test_type":"tgp",
         "test_limits":"38-63",
         "result":"34"
      },
      {
         "test_type":"eletrólitos",
         "test_limits":"2-68",
         "result":"92"
      },
      {
         "test_type":"tsh",
         "test_limits":"25-80",
         "result":"21"
      },
      {
         "test_type":"t4-livre",
         "test_limits":"34-60",
         "result":"95"
      },
      {
         "test_type":"ácido úrico",
         "test_limits":"15-61",
         "result":"10"
      }
   ]
}]

```

##### /tests/:token
Show all the relevant data for a list of tokens. It's the json model specified in the snippet.

Response example:

```json
{
   "result_token":"T9O6AI",
   "result_date":"2021-11-21",
   "cpf":"066.126.400-90",
   "name":"Matheus Barroso",
   "email":"maricela@streich.com",
   "birthday":"1972-03-09",
   "doctor": {
      "crm":"B000B7CDX4",
      "crm_state":"SP",
      "name":"Sra. Calebe Louzada"
   },
   "tests":[
      {
         "type":"hemácias",
         "limits":"45-52",
         "result":"48"
      },
      {
         "type":"leucócitos",
         "limits":"9-61",
         "result":"75"
      },
      {
         "test_type":"plaquetas",
         "test_limits":"11-93",
         "result":"67"
      },
      {
         "test_type":"hdl",
         "test_limits":"19-75",
         "result":"3"
      },
      {
         "test_type":"ldl",
         "test_limits":"45-54",
         "result":"27"
      },
      {
         "test_type":"vldl",
         "test_limits":"48-72",
         "result":"27"
      },
      {
         "test_type":"glicemia",
         "test_limits":"25-83",
         "result":"78"
      },
      {
         "test_type":"tgo",
         "test_limits":"50-84",
         "result":"15"
      },
      {
         "test_type":"tgp",
         "test_limits":"38-63",
         "result":"34"
      },
      {
         "test_type":"eletrólitos",
         "test_limits":"2-68",
         "result":"92"
      },
      {
         "test_type":"tsh",
         "test_limits":"25-80",
         "result":"21"
      },
      {
         "test_type":"t4-livre",
         "test_limits":"34-60",
         "result":"95"
      },
      {
         "test_type":"ácido úrico",
         "test_limits":"15-61",
         "result":"10"
      }
   ]
}

```

### HTML for asynchronous queue

The project has one container to run redis, that enqueue the jobs, and another to run sidekiq to execute those jobs in background. The sidekiq already came with an route to show the queues, jobs and processes.
With all container running, all you must do is access the route for it in localhost:3000/sidekiq

Note: if the page asks for user and password, is: admin senha123.


### How to test application
The project has a container for tests, because it install several libs for postgre connection, and it must be encapsulated in container.

To run the terminal for the rspec command, you must simply run the container with the command:

```bash
docker-compose run --rm test_runner rspec
```

To test just the cypress for navigation, you can run:

```bash
docker compose run --rm cypress_test
```

With the command bellow you can test both rspec for backend and cypress for frontend navigation. (Recommended for just test all application at once, not for development)

```bash
bin/test
```

If permissions error occur, you may run the command below (don't worry, is just the two docker commands above):

```bash
chmod +x bin/bash
```

Note: the database for tests must be already running for tests work properly, so you must have the container running with the docker compose commando displayed before. The same applies for the server in systems tests.




### For rebase people:

##### About containers:
I prefer to use two databases from two separated container, so i can manage more decentralized the data for development and test and drop more easily any changes in test db. Also an third container to run the server.rb so it can install the dependencies in the container folder.
The fourth container is the container for tests (and manipulation of database). I create it because of the dependencies and principally to run the server encapsulated inside the container, not exposing the port 3000, avoiding the duplicate error for puma server. Also, i can set an environment variable to indicated that the db that may be used is the one from tests, protecting the development DB, making possible to use the application while running tests.
The container for tests, despite being in the docker-compose.yml, does not run with the compose up command, just with the run, specifying the service.


##### About exam view:
I did implemented the requested endpoint such as listed in feature 2, but the text seemed to suggest that the view must be the json required in the feature, but in a html friendly view. I misread it, and i get the idea that i should display all information in a more friendly view, so i took the liberty of implementing more endpoints an as well a more refined view using pure javascript. Actually, when i first read it, i draw the layout in my head and couldn't look other way, since the layout was not specified and the term let it open to interpretation.