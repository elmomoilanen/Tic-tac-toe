module MiniMax

export play_bot_turn!, State, MARK_P1, MARK_P2, MARK_TIE, MARK_EMPTY

using Random

const MARK_P1 = Int8(1)
const MARK_P2 = Int8(-1)
const MARK_EMPTY = Int8(0)
const MARK_TIE = Int8(2)

const ONE = Int8(1)

const IdxTable = Int8[1, 2, 3, 4, 5, 6, 7, 8, 9]

mutable struct State
    player::Int8
    winner::Int8
    last_entry::Int8
    board::Array{Int8,2}
end


function play_bot_turn!(board::Array{Int8,2}, game_type::String = "normal")::State
    state = State(MARK_P1, MARK_EMPTY, MARK_EMPTY, copy(board))

    find_optimal_move!(state, game_type)

    state
end

function find_optimal_move!(state::State, game_type::String)
    init_depth::Int8 = sum(==(MARK_EMPTY), state.board)

    if init_depth == length(state.board)
        mid_cell::Int8 = ceil(length(state.board) / 2)

        state.board[mid_cell] = state.player
        state.last_entry = mid_cell
        return
    end

    best_move::Int8 = MARK_EMPTY

    if game_type == "normal"
        α::Int8 = typemin(Int8) # min value that the maximizing player get certainly
        β::Int8 = typemax(Int8) # max value that the minimizing player get certainly

        _, best_move = minimax!(state, init_depth, α, β, true)
    else
        best_move = novice_move(state)
    end

    state.last_entry = best_move

    if state.last_entry > MARK_EMPTY
        state.board[state.last_entry] = state.player
    end

    win_state::Int8 = compute_win_state(state)

    if win_state == 0 && sum(==(MARK_EMPTY), state.board) == 0
        state.winner = MARK_TIE
    else
        state.winner = win_state
    end

end

function minimax!(
    state::State,
    depth::Int8,
    α::Int8,
    β::Int8,
    maximize::Bool,
)::Tuple{Int8,Int8}
    win_state::Int8 = compute_win_state(state)

    if win_state == MARK_P1 || win_state == MARK_P2 || depth == 0
        return win_state * (depth + 1), Int8(0)
    end

    best_entry::Int8 = 0
    best_value::Int8 = (maximize == true) ? typemin(Int8) : typemax(Int8)
    current_player::Int8 = state.player

    allowed_entries::Array{Int8,1} = allowed_board_entries(state)

    for entry in allowed_entries
        state.board[entry] = current_player
        state.player = next_player(current_player)

        if maximize == true
            value, _ = minimax!(state, depth - ONE, α, β, false)

            if value > best_value
                best_value = value
                best_entry = entry
            end

            state.board[entry] = MARK_EMPTY
            state.player = current_player

            if β <= α # prune rest branches
                break
            end
            α = max(α, best_value)
        else
            value, _ = minimax!(state, depth - ONE, α, β, true)

            if value < best_value
                best_value = value
                best_entry = entry
            end

            state.board[entry] = MARK_EMPTY
            state.player = current_player

            if β <= α # prune rest branches
                break
            end
            β = min(β, best_value)
        end
    end

    best_value, best_entry
end

function allowed_board_entries(state::State)::Array{Int8,1}
    entries::Array{Int8,1} = []

    for cell::Int8 = 1:length(state.board)
        if state.board[cell] == MARK_EMPTY
            push!(entries, cell)
        end
    end

    shuffle(entries)
end

function next_player(player::Int8)::Int8
    (player == MARK_P1) ? MARK_P2 : MARK_P1
end

function compute_win_state(state::State)::Int8
    rows = size(state.board)[begin]
    cols = size(state.board)[end]

    row_states = [
        all(state.board[r, begin] .== state.board[r, :]) ? state.board[r, begin] :
        MARK_EMPTY for r = 1:rows
    ]
    col_states = [
        all(state.board[begin, c] .== state.board[:, c]) ? state.board[begin, c] :
        MARK_EMPTY for c = 1:cols
    ]

    diag_state =
        (
            state.board[begin, begin] == state.board[2, 2] &&
            state.board[2, 2] == state.board[end, end]
        ) ? state.board[begin, begin] : MARK_EMPTY
    antidiag_state =
        (
            state.board[begin, end] == state.board[2, 2] &&
            state.board[2, 2] == state.board[end, begin]
        ) ? state.board[begin, end] : MARK_EMPTY

    max_state::Int8 = max(row_states..., col_states..., diag_state, antidiag_state)
    min_state::Int8 = min(row_states..., col_states..., diag_state, antidiag_state)

    (max_state > MARK_EMPTY) ? max_state : min_state
end

function novice_move(state::State)::Int8
    free_indices::Array{Int8,1} =
        filter(x -> x > 0, reshape(state.board .== 0, (length(state.board),)) .* IdxTable)

    (length(free_indices) == 0) ? Int8(0) : shuffle(free_indices)[begin]
end

end
