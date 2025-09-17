
function Mod:init()

    Utils.merge(MUSIC_VOLUMES, {
        battle = 1, -- Limited to 1/0.7 (which is about 1.428571429)
    })
    self.MapsWithDoubleMusic = {
        "town",
    }
    self.mode = "LIGHT"
    self.keybinds = {
            {id="snowgrave",keys={"alt","s","g"}},
        }
end

---comment
---@param map Map
---@param music string
---@return nil
function Mod:onMapMusic(map,music)
    for i,v in pairs(self.MapsWithDoubleMusic) do
        if v == map.id then
            return map.data.properties["music_"..self.mode]
        end
    end
end

function Mod:findCollider(name)
    for i,v in ipairs(Game.world.map.collision) do
        if v.name == name then
            return v
        end
    end
end

---@param map Map
function Mod:onMapCollisionLoad(map)
    for i,key in ipairs(Utils.getKeys(Game.flags)) do
        if key:match("$WorldCollisions/"..(map.name or "")) then
            local name, path = unpack(Utils.split(key:gsub("$WorldCollisions/"..map.name.."/",""),"/"),1,2)
            local subpaths = Utils.split(key:gsub("$WorldCollisions/"..map.name.."/",""),"/")
            Utils.removeFromTable(subpaths,name)
            Utils.removeFromTable(subpaths,path)
            for _,c in next, map.collision, 1 do
                if c.name == name then
                    if type(c[path]) == "table" then
                        local sub = c[path]
                        if #subpaths-1 > 1 then
                            for i=1,#subpaths-1,1 do
                                sub = sub[subpaths[i]]
                            end
                        end
                        sub[subpaths[#subpaths]] = Game:getFlag(key)
                    else
                        c[path] = Game:getFlag(key)
                    end
                end
            end
        end 
    end
end