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

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end
    }
    gStateMachine:change('start', {
        score = 0,
        levelId = 1
    })

    gSounds['music']:setLooping(true)
    gSounds['music']:setVolume(0.5)
    gSounds['music']:play()

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
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    Push:start()

    gStateMachine:render()

    Push:finish()
end

