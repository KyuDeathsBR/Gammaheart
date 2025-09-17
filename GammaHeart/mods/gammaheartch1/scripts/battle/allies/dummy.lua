---@type PartyAlly
local Dummy, super = Class(PartyAlly,"dummy")

function Dummy:init()
    super.init(self)

    -- Enemy name
    self.name = {
        en = "Dummy",
        es = "Boboneco",
        ["pt-br"] = "Boboneco",
        ja = "ダミー",
        LOLCAT = "DUHMIE"
    }

    self.menu_icon = "enemies/dummy/head_icon"
    self.head_icons = "party/ralsei/icon"
    self.color = {0,1,0}
    self.soul_color = {0,1,0}
    self.dmg_color = {0,1,0}
    self.xact_color = {0,1,0}
    self.attack_bar_color = {0,1,0}
    self.attack_box_color = {0,1,0}
    self.attack_sprite = "effects/attack/slap_r"
    self.has_spells = false
    self.has_act = true
    self.equipped.amulet = nil
    self.equipped.armor = {}

    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("dummy")

    self.dialogue = {
        en="GLORB GLORB",
        es="GLORB GLORB",
        ["pt-br"]="GLORB GLORB",
        LOLCAT="GLORB GLORB",
        ja = {"グログロ"},
    }

    self.xact_name = ({en="Dummy-Action",es="Bobon-Acción",["pt-br"]="Bobon-Ação",ja="ダミーアクション",LOLCAT="DUHMIE-AKSHOEN"})[Mod.selected_language]
    self.name_sprite = "enemies/dummy/name"..(Assets.getTexture("enemies/dummy/name/"..Mod.selected_language) and "/"..Mod.selected_language or Assets.getTexture("enemies/dummy/name/default") and "/default" or "")
    -- Enemy health
    self.health = 80
    self.stats.health = 80
    -- Enemy attack (determines bullet damage)
    self.stats.attack = 4
    -- Enemy defense (usually 0)
    self.stats.defense = 0
end

return Dummy