

Creepr2 = Class{}

local WALKING_SPEED = 140
local DASH_VELOCITY = 400
local JUMP_VELOCITY = 200


function Creepr2:init(map)
    
    self.x = 0
    self.y = 0
    self.width = 15
    self.height = 20

    -- offset from top left to center to support sprite flipping
    self.xOffset = 8
    self.yOffset = 10

    -- reference to map for checking tiles
    self.map = map
    self.texture = love.graphics.newImage('graphics/creepr.png')

    -- sound effects
    self.sounds = {
       
    }

    -- animation frames
    self.frames = {}

    -- current animation frame
    self.currentFrame = nil

    -- used to determine behavior and animations
    self.state = 'idle'

    -- determines sprite flipping
    self.direction = 'left'

    -- x and y velocity
    self.dx = 0
    self.dy = 0

    -- position on top of  tiles
    self.y = map.tileHeight * (map.mapHeight - 24) - self.height
    self.x = map.tileWidth * 2

    -- initialize all player animations
    self.animations = {
        ['idle'] = Animation({
            texture = self.texture,
            frames = {
                love.graphics.newQuad(16, 2, 10, 12, self.texture:getDimensions())
            }
        }),
        ['jumping'] = Animation({
            texture = self.texture,
            frames = {
                love.graphics.newQuad(32, 2, 10, 12, self.texture:getDimensions())
            }

        })       
    }

    -- initialize animation and current frame we should render
    self.animation = self.animations['idle']
    self.currentFrame = self.animation:getCurrentFrame()

    -- behavior map we can call based on player state
    self.behaviors = {
        ['idle'] = function(dt)
            
            -- add spacebar functionality to trigger jump state
            if self.dy == 0 then
                self.dy = -JUMP_VELOCITY
                self.state = 'jumping'
                self.animation = self.animations['jumping']
                --self.sounds['jump']:play()
           
            else
                self.dx = 0
            end
        end,
       ['jumping'] = function(dt)            
            if self.dy > 0 then
                if self.dx == 0 then
                    self.direction = 'left'
                    self.dx = -WALKING_SPEED
                elseif self.x < 32  then
                    self.direction = 'right'
                    self.dx = WALKING_SPEED
                end
            end

            -- apply map's gravity before y velocity
            self.dy = self.dy + self.map.gravity

           

            -- check if there's a tile directly beneath us
            if self.map:collides(self.map:tileAt(self.x, self.y + self.height)) or
                self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y + self.height)) then
                
                -- if so, reset velocity and position and change state
                self.dy = 0
                self.state = 'idle'
                self.animation = self.animations['idle']
                self.y = (self.map:tileAt(self.x, self.y + self.height).y - 1) * self.map.tileHeight - self.height
            end

            -- check for collisions moving left and right
            self:checkRightCollision()
            self:checkLeftCollision()
        end            
    }

end

function Creepr2:update(dt)
    self.behaviors[self.state](dt)
    self.animation:update(dt)
    self.currentFrame = self.animation:getCurrentFrame()
    self.x = self.x + self.dx * dt
    
    self:calculateJumps()

    -- apply velocity
    self.y = self.y + self.dy * dt

end

-- jumping and block hitting logic
function Creepr2:calculateJumps()
    
    -- if we have negative y velocity (jumping), check if we collide
    -- with any blocks above us
    if self.dy < 0 then
        if self.map:tileAt(self.x, self.y).id == TILE_BRICK or
            self.map:tileAt(self.x + self.width - 1, self.y).id == TILE_BRICK then
            -- reset y velocity
            self.dy = 0

            
        end
    end
    
end

-- checks two tiles to our left to see if a collision occurred
function Creepr2:checkLeftCollision()
    if self.dx < 0 then
        -- check if there's a tile directly beneath us
        if self.map:collides(self.map:tileAt(self.x - 1, self.y)) or
            self.map:collides(self.map:tileAt(self.x - 1, self.y + self.height - 1)) then
            
            -- if so, reset velocity and position and change state
            self.dx = 0
            self.x = self.map:tileAt(self.x - 1, self.y).x * self.map.tileWidth
        end
    end
end

-- checks two tiles to our right to see if a collision occurred
function Creepr2:checkRightCollision()
    if self.dx > 0 then
        -- check if there's a tile directly beneath us
        if self.map:collides(self.map:tileAt(self.x + self.width, self.y)) or
            self.map:collides(self.map:tileAt(self.x + self.width, self.y + self.height - 1)) then
            
            -- if so, reset velocity and position and change state
            self.dx = 0
            self.x = (self.map:tileAt(self.x + self.width, self.y).x - 1) * self.map.tileWidth - self.width
        end
    end
end

function Creepr2:render()
    local scaleX

    -- set negative x scale factor if facing left, which will flip the sprite
    -- when applied
    if self.direction == 'right' then
        scaleX = 1
    else
        scaleX = -1
    end 
    
    love.graphics.draw(self.texture, self.currentFrame, math.floor(self.x + self.xOffset),
        math.floor(self.y + self.yOffset), 0, scaleX, 1, self.xOffset, self.yOffset)
end
