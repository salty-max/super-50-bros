--[[
    SNAIL CLASS
    CS50G Project 4
    Super 50 Bros
    Author: Maxime Blanc
    https://github.com/salty-max
--]]

Snail = Class{__includes = Entity}

function Snail:init(def)
    Entity.init(self, def)
end

function Snail:render()
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.currentAnimation:getCurrentFrame()],
        math.floor(self.x) + 8, math.floor(self.y) + 8, 0, self.direction == 'left' and 1 or -1, 1, 8, 10)
end