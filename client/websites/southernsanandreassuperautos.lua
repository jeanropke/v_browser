SouthernSanAndreasSuperAutos = {}
SouthernSanAndreasSuperAutos.__index = SouthernSanAndreasSuperAutos

local currentSelection = nil
local selectedVehicleId = nil

function SouthernSanAndreasSuperAutos:initialise(scaleform)
    repeat Wait(0) until HasScaleformMovieFilenameLoaded('WWW_SOUTHERNSANANDREASSUPERAUTOS_COM')

    Scaleform.Call(scaleform, 'INITIALISE_WEBSITE')

    for i = 3, 260 do
        Scaleform.Call(scaleform, 'SET_PRICES', i, "FREE", 0, 0, 0, 0, 0, true, true)
        Scaleform.Call(scaleform, 'SET_RANKS', i, 0, 3)
    end
    Scaleform.Call(scaleform, "UPDATE_TEXT")

end

function SouthernSanAndreasSuperAutos:onClick()
    local _curSelection = Browser.GetCurrentSelection()

    if _curSelection >= 15  then
        currentSelection = _curSelection - 7
    end

    -- Purchase vehicle
    if GetCurrentWebpageId() == 34 then
        local price = 20
        Vehicle.TryPurchase(selectedVehicleId, price, currentSelection, GetCurrentWebsiteId()) -- vehicleId, 
    else
        selectedVehicleId = GetCurrentWebpageId()
    end
end