Score = {}

function Score:load()
    self.devilfNum = {}
    self.devilfNum.img = love.graphics.newImage("assets/devilfruit.png")
    self.devilfNum.height = self.devilfNum.img:getHeight()
    self.devilfNum.width = self.devilfNum.img:getWidth()
    self.devilfNum.scale = 2.4
    self.devilfNum.xPos = love.graphics.getWidth() - 100
    self.devilfNum.yPos = 30

    self.lives = {}
    self.lives.img = love.graphics.newImage("assets/life.png")
    self.lives.width = self.lives.img:getWidth()
    self.lives.height = self.lives.img:getHeight()
    self.lives.xPos = love.graphics.getWidth() - 1320
    self.lives.yPos = 30
    self.lives.scale = 0.3
    self.lives.spacing = self.lives.width * self.lives.scale + 5
end

function Score:update(dt)

end

function Score:showLives()
    for i = 1, Player.hp.startVal do
        local xPos = self.lives.xPos + self.lives.spacing * i
        love.graphics.draw(self.lives.img, xPos, self.lives.yPos, 0, self.lives.scale, self.lives.scale)
    end
end

function Score:draw()
    self:showDevilFruit()
    self:showLives()
end

function Score:showDevilFruit()
    love.graphics.draw(self.devilfNum.img, self.devilfNum.xPos, self.devilfNum.yPos, 0, self.devilfNum.scale, self.devilfNum.scale)
    local textWidth = love.graphics.getFont():getWidth(Player.devilFruits)
    love.graphics.print(Player.devilFruits, self.devilfNum.xPos + self.devilfNum.width * self.devilfNum.scale - textWidth, self.devilfNum.yPos + self.devilfNum.height * self.devilfNum.scale)
end