local ChapterContinue, super = Class(Object)

function ChapterContinue:init(width, height)
	super.init(self, 0, 0, width, height)

    Input.clear("confirm")

    self.messages = {
        begin = "Would you like to start from Chapter %d?",
        continue = "Continue from Chapter %d?",
        beginnew = "Chapter %d was completed.",
    }

    self.layer = 100
    self.alpha = 0

    self.parallax_x = 0
	self.parallax_y = 0

    self.selected_index = 1

    self.text_y = 30
    self.choices_y = 30
    self.timer = 0
    self.optionalpha = 1

    self.state = "MAIN" -- MAIN, TRANSITION (dont touch)

    self.can_use = false

    self.heart = Sprite("player/heart")
    self.heart.visible = true
    self.heart:setOrigin(0.5, 0.5)
    self.heart:setScale(1, 1)
    self.heart:setColor(1, 0, 0)
    self.heart.layer = 100
    self.heart.alpha = 0
    self:addChild(self.heart)

    self.heart_target_x = 282
    self.heart_target_y = 258
    self.heart:setPosition(self.heart_target_x, self.heart_target_y)

    self.lines = {}

    self.font = Assets.getFont("main")

    self.rectangle = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
	self.rectangle:setColor(0, 0, 0, 1)
	self:addChild(self.rectangle)

    self.options = {
        {
            accept = "Yes",
            refuse = "No",
        },
        {
            accept = "Play Chapter %d",
            refuse = "Chapter Select",
        },
    }

    self.action = "start"
    self.continuechapter = 1


    self.chapters = Game.CHAPTER_SELECT.chapters
    if not Mod:hasNoSaveFiles(true) then
        for i,v in ipairs(self.chapters) do
            if (Mod:hasNoSaveFiles(v.modid) == false) then if v.locked ~= true then self.action = "continue" self.continuechapter = i end end
        end
    end
    local cch = Mod:getLastCompletedChapter()
    if cch ~= nil then
        if self.chapters[(cch+1)].locked ~= true then
            if self.continuechapter < (cch+1) then
                self.action = "completion"
                self.continuechapter = (cch+1)
            end
        end
    end
end

function ChapterContinue:getDrawColor()
    local r, g, b, a = super.getDrawColor(self)
    return 1, 1, 0, self.optionalpha
end

function ChapterContinue:draw()
    super.draw(self)
    
    love.graphics.setColor(1, 1, 1, self.alpha)
    if self.action == "start" then
        love.graphics.printf(string.format(self.messages.begin, Mod.startingchapter), -179, self.text_y + (184), 1000, "center", 0)
    elseif self.action == "continue" then
        love.graphics.printf(string.format(self.messages.continue, self.continuechapter), -179, self.text_y + (184), 1000, "center", 0)
    else
        love.graphics.printf(string.format(self.messages.beginnew, self.continuechapter-1), -179, self.text_y + (184), 1000, "center", 0)
    end

    if self.action == "completion" then
        love.graphics.setColor(1, 1, 1, self.optionalpha)
        if self.selected_index == 1 then
            love.graphics.setColor(self:getDrawColor())
            self.heart.x = 213
            self.heart.y = self.choices_y + (228) + (16)
        end
        love.graphics.printf(string.format(self.options[2].accept, self.continuechapter), -179, self.choices_y + (228), 1000, "center", 0)
        love.graphics.setColor(1, 1, 1, self.optionalpha)
        if self.selected_index == 2 then
            love.graphics.setColor(self:getDrawColor())
            self.heart.x = 209
            self.heart.y = self.choices_y + (268) + (16)
        end
        love.graphics.printf(self.options[2].refuse, -179, self.choices_y + (268), 1000, "center", 0)
    else
        love.graphics.setColor(1, 1, 1, self.optionalpha)
        if self.selected_index == 1 then
            love.graphics.setColor(self:getDrawColor())
            self.heart.x = 282
            self.heart.y = self.choices_y + (228) + (16)
        end
        love.graphics.printf(self.options[1].accept, -179, self.choices_y + (228), 1000, "center", 0)
        love.graphics.setColor(1, 1, 1, self.optionalpha)
        if self.selected_index == 2 then
            love.graphics.setColor(self:getDrawColor())
            self.heart.x = 289
            self.heart.y = self.choices_y + (268) + (16)
        end
        love.graphics.printf(self.options[1].refuse, -179, self.choices_y + (268), 1000, "center", 0)
    end
    self.heart.alpha = self.alpha
end

function ChapterContinue:update()
    super.update(self)
    self.timer = self.timer+DTMULT
    self.text_y = Utils.ease(10, 30, self.timer/40, "out-cubic")
    self.choices_y = Utils.ease(10, 30, self.timer/40, "out-cubic")
    if self.state == "MAIN" then
        if self.can_use then
            if Input.pressed("confirm", false) then
                Input.clear("confirm")
                if self.selected_index == 1 then
                    self.state = "TRANSITION"
                    Assets.playSound("ui_select")
                    if self.action == "start" then
                        Game.CHAPTER_SELECT:loadChapter(Mod.startingchapter)
                    else
                        Game.CHAPTER_SELECT:loadChapter(self.continuechapter)
                    end
                elseif self.selected_index == 2 then
                    Assets.playSound("ui_select")
                    Game.chapter = 1
                    Game.CHAPTER_SELECT = CHAPTER_SELECT()
                    Game.CHAPTER_SELECT.can_use = true
                    Game.stage:addChild(Game.CHAPTER_SELECT)
                    self:remove()
                end
            end
            if Game.lock_movement == false then
                if Input.pressed("up", false) then
                    Assets.playSound("ui_move")
                    if self.selected_index > 1 then
                        self.selected_index = self.selected_index - 1
                    end
                end
                if Input.pressed("down", false) then
                    Assets.playSound("ui_move")
                    if self.selected_index < 2 then
                        self.selected_index = self.selected_index + 1
                    end
                end
            end
        end
    end
end

function ChapterContinue:onAddToStage()
    if Game.world.music.current ~= Mod.selection_music then
        Game.world.music:play(Mod.selection_music)
    end
    self:fadeTo(1, 0.5)
end

return ChapterContinue