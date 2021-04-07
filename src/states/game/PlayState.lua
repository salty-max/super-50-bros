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

    self.tileset = math.random(#gFrames['tilesets'])
    self.topperset = math.random(#gFrames['toppersets'])

    self.level = LevelMaker.generate(100, 20)
    self.tilemap = self.level.tilemap

    self.player = Player ({
        x = 0,
        y = 0,
        width = PLAYER_SPRITE_WIDTH, height = PLAYER_SPRITE_HEIGHT,
        texture = PLAYER_SKINS[math.random(3)],
        stateMachine = StateMachine {
            ['idle'] = function() return PlayerIdleState(self.player) end,
            ['walking'] = function() return PlayerWalkingState(self.player) end,
            ['jump'] = function() return PlayerJumpState(self.player, GRAVITY) end,
            ['falling'] = function() return PlayerFallingState(self.player, GRAVITY) end
        },
        level = self.level,
        map = self.level.tilemap
    })
    self.player:changeState('falling')

    self:spawnEnemies()
end

function PlayState:update(dt)
    Timer.update(dt)

    -- remove any nils from pickups, etc.
    self.level:clear()

    self.player:update(dt)
    self.level:update(dt)
    self:updateCamera()

    -- constrain player X no matter which state
    if self.player.x <= 0 then
        self.player.x = 0
    elseif self.player.x > TILE_SIZE * self.tilemap.width - self.player.width then
        self.player.x = TILE_SIZE * self.tilemap.width - self.player.width
    end
end

function PlayState:render()
    love.graphics.push()
    -- repeat background multiple times along the tilemap
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX), 0)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX),
        gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX + 256), 0)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX + 256),
        gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)

    -- translate the entire view of the scene to emulate a camera
    love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))

    self.level:render()
    self.player:render()

    love.graphics.pop()

    -- render score
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(tostring(self.player.score), 5, 5)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(tostring(self.player.score), 4, 4)
end

function PlayState:updateCamera()
    -- clamp movement of the camera's X between 0 and the map bounds - virtual width,
    -- setting it half the screen to the left of the player so they are in the center
    self.camX = math.max(0,
        self.player.x - (VIRTUAL_WIDTH / 2 - self.player.width))

    -- adjust background X to move a third the rate of the camera for parallax
    self.backgroundX = (self.camX / 3) % VIRTUAL_WIDTH
end

--[[
    Adds a series of enemies to the level randomly.
]]
function PlayState:spawnEnemies()
    -- spawn snails in the level
    for x = 1, self.tilemap.width do

        -- flag for whether there's ground on this column of the level
        local groundFound = false

        for y = 1, self.tilemap.height do
            if not groundFound then
                if self.tilemap.tiles[y][x].id == TILE_ID_GROUND then
                    groundFound = true

                    -- random chance, 1 in 20
                    if math.random(SNAIL_SPAWN_CHANCE) == 1 then
                        
                        -- instantiate snail, declaring in advance so we can pass it into state machine
                        local snail
                        snail = Snail {
                            texture = 'creatures',
                            x = (x - 1) * TILE_SIZE,
                            y = (y - 2) * TILE_SIZE + 2,
                            width = 16,
                            height = 16,
                            stateMachine = StateMachine {
                                ['idle'] = function() return SnailIdleState(self.tilemap, self.player, snail) end,
                                ['moving'] = function() return SnailMovingState(self.tilemap, self.player, snail) end,
                                ['chasing'] = function() return SnailChasingState(self.tilemap, self.player, snail) end
                            }
                        }
                        snail:changeState('idle', {
                            wait = math.random(5)
                        })

                        table.insert(self.level.entities, snail)
                    end
                end
            end
        end
    end
end