local Grid = require("lib.Grid")

local Game = {}
Game.__index = Game

local moveMadeSound = love.audio.newSource("assets/sounds/move_made.wav", "static")
local winSound = love.audio.newSource("assets/sounds/win.wav", "static")

function Game:new()
    local self = setmetatable({}, Game)
    self.isOver = false
    self.isPlayerXTurn = true
    self.grid = Grid:new()
    self.cellsPlaced = 0
    return self
end

function Game:insertGridElementAtMousePosition(mouseX, mouseY)
    local cellX = math.floor(mouseX / Grid.CELL_SIZE) + 1
    local cellY = math.floor(mouseY / Grid.CELL_SIZE) + 1

    if not self.isOver and self.grid[cellX][cellY] == 0 then
        self.grid[cellX][cellY] = self.isPlayerXTurn and 1 or 2
        self.isPlayerXTurn = not self.isPlayerXTurn
        self.cellsPlaced = self.cellsPlaced + 1

        moveMadeSound:play()

        if (
            self:getWinner() ~= 0 or
            self.cellsPlaced == math.pow(Grid.NUM_CELLS, 2)
        ) then
            self.isOver = true
            winSound:play()
        end
    end
end

local function areEqualAndNotZero(a, b, c)
    return a ~= 0 and a == b and b == c
end

function Game:getWinner()
    for i = 1, Grid.NUM_CELLS do
        if areEqualAndNotZero(self.grid[1][i], self.grid[2][i], self.grid[3][i]) then
            return self.grid[1][i]
        elseif areEqualAndNotZero(self.grid[i][1], self.grid[i][2], self.grid[i][3]) then
            return self.grid[i][1]
        end
    end

    if (
        areEqualAndNotZero(self.grid[1][1], self.grid[2][2], self.grid[3][3]) or
        areEqualAndNotZero(self.grid[1][3], self.grid[2][2], self.grid[3][1])
    ) then
        return self.grid[2][2]
    end

    return 0
end

function Game:displayWinner()
    if not self.isOver then
        return
    end

    local winner = self:getWinner()
    local text = (winner == 0) and "It's a Draw!" or string.format("Player %s Wins!", (winner == 1) and "X" or "O")
    text = text .. "\nPress R to restart!"

    local font = love.graphics.newFont("assets/fonts/PressStart2P-Regular.ttf", 28)
    love.graphics.setFont(font)
    love.graphics.setColor(1, 0.851, 0.855, 1)

    local screenSize = love.graphics.getWidth()
    local textWidth = love.graphics.getFont():getWidth(text)
    local textHeight = love.graphics.getFont():getHeight(text)
    love.graphics.print(text, (screenSize - textWidth) / 2, (screenSize - textHeight) / 2)
end

return Game
