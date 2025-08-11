---@class HireableCharacter : Event
---@field mode "DARK"|"LIGHT"|string *[Property `mode`]*
---@field character Character?
---@field important boolean
---@field can_interact boolean
---@field hiring boolean
---@field recruit_choices table<string,{[number]:string}>
---@field recruit_emotion string
---@field non_recruited_text {[string]:string}
---@field non_recruited_anim string
local HireableCharacter, super = Class(Event, "hireable")

---Creates a Hireable Character
---@param data table<string,any>
function HireableCharacter:init(data)
    super.init(self,data)
    self.visible = data.properties.visible == nil and data.visible or data.properties.visible
    self.properties = data.properties
    self.mode = data.properties.mode or "DARK"
    self.character = data.properties.character or nil
    self.non_recruited_anim = data.properties.non_recruited_anim or "not_recruited"
    self.non_recruited_text = data.properties.non_recruited_text or {en="RECRUIT ME!!!",["pt-br"]="ME RECRUTE!!!",es="¡¡¡RECRUTAME!!!",ja="私をリクルートして！",LOLCAT="REKROOT AYE!1"}
    self.important = data.properties.important or false
    self.recruit_emotion = data.properties.recruit_emotion or "neutral"
    assert(self.character,"No character included for the HireableCharacter event at "..self.x..", "..self.y)
    if type(self.character) == "string" then
        local party, actor = Registry.getPartyMember(self.character --[[@as string]])(), Registry.getActor(self.character --[[@as string]])()
        if party and not Game.world:getPartyCharacterInParty(party) then
            self.character = Character(party,party:getActor(self.mode),self.x,self.y)
            self.character.party = party.id
            self.character:getPartyMember().mode = self.mode
        elseif actor then
            self.character = Character(actor,self.x,self.y)
        end
    end
    self.character.sprite:setOrigin(0.5,1)
    self.character.sprite:setScaleOrigin(0.5,1)
    self.character.sprite:setScale(2,2) 
    self.character.sprite:setPosition(self.x,self.y)
    self:setHitbox(-self.character.sprite.width*2, -self.character.sprite.height*2, self.character.sprite.width*4, self.character.sprite.height*2)
    self.hire_interactions = {
        kyuma = {
            accept = {
                en="* Sure, it would be nice to see you on our team",
                es="* Claro, sería bueno verte en nuestro equipo",
                ["pt-br"]="* Claro, seria bom te ver na nossa equipe",
                ja="＊　もちろん、あなたはチームの一員になってくれるのはいいよ。",
                LOLCAT="* YAS! ITZ NICE 2 SEE U ON OUR TEEM",
                emotion = "smirk"
            },
            deny = {
                en="* Sorry, i am very busy right now.",
                es="* Lo siento, estoy muy ocupado ahora.",
                ["pt-br"]="* Desculpe, estou muito ocupado agora.",
                ja="* ごめん、今にとても忙しいです。",
                LOLCAT="* SORY, IM VRY BUSY RITE NAO.",
                emotion="worried"
            }
        },
    }
    self.recruit_choices = {
        en = {
            "Yes",
            "No"
        },
        es = {
            "Si",
            "No"
        },
        ["pt-br"] = {
            "Sim",
            "Não",
        },
        ja={
            "うん",
            "いや"
        },
        LOLCAT={
            "YAS :3",
            "NO! >:("
        }
    }
    ---@deprecated 
    self.can_interact = true
    self.character:setAnimation(self.non_recruited_anim)
end

function HireableCharacter:Hire()
    self.hiring = true
    Game:setFlag("can_interact_with_"..self:getUniqueID(),false)
    if self.character.party then
        Game.party[#Game.party+1] = Game:getPartyMember(self.character.party)
    end 
    self.visible = false
    return self.character:convertToFollower()
end

function HireableCharacter:onInteract(plr, dir)
    if not Game:getFlag("can_interact_with_"..self:getUniqueID()) then
        return
    end
    Game.world:startCutscene(
        ---@param cutscene WorldCutscene
        function(cutscene)
            cutscene:setSpeaker(self.character)
            local interactions = self.hire_interactions[Game.party[1].id]
            if self.important then
                cutscene:text(self.non_recruited_text[Mod.selected_language],self.recruit_emotion)
                if interactions then
                    local language, emotion = interactions.accept[Mod.selected_language], interactions.accept.emotion
                    cutscene:setSpeaker(Game.world:getPartyCharacter(Game.party[1]))
                    cutscene:text(language,emotion)
                end
                self:Hire()
            else
                local choice = cutscene:textChoicer(self.non_recruited_text[Mod.selected_language],self.recruit_choices[Mod.selected_language],self.recruit_emotion)
                if interactions then
                    local language, emotion = choice == 1 and interactions.accept[Mod.selected_language] or interactions.deny[Mod.selected_language], choice == 1 and interactions.accept.emotion or interactions.deny.emotion
                    cutscene:setSpeaker(Game.world:getPartyCharacter(Game.party[1]))
                    cutscene:text(language,emotion)
                end
                if choice == 1 then
                    self:Hire()
                end
            end
        end
    )
end

function HireableCharacter:update(parent)
    super.update(self)
    for i,v in pairs(Game.party) do
        if v.id == self.character.party and not self.hiring then
            self.character:remove()
            self:remove()
        end
    end
    if self.visible then
        if self:getUniqueID() and Game:getFlag("can_interact_with_"..self:getUniqueID()) ~= true then
            Game:setFlag("can_interact_with_"..self:getUniqueID(),true)
        end
        if self.character.parent == nil and Game.world.map.object_layer then
            self.character.layer = Game.world.map.object_layer
            Game.world:addChild(self.character)
        end
    else
        if self.character.parent ~= nil then
            Game.world:removeChild(self.character)
        end
        if self:getUniqueID() and Game:getFlag("can_interact_with_"..self:getUniqueID()) == nil then
            Game:setFlag("can_interact_with_"..self:getUniqueID(),self.visible)
        end
    end
    if not self.visible_defined then
        self.visible_defined = true
        self.visible = Game:getFlag("can_interact_with_"..self:getUniqueID())
    end
end

return HireableCharacter