
Flagpole = Class{}

local VICTORY_SPEED = 50

function Flagpole:init(map)
    
    
   -- self.map = Map(self)
    self.map = map
    self.sounds = {
        ['victory'] = love.audio.newSource('sounds/victory.wav', 'static')
    }    
   -- self.x = map.mapWidthPixels - map.tileWidth * 3.25
    self.y = 0
    self.dy = VICTORY_SPEED
    self.y = 160
  
   animation = newAnimation(love.graphics.newImage("graphics/spritesheet.png"),16,16,0.25)  
   victoryfont = love.graphics.newFont('fonts/font.ttf', 16)
   
   
end

function newAnimation(image, width, height, duration)

    local animation = {}
    animation.spriteSheet = image;
    animation.quads = {};

    table.insert(animation.quads, love.graphics.newQuad(0, 48, 16, 16, image:getDimensions()))
    table.insert(animation.quads, love.graphics.newQuad(16, 48, 16, 16, image:getDimensions()))
    table.insert(animation.quads, love.graphics.newQuad(32, 48, 16, 16, image:getDimensions()))
    

    animation.duration = duration or 1
    animation.currentTime = 0
 
    return animation
end


function Flagpole:update(dt)

    animation.currentTime = animation.currentTime + dt
    if animation.currentTime >= animation.duration then
        animation.currentTime = animation.currentTime - animation.duration
    end    
    
    if playerx >= map.mapWidthPixels - map.tileWidth * 3.25 and playery >= map.mapHeightPixels / 2 - map.tileHeight * 3 then
        gamestate = 'Victory'        
    end

    if gamestate == 'Victory' then
        if self.y < map.mapHeightPixels / 2 - map.tileHeight * 2 then
            self.y = self.y + self.dy *dt
        end        
    end
end

function Flagpole:render()
    
    if gamestate == 'Victory' then
        love.graphics.setFont(victoryfont)
        love.graphics.printf('Victory!', map.mapWidthPixels - map.tileWidth * 17 , 20, 100, 'center')
    end

    local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
    love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], map.mapWidthPixels - map.tileWidth * 3.25, self.y , 0, 1)

end
