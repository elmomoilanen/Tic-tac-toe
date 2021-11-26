# Tic-tac-toe #

Tic-tac-toe implementation with Julia and React. Logic is divided into backend and frontend services, Julia being used in the backend to compute bot player's moves in the game board and React in the frontend to provide interactive user interface for the game.

## Usage ##

Currently, app is directly usable only in development mode.

To run the app, make sure to have Docker and Docker compose installed and run the following command in a shell

```bash
docker compose -f docker-compose.yml up --build
```

After the services have started, open localhost:3000.

When finished with the app, bring everything down and remove containers and volumes by running

```bash
docker compose down --volumes
```
