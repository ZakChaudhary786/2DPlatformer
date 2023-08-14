Enemy = {}
Enemy.__index = Enemy

activeEnemies = {}

function Enemy.create(xPos, yPos)
    local instance = setmetatable({}, Enemy)
    instance.xPos = xPos
    instance.yPos = yPos
    instance.rotate = 0

    instance.animation = {timer = 0, rate = 0.25}
    instance.animation.run = {total = 8, current = 1, img = Enemy.running}
    instance.animation.walk = {total = 4, current = 1, img = Enemy.walking}
    instance.animation.attack = {total = 4, current = 1, img = Enemy.attacking}
    instance.animation.draw = instance.animation.walk.img[1]

    instance.state = "walk"

    instance.speed = 70
    instance.speedModifier = 1
    instance.xVal = instance.speed
    instance.damage = 1

    instance.aggroCount = 0
    instance.aggroNum = 1


    instance.physics = {}
    instance.physics.body = love.physics.newBody(gameWorld, instance.xPos, instance.yPos, "dynamic")
    instance.physics.body:setFixedRotation(true)
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.body:setMass(30)
    table.insert(activeEnemies, instance)
end

function Enemy.loadAssets()
    Enemy.running = {}
    for i = 1, 8 do
        Enemy.running[i] = love.graphics.newImage("assets/enemy/running/"..i..".png")
    end

    Enemy.walking = {}
    for i = 1, 4 do
        Enemy.walking[i] = love.graphics.newImage("assets/enemy/walking/"..i..".png")
    end
    Enemy.height = Enemy.running[1]:getHeight()
    Enemy.width = Enemy.running[1]:getWidth()
end

function Enemy:syncPhysics()
    self.xPos, self.yPos = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVal * self.speedModifier, 100)
end

function Enemy:draw()
    local scaleX = 1
    if self.xVal > 0 then
        scaleX = -1
    end
    love.graphics.draw(self.animation.draw, self.xPos, self.yPos + 12, self.rotate, scaleX, 1, self.width / 2, self.height / 2)
end

function Enemy.drawAll()
    for i, instance in ipairs(activeEnemies) do
        instance:draw()
    end
end

function Enemy:update(dt)
    self:syncPhysics()
    self:animate(dt)
end

function Enemy.updateAll(dt)
    for i, instance in ipairs(activeEnemies) do
        instance:update(dt)
    end
end

function Enemy:animate(dt)
    self.animation.timer = self.animation.timer + dt
    if self.animation.timer > self.animation.rate then
        self.animation.timer = 0
        self:refreshFrame()
    end
end

function Enemy:refreshFrame()
    local anim = self.animation[self.state]
    if anim.current < anim.total then
        anim.current = anim.current + 1
    else
        anim.current = 1
    end
    self.animation.draw = anim.img[anim.current]
end

function Enemy:changeDirection()
    self.xVal = -self.xVal
end

function Enemy.startContact(contA, contB, contP)
    for i, instance in ipairs(activeEnemies) do
        if contA == instance.physics.fixture or contB == instance.physics.fixture then
            if contA == Player.physics.fixture or contB == Player.physics.fixture then
                Player:healthLost(instance.damage)
            end
            instance:changeDirection()
            instance:increaseAggro()
        end
    end
end

function Enemy:increaseAggro()
    self.aggroCount = self.aggroCount + 1
    if self.aggroCount > self.aggroNum then
        self.state = "run"
        self.speedModifier = 2
        self.aggroCount = 0
    else
        self.state = "walk"
        self.speedModifier = 1
    end
end

function Enemy.destroyAll()
    for i,v in ipairs(activeEnemies) do
        v.physics.body:destroy()
    end

    activeEnemies = {}
end