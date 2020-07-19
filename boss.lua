Boss = Class{}



Boss = Class{}

local WALKING_SPEED = 20
local DASH_VELOCITY = 400
local JUMP_VELOCITY = 200


function Boss:init(map)
    
    self.x = 0
    self.y = 0
    self.width = 15
    self.height = 47

    -- offset from top left to center to support sprite flipping
    self.xOffset = 8
    self.yOffset = 10

    -- reference to map for checking tiles
    self.map = map
    self.texture = love.graphics.newImage('graphics/boss.png')

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
    self.y = map.tileHeight * (map.mapHeight - 93) - self.height
    self.x = map.tileWidth * 20


    wait = true
    timer = 0
    -- initialize all player animations
    self.animations = {
        ['idle'] = Animation({
            texture = self.texture,
            frames = {
                love.graphics.newQuad(0, 0, 20, 28, self.texture:getDimensions())
    
            }
        }),
        ['walking'] = Animation({
            texture = self.texture,
            frames = {
                love.graphics.newQuad(128, 0, 20, 28, self.texture:getDimensions()),
                love.graphics.newQuad(160, 0, 20, 28, self.texture:getDimensions()),
                love.graphics.newQuad(192, 0, 20, 28, self.texture:getDimensions())
                
            },
            interval = 0.15
        })
    }

    -- initialize animation and current frame we should render
    self.animation = self.animations['idle']
    self.currentFrame = self.animation:getCurrentFrame()

    -- behavior map we can call based on player state
    self.behaviors = {
        ['idle'] = function(dt)
            
            -- add spacebar functionality to trigger jump state
           
            if self.x > playerx  then
                self.direction = 'left'
                self.dx = WALKING_SPEED
                self.state = 'walking'
                self.animations['walking']:restart()
                self.animation = self.animations['walking']
            elseif self.x < playerx then
                self.direction = 'right'
                self.dx = WALKING_SPEED
                self.state = 'walking'
                self.animations['walking']:restart()
                self.animation = self.animations['walking']
            else
                self.dx = 0
            end
        end,
        ['walking'] = function(dt)
            
            -- keep track of input to switch movement while walking, or reset
            -- to idle if we're not moving
            
            if self.x > playerx then
                self.direction = 'left'
                self.dx = -WALKING_SPEED
            elseif self.x < playerx then
                self.direction = 'right'
                self.dx = WALKING_SPEED
            else
                self.dx = 0
                self.state = 'idle'
                self.animation = self.animations['idle']
            end            
        end
    }

end

function Boss:update(dt)

    --jump timer
    timer = timer + dt

    if timer > 1 then
        wait = false
        timer = 0        
    end
    self.behaviors[self.state](dt)
    self.animation:update(dt)
    self.currentFrame = self.animation:getCurrentFrame()
    self.x = self.x + self.dx * dt
    
   

    -- apply velocity
    self.y = self.y + self.dy * dt

end

function Boss:render()
    local scaleX

    -- set negative x scale factor if facing left, which will flip the sprite
    -- when applied
    if self.direction == 'right' then
        scaleX = 2
    else
        scaleX = -2
    end 
    
    love.graphics.draw(self.texture, self.currentFrame, math.floor(self.x + self.xOffset),
        math.floor(self.y + self.yOffset), 0, scaleX, 2, self.xOffset, self.yOffset)
end
