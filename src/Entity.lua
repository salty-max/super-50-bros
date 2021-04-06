--[[
    ENTITY CLASS
    CS50G Project 4
    Super 50 Bros
    Author: Maxime Blanc
    https://github.com/salty-max
--]]

Entity = Class{}

function Entity:init(def)
  self.x = def.x
  self.y = def.y

  self.dx = 0
  self.dy = 0

  self.texture = def.texture

  self.stateMachine = def.stateMachine

  self.direction = 'right'

  self.width = def.width
  self.height = def.height
end

function Entity:changeState(state, params)
    self.stateMachine:change(state, params)
end

function Entity:update(dt)
    self.stateMachine:update(dt)
end

function Entity:collides(entity)
    return not (self.x > entity.x + entity.width or entity.x > self.x + self.width or
                self.y > entity.y + entity.height or entity.y > self.y + self.height)
end

function Entity:render()
    love.graphics.draw(
        gTextures[self.texture],
        gFrames[self.texture][self.currentAnimation:getCurrentFrame()],
        math.floor(self.x) + self.width / 2, math.floor(self.y) + self.height / 2,
        0, self.direction == 'right' and 1 or -1, 1,
        self.width / 2, self.height / 2
    )

    love.graphics.print(self.currentAnimation:getCurrentFrame(), 5, 5)
end