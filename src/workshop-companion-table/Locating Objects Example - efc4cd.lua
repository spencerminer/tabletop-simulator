--The easiest way to locate an item is with its GUID.
--But we don't always know those in advance. So we need ot search for the item.
--There are many ways to go about it.
--The easist is to hunt for them in scripting zones using tags or names.
--If a scripting zone isn't practical, then you can look for them without it.
--There are more that I haven't even listed, these are just my go-to ones

--Runs when the map is first loaded
function onload(saved_data)
    --Creates the 4 buttons
    self.createButton({
        label="Find in\nZone", click_function="findInZone",
        function_owner=self, position={0.4,0.1,-0.4},
        height=300, width=320, font_size=70
    })
    self.createButton({
        label="Find by\nName", click_function="findByName",
        function_owner=self, position={1.2,0.1,-0.4},
        height=300, width=320, font_size=70
    })
    self.createButton({
        label="Find by\nTag", click_function="findByTag",
        function_owner=self, position={0.4,0.1,0.4},
        height=300, width=320, font_size=70
    })
    self.createButton({
        label="Find by\nDistance", click_function="findByDistance",
        function_owner=self, position={1.2,0.1,0.4},
        height=300, width=320, font_size=70
    })
end

--This function finds the name of any object in a scripting zone and prints them
function findInZone()
    --We print the first line that is going into chat
    print("[b]---Items In Zone---[/b]")
    --Locate the scripting zone by its GUID, since this will not change
    --Get the GUID by using the scripting zone tool and right clicking a zone
    local zone = getObjectFromGUID("6ad43e")
    --Get a list of any objects which are inside of the zone.
    local objectsInZone = zone.getObjects()

    --Check if the table we made is empty due to the zone being empty
    if #objectsInZone == 0 then
        --What prints if the scripting zone was empty
        print("Scripting Zone Empty.")
    else
        --If it isn't empty, we use a for loop to look at each entry in the list
        for _, object in ipairs(objectsInZone) do
            --Find the name of the object
            local name = object.getName()
            --Then check if it had a name or not
            if name ~= "" then
                --Print the object's name and the word found.
                --The .. is how you combine two strings.
                print(name .. " found.")
            else
                print("No name object found.")
            end
        end
    end

    --Finally, we print the "closing" line.
    --The purpose of the first and last lines are decorative and for clarity
    print("[b]---------------------[/b]")
end

--This function finds the Ace in a deck with a specific name.
--So we're going to use the name of both the deck AND the card.
function findByName()
    --We can't just search for the ace because it is in a "container".
    --Decks and bags are containers and the things inside them don't exist.
    --So we need to search for the hidden contents of bags.

    print("[b]---Find By Name---[/b]")
    --This is a variable we're looking to create, of the deck
    local deck = nil
    --We need to identify the deck for this. We know its name.
    --So we're going to get ALL objects on the table
    local allObjects = getAllObjects()
    --And look through them for the name
    for _, object in ipairs(allObjects) do
        if object.getName() == "A Deck of Cards" then
            --If we find the name, we set "deck" to it and end the loop
            deck = object
            break
        end
    end

    --Now that we check if the deck was found.
    if deck == nil then
        print("No deck was found.")
    else
        print("Deck found.")
        --If a deck was found, we look for the act.
        --Do this by using getObjects on the deck to obtain a table
        local cardsInDeck = deck.getObjects()
        --And loop through it
        for i, card in ipairs(cardsInDeck) do
            if card.nickname == "Ace" then
                print("Ace found in deck.")
                --Instead of printing, we could have used takeObject
                --That would remove the card from the deck.
                break
            end
            --We also do a check for if the ace was never found
            if i == #cardsInDeck then
                print("Ace not found in deck.")
            end
        end
    end
    print("[b]----------------------[/b]")
end

--Lists the name of all figurines it locates on the table.
function findByTag()
    print("[b]---Find By Tag---[/b]")
    --Get all the items on the table.
    local allObjects = getAllObjects()
    --This is a variable we will use to track if we have found any figurines
    local foundFigurine = false
    --Loop through allObjects
    for _, object in ipairs(allObjects) do
        --This is how you search for a "Tag"
        --All item types have their own.
        --If you need to know an item's tag, you will need a separate tool.
        --Seach for "Info Cube" on the workshop. It can give you an item's tag.
        if object.tag == "rpgFigurine" then
            print(object.getName() .. " found.")
            foundFigurine = true
        end
    end
    --Determine if any figurines were found, if not then print that
    if foundFigurine == false then
        print("No figurines found on table.")
    end
    print("[b]--------------------[/b]")
end

--Lists any figurine within 5 units of the tool.
function findByDistance()
    print("[b]---Find By Distance---[/b]")
    --This is very similar to how we did findByTag()
    --We are also using tag to narrow it down, which isn't strictly necessary
    local allObjects = getAllObjects()
    local foundFigurine = false
    for _, object in ipairs(allObjects) do
        if object.tag == "rpgFigurine" then
            --I have a pre-written function to get distance to objects
            local distance = findProximity(self.getPosition(), object)
            --Here is the check for distance
            if distance <= 5 then
                print(object.getName() .. " found.")
                foundFigurine = true
            end
        end
    end
    if foundFigurine == false then
        print("No figurines found within 5 units.")
    end
    print("[b]-------------------------[/b]")
end

--Used by findByDistance
function findProximity(targetPos, object)
    local objectPos = object.getPosition()
    local xDistance = math.abs(targetPos.x - objectPos.x)
    local zDistance = math.abs(targetPos.z - objectPos.z)
    local distance = xDistance^2 + zDistance^2
    return math.sqrt(distance)
end