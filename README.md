# Turing Feedback API
The backend data source for Turing's FeedbackLoop Service

Base url: https://turing-feedback-api.herokuapp.com

## Users Endpoints
- POST /api/v1/users

   Purpose: To trigger a refresh of the users and cohorts data stored in our database
   
   Params Required: None

- GET /api/v1/users

   Purpose: To retrieve all users stored in the database, with optional params
   
