return {
    -- The inclusion of the below line tells the language server that the first parameter of the cutscene is `BattleCutscene`.
    -- This allows it to fetch us useful documentation that shows all of the available cutscene functions while writing our cutscenes!

    ---@param cutscene WorldCutscene
    kyuma = function(cutscene, event)
        
        local _kyuma = Game.world:getPartyCharacter("kyuma")

        cutscene:setSpeaker(_kyuma,true)

        local choice = cutscene:textChoicer("Test message, choose your emotion",{"smirk","happy"})
        if choice == 1 then
            cutscene:text("Sup.","smirk")
        elseif choice == 2 then
            cutscene:text("Chillin right now.","happy")
        end
    end
}