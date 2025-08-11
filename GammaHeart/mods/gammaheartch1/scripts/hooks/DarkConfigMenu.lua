local DarkConfigMenu, super = Utils.hookScript(DarkConfigMenu)

function DarkConfigMenu:init()
    super.init(self)

    self.font = Assets.getFont(Mod.selected_language.."_main") or self.font
end

function DarkConfigMenu:update()
    if self.state == "MAIN" and Input.pressed("confirm") and self.currently_selected == 6 then
        self.ui_select:stop()
        self.ui_select:play()
        Language = Mod.selected_language
        assert(Kristal.Mods.data["chapter_select"], "No mod \""..tostring("chapter_select").."\"")
        Gamestate.switch({})
        Kristal.clearModState()
        Kristal.loadAssets("","mods","", function()
            Kristal.loadMod("chapter_select", 1)
        end)
        Gamestate.switch(Kristal.States["Game"])
    else
        super.update(self)
    end
end



function DarkConfigMenu:draw()
    if Game.state == "EXIT" then
        super.draw(self)
        return
    end
    love.graphics.setFont(self.font)
    Draw.setColor(PALETTE["world_text"])

    if self.state ~= "CONTROLS" then
        local conf = {en="CONFIG",["pt-br"]="CONFIG",es="CONFIG",ja="コンフィグ",LOLCAT="SETINGZ!1"}

        love.graphics.print(conf[Mod.selected_language], 188, -12)

        if self.state == "VOLUME" then
            Draw.setColor(PALETTE["world_text_selected"])
        end
        local master_volume = {
            en="Master Volume",
            es="Volumen General",
            ["pt-br"]="Volume Geral",
            ja="全体の音量",
            LOLCAT="SET MASTAH NOIZE"
        }
        local controls = {
            en="Controls",
            es="Controles",
            ["pt-br"]="Controles",
            ja="キーマウ",
            LOLCAT="CHENJ CONTROLZ"
        }
        local simplify_vfx = {
            en="Simplify VFX",
            es="Simplificar gráfic.",
            ["pt-br"]="Simplificar gráfic.",
            ja="ＶＦＸを簡素化する",
            LOLCAT="SIMPLIFY TEH THINGZ",
        }
        local fullscreen = {
            en="Fullscreen",
            es="Pantalla Completa",
            ["pt-br"]="Tela-cheia",
            ja="線画面",
            LOLCAT="HOOJ SCREEN"
        }
        local auto_run = {
            en="Auto-Run",
            es="Correr autom.",
            ["pt-br"]="Correr autom.",
            ja="オートラン",
            LOLCAT="ZOOM-ZOOM!!111"
        }
        local return_chselect = {
            en="Return to Chapter Selection",
            es="volver a la selección de capítulos",
            ["pt-br"]="retornar à seleção de capítulos",
            ja="チャプターセレクションを服す",
            LOLCAT="GO BAK 2 CHEWS CHAPTUR TIME!"
        }
        local on = {
            en="ON",
            es="ON",
            ["pt-br"]="ON",
            ja="ＯＮ",
            LOLCAT= "ITZ ON!"
        }
        local off = {
            en="OFF",
            es="OFF",
            ["pt-br"]="OFF",
            ja="ＯＦＦ",
            LOLCAT = "ITZ OFF :("
        }
        local back = {
            en="Back",
            es="Volver",
            ["pt-br"]="Voltar",
            ja="戻る",
            LOLCAT="GO BAK!1"
        } 

        love.graphics.print(master_volume[Mod.selected_language], 88, 38 + (0 * 32))
        Draw.setColor(PALETTE["world_text"])
        love.graphics.print(controls[Mod.selected_language], 88, 38 + (1 * 32))
        love.graphics.print(simplify_vfx[Mod.selected_language], 88, 38 + (2 * 32))
        love.graphics.print(fullscreen[Mod.selected_language], 88, 38 + (3 * 32))
        love.graphics.print(auto_run[Mod.selected_language], 88, 38 + (4 * 32))
        love.graphics.print(return_chselect[Mod.selected_language], 88, 38 + (5 * 32))
        love.graphics.print(back[Mod.selected_language], 88, 38 + (6 * 32))

        if self.state == "VOLUME" then
            Draw.setColor(PALETTE["world_text_selected"])
        end
        local volume_val = Utils.round(Kristal.getVolume() * 100)
        volume_val = (
        ---@param num string
        function(num)
            return Mod.selected_language == "ja" and num:gsub("%d",{["0"]="０",["1"]="１",["2"]="２",["3"]="３",["4"]="４",["5"]="５",["6"]="６",["7"]="７",["8"]="８",["9"]="９",["%"]="％"}) or num
        end
        )(tostring(volume_val).."%")
        love.graphics.print(volume_val, 348, 38 + (0 * 32))
        Draw.setColor(PALETTE["world_text"])
        love.graphics.print(Kristal.Config["simplifyVFX"] and on[Mod.selected_language] or off[Mod.selected_language], 348, 38 + (2 * 32))
        love.graphics.print(Kristal.Config["fullscreen"] and on[Mod.selected_language] or off[Mod.selected_language], 348, 38 + (3 * 32))
        love.graphics.print(Kristal.Config["autoRun"] and on[Mod.selected_language] or off[Mod.selected_language], 348, 38 + (4 * 32))

        Draw.setColor(Game:getSoulColor())
        Draw.draw(self.heart_sprite, 63, 48 + ((self.currently_selected - 1) * 32))
    else
        -- NOTE: This is forced to true if using a PlayStation in DELTARUNE... Kristal doesn't have a PlayStation port though.
        local dualshock = Input.getControllerType() == "ps4"

        love.graphics.print("Function", 23, -12)
        -- Console accuracy for the Heck of it
        if not Kristal.isConsole() then
            love.graphics.print("Key", 243, -12)
        end
        if Input.hasGamepad() then
            love.graphics.print(Kristal.isConsole() and "Button" or "Gamepad", 353, -12)
        end

        for index, name in ipairs(Input.order) do
            if index > 7 then
                break
            end
            Draw.setColor(PALETTE["world_text"])
            if self.currently_selected == index then
                if self.rebinding then
                    Draw.setColor(PALETTE["world_text_rebind"])
                else
                    Draw.setColor(PALETTE["world_text_hover"])
                end
            end

            if dualshock then
                love.graphics.print(name:gsub("_", " "):upper(), 23, -4 + (29 * index))
            else
                love.graphics.print(name:gsub("_", " "):upper(), 23, -4 + (28 * index) + 4)
            end

            local shown_bind = self:getBindNumberFromIndex(index)

            if not Kristal.isConsole() then
                local alias = Input.getBoundKeys(name, false)[1]
                if type(alias) == "table" then
                    local title_cased = {}
                    for _, word in ipairs(alias) do
                        table.insert(title_cased, Utils.titleCase(word))
                    end
                    love.graphics.print(table.concat(title_cased, "+"), 243, 0 + (28 * index))
                elseif alias ~= nil then
                    love.graphics.print(Utils.titleCase(alias), 243, 0 + (28 * index))
                end
            end

            Draw.setColor(1, 1, 1)

            if Input.hasGamepad() then
                local alias = Input.getBoundKeys(name, true)[1]
                if alias then
                    local btn_tex = Input.getButtonTexture(alias)
                    if dualshock then
                        Draw.draw(btn_tex, 353 + 42, -2 + (29 * index), 0, 2, 2, btn_tex:getWidth() / 2, 0)
                    else
                        Draw.draw(btn_tex, 353 + 42 + 16 - 6, -2 + (28 * index) + 11 - 6 + 1, 0, 2, 2,
                                  btn_tex:getWidth() / 2, 0)
                    end
                end
            end
        end

        Draw.setColor(PALETTE["world_text"])
        if self.currently_selected == 8 then
            Draw.setColor(PALETTE["world_text_hover"])
        end

        if (self.reset_flash_timer > 0) then
            Draw.setColor(Utils.mergeColor(PALETTE["world_text_hover"], PALETTE["world_text_selected"],
                                           ((self.reset_flash_timer / 10) - 0.1)))
        end

        if dualshock then
            love.graphics.print("Reset to default", 23, -4 + (29 * 8))
        else
            love.graphics.print("Reset to default", 23, -4 + (28 * 8) + 4)
        end

        Draw.setColor(PALETTE["world_text"])
        if self.currently_selected == 9 then
            Draw.setColor(PALETTE["world_text_hover"])
        end

        if dualshock then
            love.graphics.print("Finish", 23, -4 + (29 * 9))
        else
            love.graphics.print("Finish", 23, -4 + (28 * 9) + 4)
        end

        Draw.setColor(Game:getSoulColor())

        if dualshock then
            Draw.draw(self.heart_sprite, -2, 34 + ((self.currently_selected - 1) * 29))
        else
            Draw.draw(self.heart_sprite, -2, 34 + ((self.currently_selected - 1) * 28) + 2)
        end
    end

    Draw.setColor(1, 1, 1, 1)

    super.super.draw(self)
end

return DarkConfigMenu