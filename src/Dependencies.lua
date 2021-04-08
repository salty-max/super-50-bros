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
require 'src/LevelMaker'
require 'src/GameLevel'
require 'src/Tile'
require 'src/TileMap'
require 'src/GameObject'

-- states
require 'src/states/BaseState'
require 'src/states/game/StartState'
require 'src/states/game/PlayState'
require 'src/states/entity/PlayerIdleState'
require 'src/states/entity/PlayerWalkingState'
require 'src/states/entity/PlayerJumpState'
require 'src/states/entity/PlayerFallingState'
require 'src/states/entity/snail/SnailIdleState'
require 'src/states/entity/snail/SnailMovingState'
require 'src/states/entity/snail/SnailChasingState'

--entities
require 'src/Entity'
require 'src/Player'
require 'src/Snail'

gSounds = {
    ['music']           = love.audio.newSource('sounds/music.wav', 'static'),
    ['death']           = love.audio.newSource('sounds/death.wav', 'static'),
    ['jump']            = love.audio.newSource('sounds/jump.wav', 'static'),
    ['kill']            = love.audio.newSource('sounds/kill.wav', 'static'),
    ['kill2']           = love.audio.newSource('sounds/kill2.wav', 'static'),
    ['pickup']          = love.audio.newSource('sounds/pickup.wav', 'static'),
    ['powerup-reveal']  = love.audio.newSource('sounds/powerup-reveal.wav', 'static'),
    ['empty-block']     = love.audio.newSource('sounds/empty-block.wav', 'static'),
    ['unlock']          = love.audio.newSource('sounds/unlock.wav', 'static'),
    ['raise-flag']      = love.audio.newSource('sounds/raise-flag.wav', 'static'),
}

gFonts = {
    ['small']           = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium']          = love.graphics.newFont('fonts/font.ttf', 16),
    ['large']           = love.graphics.newFont('fonts/font.ttf', 32),
    ['title']           = love.graphics.newFont('fonts/ArcadeAlternate.ttf', 32)
}

gTextures = {
    ['tiles']           = love.graphics.newImage('graphics/tiles.png'),
    ['toppers']         = love.graphics.newImage('graphics/tile_tops.png'),
    ['bushes']          = love.graphics.newImage('graphics/bushes_and_cacti.png'),
    ['jump-blocks']     = love.graphics.newImage('graphics/jump_blocks.png'),
    ['gems']            = love.graphics.newImage('graphics/gems.png'),
    ['backgrounds']     = love.graphics.newImage('graphics/backgrounds.png'),
    ['green-alien']     = love.graphics.newImage('graphics/green_alien.png'),
    ['blue-alien']      = love.graphics.newImage('graphics/blue_alien.png'),
    ['pink-alien']      = love.graphics.newImage('graphics/pink_alien.png'),
    ['creatures']       = love.graphics.newImage('graphics/creatures.png'),
    ['keys-locks']      = love.graphics.newImage('graphics/keys_and_locks.png'),
    ['flags']           = love.graphics.newImage('graphics/flags.png'),
    ['key']             = love.graphics.newImage('graphics/key.png'),
}

gFrames = {
    ['tiles']           = GenerateQuads(gTextures['tiles'], TILE_SIZE, TILE_SIZE),
    ['toppers']         = GenerateQuads(gTextures['toppers'], TILE_SIZE, TILE_SIZE),
    ['backgrounds']     = GenerateQuads(gTextures['backgrounds'], 256, 128),
    ['bushes']          = GenerateQuads(gTextures['bushes'], TILE_SIZE, TILE_SIZE),
    ['jump-blocks']     = GenerateQuads(gTextures['jump-blocks'], TILE_SIZE, TILE_SIZE),
    ['gems']            = GenerateQuads(gTextures['gems'], TILE_SIZE, TILE_SIZE),
    ['green-alien']     = GenerateQuads(gTextures['green-alien'], PLAYER_SPRITE_WIDTH, PLAYER_SPRITE_HEIGHT),
    ['blue-alien']      = GenerateQuads(gTextures['blue-alien'], PLAYER_SPRITE_WIDTH, PLAYER_SPRITE_HEIGHT),
    ['pink-alien']      = GenerateQuads(gTextures['pink-alien'], PLAYER_SPRITE_WIDTH, PLAYER_SPRITE_HEIGHT),
    ['creatures']       = GenerateQuads(gTextures['creatures'], TILE_SIZE, TILE_SIZE),
    ['keys-locks']      = GenerateQuads(gTextures['keys-locks'], TILE_SIZE, TILE_SIZE),
    ['flags']           = GenerateFlagsQuads(gTextures['flags'])
}

gFrames['keys'] = GenerateKeysQuads(gFrames['keys-locks'])
gFrames['locks'] = GenerateKeysQuads(gFrames['keys-locks'])

gFrames['tilesets'] = GenerateTileSets(
    gFrames['tiles'],
    TILE_SETS_WIDE, TILE_SETS_TALL,
    TILE_SET_WIDTH, TILE_SET_HEIGHT
)
gFrames['toppersets'] = GenerateTileSets(
    gFrames['toppers'],
    TOPPER_SETS_WIDE, TOPPER_SETS_TALL,
    TILE_SET_WIDTH, TILE_SET_HEIGHT
)
