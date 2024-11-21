local Grid = {}
Grid.__index = function(self, key)
    if type(key) == "number" then
        return self.cells[key]
    else
        return rawget(Grid, key)
    end
end

Grid.CELL_SIZE = 200
Grid.NUM_CELLS = 3
Grid.SHAPE_SCALE_FACTOR = 0.25

function Grid:new()
    local self = setmetatable({}, Grid)
    self.cells = {}

    for i = 1, Grid.NUM_CELLS do
        self.cells[i] = {}
        for j = 1, Grid.NUM_CELLS do
            self.cells[i][j] = 0
        end
    end

    return self
end

function Grid.drawCrossAtCellPosition(cellX, cellY)
    local startX = (cellX - 1 + Grid.SHAPE_SCALE_FACTOR) * Grid.CELL_SIZE
    local startY = (cellY - 1 + Grid.SHAPE_SCALE_FACTOR) * Grid.CELL_SIZE

    local endX = (cellX - Grid.SHAPE_SCALE_FACTOR) * Grid.CELL_SIZE
    local endY = (cellY - Grid.SHAPE_SCALE_FACTOR) * Grid.CELL_SIZE

    love.graphics.line(startX, startY, endX, endY)
    love.graphics.line(startX, endY, endX, startY)
end

function Grid.drawCircleLinesAtCellPosition(cellX, cellY)
    local centerX = (cellX - 0.5) * Grid.CELL_SIZE
    local centerY = (cellY - 0.5) * Grid.CELL_SIZE
    love.graphics.circle("line", centerX, centerY, Grid.CELL_SIZE * Grid.SHAPE_SCALE_FACTOR)
end

function Grid:drawElements()
    local screenSize = love.graphics.getWidth()
    for i = 0, screenSize, Grid.CELL_SIZE do
        love.graphics.line(0, i, screenSize, i)
        love.graphics.line(i, 0, i, screenSize)
    end

    for cellX = 1, Grid.NUM_CELLS do
        for cellY = 1, Grid.NUM_CELLS do
            if self[cellX][cellY] == 1 then
                Grid.drawCrossAtCellPosition(cellX, cellY)
            elseif self[cellX][cellY] == 2 then
                Grid.drawCircleLinesAtCellPosition(cellX, cellY)
            end
        end
    end
end

return Grid
