Tracker = {
    xPos = 0,
    yPos = 0,
    scale = 2
}

function Tracker:apply()
    love.graphics.push()
    love.graphics.scale(self.scale, self.scale)
    love.graphics.translate (-self.xPos, -self.yPos)
end

function Tracker:clear()
    love.graphics.pop()
end

function Tracker:setPos (xPos, yPos)
    self.xPos = xPos - love.graphics.getWidth() / 2 / self.scale
    self.yPos = yPos
    rightSide = self.xPos + love.graphics.getWidth() / 2

    if self.xPos < 0 then
        self.xPos = 0
    elseif rightSide > MapWidth then
        self.xPos = MapWidth - love.graphics.getWidth() / 2
    end
end

