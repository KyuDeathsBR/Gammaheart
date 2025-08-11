local DebugMenu, super = Class(Object)

function DebugMenu:init(width, height)
	super.init(self, 0, 0, width, height)

    Input.clear("confirm")

    self.messages = {
        title = "Chapter 2",
    }

    self.layer = 100
    self.alpha = 1

    self.parallax_x = 0
	self.parallax_y = 0

    self.selected_index = 1

    self.timer = 0

    self.can_use = false

    self.heart = Sprite("player/heart")
    self.heart.visible = true
    self.heart:setOrigin(0.5, 0.5)
    self.heart:setScale(1, 1)
    self.heart:setColor(1, 0, 0)
    self.heart.layer = 100
    self.heart.alpha = 1
    self:addChild(self.heart)

    self.heart_target_x = 220
    self.heart_target_y = 176
    self.heart:setPosition(self.heart_target_x, self.heart_target_y)

    self.lines = {}

    self.font = Assets.getFont("main")

    self.rectangle = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
	self.rectangle:setColor(0, 0, 0, 1)
	self:addChild(self.rectangle)

    self.options = {
        {
            accept = "Go to Main Menu",
            refuse = "Go to Debug Room",
        },
    }

    self.dog = Sprite("npcs/spr_dogcar", 320, 320+44-2)
    self.dog:setOrigin(0.5, 0.5)
    self.dog:setScale(2)
    self.dog:play(0.25, true)
    self:addChild(self.dog)
end

function DebugMenu:getDrawColor()
    local r, g, b, a = super.getDrawColor(self)
    return 1, 1, 0, 1
end

function DebugMenu:draw()
    super:draw(self)
    
    self.heart.x = 220
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(self.messages.title, -180, 184 - 60 - 44, 1000, "center", 0)
    love.graphics.setColor(1, 1, 1, 1)
    if self.selected_index == 1 then
        love.graphics.setColor(self:getDrawColor())
        self.heart.y = 176
    end
    love.graphics.print(self.options[1].accept, 221+19, (228)-68)
    love.graphics.setColor(1, 1, 1, 1)
    if self.selected_index == 2 then
        love.graphics.setColor(self:getDrawColor())
        self.heart.y = 216
    end
    love.graphics.print(self.options[1].refuse, 221+19, (268)-68)
end

function DebugMenu:update()
    super.update(self)
    self.timer = self.timer+DTMULT
    if self.can_use then
        if Input.pressed("confirm", false) then
            Input.clear("confirm")
            if self.selected_index == 1 then
                Assets.playSound("ui_move")
                Game.CHAPTER_SELECT:loadChapter2(false)
                self:remove()
            elseif self.selected_index == 2 then
                Assets.playSound("ui_move")
                Game.world:loadMap("debug_room")
                Game.CHAPTER_SELECT:remove()
                if Game.CHAPTER_CONTINUE then Game.CHAPTER_CONTINUE:remove() end
                if Game.SPLASH_SCREEN then Game.SPLASH_SCREEN:remove() end
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

return DebugMenu