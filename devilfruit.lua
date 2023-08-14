devilFruit = {}
devilFruit.__index = devilFruit
activeDfs = {}

function devilFruit.create(xPos, yPos)
    local instance = setmetatable({}, devilFruit)
    instance.xPos = xPos
    instance.yPos = yPos
    instance.img = love.graphics.newImage("assets/devilfruit.png")
    instance.height = instance.img:getHeight()
    instance.width = instance.img:getWidth()
    instance.scaleX = 1
    instance.physics = {}
    instance.physics.body = love.physics.newBody(gameWorld, instance.xPos, instance.yPos, "static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)
    instance.tbr = false
    table.insert(activeDfs, instance)
end

function devilFruit:draw()
    love.graphics.draw(self.img, self.xPos, self.yPos, 0, self.scaleX, 1, self.height / 2, self.width / 2)
end

function devilFruit.drawAll()
    for i, instance in ipairs(activeDfs) do
        instance:draw()
    end
end

function devilFruit:update()
    self:spin(dt)
    self:tbrCheck()
end

function devilFruit:spin(dt)
    self.scaleX = math.sin(love.timer.getTime())
end

function devilFruit:updateAll()
    for i, instance in ipairs(activeDfs) do
        instance:update(dt)
    end
end

function devilFruit.startContact(contA, contB, contP)
    for i, instance in ipairs(activeDfs) do
        if contA == instance.physics.fixture or contB == instance.physics.fixture then
            if contA == Player.physics.fixture or contB == Player.physics.fixture then
                instance.tbr = true
                return true
            end
        end
    end
end

function devilFruit:collected()
    for i, instance in ipairs(activeDfs) do 
        if instance == self then 
            Player:increaseDevilFruits()
            self.physics.body:destroy()
            table.remove(activeDfs, i)
        end
    end
end

function devilFruit.destroyAll()
    for i,v in ipairs(activeDfs) do
        v.physics.body:destroy()
    end

    activeDfs = {}
end

function devilFruit:tbrCheck()
    if self.tbr then 
        self:collected()
    end
end

