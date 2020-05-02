--Runs when bags spawn in when the map is loaded
function onLoad()
    --Creates the 2 buttons
    self.createButton({
        label="Spawn Die", click_function="buttonClick1",
        function_owner=self, position={0.8,0.1,-0.4},
        height=300, width=700, font_size=100
    })
    self.createButton({
        label="Spawn\nCustom Model", click_function="buttonClick2",
        function_owner=self, position={0.8,0.1,0.4},
        height=300, width=700, font_size=100
    })
end

--This runs when the button 1 on this object is clicked
--It will spawn a regular, generic die.
function buttonClick1()
    --We get the position of the tool first. We use this to place the item.
    --You can place it anywhere you like, I chose to place it near the tool.
    local toolPos = self.getPosition()
    --Spawn object takes parameters.
    --The available parameters are found in the knowledge base.
    --See the API page and the Spawnable Objects page.
    --type indicates what will be spawned, position indicates where
    spawnObject({
        type="Die_6",
        position={toolPos.x-2, toolPos.y+2, toolPos.z-3}
    })
end

--This runs when the button 2 on this object is clicked
--It will spawn a custom model set to act like a die
function buttonClick2()
    --Again, we will place it near the tool, so we need the tool's position
    local toolPos = self.getPosition()
    --This time there are 2 steps. First is spawning a custom model.
    --We are also making a reference to the object we are spawning.
    local obj = spawnObject({
        type="Custom_Model",
        position={toolPos.x+2, toolPos.y+2, toolPos.z-3},
        scale={0.5,0.5,0.5} --(shrinking it down a bit)
    })
    --Then we need to apply the object, material and properties that make it
    --We do this by applying setCustomObject to that reference (obj) we made
    --Again, this has many parameters you can feed it, KB has them all.
    obj.setCustomObject({
        type=2,
        mesh="http://pastebin.com/raw/CS2JYCqP",
        diffuse="http://i.imgur.com/AOJ50cH.jpg",
        specular_intensity=0
    })
end