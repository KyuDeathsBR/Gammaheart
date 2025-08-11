return {
    -- The inclusion of the below line tells the language server that the first parameter of the cutscene is `BattleCutscene`.
    -- This allows it to fetch us useful documentation that shows all of the available cutscene functions while writing our cutscenes!

    ---@param cutscene WorldCutscene
    kyuma = function(cutscene, event)
        
        local _kyuma = Game.world:getPartyCharacter("kyuma")
        local translationtexts = {
            test_message = {
                en = "Test message, choose your emotion",
                ["pt-br"] = "Mensagem de Teste, escolha sua emoção",
                ja = "テストメッセージ、エモーションを選ぶ",
                es = "Mensaje de Teste, elige tu emocíon"
            },
            smirk = {
                en = "Smirk",
                ["pt-br"] = "Sorriso",
                ja = "ニヤニヤ",
                es = "Sonrisa"
            },
            smirk_msg = {
                en = "Sup.",
                ["pt-br"] = "Eae.",
                ja = "最近どう",
                es = "¿Q pasa?"
            },
            happy = {
                en = "Happy",
                ["pt-br"] = "Feliz",
                ja = "嬉しい",
                es = "Feliz"
            },
            happy_msg = {
                en = "Feeling great right now.",
                ["pt-br"] = "Sentindo bem agora.",
                ja = "今に調子がいい。",
                es = "Sintiendo bíen ahora."
            }
        }
        cutscene:setSpeaker(_kyuma,true)
        
        local choice = cutscene:textChoicer(translationtexts.test_message[Mod.selected_language],{
            translationtexts.smirk[Mod.selected_language],
            translationtexts.happy[Mod.selected_language],
        })
        if choice == 1 then
            cutscene:text(translationtexts.smirk_msg[Mod.selected_language],"smirk")
        elseif choice == 2 then
            cutscene:text(translationtexts.happy_msg[Mod.selected_language],"happy")
        end
    end
}