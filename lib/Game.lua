local Grid = require("lib.Grid")

local Game = {}
Game.__index = Game

local clickSound = love.audio.newSource("assets/sounds/click.wav", "static")
local winSound = love.audio.newSource("assets/sounds/win.wav", "static")

function Game:new()
    local self = setmetatable({}, Game)
    self.isOver = false
    self.isPlayerXTurn = true
    self.grid = Grid:new()
    return self
end

function Game:setCellValueAtMousePosition(mouseX, mouseY)
    local cellX = math.floor(mouseX / Grid.CELL_SIZE) + 1
    local cellY = math.floor(mouseY / Grid.CELL_SIZE) + 1

    if not self.isOver and not self.grid[cellX][cellY] then
        local value = self.isPlayerXTurn and "X" or "O"
        self.grid:setCellValue(cellX, cellY, value)
        self.isPlayerXTurn = not self.isPlayerXTurn

        clickSound:stop()
        clickSound:play()
        
        if self.grid:getWinner() or self.grid:areAllCellsFilled() then
            self.isOver = true
            winSound:play()
        end
    end
end

function Game:displayWinner()
    local winner = self.grid:getWinner()
    local text = (not winner) and "It's a Draw!" or string.format("Player %s Wins!", winner)
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
