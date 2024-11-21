local Game = require("lib.Game")
local Grid = require("lib.Grid")

local game = Game:new()

function love.load()
    love.window.setTitle("Tic Tac Toe")
    local screenSize = Grid.CELL_SIZE * Grid.NUM_CELLS
    love.window.setMode(screenSize, screenSize)

    love.audio.setVolume(0.1)
    local icon = love.image.newImageData("assets/images/icon.png")
    love.window.setIcon(icon)
end

function love.update()
    if love.keyboard.isDown('r') then
        game = Game:new()
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if not game.isOver and love.mouse.isDown(1) then
        game:setCellValueAtMousePosition(x, y)
    end
end

function love.draw()
    love.graphics.clear(0.105, 0.125, 0.129, 1)
    love.graphics.setColor(0.918, 0.388, 0.549, 1)

    game.grid:drawGrid()
    if game.isOver then
        game:displayWinner()
    end
end
