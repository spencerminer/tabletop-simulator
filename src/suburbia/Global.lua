-- GUID
local tiles_a_bag = '4935f3'
local tiles_b_bag = '319843'
local tiles_c_bag = '7625c1'
local objectives_bag = 'c15a2b'
local setup_button = 'c97f74'
local money_10_bag = '853061'
local money_5_bag = 'd2c470'
local money_1_bag = 'd9070b'
local temp_bag = '39a49d'
local last_round = '7444d7'
local market_zone_1 = '6c59a9'
local market_zone_2 = 'a694fd'
local market_zone_3 = '639600'
local market_zone_4 = '86b84f'
local market_zone_5 = '0eceb7'
local market_zone_6 = '9152a6'
local market_zone_7 = '9f9b66'
local next_move_button = 'c0e9a6'
local stack_a = 'fc5dee'
local stack_b = '2c919b'
local stack_c = '1c1fb5'

-- Locations
local a_tiles_loc = { -31.51, 5, -8.75 }
local b_tiles_loc = { -35.62, 5, -8.6 }
local c_tiles_loc = { -35.67, 5, -4.58 }
local suburbs_loc = { -32.54, 1.5, 3.49 }
local factory_loc = { -32.61, 1.5, -1.8 }
local park_loc = { -35.23, 1.5, 0.8 }
local temp_bag_pos = { -45.64, 3, -4.31 }
local market_pos = {
    { -24.5, 1.5, 11.47 },
    { -24.45, 1.5, 8.06 },
    { -24.37, 1.5, 4.48 },
    { -24.33, 1.5, 0.83 },
    { -24.37, 1.5, -2.71 },
    { -24.29, 1.5, -6.21 },
    { -24.38, 1.5, -9.54 }
}
local objective_1 = { -29, 1.5, -4.91 }
local objective_2 = { -29, 1.5, -1.08 }
local objective_3 = { -29, 1.5, 2.78 }
local objective_4 = { -29, 1.5, 6.59 }

-- Variables
number_of_players = 0
a_tiles_quantity = { 8, 11, 14 }
b_tiles_quantity = { 15, 18, 21 }
c_tiles_quantity = { 6, 9, 12 }

function onLoad()
    create_setup_button()
end

function setup()
    number_of_players = #getSeatedPlayers()
    if number_of_players < 2 then
        printToAll("Must be at least 2 players", {1,1,1})
        return 1
    end
    startLuaCoroutine(Global, 'draw_a_tiles')
    startLuaCoroutine(Global, 'draw_b_tiles')
    startLuaCoroutine(Global, 'draw_c_tiles')
    startLuaCoroutine(Global, 'draw_objectives')
    create_next_move_button()
end

function draw_a_tiles()
    local tiles_bag = getObjectFromGUID(tiles_a_bag)
    tiles_bag.shuffle()
    local params = {}
    local number = a_tiles_quantity[number_of_players - 1]
    params.rotation = { 0, 90, 180}

    for _, pos in ipairs(market_pos) do
        params.position = pos
        tiles_bag.takeObject(params)
        waitFrames(30)
    end

    params.position = a_tiles_loc
    params.rotation = { 0, 45, 0}
    for i = 1,number,1 do
        tiles_bag.takeObject(params)
        waitFrames(30)
    end

    return 1
end

function draw_b_tiles()
    local tiles_bag = getObjectFromGUID(tiles_b_bag)
    tiles_bag.shuffle()
    local params = {}
    local number = b_tiles_quantity[number_of_players - 1]
    params.position = b_tiles_loc
    params.rotation = { 0, 45, 0}
    for i = 1,number,1 do
        tiles_bag.takeObject(params)
        waitFrames(30)
    end

    return 1
end

function draw_c_tiles()
    local tiles_bag = getObjectFromGUID(tiles_c_bag)
    tiles_bag.shuffle()
    local params = {}
    local number = c_tiles_quantity[number_of_players - 1]
    local temp = getObjectFromGUID(temp_bag)
    params.position = temp_bag_pos
    for i = 1,number,1 do
        tiles_bag.takeObject(params)
        waitFrames(30)
    end
    getObjectFromGUID(last_round).setPosition(temp_bag_pos)
    waitFrames(60)
    temp.shuffle()

    params.position = c_tiles_loc
    params.rotation = {0, 45, 0}
    for i = 1,4,1 do
        tiles_bag.takeObject(params)
        waitFrames(30)
    end
    waitFrames(60)
    for i = 1,number+1,1 do
        temp.takeObject(params)
        waitFrames(30)
    end
    waitFrames(60)
    for i = 1,9,1 do
        tiles_bag.takeObject(params)
        waitFrames(30)
    end
    waitFrames(60)
    temp.destruct()

    return 1
end

function draw_objectives()
    local bag = getObjectFromGUID(objectives_bag)
    bag.shuffle()
    local params = {}
    params.rotation = {0, 90, 0}

    params.position = objective_1
    bag.takeObject(params)
    waitFrames(30)
    params.position = objective_2
    bag.takeObject(params)
    waitFrames(30)
    if number_of_players == 3 then
        params.position = objective_3
        bag.takeObject(params)
        waitFrames(30)
    end
    if number_of_players == 4 then
        params.position = objective_3
        bag.takeObject(params)
        waitFrames(30)
        params.position = objective_4
        bag.takeObject(params)
        waitFrames(30)
    end

    local p = Player.Red
    if p.seated then
        params.rotation = {0, 0, 0}
        params.position = { -4.46, 1.5, 28.84 }
        bag.takeObject(params)
        waitFrames(30)
        params.position = { -7.62, 1.5, 28.84 }
        bag.takeObject(params)
        waitFrames(30)
    end

    local p = Player.Purple
    if p.seated then
        params.rotation = {0, 0, 0}
        params.position = { 23, 1.5, 28.84 }
        bag.takeObject(params)
        waitFrames(30)
        params.position = { 20, 1.5, 28.84 }
        bag.takeObject(params)
        waitFrames(30)
    end

    local p = Player.White
    if p.seated then
        params.rotation = {0, 180, 0}
        params.position = { -4.46, 1.5, -29 }
        bag.takeObject(params)
        waitFrames(30)
        params.position = { -7.62, 1.5, -29 }
        bag.takeObject(params)
        waitFrames(30)
    end

    local p = Player.Yellow
    if p.seated then
        params.rotation = {0, 180, 0}
        params.position = { 23, 1.5, -29 }
        bag.takeObject(params)
        waitFrames(30)
        params.position = { 20, 1.5, -29 }
        bag.takeObject(params)
        waitFrames(30)
    end
end

function create_setup_button()
    local params = {}
    params.click_function = "setup"
    params.label = "Setup"
    params.position = {0, 0.3, 0}
    params.rotation = {0, 90, 0}
    params.width = 1500
    params.height = 1000
    params.font_size = 160
    getObjectFromGUID(setup_button).createButton(params)
end

function create_next_move_button()
    local params = {}
    params.click_function = "next_move"
    params.label = "Next Move"
    params.position = {0, 0.3, 0}
    params.rotation = {0, 90, 0}
    params.width = 1500
    params.height = 1000
    params.font_size = 160
    getObjectFromGUID(next_move_button).createButton(params)
end

function next_move()
    local zone_1_objects = getObjectFromGUID(market_zone_1).getObjects()
    local zone_2_objects = getObjectFromGUID(market_zone_2).getObjects()
    local zone_3_objects = getObjectFromGUID(market_zone_3).getObjects()
    local zone_4_objects = getObjectFromGUID(market_zone_4).getObjects()
    local zone_5_objects = getObjectFromGUID(market_zone_5).getObjects()
    local zone_6_objects = getObjectFromGUID(market_zone_6).getObjects()
    local zone_7_objects = getObjectFromGUID(market_zone_7).getObjects()

    local tiles = { '', '', '', '', '', '', '' }

    for _, tile in ipairs(zone_1_objects) do
        tiles[1] = tile.getGUID()
    end
    for _, tile in ipairs(zone_2_objects) do
        tiles[2] = tile.getGUID()
    end
    for _, tile in ipairs(zone_3_objects) do
        tiles[3] = tile.getGUID()
    end
    for _, tile in ipairs(zone_4_objects) do
        tiles[4] = tile.getGUID()
    end
    for _, tile in ipairs(zone_5_objects) do
        tiles[5] = tile.getGUID()
    end
    for _, tile in ipairs(zone_6_objects) do
        tiles[6] = tile.getGUID()
    end
    for _, tile in ipairs(zone_7_objects) do
        tiles[7] = tile.getGUID()
    end

    local empty_place = 0
    for i, id in ipairs(tiles) do
        if id == '' then
            empty_place = i
            break
        end
    end

    if empty_place == 0 then
        printToAll('One place on the market must be empty!', {1,1,1})
    else
        for i = empty_place, 6, 1 do
            if tiles[i+1] == '' then
                break
            else
                getObjectFromGUID(tiles[i+1]).setPosition(market_pos[i])
            end
        end

        local params = {}
        params.rotation = { 0, 90, 180 }
        params.position = market_pos[7]
        if getObjectFromGUID(stack_a).getQuantity() > 0 then
            getObjectFromGUID(stack_a).takeObject(params)
        elseif getObjectFromGUID(stack_b).getQuantity() > 0 then
            getObjectFromGUID(stack_b).takeObject(params)
        elseif getObjectFromGUID(stack_c).getQuantity() > 0 then
            getObjectFromGUID(stack_c).takeObject(params)
        end
    end


end

function waitFrames(frames)
    while frames > 0 do
        coroutine.yield(0)
        frames = frames - 1
    end
end
