local Dummy, super = Class(Encounter)

function Dummy:init()
    super.init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = ({
        en="* A dummy it seems...?",
        es="* Parece un boboneco...?",
        ["pt-br"]="* Parece um boboneco...?",
        ja="＊ ダミーに見えるが...？",
        LOLCAT="* LOOKZ LIKE DUHMIE!"
    })[Mod.selected_language]
    
    -- Battle music ("battle" is rude buster)
    self.music = "dummy"
    -- Enables the purple grid battle background
    self.background = true
    
    self.default_xactions = true
    -- Add the dummy enemy to the encounter
    self:addEnemy("dummy")

    --- Uncomment this line to add another!
    --self:addEnemy("dummy")
end

return Dummy