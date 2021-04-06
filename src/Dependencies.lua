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

-- utilities
require 'src/constants'
require 'src/Util'
require 'src/StateMachine'
require 'src/Animation'

-- states
require 'src/states/BaseState'
require 'src/states/game/PlayState'
require 'src/states/entity/PlayerIdleState'
require 'src/states/entity/PlayerWalkingState'

--entities
require 'src/Entity'
require 'src/Player'

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
    ['tiles'] = love.graphics.newImage('graphics/tiles.png'),
    ['toppers'] = love.graphics.newImage('graphics/tile_tops.png'),
    ['bushes'] = love.graphics.newImage('graphics/bushes_and_cacti.png'),
    ['jump-blocks'] = love.graphics.newImage('graphics/jump_blocks.png'),
    ['gems'] = love.graphics.newImage('graphics/gems.png'),
    ['backgrounds'] = love.graphics.newImage('graphics/backgrounds.png'),
    ['green-alien'] = love.graphics.newImage('graphics/green_alien.png'),
    ['creatures'] = love.graphics.newImage('graphics/creatures.png')
}

gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tiles'], TILE_SIZE, TILE_SIZE),
    ['green-alien'] = GenerateQuads(gTextures['green-alien'], PLAYER_SPRITE_WIDTH, PLAYER_SPRITE_HEIGHT),
    ['backgrounds'] = GenerateQuads(gTextures['backgrounds'], 256, 128)
}

gFrames['tilesets'] = GenerateTileSets(
    gFrames['tiles'],
    TILE_SETS_WIDE, TILE_SETS_TALL,
    TILE_SET_WIDTH, TILE_SET_HEIGHT
)

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['title'] = love.graphics.newFont('fonts/ArcadeAlternate.ttf', 32)
}
