Trap = {img = love.graphics.newImage("assets/traps/trap2.png")}
Trap.__index = Trap

Trap.height = Trap.img:getHeight()
Trap.width = Trap.img:getWidth() 

activeTraps = {}

function Trap.create(xPos, yPos)
    local instance = setmetatable({}, Trap)
    instance.xPos = xPos
    instance.yPos = yPos
    instance.physics = {}
    instance.physics.body = love.physics.newBody(gameWorld, instance.xPos, instance.yPos, "static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)
    instance.damage = 1
    table.insert(activeTraps, instance)
end

function Trap:draw()
    love.graphics.draw(self.img, self.xPos, self.yPos + 5, 0, self.scaleX, 1, self.height / 2, self.width / 2)
end

function Trap.drawAll()
    for i, instance in ipairs(activeTraps) do
        instance:draw()
    end
end

function Trap:update(dt)

end

function Trap.updateAll(dt)
    for i, instance in ipairs(activeTraps) do
        instance:update(dt)
    end
end

function Trap.startContact(contA, contB, contP)
    for i, instance in ipairs(activeTraps) do
        if contA == instance.physics.fixture or contB == instance.physics.fixture then
            if contA == Player.physics.fixture or contB == Player.physics.fixture then
                Player:healthLost(instance.damage)
                return true
            end
        end
    end
end

function Trap.destroyAll()
    for i,v in ipairs(activeTraps) do
        v.physics.body:destroy()
    end

    activeTraps = {}
end

