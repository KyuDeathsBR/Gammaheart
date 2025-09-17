---@type PartyAlly
local Puddington, super = Class(PartyAlly,"puddington")

function Puddington:init()
    super.init(self)

    -- Enemy name
    self.name = {
        en = "Puddington",
        es = "Pudinton",
        ["pt-br"] = "Pudimton",
        ja = "プリプリン",
        LOLCAT = "PUDINTOAN"
    }

    self.menu_icon = "enemies/puddington/head_icon"
    self.head_icons = "enemies/puddington/icon"
    self.color = {0.8, 0.7, 0.5}
    self.soul_color = {0.8, 0.7, 0.5}
    self.dmg_color = {0.8, 0.7, 0.5}
    self.xact_color = {0.8, 0.7, 0.5}
    self.attack_bar_color = {0.8, 0.7, 0.5}
    self.attack_box_color = {0.8, 0.7, 0.5}
    self.attack_sprite = "effects/attack/slap_n"
    self.has_spells = false
    self.has_act = true
    self.equipped.amulet = nil
    self.equipped.armor = {}

    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("puddington")

    self.dialogue = {
        en="GLORB GLORB",
        es="GLORB GLORB",
        ["pt-br"]="GLORB GLORB",
        LOLCAT="GLORB GLORB",
        ja = {"グログロ"},
    }

    self.xact_name = ({en="Pudding-Action",es="Pudin-Acción",["pt-br"]="Pudim-Ação",ja="プリンーアクション",LOLCAT="PUDIN-AKSHOEN"})[Mod.selected_language]
    self.name_sprite = "enemies/puddington/name"..(Assets.getTexture("enemies/puddington/name/"..Mod.selected_language) and "/"..Mod.selected_language or Assets.getTexture("enemies/puddington/name/default") and "/default" or "")
    -- Enemy health
    self.health = 80
    self.stats.health = 80
    -- Enemy attack (determines bullet damage)
    self.stats.attack = 4
    -- Enemy defense (usually 0)
    self.stats.defense = 0
end

return Puddington