using Genie
using Genie.Router, Genie.Requests, Genie.Renderer.Json
using HTTP

include("./MiniMax.jl")
using .MiniMax: play_bot_turn!, State, MARK_P1, MARK_P2, MARK_TIE, MARK_EMPTY

const TransformIndex = Int8[1 2 3; 4 5 6; 7 8 9];
const TransformWinner =
    Dict{Int8,String}(MARK_P1 => "player_1", MARK_P2 => "player_2", MARK_TIE => "tie")


route("/api/game/v1", method = POST) do
    game_type::String = getpayload(:type, "normal")
    payload::Dict{String,Any} = jsonpayload()

    if length(get(payload, "board", [])) == 9
        raw_array::Array{Int,1} = payload["board"]
        # need to take transpose of the board now and before returning the updated version
        game_board::Array{Int8,2} = reshape(convert(Array{Int8,1}, raw_array), (3, 3))'

        game_state::State = play_bot_turn!(game_board, game_type)

        winner::String = get(TransformWinner, game_state.winner, "open")
        last_entry::Int =
            (game_state.last_entry > 0) ? Int(TransformIndex[game_state.last_entry]) :
            Int(0)
        board::Array{Int,1} = convert(Array{Int,1}, reshape(game_state.board', (9,)))

        response::Dict{String,Union{String,Int,Array{Int,1}}} =
            Dict{String,Union{String,Int,Array{Int,1}}}(
                "winner" => winner,
                "bot_last_entry" => last_entry,
                "board" => board,
            )

        json(response)
    else
        "Payload must contain an array of length nine with key `board`."
    end
end

route("/api/game/v1", method = GET) do
    """Hello from game backend!

    Play bot's turn by making a POST request with status of the current game board as payload.
    This payload must be an one-dimensional array, length of nine, and provided by key `board`.
    Mark your moves in the board by -1, bot will use 1 to mark its latest move."""
end

function force_compile()
    sleep(5) # allow the server to start before running the following
    HTTP.request("GET", "http://localhost:8000/api/game/v1")
    HTTP.request(
        "POST",
        "http://localhost:8000/api/game/v1?type=normal",
        [("Content-Type", "application/json")],
        """{"board":[0,0,0,0,0,0,0,0,0]}""",
    )
end

function main()
    println("running the server...")

    @async force_compile()

    up(8000, "0.0.0.0", async = false)
end


if abspath(PROGRAM_FILE) == @__FILE__
    println("running main...")
    main()
else
    println("not running main...")
end
