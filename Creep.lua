
Creep = Class{}

local WALKING_SPEED = 30

function Creep:init(map)    
  
    self.map = map
    self.sounds = {
        ['victory'] = love.audio.newSource('sounds/kill.wav', 'static')
    }    
   
    self.y = 0
    self.x = 300
    self.dx = WALKING_SPEED
    creepdx2 = WALKING_SPEED
    creepdx3 = WALKING_SPEED
    creepdx4 = WALKING_SPEED
    creepdx5 = WALKING_SPEED

    self.height = 10
    self.y = map.tileHeight * (map.mapHeight - 1) - self.height

    self.xOffset = 4
    self.yOffset = 4

    creep2x = 100
    creep2y = map.tileHeight * (map.mapHeight - 5) - self.height

    creep3x = 80
    creep3y = map.tileHeight * (map.mapHeight - 9) - self.height

    creep4x = 25
    creep4y = map.tileHeight * (map.mapHeight - 13) - self.height

    creep5x = 180
    creep5y = map.tileHeight * (map.mapHeight - 17) - self.height
  
   animation =  newAnimation(love.graphics.newImage("graphics/creep1.png"),8,8,0.75)
  
     
   
end

 function newAnimation(image, width, height, duration)

    local animation = {}
    animation.spriteSheet = image;
    animation.quads = {};

    table.insert(animation.quads, love.graphics.newQuad(16 , 3, 10, 9, image:getDimensions()))
    table.insert(animation.quads, love.graphics.newQuad(32, 3, 10, 9, image:getDimensions()))    

    animation.duration = duration or 1
    animation.currentTime = 0
 
    return animation
end


function Creep:update(dt)

    animation.currentTime = animation.currentTime + dt
    if animation.currentTime >= animation.duration then
        animation.currentTime = animation.currentTime - animation.duration
    end    
    if self.x >= 400 then
        self.dx = -WALKING_SPEED
    elseif self.x <= 16 then

        self.dx = WALKING_SPEED
    end

    self.x = self.x + self.dx * dt
    if creep2x >= 368 then
        creepdx2 = -WALKING_SPEED
    elseif creep2x < 16 then
        creepdx2 = WALKING_SPEED
    end
    creep2x = creep2x + creepdx2 * dt

    if creep3x >= 400 then
        creepdx3 = -WALKING_SPEED
    elseif creep3x < 48 then
        creepdx3 = WALKING_SPEED
    end
    creep3x = creep3x + creepdx3 * dt

    if creep4x >= 184 then
        creepdx4 = -WALKING_SPEED
    elseif creep4x <= 16 then
        creepdx4 = WALKING_SPEED
    end
    creep4x = creep4x + creepdx4 * dt

    if creep5x >= 184 then
        creepdx5 = -WALKING_SPEED
    elseif creep5x <= 48 then
        creepdx5 = WALKING_SPEED
    end
    creep5x = creep5x + creepdx5 * dt
    
    
end

function Creep:render()
    if self.dx > 0 then
        scaleX = 1
    elseif self.dx < 0 then
        scaleX = -1
    end
    if creepdx2 > 0 then
        scaleX2 = 1
    elseif creepdx2 < 0 then
        scaleX2 = -1
    end
    if creepdx3 > 0 then
        scaleX3 = 1
    elseif creepdx3 < 0 then
        scaleX3 = -1
    end
    if creepdx4 > 0 then
        scaleX4 = 1
    elseif creepdx4 < 0 then
        scaleX4 = -1
    end
    if creepdx5 > 0 then
        scaleX5 = 1
    elseif creepdx5 < 0 then
        scaleX5 = -1
    end
    
    local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
    
    love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], math.floor(self.x + self.xOffset), 
        math.floor(self.y + self.yOffset) , 0, scaleX, 1, self.xOffset, self.yOffset)

    love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], math.floor(creep2x + self.xOffset), 
        math.floor(creep2y + self.yOffset) , 0, scaleX2, 1, self.xOffset, self.yOffset)

    love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], math.floor(creep3x + self.xOffset), 
    math.floor(creep3y + self.yOffset) , 0, scaleX3, 1, self.xOffset, self.yOffset)
    love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], math.floor(creep4x + self.xOffset), 
    math.floor(creep4y + self.yOffset) , 0, scaleX4, 1, self.xOffset, self.yOffset)
    love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], math.floor(creep5x + self.xOffset), 
    math.floor(creep5y + self.yOffset) , 0, scaleX5, 1, self.xOffset, self.yOffset)
    

end
