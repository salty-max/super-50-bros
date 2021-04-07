--[[
    GAME LEVEL CLASS
    CS50G Project 4
    Super 50 Bros
    Author: Maxime Blanc
    https://github.com/salty-max
--]]

GameLevel = Class{}

function GameLevel:init(entities, objects, tilemap)
  self.entities = entities
  self.objects = objects
  self.tilemap = tilemap
end

--[[
    Remove all nil references from tables in case they've set themselves to nil.
]]
function GameLevel:clear()
    for i = #self.objects, 1, -1 do
        if not self.objects[i] then
            table.remove(self.objects, i)
        end
    end

    for i = #self.entities, 1, -1 do
        if not self.objects[i] then
            table.remove(self.objects, i)
        end
    end
end

function GameLevel:update(dt)
  self.tilemap:update(dt)

  for k, object in pairs(self.objects) do
    object:update(dt)
  end

  for k, entity in pairs(self.entities) do
    entity:update(dt)
  end
end

function GameLevel:render()
  self.tilemap:render()

  for k, object in pairs(self.objects) do
    object:render()
  end

  for k, entity in pairs(self.entities) do
    entity:render()
  end
end