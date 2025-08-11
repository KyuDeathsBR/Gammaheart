local SplashScreen, super = Class(Object)

function SplashScreen:init(width, height)
	super.init(self, 0, 0, width, height)

    Input.clear("confirm")

    self.state = "MAIN" --MAIN, CONFIRM

    self.messages = {
        message1 = "This program is intended for players\nwho are already familiar with UNDERTALE.",
        message2 = "Would you like to check out UNDERTALE first?",
        message3 = "Visit the UNDERTALE page\nin your web browser?",
    }

    self.layer = 100
    self.alpha = 1

    self.parallax_x = 0
	self.parallax_y = 0

    self.selected_index = 1

    self.text_alpha_a = 0
    self.text_alpha_b = 0
    self.timer = 0

    self.can_use = false

    self.heart = Sprite("player/heart")
    self.heart.visible = true
    self.heart:setOrigin(0.5, 0.5)
    self.heart:setScale(1, 1)
    self.heart:setColor(1, 0, 0)
    self.heart.layer = 100
    self.heart.alpha = 0
    self:addChild(self.heart)

    self.heart_target_x = 179
    self.heart_target_y = 258
    self.heart:setPosition(self.heart_target_x, self.heart_target_y)

    self.lines = {}

    self.font = Assets.getFont("main")

    self.rectangle = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
	self.rectangle:setColor(0, 0, 0, 1)
	self:addChild(self.rectangle)

    self.options = {
        {
            accept = "Check Out UNDERTALE",
            refuse = "Start DELTARUNE",
        },
        {
            accept = "Yes",
            refuse = "No",
        },
    }
end

function SplashScreen:getDrawColor()
    local r, g, b, a = super.getDrawColor(self)
    return 0, 1, 1, self.text_alpha_b
end

function SplashScreen:draw()
    super:draw(self)
    
    if self.state == "MAIN" then
        self.heart.x = 179
        love.graphics.setColor(1, 1, 1, self.text_alpha_a)
        love.graphics.printf(self.messages.message1, -179, 184-60, 1000, "center", 0)
        love.graphics.setColor(1, 1, 1, self.text_alpha_b)
        love.graphics.printf(self.messages.message2, -179, 184+36, 1000, "center", 0)
        if self.selected_index == 1 then
            love.graphics.setColor(self:getDrawColor())
            self.heart.y = 30 + (228) + (16) + (18)
        end
        love.graphics.print(self.options[1].accept, 221, 30 + (228) + (18))
        love.graphics.setColor(1, 1, 1, self.text_alpha_b)
        if self.selected_index == 2 then
            love.graphics.setColor(self:getDrawColor())
            self.heart.y = 30 + (268) + (16) + (18)
        end
        love.graphics.print(self.options[1].refuse, 221, 30 + (268) + (18))
        self.heart.alpha = self.text_alpha_b
    elseif self.state == "CONFIRM" then
        self.heart.y = 258+28
        love.graphics.setColor(1, 1, 1, self.text_alpha_a)
        love.graphics.printf(self.messages.message3, -179, (184-60)+64, 1000, "center", 0)
        love.graphics.setColor(1, 1, 1, self.text_alpha_b)
        if self.selected_index == 1 then
            love.graphics.setColor(self:getDrawColor())
            self.heart.x = 179+32
        end
        love.graphics.print(self.options[2].accept, 221+11, 30 + (228) + (18) - 5)
        love.graphics.setColor(1, 1, 1, self.text_alpha_b)
        if self.selected_index == 2 then
            love.graphics.setColor(self:getDrawColor())
            self.heart.x = 334+32
        end
        love.graphics.print(self.options[2].refuse, 389, 30 + (228) + (18) - 5)
        self.heart.alpha = self.text_alpha_b
    end
end

function SplashScreen:update()
    super.update(self)
    self.timer = self.timer+DTMULT
    if self.timer >= 60 then
        if self.text_alpha_a < 1 then
            self.text_alpha_a = self.text_alpha_a + 0.015
        end
        if self.text_alpha_a >= 1 then
            if self.text_alpha_b < 1 then
                self.text_alpha_b = self.text_alpha_b + 0.015
            end
        end
    end
    if self.can_use then
        if self.text_alpha_b >= 1 then
            if Input.pressed("confirm", false) then
                Input.clear("confirm")
                if self.state == "MAIN" then
                    if self.selected_index == 1 then
                        Assets.playSound("ui_move")
                        self.state = "CONFIRM"
                        self.selected_index = 1
                    elseif self.selected_index == 2 then
                        Assets.playSound("ui_move")
                        if Mod.continue and Game.CHAPTER_CONTINUE then
                            Game.CHAPTER_CONTINUE = CHAPTER_CONTINUE()
                            Game.CHAPTER_CONTINUE.can_use = true
                            Game.stage:addChild(Game.CHAPTER_CONTINUE)
                            self:remove()
                        else
                            Game.chapter = 1
                            Game.CHAPTER_SELECT = CHAPTER_SELECT()
                            Game.CHAPTER_SELECT.can_use = true
                            Game.stage:addChild(Game.CHAPTER_SELECT)
                            self:remove()
                        end
                    end
                else
                    if self.selected_index == 1 then
                        Assets.playSound("ui_move")
                        love.system.openURL("https://undertale.com/")
                    elseif self.selected_index == 2 then
                        Assets.playSound("ui_move")
                        self.state = "MAIN"
                        self.selected_index = 1
                    end
                end
            end
        end
        if self.text_alpha_b >= 1 then
            if Game.lock_movement == false then
                if self.state == "MAIN" then
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
                else
                    if Input.pressed("cancel", false) then
                        Assets.playSound("ui_move")
                        self.state = "MAIN"
                        self.selected_index = 1
                    end
                    if Input.pressed("left", false) then
                        Assets.playSound("ui_move")
                        if self.selected_index > 1 then
                            self.selected_index = self.selected_index - 1
                        end
                    end
                    if Input.pressed("right", false) then
                        Assets.playSound("ui_move")
                        if self.selected_index < 2 then
                            self.selected_index = self.selected_index + 1
                        end
                    end
                end
            end
        end
    end
end

function SplashScreen:onAddToStage()
    self:fadeTo(1, 0.5)
end

return SplashScreen