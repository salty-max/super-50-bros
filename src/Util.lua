--[[
    UTILS
    CS50G Project 4
    Super 50 Bros
    Author: Maxime Blanc
    https://github.com/salty-max
--]]

function GenerateQuads(atlas, tileWidth, tileHeight)
    local sheetWidth =  atlas:getWidth() / tileWidth
    local sheetHeight =  atlas:getHeight() / tileHeight
    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] = love.graphics.newQuad(x * tileWidth, y * tileHeight, tileWidth, tileHeight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

--[[
    Divides quads generated via slicing the tile sheet into separate tile sets.
]]
function GenerateTileSets(quads, setsX, setsY, sizeX, sizeY)
    local tilesets = {}
    local tableCounter = 0
    local sheetWidth = setsX * sizeX
    local sheetHeight = setsY * sizeY

    -- for each tile set on the X and Y
    for tilesetY = 1, setsY do
        for tilesetX = 1, setsX do
            
            -- tileset table
            table.insert(tilesets, {})
            tableCounter = tableCounter + 1

            for y = sizeY * (tilesetY - 1) + 1, sizeY * (tilesetY - 1) + 1 + sizeY do
                for x = sizeX * (tilesetX - 1) + 1, sizeX * (tilesetX - 1) + 1 + sizeX do
                    table.insert(tilesets[tableCounter], quads[sheetWidth * (y - 1) + x])
                end
            end
        end
    end

    return tilesets
end

function GenerateKeysQuads(quads)
    return table.slice(quads, 1, 4)
end
function GenerateLocksQuads(quads)
    return table.slice(quads, 5, #quads)
end

function GenerateFlagsQuads(atlas)
    local sheet = {}
    local sheetCounter = 1
    local x = 32
    local y = 0

    for row = 1, 4 do
        for col = 1, 5 do
            table.insert(sheet, love.graphics.newQuad(x, y, TILE_SIZE, TILE_SIZE, atlas:getDimensions()))
            sheetCounter = sheetCounter + 1
            x = x + TILE_SIZE
        end
        y = y + TILE_SIZE
        x = 32
    end

    return sheet
end

function table.slice(tbl, first, last, step)
    local sliced = {}
    for i = first or 1, last or #tbl, step or 1 do
        table.insert(sliced, tbl[i])
    end

    return sliced
end

--[[
    Recursive table printing function.
    https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/
]]
function print_r ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end