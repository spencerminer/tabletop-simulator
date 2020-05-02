--Runs when bags spawn in when the map is loaded
function onLoad()
    --Creates the button
    self.createButton({
        label="takeObject\nExmaple 1", click_function="buttonClick",
        function_owner=self, position={0,0.5,3},
        height=1100, width=2000, font_size=380
    })
end

--Triggered by button press
function buttonClick(entity, color)
    --Whenever you have a function activated by a button,
    --it has default parameters. I named them entity and color.
    --entity refers to the entity that the button is attached to.
    --In this case, that entity is "self", the bag
    --color is a string, and is the color of the person who pressed the button
    --Ex. "White" or "Blue"
    --Since we are not using them, we did not need to define them
    --Instead we could have used function buttonClick()

    --First we will figure out where we want to put out object
    --I chose -5 units in the Z direction from the bag
    --So we find bag's position
    local pos = self.getPosition()
    --Then we move it -5 unitz in the z, and up 4 in the Y
    pos.y = pos.y + 4
    pos.z = pos.z - 5

    --This is what is taking the object out of the bag using pos
    --Position is just ONE element we could use.
    --See the knowledge base for them all.
    self.takeObject({position=pos})
end