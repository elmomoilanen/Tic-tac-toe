import React, { useState } from "react";
import "./App.css";

const baseURL = "/api/game";

const PLAYER_1_MARK = 1; // marks must be compatible with backend
const PLAYER_2_MARK = -1;
const PLAYER_1_NAME = "Bot";
const PLAYER_2_NAME = "Player 2";

async function play_bot_turn(boardState, game_type) {
  const query_params = {
    type: game_type,
  };
  const query_string = Object.keys(query_params)
    .map(
      (key) =>
        encodeURIComponent(key) + "=" + encodeURIComponent(query_params[key])
    )
    .join("&");

  const url = baseURL + "?" + query_string;

  try {
    const response = await fetch(url, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Accept: "application/json",
      },
      body: JSON.stringify({ board: boardState }),
    });

    if (!response.ok) {
      throw new Error(`HTTP error: ${response.status}`);
    }

    const data = await response.json();

    if (typeof data !== "object") {
      throw new Error(`Wrong data type for response: ${typeof data}`);
    }

    return data;
  } catch (err) {
    console.error(err);

    return "error";
  }
}

const HelpView = ({ showView }) => {
  return (
    <div className="help-view">
      <button onClick={() => showView(false)}>X</button>
      <div className="text">
        Welcome to play Tic-tac-toe!
        <br />
        <br />
        You will play against a bot and the player who manages to place three of
        their marks in a horizontal, vertical or diagonal row is the winner of
        the game. Game board is a three-by-three grid. You may choose to play a
        normal game in which the bot plays optimally and thus the game can
        result in draw at best or an easy game in which either player can win as
        the bot plays like a novice.
      </div>
    </div>
  );
};

const WinView = ({ winner, current_game_type, newGame, resetGame }) => {
  return (
    <div className="winning-view">
      <div>Winner: {winner}</div>
      <button onClick={() => newGame(current_game_type)}>Play again</button>
      <button onClick={resetGame}>Start view</button>
    </div>
  );
};

const GameCell = ({ state, id, handleClick }) => {
  if (state === 0) {
    return (
      <div
        className="game-cell"
        id={id}
        onClick={() => handleClick(id)}
        data-cell
      ></div>
    );
  } else {
    let className = "game-cell";
    if (state === PLAYER_1_MARK) {
      // bot has played this cell
      className += " circle-symbol";
    } else {
      // player 2 has played this cell
      className += " x-symbol";
    }
    return <div className={className} id={id} data-cell></div>;
  }
};

const GamePlay = ({ game_type, updateStatus, updateWinner }) => {
  const [boardState, setBoardState] = useState([0, 0, 0, 0, 0, 0, 0, 0, 0]);

  const handleClick = async (id) => {
    const cell_id = id.split("_")[1];
    const player_move = parseInt(cell_id);

    let newBoard = boardState.slice();
    newBoard[player_move - 1] = PLAYER_2_MARK;
    let winner = "open";

    await play_bot_turn(newBoard, game_type)
      .then((resp) => {
        if (resp === "error") {
          alert("Error during bot's turn!");
        } else {
          newBoard = resp.board;
          winner = resp.winner;
        }
      })
      .catch(() => {
        console.error("error during backend post request.");
      });
    setBoardState(newBoard);
    if (winner !== "open") {
      updateStatus("completed");
      updateWinner(winner);
    }
  };

  return (
    <div className="game-board x-symbol" id="board">
      <GameCell state={boardState[0]} id="cell_1" handleClick={handleClick} />
      <GameCell state={boardState[1]} id="cell_2" handleClick={handleClick} />
      <GameCell state={boardState[2]} id="cell_3" handleClick={handleClick} />

      <GameCell state={boardState[3]} id="cell_4" handleClick={handleClick} />
      <GameCell state={boardState[4]} id="cell_5" handleClick={handleClick} />
      <GameCell state={boardState[5]} id="cell_6" handleClick={handleClick} />

      <GameCell state={boardState[6]} id="cell_7" handleClick={handleClick} />
      <GameCell state={boardState[7]} id="cell_8" handleClick={handleClick} />
      <GameCell state={boardState[8]} id="cell_9" handleClick={handleClick} />
    </div>
  );
};

export default function App() {
  const [gameStatus, setGameStatus] = useState("wait");
  const [gameType, setGameType] = useState("none");
  const [gameWinner, setGameWinner] = useState("open");
  const [helpActive, setHelpActive] = useState(false);

  const startGame = (game_type) => {
    setGameType(game_type);
    setGameStatus("going");
  };
  const resetGame = () => {
    setGameType("none");
    setGameStatus("wait");
    setGameWinner("open");
  };

  const showHelp = () => {
    setHelpActive(true);
  };

  const updateGameStatus = (value) => {
    setGameStatus(value);
  };
  const updateGameWinner = (value) => {
    let winner = "open";
    if (value !== winner) {
      winner =
        value === "player_1"
          ? PLAYER_1_NAME
          : value === "player_2"
          ? PLAYER_2_NAME
          : "Tie";
    }
    setGameWinner(winner);
  };

  if (helpActive === true) {
    return (
      <div className="app-help">
        <HelpView showView={setHelpActive} />
      </div>
    );
  }

  if (gameStatus === "going") {
    return (
      <div className="app-going">
        <GamePlay
          game_type={gameType}
          updateStatus={updateGameStatus}
          updateWinner={updateGameWinner}
        />
      </div>
    );
  }

  if (gameStatus === "completed") {
    const winnerName = gameWinner === PLAYER_2_NAME ? "You" : gameWinner;
    return (
      <div className="app-completed">
        <WinView
          winner={winnerName}
          current_game_type={gameType}
          newGame={startGame}
          resetGame={resetGame}
        />
      </div>
    );
  }

  return (
    <div className="app-start">
      <div className="start-view">
        <button onClick={() => startGame("normal")}>Normal game</button>
        <button onClick={() => startGame("easy")}>Easy game</button>
        <button onClick={showHelp}>Help</button>
      </div>
    </div>
  );
}
