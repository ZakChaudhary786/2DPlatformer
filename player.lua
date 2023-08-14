Player = {}

function Player:load()
    self.xPos = 100
    self.yPos = 0
    self.xVal = 0
    self.yVal = 100
    self.height = 60
    self.width = 20
    self.grav = 1500
    self.maxVal = 200
    self.accVal = 4000
    self.stopVal = 3500
    self.jumpNum = -500

    self.physics = {}
    self.physics.body = love.physics.newBody(gameWorld, self.xPos, self.yPos, "dynamic")
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
    self.physics.body:setGravityScale(0)

    self.currentState = "idle"
    self.grounded = false
    self.inAir = true
    self.directional = " "

    self.devilFruits = 0

    self.life = true
    self.startXPos = self.xPos
    self.startYPos = self.yPos 
    self.hp = {startVal = 5, maxVal = 5}

    self.color = {
        red = 1,
        green = 1,
        blue = 1,
        damageDur = 3
    }

    jumpSound = love.audio.newSource("assets/jumpsound.mp3", "static")


    self:loadAssets()
    
end

function Player:loadAssets()
    self.animation = {timer = 0, rate = 0.1}

    self.animation.running = {total = 10, current = 1, img = {}}
    for i = 1, self.animation.running.total do
        self.animation.running.img[i] = love.graphics.newImage("assets/player/Running/"..i..".png")
    end

    self.animation.idle = {total = 4, current = 1, img = {}}
    for i = 1, self.animation.idle.total do
        self.animation.idle.img[i] = love.graphics.newImage("assets/player/Idle/"..i..".png")
    end

    self.animation.floating = {total = 3, current = 1, img = {}}
    for i = 1, self.animation.floating.total do
        self.animation.floating.img[i] = love.graphics.newImage("assets/player/Floating/"..i..".png")
    end

    self.animation.draw = self.animation.idle.img[1]
    self.animation.width = self.animation.draw:getWidth()
    self.animation.height = self.animation.draw:getHeight()

end

function Player:update(dt)
    self:playerRecovered(dt)
    self:respawn()
    self:setState()
    self:setDirectional(dt)
    self:animate(dt)
    self:syncPhysics()
    self:movement(dt)
    self:stopping(dt)
    self:gravity(dt)
end

function Player:setState()
    if not self.grounded then
        self.state = "floating"
    elseif self.xVal == 0 then
        self.state = "idle"
    else 
        self.state = "running"
    end
end

function Player:animate(dt)
    self.animation.timer = self.animation.timer + dt
    if self.animation.timer > self.animation.rate then
        self.animation.timer = 0
        self:refreshFrame()
    end
end

function Player:syncPhysics()
    if self.physics.body then
        self.xPos, self.yPos = self.physics.body:getPosition()
        if self.xVal and self.yVal then
            self.physics.body:setLinearVelocity(self.xVal, self.yVal)
        else
            print("Warning: xVal or yVal is nil")
        end
    else
        print("Warning: physics.body is nil")
    end
end

function Player:refreshFrame()
    local anim = self.animation[self.state]
    if anim.current < anim.total then
        anim.current = anim.current + 1
    else
        anim.current = 1
    end
    self.animation.draw = anim.img[anim.current]
end

function Player:movement(dt)
    if love.keyboard.isDown("d") then
        if self.xVal < self.maxVal then
            if self.xVal + self.accVal * dt < self.maxVal then
                self.xVal = self.xVal + self.accVal * dt
            else
                self.xVal = self.maxVal
            end
        end
    elseif love.keyboard.isDown("a") then
        if self.xVal > -self.maxVal then
            if self.xVal - self.accVal * dt > -self.maxVal then
                self.xVal = self.xVal - self.accVal * dt
            else
                self.xVal = -self.maxVal
            end
        end
    end
end

function Player:stopping(dt)
    if self.xVal > 0 then
        self.xVal = math.max(self.xVal - self.stopVal * dt, 0)
    elseif self.xVal < 0 then
        self.xVal = math.min(self.xVal + self.stopVal * dt, 0)
    end
end

function Player:gravity(dt)
    if not self.grounded then
        self.yVal = self.yVal + self.grav * dt
    end
end

function Player:startContact(contA, contB, contP)
    if self.grounded == true then return end
    local nx, ny = contP:getNormal()
    if contA == self.physics.fixture then
        if ny > 0 then
            self:groundedPlayer(contP)
        elseif ny < 0 then
            self.yVal = 0
         end
    elseif contB == self.physics.fixture then 
        if ny < 0 then
            self:groundedPlayer(contP)
        elseif ny > 0 then
            self.yVal = 0
        end
    end
end

function Player:endContact(contA, contB, contP)
    if contA == self.physics.fixture or contB == self.physics.fixture then 
        if self.currentGrounding == contP then
            self.grounded = false
        end
    end
end

function Player:groundedPlayer(contP)
    self.yVal = 0
    self.grounded = true
    self.currentGrounding = contP
    self.inAir = true
end

function Player:jump(key)
    if key == "space" then
        if self.grounded then
            love.audio.play(jumpSound)
            self.yVal = self.jumpNum
        elseif self.inAir then
            self.inAir = false
            self.yVal = self.jumpNum * 0.8
        end
    end
end

function Player:setDirectional()
    if self.xVal < 0 then
        self.directional = "left"
    elseif self.xVal > 0 then
        self.directional = "right"
    end
end

function Player:draw()
    local scaleX = 1
    if self.directional == "left" then 
        scaleX = -1
    end
    love.graphics.setColor(self.color.red, self.color.green, self.color.blue)
    love.graphics.draw(self.animation.draw, self.xPos, self.yPos + 10, 0, scaleX, 1, self.animation.width / 2, self.animation.height / 2)
end

function Player:increaseDevilFruits()
    self.devilFruits = self.devilFruits + 1
end

function Player:healthLost(amount)
    if self.hp.startVal - amount > 0 then
        self.hp.startVal = self.hp.startVal - amount
    else 
        self.hp.startVal = 0
        self:gameOver()
    end
    print (self.hp.startVal)
    self:playerHit()
end

function Player:gameOver()
    print ("Game Over")
    self.life = false
end

function Player:respawn() 
    if not self.life then
        self:respawnPos()
        self.physics.body:setPosition(self.startXPos, self.startYPos)
        self.hp.startVal = self.hp.maxVal
        self.life = true
    end
end

function Player: playerHit()
    self.color.green = 0
    self.color.blue = 0
end

function Player: playerRecovered(dt)
    self.color.red = math.min(self.color.red + self.color.damageDur * dt, 1)
    self.color.green = math.min(self.color.green + self.color.damageDur * dt, 1)
    self.color.blue = math.min(self.color.blue + self.color.damageDur * dt, 1)
end

function Player:respawnPos()
    self.physics.body:setPosition(self.startXPos, self.startYPos)
end