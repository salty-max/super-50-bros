--[[
    LEVEL MAKER CLASS
    CS50G Project 4
    Super 50 Bros
    Author: Maxime Blanc
    https://github.com/salty-max
--]]

LevelMaker = Class{}

function LevelMaker.generate(width, height)
    local tiles = {}
    local objects = {}
    local entities = {}

    local tileset = math.random(#gFrames['tilesets'])
    local topperset = math.random(#gFrames['toppersets'])

    local keySpawned = false
    local lockSpawned = false
    local keyLockColor = math.random(4)

    -- create 2D array filled with emptyness
    for y = 1, height do
        table.insert(tiles, {})

        for x = 1, width do
            table.insert(tiles[y], Tile(
                x, y,
                TILE_ID_EMPTY,
                nil,
                tileset,
                topperset
            ))
        end
    end

    -- iterate column by column
    for col = 1, width do
        local tileId = TILE_ID_EMPTY
        -- y at which could be an jump block
        local blockHeight = 4
        -- first tile and last 3 ones are always ground; so don't generate chasm on those
        if math.random(CHASM_CHANCE) == 1 and not (col == 1 or col >= width - 3) then
            for ground = 7, height do
                tiles[ground][col] = Tile(
                    col, ground,
                    tileId,
                    nil,
                    tileset, topperset
                )
            end
        else
            tileId = TILE_ID_GROUND
            -- always generate TILE_ID_GROUND
            for ground = 7, height do
                tiles[ground][col].id = tileId
                tiles[ground][col].topper = ground == 7
            end

            -- random chance for a pillar
            local spawnPillar = math.random(PILLAR_CHANCE) == 1

            -- don't spawn pillars at the end of the level; leave room for
            -- the flag
            if spawnPillar and col < width - 3 then
                blockHeight = 2

                -- chance to generate a bush on top of the pillar
                if math.random(8) == 1 then
                    table.insert(objects, GameObject({
                        texture = 'bushes',
                        x = (col - 1) * TILE_SIZE,
                        y = (4 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        -- select random frame from bush_ids whitelist, then random row for variance
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false
                    }))
                end

                -- pillar tiles
                tiles[5][col] = Tile(col, 5, tileId, true, tileset, topperset)
                tiles[6][col] = Tile(col, 6, tileId, nil, tileset, topperset)
                tiles[7][col].topper = nil
            -- chance to generate a bush
            elseif math.random(8) == 1 then
                table.insert(objects, GameObject({
                    texture = 'bushes',
                    x = (col - 1) * TILE_SIZE,
                    y = (6 - 1) * TILE_SIZE,
                    width = 16,
                    height = 16,
                    -- select random frame from bush_ids whitelist, then random row for variance
                    frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                    collidable = false
                }))
            end

            -- chance to generate jump block
            if math.random(BLOCK_CHANCE) == 1 and col < width - 3 then
                table.insert(objects, GameObject {
                    texture = 'jump-blocks',
                    x = (col - 1) * TILE_SIZE,
                    y = (blockHeight - 1) * TILE_SIZE,
                    width = 16,
                    height = 16,
                    frame = math.random(#JUMP_BLOCKS),
                    collidable = true,
                    hit = false,
                    solid = true,
                    onCollide = function(obj)
                        if not obj.hit then
                            -- chance to spawn gem
                            if math.random(GEM_CHANCE) == 1 then
                                -- maintain reference to set it to nil later
                                local gem = GameObject {
                                    texture = 'gems',
                                    x = (col - 1) * TILE_SIZE,
                                    y = (blockHeight - 1) * TILE_SIZE - 4,
                                    width = 16,
                                    height = 16,
                                    frame = math.random(#GEMS),
                                    collidable = true,
                                    consumable = true,
                                    solid = false,
                                    onConsume = function(player, object)
                                        gSounds['pickup']:play()
                                        player.score = player.score + 100
                                    end
                                }

                                -- make the gem move up from the block and make a sound
                                Timer.tween(0.1, {
                                    [gem] = { y = (blockHeight - 2) * TILE_SIZE }
                                })

                                gSounds['powerup-reveal']:play()
                                table.insert(objects, gem)
                            end

                            obj.hit = true
                        end

                        gSounds['empty-block']:play()
                    end
                })
            -- spawn key at the middle of the level
            elseif not keySpawned and col >= width / 2  then
                table.insert(objects, GameObject {
                    texture = 'keys-locks',
                    x = (col - 1) * TILE_SIZE,
                    y = (blockHeight - 1) * TILE_SIZE,
                    width = 16,
                    height = 16,
                    frame = keyLockColor,
                    collidable = true,
                    consumable = true,
                    solid = false,
                    onConsume = function(player, object)
                        gSounds['pickup']:play()
                        player.hasKey = true
                    end
                })

                keySpawned = true
            -- spawn lock at 2/3 of the level
            elseif not lockSpawned and col >= width - width / 3  then
                table.insert(objects, GameObject {
                    texture = 'keys-locks',
                    x = (col - 1) * TILE_SIZE,
                    y = (blockHeight - 1) * TILE_SIZE,
                    width = 16,
                    height = 16,
                    frame = keyLockColor + 4, -- 4 is the sheet width and lock blocks are on the second row of the sheet
                    collidable = true,
                    solid = true,
                    onCollide = function(player, object)
                        if not object.hit then
                            if player.hasKey then
                                gSounds['unlock']:play()
                                -- spawn flag (non collidable to avoid wierd behavior in case of double collision with pole)
                                local flag = GameObject {
                                    texture = 'flags',
                                    x = (width - 2) * TILE_SIZE + TILE_SIZE / 2,
                                    y = (3 * TILE_SIZE) + TILE_SIZE / 2,
                                    width = 16,
                                    height = 16,
                                    frame = keyLockColor * 5,
                                    collidable = false
                                }

                                -- spawn flag's pole sprites (interactives on hit)
                                for i = 3, 1, -1 do
                                    table.insert(objects, GameObject {
                                        texture = 'flags',
                                        x = (width - 2) * TILE_SIZE,
                                        y = ((4 + i - 1) - 1) * TILE_SIZE,
                                        width = 16,
                                        height = 16,
                                        frame = keyLockColor + (5 * (i - 1)),
                                        collidable = true,
                                        interactive = true,
                                        solid = false,
                                        -- go to next level on collide
                                        onInteract = function(player, obj)
                                            gSounds['raise-flag']:play()
                                             gStateMachine:change('start', {
                                                score = player.score,
                                                levelId = player.level.id + 1
                                            })
                                        end
                                    })
                                end

                                table.insert(objects, flag)
                                player.hasKey = false
                                object.hit = true
                            else
                                gSounds['empty-block']:play()
                            end
                        end
                    end
                })

                lockSpawned = true
            end
        end
    end


    local map = TileMap(width, height)
    map.tiles = tiles

    return GameLevel(entities, objects, map)

end