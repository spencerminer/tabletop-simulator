
function onload()
    SetupPad = getObjectFromGUID('34abec')
    Phase2Block = getObjectFromGUID('4b1c6e')
    RubbleBag = getObjectFromGUID('6339b8')
    Decrees = getObjectFromGUID('5a0639')
    ClergyTiles = getObjectFromGUID('49d301')
    StartingPlans = getObjectFromGUID('5bdc80')
    PublicBuildings = getObjectFromGUID('39eb6f')

    ShipZone = getObjectFromGUID('db3673')
    BlueShips = getObjectFromGUID('9274c3')
    RedShips = getObjectFromGUID('808715')
    PurpleShips = getObjectFromGUID('03d7c7')
    BrownShips = getObjectFromGUID('213c4d')

    PoliticalDeckZone = getObjectFromGUID('6e7f0d')
    BluePolitical = getObjectFromGUID('e7da0d')
    RedPolitical1 = getObjectFromGUID('58d5aa')
    RedPolitical2 = getObjectFromGUID('b4c492')
    RedPolitical3 = getObjectFromGUID('dd0b5b')
    RedPolitical4 = getObjectFromGUID('761659')
    PurplePolitical = getObjectFromGUID('ad3502')
    BrownPolitical1 = getObjectFromGUID('5610ac')
    BrownPolitical2 = getObjectFromGUID('edbc8c')
    BrownPolitical3 = getObjectFromGUID('d9c1d6')
    BrownPolitical4 = getObjectFromGUID('775732')
    red_political_cards =
    {RedPolitical1, RedPolitical2, RedPolitical3, RedPolitical4}
    brown_political_cards =
    {BrownPolitical1, BrownPolitical2, BrownPolitical3, BrownPolitical4}

    collections_to_shuffle =
    {RubbleBag, Decrees, ClergyTiles, StartingPlans,
     BluePolitical, PurplePolitical,
     RedPolitical1, RedPolitical2, RedPolitical3, RedPolitical4,
     BrownPolitical1, BrownPolitical2, BrownPolitical3, BrownPolitical4}

    YellowPlayerBoard = getObjectFromGUID('ed8bfe')
    OrangePlayerBoard = getObjectFromGUID('5a3033')
    PurplePlayerBoard = getObjectFromGUID('90a7b8')
    GreenPlayerBoard = getObjectFromGUID('296c9b')
    player_list = {"Yellow", "Orange", "Purple", "Green"}
    phase = 1

    TwoPlayerCover = getObjectFromGUID('c82821')

    y_coord = 2.06
    rubble_wait_time = 3
    court_cards_location = {-9.65, y_coord, 8.43}
    treasury_deck_location = {-18.64, y_coord, 6.83}
    king_deck_location = {-18.68, y_coord, 2.92}
    pm_deck_location = {-18.73, y_coord, -1.01}
    architect_deck_location = {-18.69, y_coord, -4.94}
    ships_location = {3.61, y_coord, -9.00}

    for num_players=2,4 do
        playersButtonSetup(num_players)
    end
end

function playersButtonSetup(num_players)
    -- Replace this with a card that says hit this once everyone is seated
    -- and you've picked starting clergy tiles
    local z_offset = -2.1 + (num_players*0.7)
    SetupPad.createButton(
        {click_function='playerSetup'..num_players,
         label=num_players..' Players',
         position={0,0.1,z_offset},
         width=820, height=350, font_size=130})
end

function playerSetup2() playerSetup(2) end
function playerSetup3() playerSetup(3) end
function playerSetup4() playerSetup(4) end

function playerSetup(num_players)
    global_num_players = num_players
    shuffleCollections(collections_to_shuffle)
    moveTopPlansOver(PublicBuildings)
    flipTopCards(red_political_cards)
    BluePolitical.deal(5)
    StartingPlans.deal(1)
    startLuaCoroutine(Global, 'setupDecrees')
    startLuaCoroutine(Global, 'placeClergyTiles')
    startLuaCoroutine(Global, 'setupRubble')
    startLuaCoroutine(Global, 'placeShips')
    if num_players > 2 then
        TwoPlayerCover.destruct()
        startLuaCoroutine(Global, 'setupRubbleRowE')
    end
    SetupPad.destruct()

    Phase2Block.createButton(
        {click_function="startRoundTwo", label="Start Round Two",
         color={0.6,0.6,0.6}, rotation={0,270,0}, scale={0.2,0.2,0.2},
         position={0.25,0.5,0}, width=1500, height=600, font_size=170})
end

function setupRubble()
    -- Set up the rubble on the West side
    local west_x_coord = 2.20
    local west_z_coords = {7.33, 6.68,
                           5.18, 4.53,
                           3.00, 2.35,
                           0.87, 0.22}
    for _, z_coord in ipairs (west_z_coords) do
        wait(rubble_wait_time)
        RubbleBag.takeObject({position={west_x_coord, y_coord, z_coord}})
    end

    -- Set up the rubble on the North side
    local north_z_coord = 10.26
    local north_x_coords = {4.82, 5.97,
                            8.38, 9.54,
                            11.90, 13.05,
                            15.46,16.61}
    for _, x_coord in ipairs (north_x_coords) do
        wait(rubble_wait_time)
        RubbleBag.takeObject({position={x_coord, y_coord, north_z_coord}})
    end


    -- Set up the rubble on the East side
    local east_x_coord = 18.83
    local east_z_coords = {7.33, 6.68,
                           5.18, 4.53,
                           3.00, 2.35,
                           0.87, 0.22}
    for _, z_coord in ipairs (east_z_coords) do
        wait(rubble_wait_time)
        RubbleBag.takeObject({position={east_x_coord, y_coord, z_coord}})
    end

    -- Set up the rubble to the right of the stores
    local right_x_coord = 16.02
    local right_z_coords = {7.67, 7.00, 6.36,
                           5.51, 4.84, 4.20,
                           3.39, 2.73, 2.08,
                           1.21, 0.55, -0.09}
    for _, z_coord in ipairs (right_z_coords) do
        wait(rubble_wait_time)
        RubbleBag.takeObject({position={right_x_coord, y_coord, z_coord}})
    end

    -- Set up the rubble below the stores
    local upper_z_coord = -5.35
    local upper_x_coords = {6.12, 8.42, 10.73, 13.03, 14.97}
    for _, x_coord in ipairs (upper_x_coords) do
        wait(rubble_wait_time)
        RubbleBag.takeObject({position={x_coord, y_coord, upper_z_coord}})
    end

    local lower_z_coord = -6.02
    local lower_x_coords = {5.66, 6.61, 7.94, 8.88, 10.24,
                            11.21, 12.53, 13.51, 14.97}
    for _, x_coord in ipairs (lower_x_coords) do
        wait(rubble_wait_time)
        RubbleBag.takeObject({position={x_coord, y_coord, lower_z_coord}})
    end

    -- Set up the rubble pile
    local pile_locations = {
        {15.32, y_coord, -7.58},
        {16.28, y_coord, -7.56},
        {15.66, y_coord, -8.46},
        {16.57, y_coord, -8.43},
        {15.32, y_coord, -9.38},
        {16.22, y_coord, -9.33}}
    for _, loc in ipairs(pile_locations) do
        wait(rubble_wait_time)
        RubbleBag.takeObject({position=loc})
    end

    return 1
end

function setupRubbleRowE()
    wait(rubble_wait_time*9)
    local row_e_locations = {
        {2.20, y_coord, -1.23},
        {2.20, y_coord, -1.88},
        {16.02, y_coord, -0.89},
        {16.03, y_coord, -1.55},
        {16.03, y_coord, -2.20},
        {18.83, y_coord, -1.23},
        {18.83, y_coord, -1.88}}
    for _, loc in ipairs(row_e_locations) do
        wait(rubble_wait_time)
        RubbleBag.takeObject({position=loc})
    end
    return 1
end

function setupDecrees()
    local x_coord = -25.93
    local z_coords = {-10.81, -8.07, -5.33, -2.59, 0.15, 2.88, 5.63, 8.36}
    for _, z_coord in ipairs(z_coords) do
        wait(25)
        Decrees.takeObject({position={x_coord, y_coord, z_coord}, flip=true})
    end
    return 1
end

function placeClergyTiles()
    local positions = {
        {-1.13, y_coord, 5.85},
        { 0.25, y_coord, 4.47},
        { 0.23, y_coord, 1.71},
        {-1.15, y_coord, 0.35},
        {-2.53, y_coord, 1.72},
        {-2.53, y_coord, 4.47}}
    for _, pos in ipairs(positions) do
        wait(10)
        ClergyTiles.takeObject({position=pos, rotation={0,180,180}})
    end
    return 1
end

function startRoundTwo()
    phase = 2
    for _, player in ipairs(player_list) do
        local cards_in_hand = tableLength(Player[player].getHandObjects())
        PurplePolitical.deal(5 - cards_in_hand, player)
    end
    destructCardsInZone(ShipZone)
    startLuaCoroutine(Global, 'placeCardsPhaseTwo')
    startLuaCoroutine(Global, 'placeShips')
end

function placeCardsPhaseTwo()
    destructCardsInZone(PoliticalDeckZone)
    BrownPolitical1.setPositionSmooth(treasury_deck_location)
    BrownPolitical2.setPositionSmooth(king_deck_location)
    BrownPolitical3.setPositionSmooth(pm_deck_location)
    BrownPolitical4.setPositionSmooth(architect_deck_location)
    wait(70)
    flipTopCards(brown_political_cards)
    return 1
end

function placeShips()
    local ship_colors = {}
    if phase==1 then
        ship_colors = {RedShips, BlueShips}
    elseif phase==2 then
        ship_colors = {PurpleShips, BrownShips}
    end
    for _, ship_color in ipairs(ship_colors) do
        if global_num_players == 4 then
            wait(50)
            ship_color.setPositionSmooth(ships_location)
        else
            for _ = 2,global_num_players do
                wait(25)
                ship_color.takeObject({position=ships_location})
            end
        end
    end
    return 1
end

function shuffleCollections(collections)
    for _, collection in ipairs(collections) do
        collection.shuffle()
    end
end

function destructCardsInZone(zone)
    for _, obj in ipairs(zone.getObjects()) do
        if obj.tag=="Card" or obj.tag=="Deck" then
            obj.destruct()
        end
    end
end

function moveTopPlansOver(zone)
    for _, obj in ipairs(zone.getObjects()) do
        local height = obj.getPosition()[2]
        if height > 2.25 then
            obj.translate({-6,6,0})
        end
    end
end

function flipTopCard(deck)
    local pos = deck.getPosition()
    deck.takeObject({position=pos, flip=true})
end

function flipTopCards(deck_table)
    for _, deck in ipairs(deck_table) do
        flipTopCard(deck)
    end
end

function tableLength(table)
    local length = 0
    for _,_ in ipairs(table) do
        length = length + 1
    end
    return length
end

function wait(frames)
    for _=1,frames do
        coroutine.yield(0)
    end
end
