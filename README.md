# Turing Feedback API
The backend data source for Turing's FeedbackLoop Service

For instructions on installation and requirements, see [Getting Started](#getting-started)

## Endpoints

Base url: https://api.turingfeedback.com

[POST /api/v1/users/register](#post-apiv1usersregister)

[POST /api/v1/users/login](#post-apiv1userslogin)

[POST /api/v1/users](#post-apiv1users)

[GET /api/v1/students](#get-apiv1students)

[GET /api/v1/cohorts](#post-apiv1cohorts)

[POST /api/v1/surveys](#post-apiv1surveys)

[GET /api/v1/surveys](#post-apiv1surveys)

[GET /api/v1/surveys/:id](#post-apiv1surveysid)

[GET /api/v1/surveys/:id/averages](#get-apiv1surveysidaverages)

[GET /api/v1/surveys/:id/user-averages](#get-apiv1surveysiduser_averages)

[GET /api/v1/surveys/pending](#post-apiv1surveyspending)

[GET /api/v1/surveys/history](#post-apiv1surveyshistory)

[POST /api/v1/responses](#post-apiv1responses)

## For Routes Requiring Authorization:

In the event that an API key is invalid or not provided on routes where the presence of an API key is mandated, you will receive a `401` status code and the following message:

``` JSON
{
  "error": "Invalid API Key"
}
```

## POST /api/v1/users/register

Purpose: To register a new user with an email address and password

Params: None

Sample Request Body:
```
{
   "fullName": "April Dagonese",
   "role": "Student",
   "email": "dagonese@email.com",
   "password": "test"
}
```
Sample Response:
```
{
    "api_key": "6d07603f-c6d8-47e7-b48b-2fea92eb51e5",
    "full_name": "April Dagonese",
    "id": 2,
    "role": "Student"
}
```

## POST /api/v1/users/login

Purpose: To authorize a user by their email address and password, and return their api_key if valid

Params: None

Sample Request Body:
```
{
   "email": "dagonese@email.com",
   "password": "test"
}
```
Sample Response:
```
{
    "api_key": "6d07603f-c6d8-47e7-b48b-2fea92eb51e5",
    "full_name": "April Dagonese",
    "id": 2,
    "role": "Student"
}
```

## POST /api/v1/users

Purpose: To trigger a refresh of the users and cohorts data stored in our database

Params: None

## GET /api/v1/students

Purpose: To retrieve all users stored in the database, with optional params

Optional Params:
- `/api/v1/students?program=b`
- `/api/v1/students?program=f`
- `/api/v1/students?cohort=1811`
- `/api/v1/students?cohort=1903`

Sample Response:

   ``` JSON
   [
    {
        "cohort": "1903",
        "id": 48,
        "name": "William Homer",
        "program": "B",
        "status": "Active"
    },
    {
        "cohort": "1903",
        "id": 49,
        "name": "Katherine Williams",
        "program": "F",
        "status": "Active"
    }
   ]
   ```

## GET /api/v1/cohorts

Purpose: To retrieve a list of all active cohorts.

Params: None

Sample Response:
``` JSON
   [
    {
        "id": 13,
        "name": "1903",
        "status": "Active"
    },
    {
        "id": 2,
        "name": "1901",
        "status": "Active"
    },
    {
        "id": 28,
        "name": "1904",
        "status": "Active"
    },
    {
        "id": 1,
        "name": "1811",
        "status": "Active"
    }
   ]
```

## POST /api/v1/surveys

Purpose: To store a survey to the account of the user whose api_key is supplied as a param, with survey data in the request body

Required Params: `api_key={USER_API_KEY_HERE}`

Sample Request Body:
   ``` JSON
   {
  "api_key": "aP1-k3Y-g0es-here",
  "survey":
    {
      "surveyName": "Test",
      "status": "closed",
      "surveyExpiration": "2019-06-23T21:27:31",
      "questions": [
        {
          "id": 1,
          "questionTitle": "How well did this person communicate with the rest of the team?",
          "options": [
            { "option_1": {
            	"pointValue": 1,
              "description": "The person did not follow up regularly and often demonstrated unclear or inconsistent communication."
            	}
            },
            {
              "option_2": {
              	  "pointValue": 2,
            	 "description": "The person was mostly consistent but was sometimes unclear in a way that slowed down the team or created frustration."
              }
            },
            {
              "option_3": {
              	 "value": 3,
              "description": "The person overall contributed positively in terms of communication."
              }
            },
            {
            	"option_4": {
            		"value": 4,
              "description": "The person demonstrated clear and timely communication very consistently."
            	}
            }
          ]
        }
      ],
      "groups": [
        {
          "name": "Team1",
          "members_ids": [
            "7", "12", "4", "11"
          ]
        },
        {
          "name": "Team2",
          "members_ids": [
            "2", "13", "17", "9"
          ]
        }
      ]
    }
}
   ```
## GET /api/v1/surveys

Purpose: To retrieve all surveys associated with the user whose api_key is supplied as a query param.

Required Params: `api_key={USER_API_KEY_HERE}`

Sample Response Body:
   ``` JSON
   {
     "api_key": "lkj4264lkmlkj98so9oug",
     "surveys": [
       {
         "id": 1,
         "status": "closed",
         "surveyExpiration": "Mon May 20 2019 17:43:49 GMT-0600 (Mountain Daylight Time)",
         "created_at": "Sat May 18 2019 17:43:49 GMT-0600 (Mountain Daylight Time)",
         "updated_at": "Sat May 18 2019 17:43:49 GMT-0600 (Mountain Daylight Time)",
         "questions": [
           {
             "id": 1,
             "questionTitle": "How well did this person communicate with the rest of the team?",
             "options": [
               {
                 "id": 1,
                 "pointValue": 1,
                 "description": "The person did not follow up regularly and often demonstrated unclear or inconsistent communication."
               },
               {
                 "id": 2,
                 "pointValue": 2,
                 "description": "The person was mostly consistent but was sometimes unclear in a way that slowed down the team or created frustration."
               },
               {
                 "id": 3,
                 "pointValue": 3,
                 "description": "The person overall contributed positively in terms of communication."
               },
               {
                 "id": 4,
                 "pointValue": 4,
                 "description": "The person demonstrated clear and timely communication very consistently."
               },
             ]
           }
         ],
         "groups": [
           {
             "name": "Team1",
             "members": [
               {
                 "id": 7,
                 "name": "Peter Lapicola",
                 "cohort": "1811",
                 "program": "B",
                 "status": "Active"
               },
               {
                 "id": 8,
                 "name": "April Dagonese",
                 "cohort": "1811",
                 "program": "B",
                 "status": "Active"
               },
               {
                 "id": 9,
                 "name": "Scott Thomas",
                 "cohort": "1811",
                 "program": "B",
                 "status": "Active"
               }
             ],
           },
           {
             "name": "Team2",
             "members": [
               {
                 "id": 10,
                 "name": "Peregrine Reed",
                 "cohort": "1811",
                 "program": "B",
                 "status": "Active"
               },
               {
                 "id": 11,
                 "name": "Ty Mazey",
                 "cohort": "1811",
                 "program": "B",
                 "status": "Active"
               },
               {
                 "id": 12,
                 "name": "Zach Nager",
                 "cohort": "1811",
                 "program": "B",
                 "status": "Active"
               }
             ]
           }
         ]
       }
     ]
   }
 ```
## GET /api/v1/surveys/:id

Purpose: To retrieve a survey based on id.

Required Params: None

Sample Response Body:
   ``` JSON
 {
   "id": 1,
   "status": "closed",
   "surveyExpiration": "Mon May 20 2019 17:43:49 GMT-0600 (Mountain Daylight Time)",
   "created_at": "Sat May 18 2019 17:43:49 GMT-0600 (Mountain Daylight Time)",
   "updated_at": "Sat May 18 2019 17:43:49 GMT-0600 (Mountain Daylight Time)",
   "questions": [
     {
       "id": 1,
       "questionTitle": "How well did this person communicate with the rest of the team?",
       "options": [
         {
           "id": 1,
           "pointValue": 1,
           "description": "The person did not follow up regularly and often demonstrated unclear or inconsistent communication."
         },
         {
           "id": 2,
           "pointValue": 2,
           "description": "The person was mostly consistent but was sometimes unclear in a way that slowed down the team or created frustration."
         },
         {
           "id": 3,
           "pointValue": 3,
           "description": "The person overall contributed positively in terms of communication."
         },
         {
           "id": 4,
           "pointValue": 4,
           "description": "The person demonstrated clear and timely communication very consistently."
         },
       ]
     }
   ],
   "groups": [
     {
       "name": "Team1",
       "members": [
         {
           "id": 7,
           "name": "Peter Lapicola",
           "cohort": "1811",
           "program": "B",
           "status": "Active"
         },
         {
           "id": 8,
           "name": "April Dagonese",
           "cohort": "1811",
           "program": "B",
           "status": "Active"
         },
         {
           "id": 9,
           "name": "Scott Thomas",
           "cohort": "1811",
           "program": "B",
           "status": "Active"
         }
       ],
     },
     {
       "name": "Team2",
       "members": [
         {
           "id": 10,
           "name": "Peregrine Reed",
           "cohort": "1811",
           "program": "B",
           "status": "Active"
         },
         {
           "id": 11,
           "name": "Ty Mazey",
           "cohort": "1811",
           "program": "B",
           "status": "Active"
         },
         {
           "id": 12,
           "name": "Zach Nager",
           "cohort": "1811",
           "program": "B",
           "status": "Active"
         }
       ]
     }
   ]
 }
 ```

## GET /api/v1/surveys/:id/averages

Purpose: To retrieve the average response values for a survey

Params: None

Sample Response:
``` JSON
{
  "averages": [
    {
      "question_id": 42,
      "questionTitle": "Pick a number between one and four",
      "average_rating": 3.3333333333333333
    }
  ],
  "survey": {
    "id": 1,
    "surveyName": "Test survey",
    "surveyExpiration": null,
    "created_at": "2019-05-23T05:24:58",
    "updated_at": "2019-05-23T05:24:58",
    "status": "Active",
    "questions": [
      {
        "id": 42,
        "questionTitle": "Pick a number between one and four",
        "options": [
          {"description": "Four", "value": 4},
          {"description": "Three", "value": 3},
          {"description": "Two", "value": 2},
          {"description": "One", "value": 1}
        ]
      }
    ],
    "groups": [
      {
        "name": "Team1",
        "members": [{
            "id": 7,
            "name": "Peter Lapicola",
            "cohort": "1811",
            "program": "B",
            "status": "Active"
          },
          {
            "id": 8,
            "name": "April Dagonese",
            "cohort": "1811",
            "program": "B",
            "status": "Active"
          },
          {
            "id": 9,
            "name": "Scott Thomas",
            "cohort": "1811",
            "program": "B",
            "status": "Active"
          }
        ],
      }
    ]
  }
}

```

## GET /api/v1/surveys/:id/user_averages

Purpose: To retrieve the average response values for a survey

Params: None

Sample Response:
``` JSON
{
  "averages": [
    {
      "average_rating": 3.5000000000000000,
      "question_id": 42,
      "user_id": 1,
      "fullName": "Peter Lapicola"
    },
    {
      "average_rating": 3.0000000000000000,
      "question_id": 42,
      "user_id": 2,
      "fullName": "April Dagonese"
      }
    ],
    "survey": {
      "created_at": "2019-05-23T05:24:58",
      "surveyExpiration": null,
      "groups": [
        {
          "name": "Test",
          "members": [
            {
              "id": 1,
              "name": "Peter Lapicola",
              "cohort": "1811",
              "program": "B",
              "status": "Active"
            },
            {
              "id": 2,
              "name": "April Dagonese",
              "cohort": "1811",
              "program": "B",
              "status": "Active"
            },
            {
              "id": 3,
              "name": "Scott Thomas",
              "cohort": "1811",
              "program": "B",
              "status": "Active"
            }
          ]
        }
      ],
      "id": 1,
      "surveyName": "Test Survey",
      "questions": [
        {
          "options": [
            {
              "description": "Four",
              "pointValue": 4
            },
            {
              "description": "Three",
              "pointValue": 3
            },
            {
              "description": "Two",
              "pointValue": 2
            },
            {
              "description": "One",
              "pointValue": 1
            }
          ],
        "id": 42,
        "questionTitle": "Pick a number between one and four"
      }
    ],
    "status": "Active",
    "updated_at": "2019-05-23T05:24:58"
  }
}
```

## GET /api/v1/surveys/:id/user_averages

Purpose: To retrieve the average response values for a survey

Params: `api_key={USER_API_KEY_HERE}`

Sample Response:
``` JSON
{
  "averages": [
    {
      "average_rating": 3.5000000000000000,
      "question_id": 42,
      "user_id": 1,
      "fullName": "Peter Lapicola"
    },
    ],
    "survey": {
      "created_at": "2019-05-23T05:24:58",
      "surveyExpiration": null,
      "groups": [
        {
          "name": "Test",
          "members": [
            {
              "id": 1,
              "name": "Peter Lapicola",
              "cohort": "1811",
              "program": "B",
              "status": "Active"
            },
            {
              "id": 2,
              "name": "April Dagonese",
              "cohort": "1811",
              "program": "B",
              "status": "Active"
            },
            {
              "id": 3,
              "name": "Scott Thomas",
              "cohort": "1811",
              "program": "B",
              "status": "Active"
            }
          ]
        }
      ],
      "id": 1,
      "surveyName": "Test Survey",
      "questions": [
        {
          "options": [
            {
              "description": "Four",
              "pointValue": 4
            },
            {
              "description": "Three",
              "pointValue": 3
            },
            {
              "description": "Two",
              "pointValue": 2
            },
            {
              "description": "One",
              "pointValue": 1
            }
          ],
        "id": 42,
        "questionTitle": "Pick a number between one and four"
      }
    ],
    "status": "Active",
    "updated_at": "2019-05-23T05:24:58"
  }
}
```

## GET /api/v1/surveys/pending

Purpose: To retrieve the pending surveys to be completed for a user

Params: `api_key={USER_API_KEY_HERE}`

Sample Response:
``` JSON
[
  {
    "groups": [
      {
        "name": "Team1",
        "members": [
          {
            "id": 8,
            "name": "April Dagonese",
            "cohort": "1811",
            "program": "B",
            "status": "Active"
          },
          {
            "id": 9,
            "name": "Scott Thomas",
            "cohort": "1811",
            "program": "B",
            "status": "Active"
          }
        ]
      }
    ],
    "surveyName": "Test Survey",
    "id": 12,
    "surveyExpiration": null,
    "created_at": "2019-05-23T05:24:58",
    "updated_at": "2019-05-23T05:24:58",
    "questions": [
      {
        "options": [
          {
            "description": "Four",
            "pointValue": 4
          },
          {
            "description": "Three",
            "pointValue": 3
          },
          {
            "description": "Two",
            "pointValue": 2
          },
          {
            "description": "One",
            "pointValue": 1
          }
        ],
        "id": 42,
        "questionTitle": "Pick a number between one and four"
      }
    ],
    "status": "Active"
  }
]
```

## GET /api/v1/surveys/history

Purpose: To retrieve the completed and pending surveys to be completed for a user

Params: `api_key={USER_API_KEY_HERE}`

Sample Response:
``` JSON
[
  {
    "groups": [
      {
        "name": "Team1",
        "members": [
          {
            "id": 8,
            "name": "April Dagonese",
            "cohort": "1811",
            "program": "B",
            "status": "Active"
          },
          {
            "id": 9,
            "name": "Scott Thomas",
            "cohort": "1811",
            "program": "B",
            "status": "Active"
          }
        ]
      }
    ],
    "surveyName": "Test Survey",
    "id": 12,
    "surveyExpiration": null,
    "created_at": "2019-05-23T05:24:58",
    "updated_at": "2019-05-23T05:24:58",
    "questions": [
      {
        "options": [
          {
            "description": "Four",
            "pointValue": 4
          },
          {
            "description": "Three",
            "pointValue": 3
          },
          {
            "description": "Two",
            "pointValue": 2
          },
          {
            "description": "One",
            "pointValue": 1
          }
        ],
        "id": 42,
        "questionTitle": "Pick a number between one and four"
      }
    ],
    "status": "closed"
  }
]
```

## POST /api/v1/responses

Purpose: To submit responses on behalf of a user

Params: None

Sample Request:
``` JSON
{
  "api_key": "lk2jlk2jl6",
  "responses": [
    {
      "question": 7,
      "answer": 11,
      "recipient": 2
    },
    {
      "question": 7,
      "answer": 10,
      "recipient": 6
    },
    {
      "question": 7,
      "answer": 9,
      "recipient": 8
    }
  ]
}
```

Sample Response:
``` JSON
{
  "success": "Responses have been stored"
}
```

## Getting Started

### Dependencies

The application requires the following dependencies prior to setup:

- Elixir
- Phoenix
- PostgreSQL

### Initial Setup:

``` bash
mix deps.get # Install Application Dependencies
mix ecto.create # Create database
mix ecto.migrate # Run migrations
mix run ./priv/repo/seeds.exs # Seed the database with users
```

Additionally, the application requires access to the TuringSchool Rooster application. The token for which much be provided in the environment variables for the application.

Once the above has been executed, you can start the server using `ROOSTER_API_KEY={YOUR_ROOSTER_KEY_HERE} mix phx.server`

### Testing

To execute the test suite, run the command `mix test`. Testing is handled through the ExUnit library. The test suite will automatically create and migrate the database when run.

### Known Issues

- User creation is troublesome due to lack of concrete availability for instructor information and student emails. This could be resolved in the future by modifying the applicaiton to use TuringSchool's Census for student information that contains an externally identifiable service to correlate users to.

- Elixir convention regarding directory setup was noted to not be in place.

- Unit testing of model methods should be implemented.

- Testing of services and workers should be implemented.

### Contributing

To contribute to this project, please fork and issue a pull request to the master branch with a note indicating changes made.

### Core Contributors

- @aprildagonese (Author)
- @plapicola (Author)

### Database Schema

![Database Schema](/schema.png)

### Tech Stack

This application was built using the following technologies:

- Elixir
- Phoenix
- ExUnit
- PostgreSQL
- Heroku
- TravisCI
