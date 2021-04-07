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

        if math.random(CHASM_CHANCE) == 1 then
            for ground = 7, height do
                tiles[ground][col] = Tile(
                    col, ground,
                    col == 1 and TILE_ID_GROUND or tileId,
                    col == 1 and ground == 7,
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

            if spawnPillar then
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
            if math.random(BLOCK_CHANCE) == 1 then
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
            end
        end
    end


    local map = TileMap(width, height)
    map.tiles = tiles

    return GameLevel(entities, objects, map)

end