Map = {}
local STI = require ("sti")

function Map:load()
    self.activeLevel = 1
    gameWorld = love.physics.newWorld(0, 600)
    gameWorld:setCallbacks(startContact, endContact)

    self:init()
end

function Map:spawnItems()
    for i, v in ipairs(Map.itemTier.objects) do
        if v.type == "devilFruit" then
            devilFruit.create(v.x, v.y)
        elseif v.type == "crate" then
            Crate.create (v.x + v.width / 2, v.y + v.height / 2)
        elseif v.type == "trap" then
            Trap.create (v.x + v.width / 2, v.y + v.height / 2)
        elseif v.type == "enemy" then
            Enemy.create (v.x + v.width / 2, v.y + v.height / 2)
        end
    end
end

function Map:next()
    self:wipe()
    self.activeLevel = self.activeLevel + 1
    self:init()
    Player:respawnPos()
end

function Map:wipe()
    self.level:box2d_removeLayer("Solid")
    devilFruit.destroyAll()
    Enemy.destroyAll()
    Crate.destroyAll()
    Trap.destroyAll()
end

function Map:init()
    self.level = STI("Map/"..self.activeLevel..".lua", {"box2d"})

    self.level:box2d_init(gameWorld)

    self.solidTier = self.level.layers.Solid
    self.groundTier = self.level.layers.Floor
    self.itemTier = self.level.layers.Items

    self.solidTier.visible = false
    self.itemTier.visible = false
    MapWidth = Map.groundTier.width * 16

    self:spawnItems()
end

function Map:update()
    if Player.xPos > MapWidth - 16 then
        if self.activeLevel == 5 then
            gameOver()
        else
            self:next()
        end
    end
end

function gameOver()
    local fadeTime = 1
    local displayTime = 5
    local t = 0
  
    local r, g, b, a = love.graphics.getBackgroundColor()
    love.graphics.setBackgroundColor(0, 0, 0)
  
    local font = love.graphics.newFont(48)
    love.graphics.setFont(font)
    love.graphics.setColor(1, 1, 1)
  
    while t <= fadeTime * 2 do
      local alpha = math.sin(t * math.pi / fadeTime)
      love.graphics.setColor(1, 1, 1, alpha)
  
      local text = "Game Over"
      local x = love.graphics.getWidth() / 2 - font:getWidth(text) / 2
      local y = love.graphics.getHeight() / 2 - font:getHeight() / 2
      love.graphics.print(text, x, y)
  
      love.graphics.present()
      love.timer.sleep(1 / 60)
      t = t + love.timer.getDelta()
    end
  
    love.graphics.setBackgroundColor(r, g, b, a)
    love.timer.sleep(displayTime)
    love.event.quit()
  end