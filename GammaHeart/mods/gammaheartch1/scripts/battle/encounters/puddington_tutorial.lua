local Dummy, super = Class(Encounter)

function Dummy:init()

    self.hasnaayi = Game:hasPartyMember("naayi")

    ---@type HireableCharacter|Event?
    self.mapNaayi = nil
    if not self.hasnaayi then
        self.naayi = Game.battle:addPartyBattler(Game:getPartyMember("naayi"))
        self.naayi.chara.mode = Mod.mode
        self.naayi.chara:onModeChange(nil,nil,self.naayi)
        self.mapNaayi = Game.world:getEvent(2696)
    end
    super.init(self)
    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = ({
        es = {"* ¿És esto un tutorial?[wait:0.5][react:1][wait:1][react:2]",{reactions={{"¿¡QUIEN SON USTEDES!?", "left", "bottom", "shocked", Game.party[1].actor.id},{"¡TEN CUIDADO! UTILIZA TU MAGIA", "mid", "bottom", "shocked", self.naayi.actor.id}}}},
        ["pt-br"] = {"* Isto é um tutorial?[wait:0.5][react:1][wait:1][react:2]",{reactions={{"Quem são vocês!?", "left", "bottom", "shocked", Game.party[1].actor.id},{"CUIDADO! USE SUA MAGIA", "mid", "bottom", "shocked", self.naayi.actor.id}}}},
        ja = {"チュートリアルですか？[wait:0.5][react:1][wait:1][react:2]",{reactions={{"誰は！？", "left", "bottom", "shocked", Game.party[1].actor.id},{"気をつけて！魔法を使おう", "mid", "bottom", "shocked", self.naayi.actor.id}}}},
        LOLCAT = {"IZ DIS A 2-TORIEL?[wait:0.5][react:1][wait:1][react:2]",{reactions={{"WHO R U GUYZE?!1!?!!", "left", "bottom", "shocked", Game.party[1].actor.id},{"B CAERFOO!1 USE UR MAJEEK", "mid", "bottom", "shocked", self.naayi.actor.id}}}}
    })[Mod.selected_language] or {"* Is this a tutorial?[wait:0.5][react:1][wait:1][react:2]",{reactions={{"WHO ARE YOU GUYS!?", "left", "bottom", "shocked", Game.party[1].actor.id},{"BE CAREFUL! USE YOUR MAGIC", "mid", "bottom", "shocked", self.naayi.actor.id}}}}
    -- Battle music ("battle" is rude buster)
    self.music = "battle"
    -- Enables the purple grid battle background
    self.background = true
    -- Add the dummy enemy to the encounter
    self:addEnemy("puddington")
    
    self.default_xactions = true
    --- Uncomment this line to add another!
    --self:addEnemy("dummy")
    Game.world.camera:setAttached(true)
end

function Dummy:onBattleEnd()
    if not self.hasnaayi then
        self.mapNaayi.visible = true
    end
end

return Dummy