Flag = Class{}


Flag = Class{}

local WALKING_SPEED = 30

function Flag:init(map)    
  
    self.map = map
    self.sounds = {
        ['victory'] = love.audio.newSource('sounds/kill.wav', 'static')
    }    
   
    self.y = 0
    self.x = 308
    self.dx = WALKING_SPEED
  
    self.height = 14
    self.y = map.tileHeight * (map.mapHeight - 30) - self.height

    self.xOffset = 4
    self.yOffset = 4
    flagx = self.x
    flagy = self.y
   
  
   flagimation =  flagAnimation(love.graphics.newImage("graphics/flag.png"),16,16,0.75)
  
     
   
end

 function flagAnimation(image, width, height, duration)

    local flagimation = {}
    flagimation.spriteSheet = image;
    flagimation.quads = {};
    if playerx == flagx and playery == flagy then 
        table.insert(flagimation.quads, love.graphics.newQuad(0, 16, 16, 16, image:getDimensions()))
    else         
        table.insert(flagimation.quads, love.graphics.newQuad(0 , 0, 16, 16, image:getDimensions()))
    end

    flagimation.duration = duration or 1
    flagimation.currentTime = 0
 
    return flagimation
end


function Flag:update(dt)

    flagimation.currentTime = flagimation.currentTime + dt
    if flagimation.currentTime >= flagimation.duration then
        flagimation.currentTime = flagimation.currentTime - flagimation.duration
    end    
    if self.x >= 400 then
        self.dx = -WALKING_SPEED
    elseif self.x <= 16 then

        self.dx = WALKING_SPEED
    end

    
    
end

function Flag:render()
    if self.dx > 0 then
        scaleX = 1
    elseif self.dx < 0 then
        scaleX = -1
    end
   
    
    local spriteNum = math.floor(flagimation.currentTime / flagimation.duration * #flagimation.quads) + 1
    
    love.graphics.draw(flagimation.spriteSheet, flagimation.quads[spriteNum], math.floor(self.x), 
        math.floor(self.y) , 0, scaleX, 1, self.xOffset, self.yOffset)


    

end
