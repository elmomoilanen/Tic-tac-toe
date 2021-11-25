using Test

include("../src/MiniMax.jl")
using .MiniMax: play_bot_turn!, State, MARK_P1, MARK_P2, MARK_TIE, MARK_EMPTY


@testset "first move x to 2,2" begin
    # algorithm should update the initially empty board to
    # _ _ _
    # _ x _
    # _ _ _
    empty_board = fill(Int8(0), 3, 3)
    state::State = play_bot_turn!(empty_board)

    @test state.player == MARK_P1

    empty_board[5] = MARK_P1

    @test state.last_entry == Int8(5)
    @test all(state.board .== empty_board)
end

@testset "make move x to 3,2 to win" begin
    # initial game board
    # o x o
    # _ x _
    # x _ o
    game_board = reshape(
        [
            MARK_P2,
            MARK_EMPTY,
            MARK_P1,
            MARK_P1,
            MARK_P1,
            MARK_EMPTY,
            MARK_P2,
            MARK_EMPTY,
            MARK_P2,
        ],
        (3, 3),
    )
    state::State = play_bot_turn!(game_board)

    game_board[6] = MARK_P1

    @test state.last_entry == Int8(6)
    @test all(state.board .== game_board)
    @test state.winner == MARK_P1
end

@testset "make move x to 3,2 to win, second" begin
    # initial game board
    # x x o
    # _ x _
    # o _ o
    game_board = reshape(
        [
            MARK_P1,
            MARK_EMPTY,
            MARK_P2,
            MARK_P1,
            MARK_P1,
            MARK_EMPTY,
            MARK_P2,
            MARK_EMPTY,
            MARK_P2,
        ],
        (3, 3),
    )
    state::State = play_bot_turn!(game_board)

    game_board[6] = MARK_P1

    @test state.last_entry == Int8(6)
    @test all(state.board .== game_board)
    @test state.winner == MARK_P1
end

@testset "make move x to 3,2 to prevent win" begin
    # initial game board
    # x o o
    # o o x
    # x _ _
    game_board = reshape(
        [
            MARK_P1,
            MARK_P2,
            MARK_P1,
            MARK_P2,
            MARK_P2,
            MARK_EMPTY,
            MARK_P2,
            MARK_P1,
            MARK_EMPTY,
        ],
        (3, 3),
    )
    state::State = play_bot_turn!(game_board)

    game_board[6] = MARK_P1

    @test state.last_entry == Int8(6)
    @test all(state.board .== game_board)
    @test state.winner == MARK_EMPTY
end

@testset "make move x to 3,2 to prevent win, second" begin
    # initial game board
    # x o _
    # _ o x
    # _ _ _
    game_board = reshape(
        [
            MARK_P1,
            MARK_EMPTY,
            MARK_EMPTY,
            MARK_P2,
            MARK_P2,
            MARK_EMPTY,
            MARK_EMPTY,
            MARK_P1,
            MARK_EMPTY,
        ],
        (3, 3),
    )
    state::State = play_bot_turn!(game_board)

    game_board[6] = MARK_P1

    @test state.last_entry == Int8(6)
    @test all(state.board .== game_board)
    @test state.winner == MARK_EMPTY
end

@testset "make move x to 1,1 to win" begin
    # initial game board
    # _ o x
    # _ x o
    # o _ x
    game_board = reshape(
        [
            MARK_EMPTY,
            MARK_EMPTY,
            MARK_P2,
            MARK_P2,
            MARK_P1,
            MARK_EMPTY,
            MARK_P1,
            MARK_P2,
            MARK_P1,
        ],
        (3, 3),
    )
    state::State = play_bot_turn!(game_board)

    game_board[1] = MARK_P1

    @test state.last_entry == Int8(1)
    @test all(state.board .== game_board)
    @test state.winner == MARK_P1
end

@testset "make move x to 1,1 to win, second" begin
    # initial game board
    # _ o _
    # _ x _
    # o _ x
    game_board = reshape(
        [
            MARK_EMPTY,
            MARK_EMPTY,
            MARK_P2,
            MARK_P2,
            MARK_P1,
            MARK_EMPTY,
            MARK_EMPTY,
            MARK_EMPTY,
            MARK_P1,
        ],
        (3, 3),
    )
    state::State = play_bot_turn!(game_board)

    game_board[1] = MARK_P1

    @test state.last_entry == Int8(1)
    @test all(state.board .== game_board)
    @test state.winner == MARK_P1
end

@testset "make move x to 1,1 to prevent win" begin
    # initial game board
    # _ o o
    # o x x
    # _ x _
    game_board = reshape(
        [
            MARK_EMPTY,
            MARK_P2,
            MARK_EMPTY,
            MARK_P2,
            MARK_P1,
            MARK_P1,
            MARK_P2,
            MARK_P1,
            MARK_EMPTY,
        ],
        (3, 3),
    )
    state::State = play_bot_turn!(game_board)

    game_board[1] = MARK_P1

    @test state.last_entry == Int8(1)
    @test all(state.board .== game_board)
    @test state.winner == MARK_EMPTY
end

@testset "make move x to 1,1 to prevent win, second" begin
    # initial game board
    # _ o o
    # o x x
    # o x _
    game_board = reshape(
        [
            MARK_EMPTY,
            MARK_P2,
            MARK_P2,
            MARK_P2,
            MARK_P1,
            MARK_P1,
            MARK_P2,
            MARK_P1,
            MARK_EMPTY,
        ],
        (3, 3),
    )
    state::State = play_bot_turn!(game_board)

    game_board[1] = MARK_P1

    @test state.last_entry == Int8(1)
    @test all(state.board .== game_board)
    @test state.winner == MARK_EMPTY
end

@testset "make move x to 2,3 to end the game to draw" begin
    # initial game board
    # x o o
    # o x _
    # x x o
    game_board = reshape(
        [
            MARK_P1,
            MARK_P2,
            MARK_P1,
            MARK_P2,
            MARK_P1,
            MARK_P1,
            MARK_P2,
            MARK_EMPTY,
            MARK_P2,
        ],
        (3, 3),
    )
    state::State = play_bot_turn!(game_board)

    game_board[8] = MARK_P1

    @test state.last_entry == Int8(8)
    @test all(state.board .== game_board)
    @test state.winner == MARK_TIE
end

@testset "make move x to 2,2 to end the game to draw" begin
    # initial game board
    # x o o
    # o _ x
    # x x o
    game_board = reshape(
        [
            MARK_P1,
            MARK_P2,
            MARK_P1,
            MARK_P2,
            MARK_EMPTY,
            MARK_P1,
            MARK_P2,
            MARK_P1,
            MARK_P2,
        ],
        (3, 3),
    )
    state::State = play_bot_turn!(game_board)

    game_board[5] = MARK_P1

    @test state.last_entry == Int8(5)
    @test all(state.board .== game_board)
    @test state.winner == MARK_TIE
end

@testset "make move x to 3,3 to win" begin
    # initial game board
    # x o x
    # o x _
    # o _ _
    game_board = reshape(
        [
            MARK_P1,
            MARK_P2,
            MARK_P2,
            MARK_P2,
            MARK_P1,
            MARK_EMPTY,
            MARK_P1,
            MARK_EMPTY,
            MARK_EMPTY,
        ],
        (3, 3),
    )
    state::State = play_bot_turn!(game_board)

    game_board[9] = MARK_P1

    @test state.last_entry == Int8(9)
    @test all(state.board .== game_board)
    @test state.winner == MARK_P1
end

@testset "make move x to 1,3 to win" begin
    # initial game board
    # o _ _
    # _ o x
    # o _ x
    game_board = reshape(
        [
            MARK_P2,
            MARK_EMPTY,
            MARK_P2,
            MARK_EMPTY,
            MARK_P2,
            MARK_EMPTY,
            MARK_EMPTY,
            MARK_P1,
            MARK_P1,
        ],
        (3, 3),
    )
    state::State = play_bot_turn!(game_board)

    game_board[7] = MARK_P1

    @test state.last_entry == Int8(7)
    @test all(state.board .== game_board)
    @test state.winner == MARK_P1
end

@testset "make move x to 1,3 to prevent win" begin
    # initial game board
    # o _ _
    # x o o
    # o x x
    game_board = reshape(
        [
            MARK_P2,
            MARK_P1,
            MARK_P2,
            MARK_EMPTY,
            MARK_P2,
            MARK_P1,
            MARK_EMPTY,
            MARK_P2,
            MARK_P1,
        ],
        (3, 3),
    )
    state::State = play_bot_turn!(game_board)

    game_board[7] = MARK_P1

    @test state.last_entry == Int8(7)
    @test all(state.board .== game_board)
    @test state.winner == MARK_EMPTY
end

@testset "find out that the opponent has won by diagonal line" begin
    # initial game board
    # o x _
    # x o x
    # o x o
    game_board = reshape(
        [
            MARK_P2,
            MARK_P1,
            MARK_P2,
            MARK_P1,
            MARK_P2,
            MARK_P1,
            MARK_EMPTY,
            MARK_P1,
            MARK_P2,
        ],
        (3, 3),
    )
    state::State = play_bot_turn!(game_board)

    @test state.last_entry == MARK_EMPTY
    @test all(state.board .== game_board)
    @test state.winner == MARK_P2
end

@testset "find out that the opponent has won by antidiagonal line" begin
    # initial game board
    # x x o
    # x o x
    # o _ o
    game_board = reshape(
        [
            MARK_P1,
            MARK_P1,
            MARK_P2,
            MARK_P1,
            MARK_P2,
            MARK_EMPTY,
            MARK_P2,
            MARK_P1,
            MARK_P2,
        ],
        (3, 3),
    )
    state::State = play_bot_turn!(game_board)

    @test state.last_entry == MARK_EMPTY
    @test all(state.board .== game_board)
    @test state.winner == MARK_P2
end

@testset "find out that the game has ended in draw" begin
    # initial game board
    # x o x
    # x o x
    # o x o
    game_board = reshape(
        [MARK_P1, MARK_P1, MARK_P2, MARK_P2, MARK_P2, MARK_P1, MARK_P1, MARK_P1, MARK_P2],
        (3, 3),
    )
    state::State = play_bot_turn!(game_board)

    @test state.last_entry == MARK_EMPTY
    @test all(state.board .== game_board)
    @test state.winner == MARK_TIE
end

@testset "make move x to 2,2 to win" begin
    # initial game board
    # _ x _
    # o _ _
    # _ x o
    game_board = reshape(
        [
            MARK_EMPTY,
            MARK_P2,
            MARK_EMPTY,
            MARK_P1,
            MARK_EMPTY,
            MARK_P1,
            MARK_EMPTY,
            MARK_EMPTY,
            MARK_P2,
        ],
        (3, 3),
    )
    state::State = play_bot_turn!(game_board)

    game_board[5] = MARK_P1

    @test state.last_entry == Int8(5)
    @test all(state.board .== game_board)
    @test state.winner == MARK_P1
end

@testset "make move x to 2,1 to win" begin
    # initial game board
    # o o _
    # _ x x
    # _ _ o
    game_board = reshape(
        [
            MARK_P2,
            MARK_EMPTY,
            MARK_EMPTY,
            MARK_P2,
            MARK_P1,
            MARK_EMPTY,
            MARK_EMPTY,
            MARK_P1,
            MARK_P2,
        ],
        (3, 3),
    )
    state::State = play_bot_turn!(game_board)

    game_board[2] = MARK_P1

    @test state.last_entry == Int8(2)
    @test all(state.board .== game_board)
    @test state.winner == MARK_P1
end

@testset "make move x to 2,1 to win, second" begin
    # initial game board
    # o _ _
    # _ x x
    # o _ o
    game_board = reshape(
        [
            MARK_P2,
            MARK_EMPTY,
            MARK_P2,
            MARK_EMPTY,
            MARK_P1,
            MARK_EMPTY,
            MARK_EMPTY,
            MARK_P1,
            MARK_P2,
        ],
        (3, 3),
    )
    state::State = play_bot_turn!(game_board)

    game_board[2] = MARK_P1

    @test state.last_entry == Int8(2)
    @test all(state.board .== game_board)
    @test state.winner == MARK_P1
end

@testset "make move x to 1,2 to win" begin
    # initial game board
    # _ _ o
    # o x x
    # o x _
    game_board = reshape(
        [
            MARK_EMPTY,
            MARK_P2,
            MARK_P2,
            MARK_EMPTY,
            MARK_P1,
            MARK_P1,
            MARK_P2,
            MARK_P1,
            MARK_EMPTY,
        ],
        (3, 3),
    )
    state::State = play_bot_turn!(game_board)

    game_board[4] = MARK_P1

    @test state.last_entry == Int8(4)
    @test all(state.board .== game_board)
    @test state.winner == MARK_P1
end

@testset "make move x to 1,2 to win, second" begin
    # initial game board
    # _ _ o
    # o x _
    # x x o
    game_board = reshape(
        [
            MARK_EMPTY,
            MARK_P2,
            MARK_P2,
            MARK_EMPTY,
            MARK_P1,
            MARK_P1,
            MARK_P2,
            MARK_EMPTY,
            MARK_P2,
        ],
        (3, 3),
    )
    state::State = play_bot_turn!(game_board)

    game_board[4] = MARK_P1

    @test state.last_entry == Int8(4)
    @test all(state.board .== game_board)
    @test state.winner == MARK_P1
end

@testset "make move x to 2,3 to prevent win" begin
    # initial game board
    # x o o
    # o x _
    # x _ o
    game_board = reshape(
        [
            MARK_P1,
            MARK_P2,
            MARK_P1,
            MARK_P2,
            MARK_P1,
            MARK_EMPTY,
            MARK_P2,
            MARK_EMPTY,
            MARK_P2,
        ],
        (3, 3),
    )
    state::State = play_bot_turn!(game_board)

    game_board[8] = MARK_P1

    @test state.last_entry == Int8(8)
    @test all(state.board .== game_board)
    @test state.winner == MARK_EMPTY
end

@testset "make move x to 2,3 to prevent win, second" begin
    # initial game board
    # x o o
    # o x _
    # _ x o
    game_board = reshape(
        [
            MARK_P1,
            MARK_P2,
            MARK_EMPTY,
            MARK_P2,
            MARK_P1,
            MARK_P1,
            MARK_P2,
            MARK_EMPTY,
            MARK_P2,
        ],
        (3, 3),
    )
    state::State = play_bot_turn!(game_board)

    game_board[8] = MARK_P1

    @test state.last_entry == Int8(8)
    @test all(state.board .== game_board)
    @test state.winner == MARK_EMPTY
end

@testset "make move x to 2,3 to prevent win, third" begin
    # initial game board
    # x o o
    # _ x _
    # _ x o
    game_board = reshape(
        [
            MARK_P1,
            MARK_EMPTY,
            MARK_EMPTY,
            MARK_P2,
            MARK_P1,
            MARK_P1,
            MARK_P2,
            MARK_EMPTY,
            MARK_P2,
        ],
        (3, 3),
    )
    state::State = play_bot_turn!(game_board)

    game_board[8] = MARK_P1

    @test state.last_entry == Int8(8)
    @test all(state.board .== game_board)
    @test state.winner == MARK_EMPTY
end

@testset "make move x to 2,3 to prevent win, fourth" begin
    # initial game board
    # _ _ o
    # _ x _
    # x _ o
    game_board = reshape(
        [
            MARK_EMPTY,
            MARK_EMPTY,
            MARK_P1,
            MARK_EMPTY,
            MARK_P1,
            MARK_EMPTY,
            MARK_P2,
            MARK_EMPTY,
            MARK_P2,
        ],
        (3, 3),
    )
    state::State = play_bot_turn!(game_board)

    game_board[8] = MARK_P1

    @test state.last_entry == Int8(8)
    @test all(state.board .== game_board)
    @test state.winner == MARK_EMPTY
end

@testset "play full game between bots, should end in draw" begin
    game_board = fill(Int8(0), 3, 3)
    state::State = play_bot_turn!(game_board)

    for j = 2:9
        game_board = copy(state.board)
        game_board .*= Int8(-1)
        state = play_bot_turn!(game_board)
    end

    @test state.winner == MARK_TIE
    @test sum(==(MARK_EMPTY), state.board) == 0
end
