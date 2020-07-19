
Slime1 = Class{}

local WALKING_SPEED = 30

function Slime1:init(map)    
  
    self.map = map
    self.sounds = {
        ['victory'] = love.audio.newSource('sounds/kill.wav', 'static')
    }    
   
    self.y = 0
    self.x = 300
    self.dx = WALKING_SPEED
    

    self.height = 16
    self.y = map.tileHeight * (map.mapHeight - 1) - self.height

    self.xOffset = 8
    self.yOffset = 7

    

    
   newAnimationslime1 =  newAnimationslime1(love.graphics.newImage("graphics/slime.png"),16,16,1.25)
  
     
   
end

 function newAnimationslime1(image, width, height, duration)

    local newAnimationslime1 = {}
    newAnimationslime1.spriteSheet = image;
    newAnimationslime1.quads = {};

    table.insert(newAnimationslime1.quads, love.graphics.newQuad(0 , 0, 16, 16, image:getDimensions()))
    table.insert(newAnimationslime1.quads, love.graphics.newQuad(16, 0, 16, 16, image:getDimensions())) 
    table.insert(newAnimationslime1.quads, love.graphics.newQuad(32, 0, 16, 16, image:getDimensions()))     

    newAnimationslime1.duration = duration or 1
    newAnimationslime1.currentTime = 0
 
    return newAnimationslime1
end


function Slime1:update(dt)

    newAnimationslime1.currentTime = newAnimationslime1.currentTime + dt
    if newAnimationslime1.currentTime >= newAnimationslime1.duration then
        newAnimationslime1.currentTime = newAnimationslime1.currentTime - newAnimationslime1.duration
    end    
    if self.x >= 405 - self.height / 2 then
        self.dx = 0
        self.dy = -WALKING_SPEED
        self.y = self.y + self.dy * dt
        self.direction = 'up'
        rotate1 = math.pi * 1.5
    end
    if self.y <= map.tileHeight * (map.mapHeight - 3) - self.height + 2  then

        self.dx = -WALKING_SPEED
        self.dy = 0
        self.direction = 'left'
        rotate1 = math.pi
    end
    if self.x <= 16 then
        self.dx = 0
        self.dy = WALKING_SPEED
        self.y = self.y + self.dy * dt
        self.direction = 'down'
        rotate1 = math.pi / 2
    end
    if self.y >= map.tileHeight * (map.mapHeight - 1) - self.height then
        self.dy = 0
        self.dx = WALKING_SPEED
        self.direction = 'right'
        rotate1 = 0
    end


    self.x = self.x + self.dx * dt
    
    
    
end

function Slime1:render()
    if self.dx > 0 then
        scaleX = 1
    elseif self.dx < 0 then
        scaleX = -1
    end
    
    
    local spriteNum = math.floor(newAnimationslime1.currentTime / newAnimationslime1.duration * #newAnimationslime1.quads) + 1
    
    love.graphics.draw(newAnimationslime1.spriteSheet, newAnimationslime1.quads[spriteNum], math.floor(self.x + self.xOffset), 
        math.floor(self.y + self.yOffset) , rotate1, scaleX, 1, self.xOffset, self.yOffset)

    
    

end
 