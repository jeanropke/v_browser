ElitasTravel = {}
ElitasTravel.__index = ElitasTravel

local currentSelection = nil
local selectedVehicleId = nil

function ElitasTravel:initialise(scaleform)
    repeat Wait(0) until HasScaleformMovieFilenameLoaded('WWW_ELITASTRAVEL_COM')

    Scaleform.Call(scaleform, 'INITIALISE_WEBSITE')
    
    for i = 1, 40 do 
        Scaleform.Call(scaleform, 'SET_PRICES', i, 45000+i, 55000+i, 0, 0, 0, 0, true, true)
        Scaleform.Call(scaleform, 'SET_RANKS', i, 0, 3)
    end

    Scaleform.Call(scaleform, "UPDATE_TEXT", true)
end

function ElitasTravel:onClick()
    
    if Browser.GetCurrentSelection() >= 8  then
        currentSelection = Browser.GetCurrentSelection()
    end

    -- Purchase vehicle
    if GetCurrentWebpageId() == 12 then
        local price = 20
        Vehicle.TryPurchase(selectedVehicleId, price, currentSelection, GetCurrentWebsiteId()) -- vehicleId, 
    else
        selectedVehicleId = GetCurrentWebpageId()
    end
end