local actor, super = Class(Actor, "noelle_lw")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Noelle"

    -- Width and height for this actor, used to determine its center
    self.width = 23
    self.height = 46

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {2, 33, 19, 14}

    -- A table that defines where the Soul should be placed on this actor if they are a player.
    -- First value is x, second value is y.
    self.soul_offset = {11.5, 28}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {1, 1, 0}

    -- Path to this actor's sprites (defaults to "")
    self.path = "party/noelle/light"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "walk"

    -- Sound to play when this actor speaks (optional)
    self.voice = "noelle"
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = "face/noelle"
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = {-12, -10}

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of sprite animations
    self.animations = {
        ["battle/idle"]         = {"battle/idle", 0.2, true},

        ["battle/attack"]       = {"battle/idle", 1/15, false},
        ["battle/act"]          = {"battle/idle", 1/15, false},
        ["battle/spell"]        = {"battle/idle", 1/15, false, next="battle/idle"},
        ["battle/item"]         = {"battle/idle", 1/12, false, next="battle/idle"},
        ["battle/spare"]        = {"battle/idle", 1/15, false, next="battle/idle"},

        ["battle/attack_ready"] = {"battle/idle", 0.2, true},
        ["battle/act_ready"]    = {"battle/idle", 0.2, true},
        ["battle/spell_ready"]  = {"battle/idle", 0.2, true},
        ["battle/item_ready"]   = {"battle/idle", 0.2, true},
        ["battle/defend_ready"] = {"battle/idle", 1/15, false},

        ["battle/act_end"]      = {"battle/idle", 1/15, false, next="battle/idle"},

        ["battle/hurt"]         = {"battle/idle", 1/15, false, temp=true, duration=0.5},
        ["battle/defeat"]       = {"battle/idle", 1/15, false},

        ["battle/transition"]   = {"battle/idle", 1/15, false},
        ["battle/victory"]      = {"battle/idle", 1/10, false},
    }

    -- Tables of sprites to change into in mirrors
    self.mirror_sprites = {
        ["walk/down"] = "walk/up",
        ["walk/up"] = "walk/down",
        ["walk/left"] = "walk/left",
        ["walk/right"] = "walk/right",
    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        -- Cutscene offsets
        ["shocked"] = {0, 0},
    }
end

return actor