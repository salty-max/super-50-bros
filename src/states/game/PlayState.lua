--[[
    PLAY STATE CLASS
    CS50G Project 4
    Super 50 Bros
    Author: Maxime Blanc
    https://github.com/salty-max
--]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.camX = 0
    self.camY = 0

    self.background = math.random(3)
    self.backgroundX = 0

    self.player = Player ({
        x = VIRTUAL_WIDTH / 2 - (PLAYER_SPRITE_WIDTH / 2),
        y = ((7 - 1) * TILE_SIZE) - PLAYER_SPRITE_HEIGHT,
        width = PLAYER_SPRITE_WIDTH, height = PLAYER_SPRITE_HEIGHT,
        texture = 'green-alien',
        stateMachine = StateMachine {
            ['idle'] = function() return PlayerIdleState(self.player) end,
            ['walking'] = function() return PlayerWalkingState(self.player) end
        }
    })
    self.player:changeState('idle')

    self.tiles = {}

    mapWidth = 20
    mapHeight = 20

    for y = 1, mapHeight do
        table.insert(self.tiles, {})

        for x = 1, mapWidth do
            table.insert(self.tiles[y], {
                id = y < 7 and TILE_ID_EMPTY or TILE_ID_GROUND
            })
        end
    end
end

function PlayState:update(dt)
    
    self.player:update(dt)
    self:updateCamera()
end

function PlayState:render()
    -- repeat background multiple times along the tilemap
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX), 0)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX),
        gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX + 256), 0)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX + 256),
        gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)

    -- translate the entire view of the scene to emulate a camera
    love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))

    for y = 1, mapHeight do
        for x = 1, mapWidth do
            local tile = self.tiles[y][x]
            if tile.id == TILE_ID_GROUND then
                love.graphics.draw(gTextures['tiles'], gFrames['tiles'][6], (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE)
            end
        end
    end

    self.player:render()
end

function PlayState:updateCamera()
    -- clamp movement of the camera's X between 0 and the map bounds - virtual width,
    -- setting it half the screen to the left of the player so they are in the center
    self.camX = math.max(0,
        self.player.x - (VIRTUAL_WIDTH / 2 - self.player.width))

    -- adjust background X to move a third the rate of the camera for parallax
    self.backgroundX = (self.camX / 3) % VIRTUAL_WIDTH
end