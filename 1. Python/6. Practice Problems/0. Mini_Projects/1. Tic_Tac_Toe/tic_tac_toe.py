# ============================================================
# TIC-TAC-TOE GAME
# Python Console Project
# ============================================================


# ------------------------------------------------------------
# 1. Initialize Board
# ------------------------------------------------------------

def initialize_board():
    """
    Creates and returns an empty Tic-Tac-Toe board.

    Index mapping:
        0 -> Position 1
        1 -> Position 2
        ...
        8 -> Position 9
    """

    board = [" "] * 9

    return board


# ------------------------------------------------------------
# 2. Display Board
# ------------------------------------------------------------

def display_board(board):
    """
    Displays the current Tic-Tac-Toe board.
    """

    print()

    print(f" {board[0]} | {board[1]} | {board[2]} ")
    print("---+---+---")
    print(f" {board[3]} | {board[4]} | {board[5]} ")
    print("---+---+---")
    print(f" {board[6]} | {board[7]} | {board[8]} ")

    print()


# ------------------------------------------------------------
# 3. Display Position Guide
# ------------------------------------------------------------

def display_positions():
    """
    Shows position numbers so players know
    which number corresponds to which cell.
    """

    print("\nBoard Positions:\n")

    print(" 1 | 2 | 3 ")
    print("---+---+---")
    print(" 4 | 5 | 6 ")
    print("---+---+---")
    print(" 7 | 8 | 9 ")

    print()


# ------------------------------------------------------------
# 4. Choose Player Symbol
# ------------------------------------------------------------

def choose_symbol():
    """
    Allows Player 1 to choose X or O.

    Returns:
        player1_symbol
        player2_symbol
    """

    while True:

        symbol = input("Player 1, choose X or O: ").strip().upper()

        if symbol == "X":
            return "X", "O"

        elif symbol == "O":
            return "O", "X"

        else:
            print("Invalid choice! Please enter X or O.")


# ------------------------------------------------------------
# 5. Validate Move
# ------------------------------------------------------------

def is_valid_move(board, position):
    """
    Checks whether the selected position is valid.

    Conditions:
    1. Position must be between 1 and 9.
    2. Position must be empty.

    Returns:
        True  -> Valid move
        False -> Invalid move
    """

    if position < 1 or position > 9:
        return False

    # Convert user position 1-9 into list index 0-8
    index = position - 1

    if board[index] != " ":
        return False

    return True


# ------------------------------------------------------------
# 6. Get Player Move
# ------------------------------------------------------------

def get_player_move(board, player):
    """
    Takes a move from the current player.

    Keeps asking until the player enters
    a valid and empty position.

    Returns:
        Valid position from 1 to 9
    """

    while True:

        user_input = input(
            f"Player {player}, choose a position (1-9): "
        ).strip()

        # Check whether input contains only digits
        if not user_input.isdigit():
            print("Invalid input! Please enter a number from 1 to 9.")
            continue

        position = int(user_input)

        # Check range separately for a clearer message
        if position < 1 or position > 9:
            print("Position must be between 1 and 9.")
            continue

        # Check whether position is already occupied
        if not is_valid_move(board, position):
            print("That position is already occupied. Try another one.")
            continue

        return position


# ------------------------------------------------------------
# 7. Make Move
# ------------------------------------------------------------

def make_move(board, position, player):
    """
    Places the player's symbol on the selected position.
    """

    index = position - 1

    board[index] = player


# ------------------------------------------------------------
# 8. Check Winner
# ------------------------------------------------------------

def check_winner(board, player):
    """
    Checks all 8 possible winning combinations.

    Winning combinations:
    - 3 Rows
    - 3 Columns
    - 2 Diagonals

    Returns:
        True  -> Player has won
        False -> Player has not won
    """

    winning_combinations = [

        # Rows
        (0, 1, 2),
        (3, 4, 5),
        (6, 7, 8),

        # Columns
        (0, 3, 6),
        (1, 4, 7),
        (2, 5, 8),

        # Diagonals
        (0, 4, 8),
        (2, 4, 6)
    ]

    for combination in winning_combinations:

        a, b, c = combination

        if (
            board[a] == player
            and board[b] == player
            and board[c] == player
        ):
            return True

    return False


# ------------------------------------------------------------
# 9. Check Draw
# ------------------------------------------------------------

def check_draw(board):
    """
    Checks whether the board is completely filled.

    Important:
    Winner should be checked before calling this function.

    Returns:
        True  -> Board is full
        False -> Empty positions are available
    """

    return " " not in board


# ------------------------------------------------------------
# 10. Switch Player
# ------------------------------------------------------------

def switch_player(current_player):
    """
    Switches the current player.

    X -> O
    O -> X
    """

    if current_player == "X":
        return "O"

    return "X"


# ------------------------------------------------------------
# 11. Play One Complete Game
# ------------------------------------------------------------

def play_game():
    """
    Controls one complete Tic-Tac-Toe game.

    Workflow:
    1. Create board
    2. Choose symbols
    3. Take move
    4. Update board
    5. Check winner
    6. Check draw
    7. Switch player
    8. Repeat
    """

    # Create empty board
    board = initialize_board()

    print("\n" + "=" * 40)
    print("          TIC-TAC-TOE")
    print("=" * 40)

    # Show board position numbers
    display_positions()

    # Let Player 1 choose symbol
    player1, player2 = choose_symbol()

    print(f"\nPlayer 1: {player1}")
    print(f"Player 2: {player2}")

    # Player 1 starts the game
    current_player = player1

    # Main game loop
    while True:

        # Display current board
        display_board(board)

        # Get valid move
        position = get_player_move(
            board,
            current_player
        )

        # Update board
        make_move(
            board,
            position,
            current_player
        )

        # Check whether current player won
        if check_winner(board, current_player):

            display_board(board)

            print(
                f"Congratulations! Player {current_player} wins!"
            )

            break

        # Check whether game is draw
        if check_draw(board):

            display_board(board)

            print("Game Draw!")

            break

        # Change player
        current_player = switch_player(current_player)


# ------------------------------------------------------------
# 12. Play Again
# ------------------------------------------------------------

def play_again():
    """
    Asks the players whether they want another game.

    Returns:
        True  -> Play again
        False -> Exit
    """

    while True:

        choice = input(
            "\nDo you want to play again? (Y/N): "
        ).strip().upper()

        if choice == "Y":
            return True

        elif choice == "N":
            return False

        else:
            print("Invalid choice! Please enter Y or N.")


# ------------------------------------------------------------
# 13. Main Program
# ------------------------------------------------------------

def main():
    """
    Main entry point of the program.

    Runs games until the user chooses to stop.
    """

    while True:

        play_game()

        if not play_again():
            print("\nThanks for playing Tic-Tac-Toe!")
            break


# ------------------------------------------------------------
# 14. Start Program
# ------------------------------------------------------------

main()

