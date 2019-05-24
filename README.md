# Turing Feedback API
The backend data source for Turing's FeedbackLoop Service

Base url: https://turing-feedback-api.herokuapp.com

###### For any route requiring authorization:

In the event that an API key is invalid or not provided on routes where the presence of an API key is mandated, you will receive a `401` status code and the following message:

``` JSON
{
  "error": "Invalid API Key"
}
```

## `POST /api/v1/users/register`

Purpose: To register a new user with an email address and password

Params: None

Sample Request:
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

## `POST /api/v1/users`

Purpose: To trigger a refresh of the users and cohorts data stored in our database

Params: None

## `GET /api/v1/users`

Purpose: To retrieve all users stored in the database, with optional params

Optional Params:
- `/api/v1/users?program=b`
- `/api/v1/users?program=f`
- `/api/v1/users?cohort=1811`
- `/api/v1/users?cohort=1903`

Sample Response:

   ``` JSON
   [
    {
        "cohort": "1903",
        "id": 48,
        "name": "William Homer",
        "program": "B",
        "status": "active"
    },
    {
        "cohort": "1903",
        "id": 49,
        "name": "Katherine Williams",
        "program": "F",
        "status": "active"
    }
   ]
   ```

## `POST /api/v1/surveys`

Purpose: To store a survey to the account of the user whose api_key is supplied as a param, with survey data in the request body

Required Params: `api_key={USER_API_KEY_HERE}`

Sample Request Body:
   ``` JSON
   {
     "api_key": "lkj4264lkmlkj98so9oug",
     "survey": {
       "name": "1811 Cross-Pollination Project",
       "surveyExpiration": "Mon May 20 2019 17:43:49 GMT-0600 (Mountain Daylight Time)",
       "questions": [
         {
           "id": 1,
           "questionTitle": "How well did this person communicate with the rest of the team?",
           "options": [
             {
               "id": 1,
               "value": 1,
               "description": "The person did not follow up regularly and often demonstrated unclear or inconsistent communication."
             },
             {
               "id": 2,
               "value": 2,
               "description": "The person was mostly consistent but was sometimes unclear in a way that slowed down the team or created frustration."
             },
             {
               "id": 3,
               "value": 3,
               "description": "The person overall contributed positively in terms of communication."
             },
             {
               "id": 4,
               "value": 4,
               "description": "The person demonstrated clear and timely communication very consistently."
             },
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
## `GET /api/v1/surveys`

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
     ]
   }
   ```
## `GET /api/v1/cohorts`

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

## `GET /api/v1/surveys/averages`

Purpose: To retrive the average response values for a survey

Params: None

Sample Response:
``` JSON
{
  "survey": {
    "id": 1,
    "surveyName": "Test survey",
    "surveyExpiration": null,
    "created_at": "2019-05-23T05:24:58",
    "updated_at": "2019-05-23T05:24:58",
    "status": "active",
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
          "member_ids": [1, 2, 3],
          "name": "Test"
        }
      ]
    },
    "averages": [
      {
        "question_id": 42,
        "questionTitle": "Pick a number between one and four",
        "average_rating": 3.3333333333333333
      }
    ]
  }
```

## `GET /api/v1/surveys/user_averages`

Purpose: To retrive the average response values for a survey

Params: None

Sample Response:
``` JSON
{
  "averages": [
    {
      "average_rating": 3.5000000000000000,
      "question_id": 42,
      "user_id": 1
    },
    {
      "average_rating": 3.0000000000000000,
      "question_id": 42,
      "user_id": 2
      }
    ],
    "survey": {
      "created_at": "2019-05-23T05:24:58",
      "surveyExpiration": null,
      "groups": [
        {
          "member_ids": [1, 2, 3],
          "name": "Test"
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
    "status": "active",
    "updated_at": "2019-05-23T05:24:58"
  }
}
```

## `GET /api/v1/surveys/pending`

Purpose: To retrieve the pending surveys to be completed for a user

Params: `api_key={USER_API_KEY_HERE}`

Sample Response:
``` JSON
[
  {
    "groups": [
      {
        "member_ids": [2, 3],
        "name": "Test"
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
    "status": "active"
  }
]
```
