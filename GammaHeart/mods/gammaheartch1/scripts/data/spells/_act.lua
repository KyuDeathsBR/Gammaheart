-- This spell is only used for display in the POWER menu.

local spell, super = Class(Spell, "_act")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "ACT"
    self.name_translations = {
        es = "AGIR",
        ["pt-br"] = "AGIR",
        ja = "ｱｸﾄ",
        LOLCAT = "AKT!1"
    }
    -- Name displayed when cast (optional)
    self.cast_name = nil

    -- Battle description
    self.effect = ""
    -- Menu description
    if Game.chapter == 1 then
        self.description = "Do all sorts of things.\nIt isn't magic."
        self.desc_translations = {
            es = "Hace muchas cosas.\nNo eres magia.",
            ["pt-br"] = "Faz muitas coisas.\nNão é magia.",
            ja="たくさんことがします。\nマジックじゃない。",
            LOLCAT = "CAN DO LOT OV THINGS, IT INST MAGIC THOUGH :("
        }
    elseif Game.chapter == 2 then
        self.description = "You can do many things.\nDon't confuse it with magic."
    elseif Game.chapter == 3 then
        self.description = "Many different skills.\nIt has nothing to do with magic."
    else
        self.description = "Execute various behaviors.\nIt can't be considered magic."
    end

    -- TP cost
    self.cost = 0

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemy"

    -- Tags that apply to this spell
    self.tags = {}
end

return spell