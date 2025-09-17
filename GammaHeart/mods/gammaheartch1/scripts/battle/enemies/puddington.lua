local Dummy, super = Class(EnemyBattler)

function Dummy:init()
    super.init(self)

    self.ally = "puddington"
    self.recruitable = true
    -- Enemy name
    self.name = ({
        en = "Puddington",
        es = "Puddington",
        ["pt-br"] = "Puddington",
        ja = "プリプリン",
        LOLCAT = "PUDINTOAN"
    })[Mod.selected_language] or "Puddington TEMPLATE NAME"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("puddington")

    -- Enemy health
    self.max_health = 450
    self.health = 450
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
        "puddington/jumping_pudding",
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {
        "GLORB GLORB",
        ja = {"グログロ"},
    }

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = "AT 4 DF 0\n* Seems tasty."

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        en = {
            "* The aroma of pudding lingers you",
            "* A tasty but dangerous surprise"
        },
        es = {
            "* El aroma del pudin te persigue",
            "* Una sorpresa sabrosa pero peligrosa"
        },
        ja = {
            "＊　プリンの香りが残る",
            "＊　美味しくも危険なサプライズ"
        },
        ["pt-br"] = {
            "* O aroma de pudim te persegue",
            "* Uma surpresa saborosa porém perigosa"
        },
        LOLCAT = {
            "* DA SMEL OV PUDIN CHASE U",
            "* A TAESTEEH BUT DANJERUS SURPRAIZ"
        }
    }

    -- Register act called "Smile"
    self:registerAct(({
        en = "Devour",
        es = "Devorar",
        ["pt-br"] = "Devorar",
        ja = "食べ尽くす",
        LOLCAT = "EET"
    })[Mod.selected_language])
end

function Dummy:onAct(battler, name)
    if name == ({
        en = "Devour",
        es = "Devorar",
        ["pt-br"] = "Devorar",
        ja = "食べ尽くす",
        LOLCAT = "EET"
    })[Mod.selected_language] then
        self:addMercy(30)
        if self:canSpare() then
            return ({
            en="* You devour the pudding, it looks happy",
            es="* Devoras el pudín, el se ve feliz",
            ja="* プリンを食べ尽くすと、今にプリプリンは嬉しいに見えるが。",
            ["pt-br"]="* Você devora o pudim, agora o Puddington parece feliz.",
            LOLCAT="* U DVOR D PUDIN, IT SEEMZ HAPPIE!!!"
        })[Mod.selected_language]
        end
        return ({
            en="* You devour the pudding, suddenly it grows more pudding",
            es="* Devoras el pudín, de repente crece más pudín",
            ja="* プリンを食べ尽くすと、突然プリンが増える。",
            ["pt-br"]="* Você devora o pudim, mas de repente cresce mais pudim.",
            LOLCAT="* U DVOR D PUDIN, BUT IT GROWZ MORE PUDINN!? HOW!"
        })[Mod.selected_language]
    elseif name == "Standard" then --X-Action
        -- Give the enemy 50% mercy
        self:addMercy(15)
        if battler.chara.id == "naayi" then
            return ({
                en = "* Naayí looked at the Puddington with a satiated face.",
                es = "* Naayí miró el Puddington con cara de saciedad.",
                ja = "* ナーイは満足そうな顔でプリプリンを見ていた。",
                ["pt-br"] = "* Naayí olhou ao Puddington com cara de alguém saciado.",
                LOLCAT = "* NAAYI LOKE AT DA PUDINTOAN WIF SATIATD FAEC."
            })[Mod.selected_language]
        elseif battler.chara.id == "kyuma" then
            -- S-Action: start a cutscene (see scripts/battle/cutscenes/dummy.lua)
            return ({
                en = "* Kyuuma looked at the Puddington as if he wanted to devour it.",
                es = "* Kyuuma miró el Puddington como si quisiera devorarlo.",
                ja = "* 丘真は、そのプリントンを食い入るように見つめた。",
                ["pt-br"] = "* Kyuuma olhou ao Puddington como se quisesse devorá-lo.",
                LOLCAT = "* KYOOMA LOOKE AT DA PUDINTOAN AS IV HE WAN 2 EET IT."
            })[Mod.selected_language]
        else
            -- Text for any other character (like Noelle)
            return "* "..battler.chara:getName().." looked at the weird pudding."
        end
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end

return Dummy