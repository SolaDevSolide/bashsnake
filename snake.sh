#!/bin/bash

# Snake Game in Bash Without Flickering

# Game settings
WIDTH=40         # Width of the game board
HEIGHT=20        # Height of the game board
SPEED=0.1        # Speed of the game (delay between moves)

# Initial snake settings
SNAKE_X=$((WIDTH / 2))
SNAKE_Y=$((HEIGHT / 2))
SNAKE_LENGTH=5
DIRECTION="RIGHT"
GAME_OVER=0

# Arrays to store snake body positions
declare -a SNAKE_BODY_X
declare -a SNAKE_BODY_Y

# Initialize the snake's body
for ((i=0; i<SNAKE_LENGTH; i++)); do
    SNAKE_BODY_X[$i]=$((SNAKE_X - i))
    SNAKE_BODY_Y[$i]=$SNAKE_Y
done

# Generate initial food position
generate_food() {
    FOOD_X=$((RANDOM % (WIDTH - 2) + 1))
    FOOD_Y=$((RANDOM % (HEIGHT - 2) + 1))
}

generate_food

# Hide the cursor
tput civis

# Draw the game borders once
draw_borders() {
    # Draw top border
    tput cup 0 0
    printf '#%.0s' $(seq 1 $WIDTH)
    # Draw side borders
    for ((i=1; i<HEIGHT; i++)); do
        tput cup $i 0
        echo -n "#"
        tput cup $i $((WIDTH - 1))
        echo -n "#"
    done
    # Draw bottom border
    tput cup $HEIGHT 0
    printf '#%.0s' $(seq 1 $WIDTH)
}

# Function to draw the food
draw_food() {
    tput cup $FOOD_Y $FOOD_X
    echo -n "*"
}

# Function to erase the tail
erase_tail() {
    local tail_index=$((SNAKE_LENGTH - 1))
    local tail_x=${SNAKE_BODY_X[$tail_index]}
    local tail_y=${SNAKE_BODY_Y[$tail_index]}
    tput cup $tail_y $tail_x
    echo -n " "
}

# Function to draw the snake
draw_snake() {
    # Draw head
    tput cup ${SNAKE_BODY_Y[0]} ${SNAKE_BODY_X[0]}
    echo -n "O"
    # Draw body segments (optional since we don't need to redraw them)
}

# Function to update the snake's position
update_snake() {
    # Erase the tail from the screen
    erase_tail

    # Move the snake body
    for ((i=SNAKE_LENGTH-1; i>0; i--)); do
        SNAKE_BODY_X[$i]=${SNAKE_BODY_X[$((i-1))]}
        SNAKE_BODY_Y[$i]=${SNAKE_BODY_Y[$((i-1))]}
    done

    # Update the head position
    case "$DIRECTION" in
        "UP") ((SNAKE_BODY_Y[0]--));;
        "DOWN") ((SNAKE_BODY_Y[0]++));;
        "LEFT") ((SNAKE_BODY_X[0]--));;
        "RIGHT") ((SNAKE_BODY_X[0]++));;
    esac

    # Check for wall collision
    if (( SNAKE_BODY_X[0] <= 0 || SNAKE_BODY_X[0] >= WIDTH - 1 || SNAKE_BODY_Y[0] <= 0 || SNAKE_BODY_Y[0] >= HEIGHT )); then
        GAME_OVER=1
    fi

    # Check for self collision
    for ((i=1; i<SNAKE_LENGTH; i++)); do
        if (( SNAKE_BODY_X[0] == SNAKE_BODY_X[i] && SNAKE_BODY_Y[0] == SNAKE_BODY_Y[i] )); then
            GAME_OVER=1
        fi
    done

    # Check for food collision
    if (( SNAKE_BODY_X[0] == FOOD_X && SNAKE_BODY_Y[0] == FOOD_Y )); then
        ((SNAKE_LENGTH++))
        SNAKE_BODY_X+=(${SNAKE_BODY_X[$((SNAKE_LENGTH - 2))]})
        SNAKE_BODY_Y+=(${SNAKE_BODY_Y[$((SNAKE_LENGTH - 2))]})
        generate_food
        draw_food
    fi

    # Draw the snake's new head
    draw_snake
}

# Function to handle user input
read_input() {
    tput cup 0 0
    read -n 1 -s -t $SPEED key
    echo -n "#"
    case "$key" in
        z|Z) [[ "$DIRECTION" != "DOWN" ]] && DIRECTION="UP";;
        s|S) [[ "$DIRECTION" != "UP" ]] && DIRECTION="DOWN";;
        q|Q) [[ "$DIRECTION" != "RIGHT" ]] && DIRECTION="LEFT";;
        d|D) [[ "$DIRECTION" != "LEFT" ]] && DIRECTION="RIGHT";;
        a|A) GAME_OVER=1;;
    esac
}

# Function to display score and instructions
display_status() {
    tput cup $((HEIGHT + 1)) 0
    echo "Score: $((SNAKE_LENGTH - 5))    Press 'a' to quit."
}

# Draw the initial game state
clear
draw_borders
draw_food
draw_snake
display_status

# Main game loop
while (( GAME_OVER == 0 )); do
    read_input
    update_snake
    display_status
done

# Show the cursor again
tput cnorm

# Move cursor to the bottom to avoid overwriting
tput cup $((HEIGHT + 3)) 0

echo "Game Over! Your score was $((SNAKE_LENGTH - 5))"
