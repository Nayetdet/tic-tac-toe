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
    self.cellsPlaced = 0
    self.cells = {
        {nil, nil, nil},
        {nil, nil, nil},
        {nil, nil, nil}
    }

    return self
end

function Grid:areAllCellsFilled()
    return self.cellsPlaced == Grid.NUM_CELLS ^ 2
end

function Grid:setCellValue(cellX, cellY, value)
    self[cellX][cellY] = value
    self.cellsPlaced = self.cellsPlaced + 1
end

function Grid.areEqualNonEmptyCells(cellA, cellB, cellC)
    return cellA and cellA == cellB and cellB == cellC
end

function Grid:getWinner()
    for i = 1, Grid.NUM_CELLS do
        if Grid.areEqualNonEmptyCells(self[i][1], self[i][2], self[i][3]) then
            return self[i][1]
        elseif Grid.areEqualNonEmptyCells(self[1][i], self[2][i], self[3][i]) then
            return self[1][i]
        end
    end

    if Grid.areEqualNonEmptyCells(self.cells[1][1], self.cells[2][2], self.cells[3][3]) or
       Grid.areEqualNonEmptyCells(self.cells[1][3], self.cells[2][2], self.cells[3][1]) then
        return self.cells[2][2]
    end

    return nil
end

function Grid.drawCross(cellX, cellY)
    local startX = (cellX - 1 + Grid.SHAPE_SCALE_FACTOR) * Grid.CELL_SIZE
    local startY = (cellY - 1 + Grid.SHAPE_SCALE_FACTOR) * Grid.CELL_SIZE
    local endX = (cellX - Grid.SHAPE_SCALE_FACTOR) * Grid.CELL_SIZE
    local endY = (cellY - Grid.SHAPE_SCALE_FACTOR) * Grid.CELL_SIZE

    love.graphics.line(startX, startY, endX, endY)
    love.graphics.line(startX, endY, endX, startY)
end

function Grid.drawCircle(cellX, cellY)
    local centerX = (cellX - 0.5) * Grid.CELL_SIZE
    local centerY = (cellY - 0.5) * Grid.CELL_SIZE
    love.graphics.circle("line", centerX, centerY, Grid.CELL_SIZE * Grid.SHAPE_SCALE_FACTOR)
end

function Grid:drawGrid()
    local screenSize = love.graphics.getWidth()
    for i = 0, screenSize, Grid.CELL_SIZE do
        love.graphics.line(0, i, screenSize, i)
        love.graphics.line(i, 0, i, screenSize)
    end

    for cellX = 1, Grid.NUM_CELLS do
        for cellY = 1, Grid.NUM_CELLS do
            if self[cellX][cellY] == "X" then
                Grid.drawCross(cellX, cellY)
            elseif self[cellX][cellY] == "O" then
                Grid.drawCircle(cellX, cellY)
            end
        end
    end
end

return Grid
