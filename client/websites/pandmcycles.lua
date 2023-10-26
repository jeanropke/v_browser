PMCycles = {}
PMCycles.__index = PMCycles

local currentSelection = nil
local selectedVehicleId = nil

function PMCycles:initialise(scaleform)
    repeat Wait(0) until HasScaleformMovieFilenameLoaded('WWW_PANDMCYCLES_COM')

    Scaleform.Call(scaleform, 'INITIALISE_WEBSITE')
    
    for i = 3, 10 do
        Scaleform.Call(scaleform, 'SET_PRICES', i, "FREE", 0, 0, 0, 0, 0, true, true)
        --Scaleform.Call(scaleform, 'SET_RANKS', i, 0, 3)
    end
    
    Scaleform.Call(scaleform, "UPDATE_TEXT")

end

function PMCycles:onClick()
    local _curSelection = Browser.GetCurrentSelection()

    -- Color
    if _curSelection >= 15  then
        currentSelection = _curSelection - 7
    end

    -- Purchase vehicle
    if GetCurrentWebpageId() == 12 then
        local price = 20
        Vehicle.TryPurchase(selectedVehicleId, price, currentSelection, GetCurrentWebsiteId()) -- vehicleId, 
    else
        selectedVehicleId = GetCurrentWebpageId()
    end
end