local actor, super = Class(Actor, "puddington")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Puddington"

    -- Width and height for this actor, used to determine its center
    self.width = 27
    self.height = 45

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {0, 25, 19, 14}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {1, 0, 0}

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = nil

    -- Path to this actor's sprites (defaults to "")
    self.path = "enemies/puddington"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "walk"
    
    -- Sound to play when this actor speaks (optional)
    self.voice = Assets.getSound(Mod.selected_language.."_puddington_glorb") and Mod.selected_language.."_puddington_glorb" or "puddington_glorb"
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = nil
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = nil

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of talk sprites and their talk speeds (default 0.25)
    self.talk_sprites = {}

    -- Table of sprite animations
    self.animations = {
        ["enemy_idle"] = {"idle", 1/8, true},
        ["hurt"] = {"hurt", 1/8, false, temp = 2, next = "idle"},
        ["walk/down"] = {"walk/down",1/12, true},
        ["walk/up"] = {"walk/up",1/12, true},
        ["walk/right"] = {"walk/right",1/12, true},
        ["walk/left"] = {"walk/left",1/12, true},
        ["battle/intro"] = {"battle/intro",1/8,true},
        ["battle/idle"] = {"battle/idle",1/8,true}
    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        -- Since the width and height is the idle sprite size, the offset is 0,0
        ["idle"] = {0, 0},
        ["battle/idle"] = {0,10},
        ["battle/intro"] = {0,10},
        ["walk/down"]={-13,-6},
        ["walk/up"]={-13,-6},
        ["walk/left"]={-13,-6},
        ["walk/right"]={-13,-6},
    }
end

return actor
