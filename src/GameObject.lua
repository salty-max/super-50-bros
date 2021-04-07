--[[
    GAME OBJECT CLASS
    CS50G Project 4
    Super 50 Bros
    Author: Maxime Blanc
    https://github.com/salty-max
--]]

GameObject = Class{}

function GameObject:init(def)
  self.x = def.x
  self.y = def.y
  self.width = def.width
  self.height = def.height

  self.texture = def.texture
  self.frame = def.frame

  self.solid = def.solid
  self.collidable = def.collidable
  self.consumable = def.consumable
  self.onCollide = def.onCollide
  self.onConsume = def.onConsume
  self.hit = def.hit
end

function GameObject:collides(target)
  return not (target.x > self.x + self.width or self.x > target.x + target.width or
              target.y > self.y + self.height or self.y > target.y + target.height)
end

function GameObject:update(dt)
end

function GameObject:render()
  love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.frame], self.x, self.y)
end