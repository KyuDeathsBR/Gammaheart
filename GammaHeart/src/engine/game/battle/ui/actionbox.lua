---@class ActionBox : Object
---@field buttons ActionButton[]
---@overload fun(...) : ActionBox
local ActionBox, super = Class(Object)

---comment
---@param x number
---@param y number
---@param index number
---@param battler PartyBattler|PartyAlly
function ActionBox:init(x, y, index, battler)
    super.init(self, x, y)
    
    self.selection_siner = 0

    self.index = index
    self.battler = battler

    self.selected_button = 1

    self.revert_to = 40
    self.return_point = 0
    self.data_offset = 0
    self.box = ActionBoxDisplay(self)
    self.box.layer = 1
    self:addChild(self.box)


    self.head_offset_x, self.head_offset_y = battler.chara:getHeadIconOffset()

    self.head_sprite = Sprite(battler.chara:getHeadIcons().."/"..battler:getHeadIcon(), 12 + self.head_offset_x, 12 + self.head_offset_y)
    self.head_sprite:setScaleOrigin(0,1)
    if not self.head_sprite:getTexture() then
        self.head_sprite:setAnimation({battler.chara:getHeadIcons().."/head",1/12,true})
    end
    self.force_head_sprite = false

    if battler.chara:getNameSprite() then
        self.name_sprite = Sprite(battler.chara:getNameSprite(), 51, 14)
        self.box:addChild(self.name_sprite)
    end

    self.hp_sprite = Sprite("ui/hp", 109, 22)

    self.box:addChild(self.head_sprite)
    self.box:addChild(self.hp_sprite)

    self:createButtons()
end

function ActionBox:getButtons(battler)
end

function ActionBox:createButtons()
    for _,button in ipairs(self.buttons or {}) do
        button:remove()
    end
    ---@type ActionButton[]
    self.buttons = {}

    local btn_types = {"fight", "act", "magic", "item", "spare", "defend"}

    if not self.battler.chara:hasAct() then Utils.removeFromTable(btn_types, "act") end
    if not self.battler.chara:hasSpells() then Utils.removeFromTable(btn_types, "magic") end

    for lib_id,_ in Kristal.iterLibraries() do
        btn_types = Kristal.libCall(lib_id, "getActionButtons", self.battler, btn_types) or btn_types
    end
    btn_types = Kristal.modCall("getActionButtons", self.battler, btn_types) or btn_types

    local start_x = (213 / 2) - ((#btn_types-1) * 35 / 2)%64 - 1
    local start_y = - (24/2) + math.floor(((#btn_types-1) * 35 / 2)/64) + 1

    if (#btn_types <= 5) and Game:getConfig("oldUIPositions") then
        start_x = start_x - 5.5
    end

    for i,btn in ipairs(btn_types) do
        if type(btn) == "string" then
            local button = ActionButton(btn, self.battler, math.floor(start_x + ((math.floor((i-1)%3)) * 35)) + 0.5, start_y + math.floor((i-1)/3)*35)
            button.visible = Game.battle.current_selecting == self.index
            button.actbox = self
            table.insert(self.buttons, button)
            self:addChild(button)
        elseif type(btn) ~= "boolean" then -- nothing if a boolean value, used to create an empty space
            btn:setPosition(math.floor(start_x + ((i - 1) * 35)) + 0.5, 21)
            btn.battler = self.battler
            btn.actbox = self
            table.insert(self.buttons, btn)
            self:addChild(btn)
        end
    end

    self.selected_button = Utils.clamp(self.selected_button, 1, #self.buttons)
end

function ActionBox:setHeadIcon(icon)
    self.force_head_sprite = true

    local full_icon = self.battler.chara:getHeadIcons().."/"..icon
    if self.head_sprite:hasSprite(full_icon) then
        self.head_sprite:setAnimation({full_icon,1/12,true})
    else
        self.head_sprite:setAnimation({self.battler.chara:getHeadIcons().."/head",1/12,true})
    end
    local check = self.head_sprite:getScaledWidth() == 30
    if check then
        self.head_sprite.scale_x = 2
        self.head_sprite.scale_y = 2
    end
end

function ActionBox:resetHeadIcon()
    self.force_head_sprite = false

    local full_icon = self.battler.chara:getHeadIcons().."/"..self.battler:getHeadIcon()
    if self.head_sprite:hasSprite(full_icon) then
        self.head_sprite:setAnimation({full_icon,1/12,true})
    else
        self.head_sprite:setAnimation({self.battler.chara:getHeadIcons().."/head",1/12,true})
    end
    local check = self.head_sprite:getScaledWidth() == 30
    if check then
        self.head_sprite.scale_x = 2
        self.head_sprite.scale_y = 2
    end
end

function ActionBox:update()
    self.selection_siner = self.selection_siner + 2 * DTMULT
    local total = Utils.contains(Game.battle.state,"SELECT") and Game.battle.current_selecting or ({
        ACTING = Game.battle.completed_attacks and #Game.battle.completed_attacks or 1,
        ATTACKING = Game.battle.current_action_index,
        BATTLETEXT = Game.battle.current_action_index
    })[Game.battle.state] or 0
    local final_x = (self.index - math.max(total,1)) * 213

    self.x = Utils.approach(self.x,final_x,math.abs(final_x-self.x)/24)
    if self.return_point < 0 then 
        for i,v in ipairs(self.buttons) do
            v.visible = Game.battle.current_selecting <= self.index
        end
    end

    local delta = #(self.box.sprite.frames or {1})-self.box.sprite.frame
    self.head_sprite.scale_y = (delta*4.5/42)/#(self.box.sprite.frames or {1})+(2*self.box.sprite.frame)/#(self.box.sprite.frames or {1})
    self.head_sprite.scale_x = (delta*10/30)/#(self.box.sprite.frames or {1})+(2*self.box.sprite.frame)/#(self.box.sprite.frames or {1})
    self.head_sprite.y = -9 + self.y
    if self.name_sprite then
        local xa, xb,ya,yb,t  = 24,84,32,-54,#(self.box.sprite.frames or {1})
        self.name_sprite.y = (delta*ya)/t+(yb*self.box.sprite.frame)/t
        self.name_sprite.x = (delta*xa)/t+(xb*self.box.sprite.frame)/t
    end
    local xa, xb,ya,yb,t  = 104,84,26,-36,#(self.box.sprite.frames or {1})
    self.hp_sprite.y = (delta*ya)/t+(yb*self.box.sprite.frame)/t
    self.hp_sprite.x = (delta*xa)/t+(xb*self.box.sprite.frame)/t

    self.hp_sprite.visible = (Game.battle.current_selecting == self.index) and self.box.sprite.frame == 4

    if not self.force_head_sprite then
        local current_head = self.battler.chara:getHeadIcons().."/"..self.battler:getHeadIcon()
        if not self.head_sprite:hasSprite(current_head) then
            current_head = self.battler.chara:getHeadIcons().."/head"
        end
        if self.head_anim ~= current_head then
            self.head_anim = current_head
            self.head_sprite:setAnimation({current_head,1/12,true})
        end
    end

    for i,button in ipairs(self.buttons) do
        local default = (self.box.sprite.frame-1)/#(self.box.sprite.frames or {1})
        button.alpha = (self.box.sprite.frame < #(self.box.sprite.frames or {1})) and default or  1
        if (Game.battle.current_selecting == self.index) then
            button.selectable = true
            button.hovered = (self.selected_button == i)
        else
            button.selectable = false
            button.hovered = false
        end
    end

    super.update(self)
end

function ActionBox:select()
    self.buttons[self.selected_button]:select()
end

function ActionBox:unselect()
    self.buttons[self.selected_button]:unselect()
end

function ActionBox:draw()
    self:drawSelectionMatrix()
    self:drawActionBox()

    super.draw(self)

    if not self.name_sprite then
        local font = Assets.getFont("name")
        love.graphics.setFont(font)
        Draw.setColor(1, 1, 1, 1)

        local name = self.battler.chara:getName():upper()
        local spacing = 5 - name:len()

        local off = 0
        for i = 1, name:len() do
            local letter = name:sub(i, i)
            love.graphics.print(letter, self.box.x + 51 + off, self.box.y + 14 - self.data_offset - 1)
            off = off + font:getWidth(letter) + spacing
        end
    end
end

function ActionBox:drawActionBox()
    --[[if Game.battle.current_selecting == self.index then
        Draw.setColor(self.battler.chara:getColor())
        love.graphics.setLineWidth(2)
        love.graphics.line(1  , 2, 1,   37)
        love.graphics.line(Game:getConfig("oldUIPositions") and 211 or 212, 2, Game:getConfig("oldUIPositions") and 211 or 212, 37)
        love.graphics.line(0  , 6, 212, 6 )
    end]]
    Draw.setColor(1, 1, 1, 1)
end

function ActionBox:drawSelectionMatrix()
    -- Draw the background of the selection matrix
    --[[Draw.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 2, 2+self.box.y, 209, 35-self.box.y)

    if Game.battle.current_selecting == self.index then
        local r,g,b,a = self.battler.chara:getColor()

        for i = 0, 11 do
            local siner = self.selection_siner + (i * (10 * math.pi))

            love.graphics.setLineWidth(2)
            Draw.setColor(r, g, b, a * math.sin(siner / 60))
            if math.cos(siner / 60) < 0 then
                love.graphics.line(1 - (math.sin(siner / 60) * 30) + 30, 0, 1 - (math.sin(siner / 60) * 30) + 30, 37)
                love.graphics.line(211 + (math.sin(siner / 60) * 30) - 30, 0, 211 + (math.sin(siner / 60) * 30) - 30, 37)
            end
        end

        Draw.setColor(1, 1, 1, 1)
    end
    ]]
end

return ActionBox