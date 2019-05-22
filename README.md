# Turing Feedback API
The backend data source for Turing's FeedbackLoop Service

Base url: https://turing-feedback-api.herokuapp.com

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
   
   ```
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
   ```
   {
     "api_key": "lkj4264lkmlkj98so9oug",
     "name": "1811 Cross-Pollination Project",
     "exp_date": "Mon May 20 2019 17:43:49 GMT-0600 (Mountain Daylight Time)",
     "questions": [
       {
         "id": 1,
         "text": "How well did this person communicate with the rest of the team?",
         "answers": [
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
             "description": "The person demonstrated demonstrated clear and timely communication very consistently."
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
   ```
## `GET /api/v1/surveys`

   Purpose: To retrieve all surveys associated with the user whose api_key is supplied as a query param.
   
   Required Params: `api_key={USER_API_KEY_HERE}`
   
   Sample Response Body:
   ```
   {
     "api_key": "lkj4264lkmlkj98so9oug",
     "surveys": [
       {
         "id": 1,
         "status": "closed",
         "exp_date": "Mon May 20 2019 17:43:49 GMT-0600 (Mountain Daylight Time)",
         "created_at": "Sat May 18 2019 17:43:49 GMT-0600 (Mountain Daylight Time)",
         "updated_at": "Sat May 18 2019 17:43:49 GMT-0600 (Mountain Daylight Time)",
         "questions": [
           {
             "id": 1,
             "text": "How well did this person communicate with the rest of the team?",
             "answers": [
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
                 "description": "The person demonstrated demonstrated clear and timely communication very consistently."
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

