local Dummy, super = Class(EnemyBattler)

function Dummy:init()
    super.init(self)

    -- Enemy name
    self.name = ({
        en = "OP Dummy [100MHP]",
        es = "Boboneco OP",
        ["pt-br"] = "Boboneco APELÃO",
        ja = "ＯＰなダミー",
        LOLCAT = "WEEK DUHMIE SRC: TRUZT ME BRO"
    })[Mod.selected_language] or "Dummy TEMPLATE NAME"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("dummy")
    self.sprite:setColor(1,1,0,1)

    -- Enemy health
    self.max_health = 100*1000*1000
    self.health = self.max_health
    -- Enemy attack (determines bullet damage)
    self.attack = 4
    -- Enemy defense (usually 0)
    self.defense = 0
    -- Enemy reward
    self.money = 100

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 20

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        "basic",
        "aiming",
        "movingarena"
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {
        "..."
    }

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = "AT 4 DF 0\n* Cotton soul and button eye."

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        en={"* The dummy looks cool.","* The dummy glances at you"},
        es={"* El boboneco se ve increíble.","* El boboneco te mira"},
        ["pt-br"]={"* O boboneco parece demais.","* O boboneco olha você"},
        ja={"＊ダミーがかっこよく見える", "＊ダミーがちらっとこちらを見る"},
        LOLCAT = {"* DUHMIE LOOK COOL","* DUMMIE DOAZ LOOK AT U"}
    }
    -- Text displayed at the bottom of the screen when the enemy has low health
    self.low_health_text = "* The dummy looks like it's\nabout to fall over."

    -- Register act called "Smile"
    self:registerAct(({en="Smile",es="Sonreír",["pt-br"]="Sorrir",ja="笑顔する",LOLCAT="SMAIEL :3"})[Mod.selected_language])
    -- Register party act with Ralsei called "Tell Story"
    -- (second argument is description, usually empty)
    self:registerAct("Tell Story", "", {"ralsei"})
    self.shader = love.graphics.newShader([[
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
           if (Texel(texture, texture_coords).a == 0.0) {
              // a discarded pixel wont be applied as the stencil.
              discard;
           }
           return vec4(1.0);
        }
    ]])
end

---@param object Object
function Dummy:drawCharacter()
    love.graphics.push()
    super.draw(self)
    super.draw(self)
    super.draw(self)
    love.graphics.pop()
end

---@param object Object
function Dummy:drawMask(object)
    love.graphics.setShader(self.shader)
    self:drawCharacter()
    love.graphics.setShader()
end


function Dummy:draw()
    local object = super
    love.graphics.stencil((function () self:drawMask(object) end), "replace", 1)
    love.graphics.setStencilTest("less", 1)

    love.graphics.setShader(Kristal.Shaders["AddColor"])

    Kristal.Shaders["AddColor"]:sendColor("inputcolor", { self.actor:getColor() })
    Kristal.Shaders["AddColor"]:send("amount", 1)

    love.graphics.translate(-2, 0)
    self:drawCharacter()
    love.graphics.translate(2, 0)

    love.graphics.translate(2, 0)
    self:drawCharacter()
    love.graphics.translate(-2, 0)

    love.graphics.translate(0, 2)
    self:drawCharacter()
    love.graphics.translate(0, -2)

    love.graphics.translate(0, -2)
    self:drawCharacter()
    love.graphics.translate(0, 2)

    love.graphics.setShader()

    love.graphics.setStencilTest()
    super.draw(self)
end

function Dummy:onAct(battler, name)
    if name == ({en="Smile",es="Sonreír",["pt-br"]="Sorrir",ja="笑顔する",LOLCAT="SMAIEL :3"})[Mod.selected_language] then
        -- Give the enemy 100% mercy
        self:addMercy(100)
        -- Change this enemy's dialogue for 1 turn
        self.dialogue_override = "... ^^"
        -- Act text (since it's a list, multiple textboxes)
        return {
            "* You smile.[wait:5]\n* The dummy smiles back.",
            "* It seems the dummy just wanted\nto see you happy."
        }

    elseif name == "Tell Story" then
        -- Loop through all enemies
        for _, enemy in ipairs(Game.battle.enemies) do
            -- Make the enemy tired
            enemy:setTired(true)
        end
        return "* You and Ralsei told the dummy\na bedtime story.\n* The enemies became [color:blue]TIRED[color:reset]..."

    elseif name == "Standard" then --X-Action
        -- Give the enemy 50% mercy
        self:addMercy(50)
        if battler.chara.id == "ralsei" then
            -- R-Action text
            return "* Ralsei bowed politely.\n* The dummy spiritually bowed\nin return."
        elseif battler.chara.id == "susie" then
            -- S-Action: start a cutscene (see scripts/battle/cutscenes/dummy.lua)
            Game.battle:startActCutscene("dummy", "susie_punch")
            return
        else
            -- Text for any other character (like Noelle)
            return "* "..battler.chara:getName().." straightened the\ndummy's hat."
        end
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end

return Dummy