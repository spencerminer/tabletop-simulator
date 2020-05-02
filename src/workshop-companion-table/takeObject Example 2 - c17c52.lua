--Runs when bags spawn in when the map is loaded
function onLoad()
    --Creates the button
    self.createButton({
        label="takeObject\nExample 2", click_function="buttonClick",
        function_owner=self, position={0,0.5,3},
        height=1100, width=2000, font_size=380
    })
end

--Triggered by button press
function buttonClick()
    --This is establishing a variable used later in this function
    local foundSquare = false
    --We need to first get a list of the objects inside of the bag
    local objectsInBag = self.getObjects()
    --Then we go through those entires using a for loop, looking for one
    for _, object in ipairs(objectsInBag) do
        --Look for an entry that has the name of "Square"
        if object.name == "Square" then
            --If it is found, then we need to use takeObject on it
            --We get the position first, which I am going to use the bag pos
            local pos = self.getPosition()
            --Then we move it -5 unitz in the z, and up 4 in the Y
            pos.y = pos.y + 4
            pos.z = pos.z - 5
            --Now we use takeObject. I will be giving it parameters
            --Giving it GUID has it pull this specific object out of the bag
            --[[Giving it a callback lets it run code on the object after it
                has been spawned int othe world. If we simply tried to run
                code as we're using takeObject to get it, it doesn't exist
                in the world yet (hasn't spawned) so we can't apply changes.

                We will be establishing both a callback and a callback_owner.
                Callback is the NAME of the function, owner is where it is.]]
            self.takeObject({
                position=pos, guid=object.guid,
                callback="afterSpawn", callback_owner=self
            })
            --Set foundSquare to true, to indicate we did find the square.
            foundSquare = true
            --We only want it to find 1 Square per button press
            --Break will end the for loop here, preventing multiple returns
            break
        end
    end

    --Now we check foundSquare to see if the for loop found a square or not
    if foundSquare == false then
        broadcastToAll("There was no object named 'Square' in the bag.", {1,1,1})
    end
end

--This is the callback function, triggered when we used takeObject
--Notice it has a reference to the entity that was spawned.
function afterSpawn(spawnedObject)
    --This is how we would lock the object, change its color, name, etc
    spawnedObject.lock()
end
