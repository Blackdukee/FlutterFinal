
### API Endpoints

| HTTP Method | Endpoint                        | Description                    | Returns                             |
|-------------|---------------------------------|--------------------------------|-------------------------------------|
| POST        | `/diets`                        | Create a new diet              | JSON object containing the diet     |
| GET         | `/diets`                        | Retrieve all diets             | JSON array of diet objects          |
| GET         | `/diets?category={category}`    | Retrieve diets by category     | JSON array of diet objects          |
| GET         | `/diets?filters={filters}`      | Retrieve diets with filters    | JSON array of diet objects          |
| GET         | `/diets?query={query}`          | Retrieve diets with query      | JSON array of diet objects          |
| GET         | `/diets/{id}`                   | Retrieve a diet by ID          | JSON object containing the diet     |
| POST        | `/users`                        | Create a new user              | JSON object containing the user     |
| POST        | `/users/login`                  | Retrieve a user (login)        | JSON object containing the user     |
| PUT         | `/users/{id}`                   | Update a user                  | JSON object containing the updated user |
| GET         | `/users/{userId}/history`       | Retrieve user history          | JSON array of diet history objects  |
| GET         | `/users/{userId}/saved-recipes` | Retrieve user's saved recipes  | JSON array of saved recipe objects  |
| POST        | `/categories`                   | Create a new category          | JSON object containing the category |
| GET         | `/categories`                   | Retrieve all categories        | JSON array of category objects      |


### Request Parameters

| HTTP Method | Endpoint                        | Request Body                   |
|-------------|---------------------------------|--------------------------------|
| POST        | `/diets`                        | `{ "name": "string", "category": "string", "calories": "number" }` |
| GET         | `/diets`                        | None                           |
| GET         | `/diets?category={category}`    | None                           |
| GET         | `/diets/{id}`                   | None                           |
| GET         | `/diets?filters={filters}`      | `{ "filters": "string" }`      |
| GET         | `/diets?query={query}`          | `{ "query": "string" }`        |
| POST        | `/users`                        | `{ "username": "string", "password": "string", "email": "string" }` |
| POST        | `/users/login`                  | `{ "email": "string", "password": "string" }` |
| PUT         | `/users/{id}`                   | `{ "username": "string", "password": "string" }` |
| GET         | `/users/{userId}/history`       | `{ "userId" : "int" }`                          |
| GET         | `/users/{userId}/saved-recipes` | `{ "userId" : "int" }`      |
| POST        | `/categories`                   | `{ "name": "string" , "iconPath" : "string" , "boxColor": "string"  }`         |
| GET         | `/categories`                   | None                           |

