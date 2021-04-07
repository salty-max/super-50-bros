--[[
    TILE CLASS
    CS50G Project 4
    Super 50 Bros
    Author: Maxime Blanc
    https://github.com/salty-max
--]]

Tile = Class{}

function Tile:init(x, y, id, topper, tileset, topperset)
    self.x = x
    self.y = y
    self.width = TILE_SIZE
    self.height = TILE_SIZE
    self.id = id
    self.topper = topper
    self.tileset = tileset
    self.topperset = topperset
end

function Tile:collidable()
    for k, v in pairs(COLLIDABLE_TILES) do
        if v == self.id then
            return true
        end
    end

    return false
end

function Tile:render()
    love.graphics.draw(
        gTextures['tiles'],
        gFrames['tilesets'][self.tileset][self.id],
        (self.x - 1) * TILE_SIZE,
        (self.y - 1) * TILE_SIZE
    )

    if self.topper then
        love.graphics.draw(
            gTextures['toppers'],
            gFrames['toppersets'][self.topperset][self.id],
            (self.x - 1) * TILE_SIZE,
            (self.y - 1) * TILE_SIZE
        )
    end
end