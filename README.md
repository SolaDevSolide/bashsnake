# BashSnake - Snake Game in Bash

This repository contains a simple Snake game written in Bash. It runs in the terminal and provides basic snake game mechanics with keyboard controls, boundary walls, and food spawning.

## Overview

The game operates by manipulating cursor positions in the terminal, simulating a "snake" that grows as it "eats" food items represented by an asterisk (`*`). The game ends if the snake collides with the walls or itself.

### Features
- Adjustable game board dimensions and speed.
- Growing snake body upon eating food.
- Collision detection for walls and snake's own body.
- Simple keyboard controls to navigate the snake.
- Real-time score display.

---

## Code Breakdown

### Game Settings

```bash
WIDTH=40         # Width of the game board
HEIGHT=20        # Height of the game board
SPEED=0.1        # Game speed, adjusting the delay between moves
```

These variables define the board dimensions and speed. `SPEED` determines the delay between each frame update, controlling how quickly the snake moves.

### Snake Initialization

```bash
SNAKE_X=$((WIDTH / 2))
SNAKE_Y=$((HEIGHT / 2))
SNAKE_LENGTH=5
DIRECTION="RIGHT"
GAME_OVER=0
```

The initial position of the snake is set at the center of the board. The snake's default direction is "RIGHT" and its initial length is `5`. The `GAME_OVER` flag monitors the game state.

### Snake's Body Storage

```bash
declare -a SNAKE_BODY_X
declare -a SNAKE_BODY_Y
```

The arrays `SNAKE_BODY_X` and `SNAKE_BODY_Y` store the X and Y positions of each segment of the snake's body. These arrays are updated as the snake moves.

### Food Generation

```bash
generate_food() {
    FOOD_X=$((RANDOM % (WIDTH - 2) + 1))
    FOOD_Y=$((RANDOM % (HEIGHT - 2) + 1))
}
```

The `generate_food` function places food at a random position within the game board boundaries. 

### Game Display Setup

- **`draw_borders`**: Draws the borders once at the beginning of the game.
- **`draw_food`**: Displays the food's position on the board.
- **`erase_tail`**: Erases the last segment of the snake's body to simulate movement.
- **`draw_snake`**: Draws the snake's head.

### Game Logic

#### Snake Movement

```bash
update_snake() {
    # Erase the tail
    # Move body segments
    # Update head based on direction
}
```

- The `update_snake` function handles all aspects of movement, including checking for collisions and updating the snake’s position.
- The direction (`UP`, `DOWN`, `LEFT`, `RIGHT`) determines the change in position of the snake’s head.
- After moving, the function checks for collisions:
  - **Wall Collision**: Ends the game if the snake hits the boundaries.
  - **Self Collision**: Ends the game if the snake hits its own body.
  - **Food Collision**: Extends the snake's length by one segment and generates a new food item.

#### User Input

```bash
read_input() {
    read -n 1 -s -t $SPEED key
    case "$key" in
        z|Z) [[ "$DIRECTION" != "DOWN" ]] && DIRECTION="UP";;
        s|S) [[ "$DIRECTION" != "UP" ]] && DIRECTION="DOWN";;
        q|Q) [[ "$DIRECTION" != "RIGHT" ]] && DIRECTION="LEFT";;
        d|D) [[ "$DIRECTION" != "LEFT" ]] && DIRECTION="RIGHT";;
        a|A) GAME_OVER=1;;
    esac
}
```

- This function reads a single character input to control the snake’s direction:
  - `z` or `Z` - Move up
  - `s` or `S` - Move down
  - `q` or `Q` - Move left
  - `d` or `D` - Move right
  - `a` or `A` - Quit game

#### Score Display

```bash
display_status() {
    echo "Score: $((SNAKE_LENGTH - 5))    Press 'a' to quit."
}
```

Displays the player's score (the snake's length minus its starting length) and instructions for quitting.

### Game Loop

```bash
while (( GAME_OVER == 0 )); do
    read_input
    update_snake
    display_status
done
```

The main game loop continuously reads player input, updates the snake’s position, and displays the updated game state until a collision occurs (ending the game).

### Cleanup

```bash
tput cnorm
echo "Game Over! Your score was $((SNAKE_LENGTH - 5))"
```

After the game ends, the cursor is restored, and the player’s final score is displayed.

---

## How to Run

1. Make the script executable:
   ```bash
   chmod +x bashsnake.sh
   ```

2. Run the script:
   ```bash
   ./bashsnake.sh
   ```

## Controls

- `z` or `Z`: Move Up
- `s` or `S`: Move Down
- `q` or `Q`: Move Left
- `d` or `D`: Move Right
- `a` or `A`: Quit game
