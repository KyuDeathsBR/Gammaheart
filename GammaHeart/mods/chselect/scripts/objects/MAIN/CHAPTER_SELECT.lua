local ChapterSelect, super = Class(Object)

---@class ChapterSelect
---@field languages Languages
function ChapterSelect:init(width, height)
	super.init(self, 0, 0, width, height)

    Input.clear("confirm")

    self.state = "SELECT" --SELECT, CONFIRM, LOADING

    self.sc_scale_x = 1

    self.layer = 100
    self.alpha = 0
    self.screenshot = nil

    self.parallax_x = 0
	self.parallax_y = 0

    self.selected_index = 1
    self.selected_confirm = 1

    self.text_y = 30
    self.lines_y = 60
    self.icon_y = 24
    self.timer = 0

    self.can_click = true
    self.can_use = false

    self.heart = Sprite("player/heart")
    self.heart.visible = true
    self.heart:setOrigin(0.5, 0.5)
    self.heart:setScale(1, 1)
    self.heart:setColor(0.2, 1, 1)
    self.heart.layer = 100
    self.heart.alpha = 0
    self:addChild(self.heart)

    self.heart_target_x = 49
    self.heart_target_y = 47
    self.heart:setPosition(self.heart_target_x, self.heart_target_y)

    self.lines = {}


    self.font = Assets.getFont("main")

    self.rectangle = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
	self.rectangle:setColor(0, 0, 0, 1)
	self:addChild(self.rectangle)
    self.substate = "NIL"

    self.chapters = {
        {
            chapter = {["en"]="Chapter  1",["ja"]="章１",["es"]="Capítulo 1",["pt-br"]="Capítulo 1",["LOLCAT"]="CHAPTUR 1"},
            title = {["en"]="The Beginning",["ja"]="始まり",["es"]="El comienzo",["pt-br"]="O começo",["LOLCAT"]="START TIEM!"},
            sound = function()
               return "chapter1-"..self.language() 
            end,
            modid = "ch1",
            locked = false,
        }, 
    }
    ---@enum (key) LanguageID
    local _info = {
        en = 1,
        ja = 2,
        ["pt-br"]=3,
        es=4,
        LOLCAT=5
    }
    ---@enum (key) Language
    local _info2 = {
        ["English"]=1,
        ["日本語"]=2,
        ["Português"]=3,
        ["Español"]=4,
        ["LOLSPEEK"]=5
    }

    local _languages = {
        ---@type table<integer,[LanguageID,Language]>
        data = {
            {"en","English"},
            {"ja","日本語"},
            {"pt-br","Português"},
            {"es","Español"},
            {"LOLCAT","LOLSPEEK"}
        },
        ---@private
        index = 1
    }

    ---comment
    ---@param index? number
    ---@return LanguageID | Language
    function _languages.next(_self,index)
        index = index or _self.index
        index = index+1
        if index > #_self.data then
            index = 1
        end
        _self.index = index
        return index
    end

    ---@type metatable
    local M_languages = {
        ---Returns the ID of the required value
        ---@param t Languages
        ---@param value Language|LanguageID?
        ---@return LanguageID
        __call = function (t,value)    
            if type(index) == "string" then
                for i,v in pairs(t.data) do
                    if v[1] == index then
                        t.index = i
                        return i
                    end 
                end
            end
            value = value or t.index
            for k, v in pairs(t.data) do
                if k == value then
                    return v[1] -- Return the key if the value is found
                end
            end
            return t.index or "en"
        end,
        __tostring = function (t)
            return t.data[t.index or 1][2] or "English"
        end
    }

    ---@class Languages
    self.language = setmetatable(_languages,M_languages)


    self.options = {
        {
            accept = {["en"]="Play",["ja"]="スタート",["es"]="Jugar",["pt-br"]="Jogar",["LOLCAT"]="PULAY TIEM"},
            refuse = {["en"]="Do Not.",["ja"]="しない。",["es"]="No hace.",["pt-br"]="Nem pense.",["LOLCAT"]="GO BAK"},
        },
    }

    self.language_text = {
        ["en"] = "Language: ",["ja"]="言語：",["es"]="Lenguaje: ",["pt-br"]="Linguagem: ",["LOLCAT"]="SPEEK TYPE: "
    }

    self.quit_text = {
        ["en"] = "Quit",["ja"]="終了",["es"]="Salir",["pt-br"]="Sair",["LOLCAT"]="LEEF :("
    }
end

------// Functions for loading each Chapter //------

function ChapterSelect:loadChapter(index)
    if self.parent == nil then Game.stage:addChild(self) end
    self.state = "LOADING"
    self.can_use = true
    Game.world.music:stop()

    local sound
    if type(self.chapters[index].sound) == "function" then
        sound = Assets.playSound(self.chapters[index].sound())
    elseif type(self.chapters[index].sound) == "string" then
        sound = Assets.playSound(self.chapters[index].sound)
    elseif self.chapters[index].sound ~= nil then
        error(self.chapters[index].chapter.." - "..self.chapters[index].title.en.." has an incorrect type for the sound")
    end
    local function thingy()
        local screenshot = love.graphics.newImage(SCREEN_CANVAS:newImageData())
        self.screenshot = Sprite(screenshot, 0, 0)
        self.screenshot:setScaleOrigin(0.5, 0)
        self.screenshot.scale_x = 1
        self.screenshot.scale_y = 1
        self.screenshot:setOrigin(0, 0)
        self.screenshot.layer = 200
        Game.stage:addChild(self.screenshot)
        self:fadeTo(0, 0.1)
        if Game.CHAPTER_CONTINUE then Game.CHAPTER_CONTINUE:fadeTo(0, 0.1) Game.CHAPTER_CONTINUE.optionalpha = 0 end
        Game.lock_movement = true
        self.rectangle2 = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
        self.rectangle2:setColor(0, 0, 0, 1)
        self.rectangle2.layer = 100
        self:addChild(self.rectangle2)
        Game.world.timer:tween(1, self.screenshot, { scale_x = 0.1, scale_y = 0.7 })
        self.screenshot:fadeOutAndRemove()
        if index == 1 then
            self:loadChapter1()
        elseif index == 2 then
            self:loadChapter2(true)
        else
            Game.stage.timer:after(1, function()
                Game.fader:fadeOut(self.returnToMenu, { speed = 0, music = 10 / 30 })
                Game.state = "EXIT"
            end)
        end
    end
    if sound then
        Game.stage.timer:after(sound:getDuration(),thingy)
    else
        thingy()
    end
    
end

function ChapterSelect:loadChapter1()
    Game.chapter = 1
    Game.world.timer:after(2.25, function()
        if Mod:hasNoSaveFiles(self.chapters[self.selected_index].modid) then
            self:swapIntoMod(self.chapters[self.selected_index].modid, 1)
        else
            Game.world:startCutscene(function(cutscene)
                self.state = "CHAPTER1_CUTSCENE"
                self.can_click = true
                Game.legend = Game.stage:addChild(LegendHandler())
                Game.legend.layer = 500
                cutscene:wait(function() if Game.legend then return Game.legend:isOver() end end)
                self.can_click = false
                if Game.legend then Game.legend:remove() end
                self.state = "DELTARUNE_LOGO"
                Game.deltarune_logo = Game.stage:addChild(DELTARUNE())
                Game.deltarune_logo.layer = 1500
                cutscene:wait(function() if Game.deltarune_logo then return Game.deltarune_logo:isOver() end end)
                if Game.deltarune_logo and Game.deltarune_logo.skipped == false then
                    cutscene:wait(10)
                end
                Game.fader:fadeOut(self.returnToMenu, { speed = 1, music = 10 / 30 })
                Game.state = "EXIT"
            end)
        end
    end)
end

function ChapterSelect:loadChapter2(load_debug)
    Game.chapter = 2
    Game.world.timer:after(2.25, function()
        if Mod.debug and load_debug then
            self.can_use = false
            Assets.playSound("voice/sans")
            Game.lock_movement = false
            Game.DEBUG_MENU = DEBUG_MENU()
            Game.DEBUG_MENU.can_use = true
            Game.stage:addChild(Game.DEBUG_MENU)
        else
            Game.lock_movement = true
            if Mod:hasNoSaveFiles(self.chapters[self.selected_index].modid) then
                Game.world:startCutscene(function(cutscene)
                    self.state = "CHAPTER2_CUTSCENE"
                    self.can_click = false
                    cutscene:wait(3)
    
                    local logoparts = {}
                    local function createLogoPart(id)
                        if not id then return end
                        local part = Sprite("IMAGE_LOGO/IMAGE_LOGO_SEPARATE_" .. id, 320, 240 - 44)
                        part:setOrigin(0.5, 0.5)
                        part:setScale(2)
                        part:play(0.25, true)
                        part.layer = 500
                        self:addChild(part)
                        Assets.playSound("noise", 0.8, (0.5 + Utils.round(Utils.random(1), 0.2)))
                        table.insert(logoparts, part)
                    end
                    createLogoPart(0)
                    cutscene:wait(0.28)
                    createLogoPart(8)
                    cutscene:wait(0.28)
                    createLogoPart(1)
                    cutscene:wait(0.28)
                    createLogoPart(7)
                    cutscene:wait(0.28)
                    createLogoPart(2)
                    cutscene:wait(0.28)
                    createLogoPart(6)
                    cutscene:wait(0.28)
                    createLogoPart(3)
                    cutscene:wait(0.28)
                    createLogoPart(5)
                    cutscene:wait(0.28)
                    createLogoPart(4)
                    cutscene:wait(1.25)
                    Assets.playSound("snd_queen_laugh_title")
                    local part = Sprite("IMAGE_LOGO/IMAGE_LOGO_CHAPTERNUMBER_2", 320, (240 + 32 + 44) - 44)
                    part:setOrigin(0.5, 0.5)
                    part:setScale(2)
                    part:play(0.25, true)
                    part.layer = 500
                    self:addChild(part)
                    cutscene:wait(4)
                    Game.fader:fadeOut(self.returnToMenu, { speed = 0, music = 10 / 30 })
                    Game.state = "EXIT"
                end)
            else
                Game.world:startCutscene(function(cutscene)
                    self.state = "CHAPTER2_CUTSCENE"
                    self.can_click = true
                    cutscene:wait(1)
    
                    local queen = Sprite("intro/chapter_2/queen_wireframe_rotate", 320, -106)
                    queen:play(0.075, true)
                    queen.alpha = 0
                    queen:setOrigin(0.5, 0.5)
                    queen:setScale(2)
                    queen.layer = 500
                    Game.stage:addChild(queen)
                    Game.world.timer:tween(0.5, queen, { alpha = 1 })
                    Game.world.timer:tween(1, queen, { y = 240 }, 'out-elastic')                       --quint
                    cutscene:wait(0.89)
                    queen:stop()
                    queen:setFrame(4)
                    cutscene:wait(0.75)
                    Assets.playSound("snd_queen_bitcrushlaugh")
                    queen:set("intro/chapter_2/queen_wireframe_laugh")
                    queen:play(0.075, true)
                    cutscene:wait(1.75)
                    queen:set("intro/chapter_2/queen_wireframe_explode")
                    queen:play(0.075, true)
                    cutscene:wait(cutscene:playSound("snd_explosion_mmx3"))
                    Game.world.timer:tween(0.5, queen, { alpha = 0 })
                    cutscene:wait(1)
                    Game.fader:fadeOut(self.returnToMenu, { speed = 0, music = 10 / 30 })
                    Game.state = "EXIT"
                end)
            end
        end
    end)
end
----------------------------------------------------

function ChapterSelect:getDrawColor()
    local r, g, b, a = super.getDrawColor(self)
    return 1, 1, 0, self.alpha
end

function ChapterSelect:drawRectangle(x, y, w, h)
    love.graphics.setColor(0.16862745098,0.16862745098,0.16862745098, self.alpha)
    love.graphics.rectangle("fill", 2, y - 1.35, SCREEN_WIDTH, h - 2)
end

function ChapterSelect:close()
    Game.world.menu = nil
    self:remove()
end

function ChapterSelect:draw()
    super.draw(self)
    love.graphics.setFont(self.font)
    -- Draw the lines
    self.lines = {
        self:drawRectangle(0, self.lines_y+(60*0), self.width, self.height),
        self:drawRectangle(0, self.lines_y+(60*1), self.width, self.height),
        self:drawRectangle(0, self.lines_y+(60*2), self.width, self.height),
        self:drawRectangle(0, self.lines_y+(60*3), self.width, self.height),
        self:drawRectangle(0, self.lines_y+(60*4), self.width, self.height),
        self:drawRectangle(0, self.lines_y+(60*5), self.width, self.height),
    }

    
    
    for i = 1, (#self.chapters + 1) do
        love.graphics.setColor(1, 1, 1, self.alpha)
        
        love.graphics.print(self.language_text[self.language()]..tostring(self.language), 226, self.text_y+(60*6.84))
    
        love.graphics.print(self.quit_text[self.language()], SCREEN_WIDTH-self.font:getWidth(self.quit_text[self.language()]), self.text_y+(60*6.84))
        
        if self.selected_index == i then
            love.graphics.setColor(self:getDrawColor())
        end
        --chapters
        if i <= #self.chapters then
            local icon = Assets.getTexture("chselect/ch"..i)
            if self.chapters[i].locked == true then
                love.graphics.setColor(0.5, 0.5, 0.5, self.alpha)
            end
            if icon then
                Draw.draw(icon, 547, self.icon_y+(60*(i-1)), 0, 2, 2)
            end
            if self.chapters[i].locked == true then
                love.graphics.setColor(0.5, 0.5, 0.5, self.alpha)
            end
            love.graphics.print(self.chapters[i].chapter[self.language()], 79, self.text_y+(60*(i-1)))
            if self.state == "SELECT" or self.state ~= "CHAPTER"..i and ((self.selected_index ~= i and self.selected_index)) then
                if self.chapters[i].locked == true then
                    love.graphics.setColor(0.5, 0.5, 0.5, self.alpha)
                end
                if type(self.chapters[i].title) == "table" then
                    love.graphics.printf(self.chapters[i].title[self.language()], -140, self.text_y+(60*(i-1)), 1000, "center", 0)
                else
                    love.graphics.printf(self.chapters[i].title, -140, self.text_y+(60*(i-1)), 1000, "center", 0)
                end
            elseif self.state == "CHAPTER"..i then
                love.graphics.setColor(1, 1, 1, self.alpha)
                if self.selected_confirm == 1 then
                    love.graphics.setColor(self:getDrawColor())
                end
                love.graphics.print(self.options[1].accept[self.language()], 250, self.text_y+(60*(self.selected_index-1)))
                love.graphics.setColor(1, 1, 1, self.alpha)
                if self.selected_confirm == 2 then
                    love.graphics.setColor(self:getDrawColor())
                end
                love.graphics.print(self.options[1].refuse[self.language()], 430, self.text_y+(60*(self.selected_index-1)))
            end
        end
        
        if self.substate == "LANGUAGE" then
            love.graphics.print(self.language_text[self.language()]..tostring(self.language), 226, self.text_y+(60*6.84))
        elseif self.substate == "QUIT" then
            love.graphics.print(self.quit_text[self.language()], SCREEN_WIDTH-self.font:getWidth(self.quit_text[self.language()]), self.text_y+(60*6.84))
        end
        self.heart.alpha = self.alpha
    end
end

function ChapterSelect:ChangeLanguage()
    self.languages:next()
end

--- Exits the current mod and returns to the Kristal menu.
function ChapterSelect.returnToMenu()
    local modid = Mod:getCurrentModId()
    -- Go to empty state
    Gamestate.switch({})
    -- Clear the mod
    Kristal.clearModState()
    -- Reload mods and return to memu
    Kristal.loadAssets("", "mods", "", function ()
        love.window.setTitle(Kristal.getDesiredWindowTitle())
        local MENU = Kristal.States["MainMenu"]
        Gamestate.switch(MENU)
        MENU:setState("MODSELECT")
        local selected
        for i,v in pairs(MENU.mod_list.list.mods) do
            if v.id == modid then
                selected = v
            end
        end
        local mod = selected and selected.mod
        MENU.selected_mod = mod
        MENU.selected_mod_button = selected
        MENU.file_select.mod = mod
        MENU:setState("FILESELECT")
    end)

    Kristal.DebugSystem:refresh()
    -- End input if it's open
    if not Kristal.Console.is_open then
        TextInput.endInput()
    end
end

function ChapterSelect:swapIntoMod(mod_id, save_id, save_name, after)
    local Language = self.language()
    assert(Kristal.Mods.data[mod_id], "No mod \""..tostring(mod_id).."\"")
    Gamestate.switch({})
    Kristal.clearModState()
    Kristal.loadAssets("","mods","", function()
        Kristal.loadMod(mod_id, save_id, save_name, after)
        if Mod then
            Mod.selected_language = Language
        end
    end)
    Gamestate.switch(Kristal.States["Game"])
end

function ChapterSelect:update()
    super.update(self)
    self.timer = self.timer+DTMULT
    self.text_y = Utils.ease(10, 30, self.timer/32, "out-cubic")
    self.lines_y = Utils.ease(82, 80, self.timer/32, "out-cubic")
    self.icon_y = Utils.ease(10, 24, self.timer/32, "out-cubic")

    if self.can_use then
        if Language and not self.language_loaded then 
            self.language(Language)
            self.language_loaded = true
            self.font = Assets.getFont(self.language().."_main") or Assets.getFont("main")
            love.graphics.clear(0,0,0,255)
            self:draw()
        end
        for i, chapter in ipairs(self.chapters) do
            if Input.pressed("confirm", false) then
                Input.clear("confirm")
                if self.state == "SELECT" then
                    if self.can_click == true then
                        if self.substate ~= "NIL" then
                            if self.substate == "QUIT" then
                                Assets.playSound("ui_cancel_small")
                                love.event.quit()
                            elseif self.substate == "LANGUAGE" then
                                self.language:next()
                                self.font = Assets.getFont(self.language().."_main") or Assets.getFont("main")
                                love.graphics.clear(0,0,0,0)
                                self:draw()
                            end
                        else
                            Assets.playSound("ui_select")
                            self.state = "CHAPTER"..self.selected_index
                        end
                        Game.world.timer:after(0.75, function()
                            self.can_click = true
                        end)
                    end
                elseif self.state == "CHAPTER"..self.selected_index then
                    if self.can_click == true then
                        if self.selected_confirm == 1 then
                            Assets.playSound("ui_select")
                            self:loadChapter(self.selected_index)
                        elseif self.selected_confirm == 2 then
                            Assets.playSound("ui_select")
                            self.selected_confirm = 1
                            self.state = "SELECT"
                            Game.world.timer:after(0.75, function()
                                self.can_click = true
                            end)
                        end
                    end
                elseif self.state == "CHAPTER1_CUTSCENE" then
                    if Game.legend then
                        self.can_click = false
                        local leg = Game.legend
                        Game.legend.music:fade(0)
                        Game.legend = nil
                        local rectangle = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                        rectangle:setColor(0, 0, 0, 1)
                        rectangle.layer = 1000
                        rectangle.alpha = 0
                        Game.stage:addChild(rectangle)
                        Game.world.timer:tween(0.5, rectangle, {alpha = 1})
                        Game.world.timer:after(0.75, function()
                            leg:remove()
                            self.can_click = true
                            self.state = "DELTARUNE_LOGO"
                            Game.deltarune_logo = Game.stage:addChild(DELTARUNE())
                            Game.deltarune_logo.layer = 1500
                            if Game.world.cutscene then Game.world.cutscene:endCutscene() end
                            Game.world:startCutscene(function(cutscene)
                                cutscene:wait(function() if Game.deltarune_logo then return Game.deltarune_logo:isOver() end end)
                                if Game.deltarune_logo and Game.deltarune_logo.skipped == false then
                                    cutscene:wait(10)
                                end
                                Game.fader:fadeOut(self.returnToMenu, {speed = 1, music = 10/30})
                                Game.state = "EXIT"
                            end)
                        end)
                    end
                elseif self.state == "DELTARUNE_LOGO" then
                    if Game.deltarune_logo then
                        local log = Game.deltarune_logo
                        Game.deltarune_logo.skipped = true
                        Game.deltarune_logo = nil
                        Game.world.timer:after(3.25, function()
                            log:remove()
                            Game.fader:fadeOut(self.returnToMenu, {speed = 1, music = 10/30})
                            Game.state = "EXIT"
                        end)
                    end
                end
                self.can_click = false
            end
        end
        if self.state == "SELECT" then
            --move up
            if Game.lock_movement == false then
                if Input.pressed("up", false) then
                    Assets.playSound("ui_move")
                    if self.selected_index > 1 then
                        if self.selected_index > #self.chapters then
                            self.substate = "NIL"
                        end
                        self.selected_index = self.selected_index - 1
                        if self.chapters[self.selected_index] and self.chapters[self.selected_index].locked == true then self.selected_index = self.selected_index - 1 end
                    end
                end
                --move down
                if Input.pressed("down", false) then
                    Assets.playSound("ui_move")
                    if self.selected_index < #self.chapters+1 then
                        self.selected_index = self.selected_index + 1
                        if self.chapters[self.selected_index] and self.chapters[self.selected_index].locked == true then self.selected_index = self.selected_index + 1 end
                        if self.selected_index > #self.chapters then
                            self.substate = "LANGUAGE"
                        end
                    end
                end
                if self.substate ~= "NIL" then
                    local _t = {LANGUAGE={next="QUIT",prev="QUIT"},QUIT={next="LANGUAGE",prev="LANGUAGE"}}
                    if Input.pressed("right", false) then
                        self.substate = _t[self.substate].next
                    elseif Input.pressed("left",false) then
                        self.substate = _t[self.substate].prev
                    end
                end
            end
        end
        for i = 1, (#self.chapters + 1) do
            if self.state == "CHAPTER"..i then
                --move left
                if Game.lock_movement == false then
                    if Input.pressed("left", true) then
                        Assets.playSound("ui_move")
                        self.selected_confirm = self.selected_confirm - 1
                    end
                    --move right
                    if Input.pressed("right", true) then
                        Assets.playSound("ui_move")
                        self.selected_confirm = self.selected_confirm + 1
                    end
                end
            end
            --soul positions
            if self.state == "SELECT" then
                if self.selected_index == i then
                    if i > #self.chapters then
                        self.heart:setPosition(({LANGUAGE=202,QUIT=SCREEN_WIDTH-self.font:getWidth(self.quit_text[self.language()])-24})[self.substate] or 0, 457)
                        self.heart:setColor(1, 0, 0)
                    else
                        self.heart:setPosition(self.heart_target_x, (17 + 60 * (i - 1))+self.text_y)
                        self.heart:setColor(1, 0, 0)
                    end
                end
            elseif self.state == "CHAPTER" .. i then
                if self.selected_confirm == 1 then
                    self.heart:setPosition(230, 47 + 60 * (self.selected_index - 1))
                    self.heart:setColor(1, 0, 0)
                end
                if self.selected_confirm == 2 then
                    self.heart:setPosition(410, 47 + 60 * (self.selected_index - 1))
                    self.heart:setColor(1, 0, 0)
                end
                if self.selected_confirm > 1 then
                    self.selected_confirm = 2
                end
                if self.selected_confirm < 2 then
                    self.selected_confirm = 1
                end
            end
        end
    end
end

function ChapterSelect:onAddToStage()
    if Game.world.music.current ~= Mod.selection_music then
        Game.world.music:play(Mod.selection_music)
    end
    self:fadeTo(1, 0.5)
end

return ChapterSelect