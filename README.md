# Turing Feedback API
The backend data source for Turing's FeedbackLoop Service

Base url: https://turing-feedback-api.herokuapp.com

## Users Endpoints
- `POST /api/v1/users`

   Purpose: To trigger a refresh of the users and cohorts data stored in our database
   
   Params: None

- `GET /api/v1/users`

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

## Surveys Endpoints
- `POST /api/v1/surveys'
   
