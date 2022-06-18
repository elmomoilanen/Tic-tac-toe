### Backend ###

Backend service for the app. Responsible of computing bot player's next move in the game board which is done by applying the minimax algorithm with alpha-beta pruning. Julia's Genie web framework is used to provide the web server enabling communication with the frontend service of the game.

---

It's possible to play the game against the backend only though this might not be the most convenient way.

To do this, build first an image from the Dockerfile

```bash
docker build -f Dockerfile -t tic-tac-toe/backend:latest .
```

and after that start the server as follows

```bash
docker run -p 127.0.0.1:8000:8000 --rm tic-tac-toe/backend julia ./src/Server.jl
```

Server running in the container listens port 8000 and thus the latter port should not be changed. This port was bound also to port 8000 on 127.0.0.1 of the host machine.

On success, previous run command should result few initial prints to stdout indicating that the server started and completed couple test requests (used to force compile the backend).

---

To finally the play the game, notice that the bot player uses number 1 to mark its movements on the board and you must use number -1. Zeros on the board indicate empty slots. Board itself must be passed as an array of 9 elements (3x3 board) such that the first three elements correspond to the first row etc.

Start the game by sending the first POST request as follows

```bash
curl -X 'POST' http://localhost:8000/api/game/ -H 'Accept: application/json' -H 'Content-Type: application/json' -d '{"board": [0,0,0,0,-1,0,0,0,0]}'
```

Data payload shows that you played slot 5 (second row and column) of the board. As a response you will receive current status of the game, after bot's latest movement. This can be e.g.

```bash
{"bot_last_entry":3,"winner":"open","board":[0,0,1,0,-1,0,0,0,0]}
```

which shows that bot played slot 3 and the game is still open. As the backend server is stateless it doesn't remember status of the game and you must always send the most recent board as part of the POST request. E.g. you could make your next movement by marking the first slot and then data payload is *[-1,0,1,0,-1,0,0,0,0]*
