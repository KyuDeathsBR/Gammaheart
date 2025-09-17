local item, super = Class(Item, "cell_phone")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Cell Phone"

    self.name_translations = {ja="電話",["pt-br"]="Celular",es="Celular",LOLCAT="CELLFON!"}
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "key"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "It can be used to make calls."

    self.description_translations = {
        ja="電話を入れることができます。",
        es="Se puede hacer una llamada telefónica con esto.",
        ["pt-br"]="Pode ser usado para fazer chamadas.",
        LOLCAT="CAN UZE 2 MAEK CALZ"
    } 

    -- Default shop price (sell price is halved)
    self.price = 0
    -- Whether the item can be sold
    self.can_sell = false

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "none"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "world"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {}
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = nil
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {}

    self.interaction_messages = {
        {
            en="* (You tried to call on the Cell\nPhone.)",
            es="* (Intentaste realizar una \nllamada.)",
            ["pt-br"]="* (Você tentou fazer uma \nchamada)",
            ja="＊（電話を入れるのを試みた。）",
            LOLCAT="* (U TRID 2 CALL ON TEH \nCELLFONE.)"
        },
        {
            en="* It's nothing but garbage noise.",
            es="* No has oído nada más que ruido.",
            ["pt-br"]="* Não ouviu nada alem de ruido",
            ja="＊　騒音以外何物でもない聞かない。",
            LOLCAT="* U HEAR NOTHIN ONLY STINKY\n BAD NOIZE >:("
        },
    }
    self.character_interactions = {
        kyuma = {
            {
                en="* Hello? Anyone there?",
                es="* ¿Hola? ¿Hay alguien ahí?",
                ["pt-br"]="* Olá? alguem aí?",
                ja="＊　孟子孟子？　誰がいますか？",
                LOLCAT="* OH HAI?! ANYONE THAR?!?11",
                emotion = "worried"
            }
        },
        naayi = {
            kyuma = {
                en="* Better to ignore it, i think",
                es="* Mejor ignorar, yo creo",
                ["pt-br"]="* Melhor ignorar, eu acho",
                ja="＊無視したそれがいいと思う",
                LOLCAT="* BETAH 2 IGNORES EET, AYE TINK",
                emotion = "worried"
            }
        }
    }

    -- Character reactions (key = party member id)
    self.reactions = {}
end

function item:onWorldUse()
    Game.world:startCutscene(
    ---@param cutscene WorldCutscene
    function(cutscene)
        Assets.playSound("phone", 0.7)
        cutscene:text(self.interaction_messages[1][Mod.selected_language], nil, nil, {advance = false})
        cutscene:wait(40/30)
        local was_playing = Game.world.music:isPlaying()
        if was_playing then
            Game.world.music:pause()
        end
        Assets.playSound("smile")
        cutscene:wait(200/30)
        if was_playing then
            Game.world.music:resume()
        end
        cutscene:text(self.interaction_messages[2][Mod.selected_language])
        if self.character_interactions then
            local main_interaction = self.character_interactions[Game.party[1].id]
            main_interaction = main_interaction and main_interaction[1]
            if main_interaction and main_interaction[Mod.selected_language] then
                cutscene:setSpeaker(Game.party[1]:getActor())
                cutscene:text(main_interaction[Mod.selected_language],main_interaction.emotion)
            end
            local c
            for i,v in next,Game.party,1 do
                c = self.character_interactions[v.id]
                if (c[Game.party[1].id]) then
                    cutscene:setSpeaker(v:getActor())
                    c = c[Game.party[1].id]
                    cutscene:text(c[Mod.selected_language],c.emotion)
                end
            end
        end
        
    end)
end

return item