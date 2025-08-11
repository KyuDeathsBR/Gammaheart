local DarkMenu, super = Utils.hookScript(DarkMenu)

function DarkMenu:init()
    super.init(self)
    self.font = Assets.getFont(Mod.selected_language.."_main") or self.font
    self.description.font = Assets.getFont(Mod.selected_language.."_main") and Mod.selected_language.."_main" or self.description.font or "main"
end

function DarkMenu:addButtons()
    -- ITEM
    self:addButton({
        ["state"]          = "ITEMMENU",
        ["sprite"]         = Assets.getTexture("ui/menu/btn/item"),
        ["hovered_sprite"] = Assets.getTexture("ui/menu/btn/item_h"),
        ["desc_sprite"]    = Assets.getTexture("ui/menu/desc/item/"..Mod.selected_language) or Assets.getTexture("ui/menu/desc/item"),
        ["callback"]       = function()
            self.box = DarkItemMenu()
            self.box.layer = 1
            self:addChild(self.box)
            
            self.ui_select:stop()
            self.ui_select:play()
        end
    })

    -- EQUIP
    self:addButton({
        ["state"]          = "EQUIPMENU",
        ["sprite"]         = Assets.getTexture("ui/menu/btn/equip"),
        ["hovered_sprite"] = Assets.getTexture("ui/menu/btn/equip_h"),
        ["desc_sprite"]    = Assets.getTexture("ui/menu/desc/equip/"..Mod.selected_language) or Assets.getTexture("ui/menu/desc/equip"),
        ["callback"]       = function()
            self.box = DarkEquipMenu()
            self.box.layer = 1
            self:addChild(self.box)

            self.ui_select:stop()
            self.ui_select:play()
        end
    })

    -- POWER
    self:addButton({
        ["state"]          = "POWERMENU",
        ["sprite"]         = Assets.getTexture("ui/menu/btn/power"),
        ["hovered_sprite"] = Assets.getTexture("ui/menu/btn/power_h"),
        ["desc_sprite"]    = Assets.getTexture("ui/menu/desc/power/"..Mod.selected_language) or Assets.getTexture("ui/menu/desc/power"),
        ["callback"]       = function()
            self.box = DarkPowerMenu()
            self.box.layer = 1
            self:addChild(self.box)

            self.ui_select:stop()
            self.ui_select:play()
        end
    })

    -- CONFIG
    self:addButton({
        ["state"]          = "CONFIGMENU",
        ["sprite"]         = Assets.getTexture("ui/menu/btn/config"),
        ["hovered_sprite"] = Assets.getTexture("ui/menu/btn/config_h"),
        ["desc_sprite"]    = Assets.getTexture("ui/menu/desc/config/"..(Mod.selected_language)) or Assets.getTexture("ui/menu/desc/config"),
        ["callback"]       = function()
            self.box = DarkConfigMenu()
            self.box.layer = -1
            self:addChild(self.box)

            self.ui_select:stop()
            self.ui_select:play()
        end
    })
end

function DarkMenu:update()
    super.update(self)
    if Mod then
        if self.mode ~= Mod.mode then
            love.graphics.clear(0,0,0,255)
            self:draw()
        end
        self.mode = Mod.mode
    end
end

function DarkMenu:draw()
    Draw.setColor(PALETTE["world_fill"])
    love.graphics.rectangle("fill", 0, 0, 640, 80)

    Draw.setColor(1, 1, 1, 1)
    if self.buttons[self.selected_submenu].desc_sprite then
        Draw.draw(self.buttons[self.selected_submenu].desc_sprite, 20, 24, 0, 2, 2)
    end

    for i = 1, #self.buttons do
        self:drawButton(i, 120 + ((i - 1) * self:getButtonSpacing()), 20)
    end
    Draw.setColor(1, 1, 1)

    love.graphics.setFont(self.font)
    love.graphics.print((Game:getConfig(Mod.mode:lower().."CurrencyShort")[Mod.selected_language] or Game:getConfig(Mod.mode:lower().."CurrencyShort").default) .. " " .. (
        ---@param num string
        function(num)
            return Mod.selected_language == "ja" and num:gsub("%d",{["0"]="０",["1"]="１",["2"]="２",["3"]="３",["4"]="４",["5"]="５",["6"]="６",["7"]="７",["8"]="８",["9"]="９",["%"]="％"}) or num
        end
        )(tostring(Game.money)), 520, 20)

    super.super.draw(self)
end

return DarkMenu