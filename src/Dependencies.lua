--[[
    DEPENDENCIES
    CS50G Project 4
    Super 50 Bros
    Author: Maxime Blanc
    https://github.com/salty-max
--]]

-- libs
Push = require 'lib/push'
Class = require 'lib/class'
Timer = require 'lib/knife.timer'

-- constants
require 'src/constants'

-- utils
require 'src/Util'

-- state machine
require 'src/StateMachine'

-- states
require 'src/states/BaseState'

gSounds = {
    ['music'] = love.audio.newSource('sounds/music.wav', 'static'),
    ['death'] = love.audio.newSource('sounds/death.wav', 'static'),
    ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
    ['kill'] = love.audio.newSource('sounds/kill.wav', 'static'),
    ['kill2'] = love.audio.newSource('sounds/kill2.wav', 'static'),
    ['pickup'] = love.audio.newSource('sounds/pickup.wav', 'static'),
    ['powerup-reveal'] = love.audio.newSource('sounds/powerup-reveal.wav', 'static'),
    ['empty-block'] = love.audio.newSource('sounds/empty-block.wav', 'static')
}

gTextures = {
    ['backgrounds'] = love.graphics.newImage('graphics/backgrounds.png'),
    ['blue_alien'] = love.graphics.newImage('graphics/blue_alien.png'),
    ['bushes_and_cacti'] = love.graphics.newImage('graphics/bushes_and_cacti.png'),
    ['buttons'] = love.graphics.newImage('graphics/buttons.png'),
    ['coins_and_bombs'] = love.graphics.newImage('graphics/coins_and_bombs.png'),
    ['crates_and_blocks'] = love.graphics.newImage('graphics/crates_and_blocks.png'),
    ['creatures'] = love.graphics.newImage('graphics/creatures.png'),
    ['doors_and_windows'] = love.graphics.newImage('graphics/doors_and_windows.png'),
    ['faces_and_hills'] = love.graphics.newImage('graphics/faces_and_hills.png'),
    ['fireballs'] = love.graphics.newImage('graphics/fireballs.png'),
    ['flags'] = love.graphics.newImage('graphics/flags.png'),
    ['gems'] = love.graphics.newImage('graphics/gems.png'),
    ['green_alien'] = love.graphics.newImage('graphics/green_alien.png'),
    ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
    ['jump_blocks'] = love.graphics.newImage('graphics/jump_blocks.png'),
    ['keys_and_locks'] = love.graphics.newImage('graphics/keys_and_locks.png'),
    ['ladder_and_signs'] = love.graphics.newImage('graphics/ladder_and_signs.png'),
    ['mushrooms'] = love.graphics.newImage('graphics/mushrooms.png'),
    ['numbers'] = love.graphics.newImage('graphics/numbers.png')
}

gFrames = {}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
}
