--[[
    PLAYER WALKING STATE CLASS
    CS50G Project 4
    Super 50 Bros
    Author: Maxime Blanc
    https://github.com/salty-max
--]]

PlayerWalkingState = Class{__includes = BaseState}

function PlayerWalkingState:init(player)
    self.player = player
    self.player.dx = PLAYER_WALK_SPEED
    self.animation = Animation {
        frames = {10, 11},
        interval = 0.2
    }

    self.player.currentAnimation = self.animation
end

function PlayerWalkingState:update(dt)
    self.player.currentAnimation:update(dt)
    
    if not love.keyboard.isDown('left') and not love.keyboard.isDown('right') then
        self.player:changeState('idle')
    else
        if love.keyboard.isDown('left') then
            self.player.x = self.player.x - self.player.dx * dt
            self.player.direction = 'left'
        elseif love.keyboard.isDown('right') then
            self.player.x = self.player.x + self.player.dx * dt
            self.player.direction = 'right'
        end
    end
end