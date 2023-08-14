love.graphics.setDefaultFilter("nearest", "nearest")
require ("player")
require("score")
require("devilfruit")
require("traps")
require("tracker")
require("crate")
require("enemy")
require("map")

function love.load()
    Enemy.loadAssets()
    Map:load()
    background = love.graphics.newImage("assets/background.jpg")
    Player:load()
    Score:load()
    bgm = love.audio.newSource("assets/bgmusic.mp3", "stream")
    bgm:setLooping(true) 
    bgm:play() 
end

function love.update(dt)
    gameWorld:update(dt)
    Player:update(dt)
    devilFruit.updateAll(dt)
    Trap:update(dt)
    Crate.updateAll(dt)
    Enemy.updateAll(dt)
    Score:update(dt)
    Tracker:setPos(Player.xPos, 0)
    Map:update(dt)
end


function love.draw()
    love.graphics.draw(background)
    Map.level:draw(-Tracker.xPos, -Tracker.yPos, 2, 2)   
    Tracker:apply()

    Player:draw()
    devilFruit.drawAll()
    Trap.drawAll()
    Crate:drawAll()
    Enemy.drawAll()
    Tracker:clear()

    Score:draw()
 
end

function startContact(contA, contB, contP)
    if devilFruit.startContact(contA, contB, contP) then return end
    if Trap.startContact(contA, contB, contP) then return end
    Enemy.startContact(contA, contB, contP)
    Player:startContact(contA, contB, contP)
end

function endContact(contA, contB, contP)
    Player:endContact(contA, contB, contP)
end

function love.keypressed(key)
    Player:jump(key)
    print(key)
end