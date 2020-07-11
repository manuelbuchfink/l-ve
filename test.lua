function love.load()
    animation = newAnimation(love.graphics.newImage("spritesheet.png"),16,16,0.25)
end

function love.update(dt)
    animation.currentTime = animation.currentTime + dt
    if animation.currentTime >= animation.duration then
        animation.currentTime = animation.currentTime - animation.duration
    end
end

function love.draw()
    local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
    love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], 200, 200, 0, 4)
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