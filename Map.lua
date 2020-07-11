--[[
    Contains tile data and necessary code for rendering a tile map to the
    screen.
]]

require 'Util'

Map = Class{}

TILE_BRICK = 36
--TILE_EMPTY = -1

TILE_WALL = 132

-- a speed to multiply delta time to scroll map; smooth value
local SCROLL_SPEED = 62

-- constructor for our map object
function Map:init()

    self.spritesheet = love.graphics.newImage('graphics/spritesheet.png')
    
    self.sprites = generateQuads(self.spritesheet, 16, 16)
    self.music = love.audio.newSource('sounds/music.wav', 'static')

    self.tileWidth = 16
    self.tileHeight = 16
    self.mapWidth = 27
    self.mapHeight = 100
    self.tiles = {}

    -- applies positive Y influence on anything affected
    self.gravity = 20


    -- associate player with map
    self.player = Player(self)
    



    -- camera offsets
    self.camX = 0
    self.camY = 0

    -- cache width and height of map in pixels
    self.mapWidthPixels = self.mapWidth * self.tileWidth
    self.mapHeightPixels = self.mapHeight * self.tileHeight

    -- first, fill map with empty tiles
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            
            -- support for multiple sheets per tile; storing tiles as tables 
            self:setTile(x, y, TILE_WALL)
            
        end
    end
    
    

    -- begin generating the terrain using vertical scan lines
    local x = 1
    local y = 1
    while x <= self.mapWidth do


        --create left wall
        if x == 1 then
            for y = 0, self.mapHeight do
                self:setTile(x, y, TILE_BRICK)
            end
        
        
        --create right wall
        elseif x == self.mapWidth  then
            for y = 0, self.mapHeight do
                self:setTile(x, y, TILE_BRICK)
            end
        end     
         x = x + 1          
    
    end

    
    while y <= self.mapHeight do
        local h = 4
         --create ceiling
        if y == 1 then
            for x= 0, self.mapWidth do
                self:setTile(x,y, TILE_BRICK)
            end
           

        --create floor
        elseif y == self.mapHeight then
            for x = 0, self.mapWidth do
                self:setTile(x, y, TILE_BRICK)
            end
        end

        --[[ y = y + 1 
        
        if y == self.mapHeight - h then
            for x = 0, self.mapWidth - 3 do
                self:setTile(x, y, TILE_BRICK)
            end
        
            h = h + 4
        elseif y == self.mapHeight - h then
            for x = 4, self.mapWidth do
                self:setTile(x, y, TILE_BRICK)
            end

            h = h + 4
        end ]]
        
       
           --create platforms
            if y == self.mapHeight - 4 then
                for x = 0, self.mapWidth - 3 do
                    self:setTile(x, y, TILE_BRICK)
                end
            

            elseif y == self.mapHeight - 8 then
                for x = 4, self.mapWidth do
                    self:setTile(x, y, TILE_BRICK)
                end
            

            elseif y == self.mapHeight - 12 then
                for x = 0, self.mapWidth do
                    self:setTile(x, y, TILE_BRICK)
                end
                for x = self.mapWidth - 14, self.mapWidth - 11 do
                    self:setTile(x, y, TILE_WALL)
                end       
            

            elseif y == self.mapHeight - 16 then
                for x = 4, self.mapWidth do
                    self:setTile(x, y, TILE_BRICK)
                end

            elseif y == self.mapHeight - 20 then
                for x = 0, self.mapWidth - 3 do
                    self:setTile(x, y, TILE_BRICK)
                end

            elseif y == self.mapHeight - 24 then
                for x = 4, self.mapWidth do
                    self:setTile(x, y, TILE_BRICK)
                end

            elseif y == self.mapHeight - 28 then
                for x = 0, self.mapWidth - 3 do
                    self:setTile(x, y, TILE_BRICK)
                end
                for x = self.mapWidth - 14, self.mapWidth - 11 do
                    self:setTile(x, y, TILE_WALL)
                end

            elseif y == self.mapHeight - 32 then
                for x = 4, self.mapWidth do
                    self:setTile(x, y, TILE_BRICK)
                end

            elseif y == self.mapHeight - 36 then
                for x = 0, self.mapWidth - 3 do
                    self:setTile(x, y, TILE_BRICK)
                end

            elseif y == self.mapHeight - 40 then
                for x = 4, self.mapWidth do
                    self:setTile(x, y, TILE_BRICK)
                end

            elseif y == self.mapHeight - 44 then
                for x = 0, self.mapWidth - 3 do
                    self:setTile(x, y, TILE_BRICK)
                end

            elseif y == self.mapHeight - 48 then
                for x = 4, self.mapWidth do
                    self:setTile(x, y, TILE_BRICK)
                end

            elseif y == self.mapHeight - 52 then
                for x = 0, self.mapWidth - 3 do
                    self:setTile(x, y, TILE_BRICK)
                end
                for x = self.mapWidth - 14, self.mapWidth - 11 do
                    self:setTile(x, y, TILE_WALL)
                end

            elseif y == self.mapHeight - 56 then
                for x = 4, self.mapWidth do
                    self:setTile(x, y, TILE_BRICK)
                end

            elseif y == self.mapHeight - 60 then
                for x = 0, self.mapWidth - 3 do
                    self:setTile(x, y, TILE_BRICK)
                end

            elseif y == self.mapHeight - 64 then
                for x = 4, self.mapWidth do
                    self:setTile(x, y, TILE_BRICK)
                end

            elseif y == self.mapHeight - 68 then
                for x = 0, self.mapWidth - 3 do
                    self:setTile(x, y, TILE_BRICK)
                end

            elseif y == self.mapHeight - 72 then
                for x = 4, self.mapWidth do
                    self:setTile(x, y, TILE_BRICK)
                end
                for x = self.mapWidth - 14, self.mapWidth - 11 do
                    self:setTile(x, y, TILE_WALL)
                end

            elseif y == self.mapHeight - 76 then
                for x = 0, self.mapWidth - 3 do
                    self:setTile(x, y, TILE_BRICK)
                end

            elseif y == self.mapHeight - 80 then
                for x = 4, self.mapWidth do
                    self:setTile(x, y, TILE_BRICK)
                end

            elseif y == self.mapHeight - 84 then
                for x = 0, self.mapWidth - 3 do
                    self:setTile(x, y, TILE_BRICK)
                end

            elseif y == self.mapHeight - 88 then
                for x = 4, self.mapWidth do
                    self:setTile(x, y, TILE_BRICK)
                end

            elseif y == self.mapHeight - 92 then
                for x = 0, self.mapWidth - 3 do
                    self:setTile(x, y, TILE_BRICK)
                end

            
            end        
        y = y + 1 

    end
    

    -- start the background music
    self.music:setLooping(true)
    self.music:play()
end

-- return whether a given tile is collidable
function Map:collides(tile)
    -- define our collidable tiles
    local collidables = {
        TILE_BRICK
    }

    -- iterate and return true if our tile type matches
    for _, v in ipairs(collidables) do
        if tile.id == v then
            return true
        end
    end

    return false
end

-- function to update camera offset with delta time
function Map:update(dt)
    self.player:update(dt)
    
    
    -- keep camera's X coordinate following the player, preventing camera from
    -- scrolling past 0 to the left and the map's width
    self.camX = math.max(0, math.min(self.player.x - VIRTUAL_WIDTH / 2,
        math.min(self.mapWidthPixels - VIRTUAL_WIDTH, self.player.x)))

    self.camY = self.player.y - VIRTUAL_HEIGHT  + self.player.height + self.tileHeight
    --if self.player.y < self.mapHeight - 4 then
       -- self.camY = self.player.y - VIRTUAL_HEIGHT  + self.player.height + self.tileHeight
    
        
    --end
end

-- gets the tile type at a given pixel coordinate
function Map:tileAt(x, y)
    return {
        x = math.floor(x / self.tileWidth) + 1,
        y = math.floor(y / self.tileHeight) + 1,
        id = self:getTile(math.floor(x / self.tileWidth) + 1, math.floor(y / self.tileHeight) + 1)
    }
end

-- returns an integer value for the tile at a given x-y coordinate
function Map:getTile(x, y)
    return self.tiles[(y - 1) * self.mapWidth + x]
end

-- sets a tile at a given x-y coordinate to an integer value
function Map:setTile(x, y, id)
    self.tiles[(y - 1) * self.mapWidth + x] = id
end

-- renders our map to the screen, to be called by main's render
function Map:render()
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            local tile = self:getTile(x, y)
            if tile ~= TILE_WALL then
                love.graphics.draw(self.spritesheet, self.sprites[tile],
                    (x - 1) * self.tileWidth, (y - 1) * self.tileHeight)
            
            else
                love.graphics.draw(self.spritesheet, self.sprites[tile],
                    (x - 1) * self.tileWidth, (y - 1) * self.tileHeight)
            end

        end
    end
    self.player:render()
    
end
