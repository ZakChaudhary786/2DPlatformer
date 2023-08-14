Crate = {img = love.graphics.newImage("assets/crate.png")}
Crate.__index = Crate

Crate.height = Crate.img:getHeight()
Crate.width = Crate.img:getWidth() 

activeCrates = {}

function Crate.create(xPos, yPos)
    local instance = setmetatable({}, Crate)
    instance.xPos = xPos
    instance.yPos = yPos
    instance.rotate = 0

    instance.physics = {}
    instance.physics.body = love.physics.newBody(gameWorld, instance.xPos, instance.yPos, "dynamic")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.body:setMass(30)
    table.insert(activeCrates, instance)
end

function Crate:syncPhysics()
    self.xPos, self.yPos = self.physics.body:getPosition()
    self.rotation = self.physics.body:getAngle()
end

function Crate:draw()
    love.graphics.draw(self.img, self.xPos, self.yPos, self.rotation, self.scaleX, 1, self.height / 2, self.width / 2)
end

function Crate.drawAll()
    for i, instance in ipairs(activeCrates) do
        instance:draw()
    end
end

function Crate:update(dt)
    self:syncPhysics()
end

function Crate.updateAll(dt)
    for i, instance in ipairs(activeCrates) do
        instance:update(dt)
    end
end

function Crate.destroyAll()
    for i,v in ipairs(activeCrates) do
        v.physics.body:destroy()
    end

    activeCrates = {}
end

