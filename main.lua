--[[
    MAIN PROGRAM
    CS50G Project 4
    Super 50 Bros
    Author: Maxime Blanc
    https://github.com/salty-max
--]]

love.graphics.setDefaultFilter('nearest', 'nearest')

require 'src/Dependencies'

function love.load()
    love.window.setTitle('Super 50 Bros')

    math.randomseed(os.time())

    Push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    tiles = {}

    player = Player ({
        x = VIRTUAL_WIDTH / 2 - (PLAYER_SPRITE_WIDTH / 2),
        y = ((7 - 1) * TILE_SIZE) - PLAYER_SPRITE_HEIGHT,
        width = PLAYER_SPRITE_WIDTH, height = PLAYER_SPRITE_HEIGHT,
        texture = 'green-alien',
        stateMachine = StateMachine {
            ['idle'] = function() return PlayerIdleState(player) end,
            ['walking'] = function() return PlayerWalkingState(player) end
        }
    })
    player:changeState('idle')

    mapWidth = 20
    mapHeight = 20

    cameraScroll = 0

    backgroundR = math.random()
    backgroundG = math.random()
    backgroundB = math.random()

    for y = 1, mapHeight do
        table.insert(tiles, {})

        for x = 1, mapWidth do
            table.insert(tiles[y], {
                id = y < 7 and TILE_ID_EMPTY or TILE_ID_GROUND
            })
        end
    end

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    Push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    player:update(dt)

    cameraScroll = -math.floor(player.x - (VIRTUAL_WIDTH / 2) + (PLAYER_SPRITE_WIDTH / 2))

    love.keyboard.keysPressed = {}
end

function love.draw()
    Push:start()

    love.graphics.clear(backgroundR, backgroundG, backgroundB, 1)

    love.graphics.translate(cameraScroll, 0)

    for y = 1, mapHeight do
        for x = 1, mapWidth do
            local tile = tiles[y][x]
            if tile.id == TILE_ID_GROUND then
                love.graphics.draw(gTextures['tiles'], gFrames['tiles'][6], (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE)
            end
        end
    end

    player:render()

    Push:finish()
end

