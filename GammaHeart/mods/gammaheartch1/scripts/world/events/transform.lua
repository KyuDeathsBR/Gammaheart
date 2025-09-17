---@class Transformation : Event
---@field mode "DARK"|"LIGHT"|string *[Property `mode`]*
---@field flash FlashFade[] *[Property `mode`]*
local Transformation, super = Class(Event, "transform")

---@param self Transformation
function Transformation:init(data)
    local default_colors = {
        DARK = {17/255, 35/255, 128/255},
        LIGHT = {1,1,1}
    }
    super.init(self, data)
    self.flash = {}
    local properties = data.properties or {}
    local opposite = properties["opposite"] or {
        DARK = "LIGHT",
        LIGHT = "DARK"
    }
    self.mode = properties["mode"] or "DARK"
    self.opposite = opposite[self.mode]
    self.vertical = properties["vertical"]
    self.cutout_type = properties["cutoffside"]
    self:setOrigin(0,0)
    self.color = properties["color"] or default_colors[opposite[self.mode]]
    self.sprite = Sprite("world/events/transform",0,0)
    self.sprite:setAnimation({"world/events/transform",1/12,true, frames={1,2,3,2}})
    self.sprite:setScaleOrigin(0.5,0.5)
    self.sprite:setRotationOrigin(0.5,0.5)
    if self.vertical or self.height > self.width then
        self.sprite.rotation = math.rad(90)
        self.sprite:setScale(self.height/self.sprite.width,2*self.width/self.sprite.height)
        self.sprite.cutout_top = self.cutout_type == 1 and self.sprite.height/2 or 0
        self.sprite.cutout_bottom = self.cutout_type == 2 and self.sprite.height/2 or 0
        if self.cutout_type == 1 then
            self.sprite.x = self.sprite.x + (self.sprite:getScaledHeight())
        elseif self.cutout_type == 2 then
            self.sprite.x = self.sprite.x + (self.sprite:getScaledHeight()/2)
        end
    else
        self.sprite:setScale(self.width/self.sprite.width,2*self.height/self.sprite.height)
        self.sprite.cutout_bottom = self.cutout_type == 1 and self.sprite.height/2 or 0
        self.sprite.cutout_top = self.cutout_type == 2 and self.sprite.height/2 or 0
    if self.cutout_type == 1 then
            self.sprite.y = self.sprite.y
        elseif self.cutout_type == 2 then
            self.sprite.y = self.sprite.y - (self.sprite:getScaledHeight()/2)
        end
    end
    self.sprite:setScaleOrigin(0,0)
    self.sprite.color = properties["color"] or default_colors[self.mode]
    self:addChild(self.sprite)
end

---@param plr    Player
---@param DT     number
function Transformation:onCollide(plr,DT)
    local member = plr:getPartyMember()
    if Mod.mode ~= self.mode then
        Mod.mode = self.mode
        if Game.world and not self.transitioning_music then
            self.transitioning_music = true
            Game.world.music:stop()
            Game.world.music:play(Game.world.map.data.properties["music_"..self.opposite] or Game.world.map.data.properties.music)
            Game.world.timer:after(0.5,function()
                self.transitioning_music = false
            end)
        end
    end
    if member and member.can_transform then
        if member.mode ~= self.mode then
            member.mode = self.mode
            
            if not self.flash[member] then
                self.flash[member] = plr:flash(plr.sprite,0,0,WORLD_LAYERS["below_soul"])
                self.flash[member].path = member:getActor(self.mode).animations[self.flash[member].anim_sprite]
                self.flash[member].frame = plr.sprite.frame
                self.flash[member].color_mask:setColor(self.color[1],self.color[2],self.color[3])
                local _s = self.flash
                Game.world.timer:after(0.5,function()
                    _s[member] = nil
                end)
            end
        end
        if self.flash[member] then
            self.flash[member].alpha = math.max(math.sin(DT),0)
        end
    end
end

return Transformation