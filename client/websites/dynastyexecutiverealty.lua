DynastyExecutiveRealty = {}
DynastyExecutiveRealty.__index = DynastyExecutiveRealty

function DynastyExecutiveRealty:initialise(scaleform)
    repeat Wait(0) until HasScaleformMovieFilenameLoaded('WWW_DYNASTY8EXECUTIVEREALTY_COM')

    Scaleform.Call(scaleform, 'INITIALISE_WEBSITE')
    
    --Citizen.CreateThread(function()
        --while true do
            --if GetCurrentWebpageId() == 2 then
                Scaleform.Call(scaleform, "SET_DATA_SLOT_EMPTY")

                Scaleform.Call(scaleform, 'SET_DATA_SLOT', 1, 1.0, 1.0, 2, "DYN_MP_1", "DESCRIPTION", 7, 7, "DLC", false, false, false, false, false)
                Scaleform.Call(scaleform, "APPEND_OFFICE_DATA_SLOT", 1)

                --end
                
                Scaleform.Call(scaleform, "UPDATE_TEXT")
                
            --break
            --end
            --Wait(0)
       --end
   -- end)
    

end