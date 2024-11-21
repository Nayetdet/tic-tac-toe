#include <stdlib.h>
#include <stdbool.h>
#include <time.h>

#include "raylib.h"
#include "raymath.h"

#define CELL_SIZE 200
#define NUM_CELLS 3
#define SCREEN_SIZE (CELL_SIZE * NUM_CELLS)
#define SHAPE_SCALE 0.25

Vector2 GetClickedCell() {
    if (IsMouseButtonDown(MOUSE_LEFT_BUTTON)) {
        Vector2 mousePosition = GetMousePosition();
        mousePosition.x = (int)mousePosition.x / CELL_SIZE;
        mousePosition.y = (int)mousePosition.y / CELL_SIZE;
        return mousePosition;
    }

    return (Vector2){-1, -1};
}

void DrawGridBorder() {
    for (int i = 0; i <= SCREEN_SIZE; i += CELL_SIZE) {
        DrawLine(0, i, SCREEN_SIZE, i, BLACK);
        DrawLine(i, 0, i, SCREEN_SIZE, BLACK);
    }
}

void DrawCrossAtPosition(Vector2 position) {
    Vector2 startPosition1 = Vector2Scale(Vector2AddValue(position, SHAPE_SCALE), CELL_SIZE);
    Vector2 endPosition1 = Vector2Scale(Vector2AddValue(position, 1 - SHAPE_SCALE), CELL_SIZE);

    Vector2 startPosition2 = (Vector2){startPosition1.x, endPosition1.y};
    Vector2 endPosition2 = (Vector2){endPosition1.x, startPosition1.y};

    DrawLineV(startPosition1, endPosition1, BLACK);
    DrawLineV(startPosition2, endPosition2, BLACK);
}

void DrawCircleAtPosition(Vector2 position) {
    Vector2 center = Vector2Scale(Vector2AddValue(position, 0.5), CELL_SIZE);
    DrawCircleLinesV(center, CELL_SIZE * SHAPE_SCALE, BLACK);
}

void DrawGridElements(int grid[NUM_CELLS][NUM_CELLS]) {
    for (int i = 0; i < NUM_CELLS; i++) {
        for (int j = 0; j < NUM_CELLS; j++) {
            Vector2 position = {i, j};
            switch (grid[i][j]) {
                case 1:
                    DrawCrossAtPosition(position);
                    break;
                case 2:
                    DrawCircleAtPosition(position);
                    break;
            }
        }
    }
}

int GetWinner(int grid[NUM_CELLS][NUM_CELLS]) {
    for (int i = 0; i < NUM_CELLS; i++) {
        if (grid[i][0] != 0 && grid[i][0] == grid[i][1] && grid[i][1] == grid[i][2])
            return grid[i][0];
        if (grid[0][i] != 0 && grid[0][i] == grid[1][i] && grid[1][i] == grid[2][i])
            return grid[0][i];
    }

    if (grid[0][0] != 0 && grid[0][0] == grid[1][1] && grid[1][1] == grid[2][2])
        return grid[0][0];
    if (grid[0][2] != 0 && grid[0][2] == grid[1][1] && grid[1][1] == grid[2][0])
        return grid[0][2];

    return 0;
}

bool IsValidCell(int i, int j) {
    return i >= 0 && i < NUM_CELLS && j >= 0 && j < NUM_CELLS;
}

int main(void) {
    bool isGameOver = false;
    bool isPlayerXTurn = true;
    int grid[NUM_CELLS][NUM_CELLS] = {0};

    SetConfigFlags(FLAG_MSAA_4X_HINT);
    InitWindow(SCREEN_SIZE, SCREEN_SIZE, "Tic Tac Toe");
    SetTargetFPS(60);    

    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(RAYWHITE);

        DrawGridBorder();
        DrawGridElements(grid);

        if (!isGameOver) {
            Vector2 clickedCell = GetClickedCell();
            int i = (int)clickedCell.x;
            int j = (int)clickedCell.y;

            if (IsValidCell(i, j) && !grid[i][j]) {
                isPlayerXTurn = !isPlayerXTurn;
                grid[i][j] = isPlayerXTurn + 1;
            }
        }

        int winner = GetWinner(grid);
        if (winner) {
            const int fontSize = 36;
            const char* message = TextFormat("Player %c Wins!", (winner == 1) ? 'X' : 'O');

            int textWidth = MeasureText(message, fontSize);
            int x = (SCREEN_SIZE - textWidth) / 2;
            int y = (SCREEN_SIZE - fontSize) / 2;
            DrawText(message, x, y, fontSize, RED);
            isGameOver = true;
        }

        EndDrawing();
    }

    CloseWindow();
    return 0;
}
