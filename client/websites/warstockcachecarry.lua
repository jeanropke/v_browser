WarstockCacheCarry = {}
WarstockCacheCarry.__index = WarstockCacheCarry

local currentSelection = nil
local selectedVehicleId = nil

function WarstockCacheCarry:initialise(scaleform)
    repeat Wait(0) until HasScaleformMovieFilenameLoaded('WWW_WARSTOCK_D_CACHE_D_AND_D_CARRY_COM')

    Scaleform.Call(scaleform, 'INITIALISE_WEBSITE')

    Scaleform.Call(scaleform, "SET_DATA_SLOT", 10) -- MOC
    Scaleform.Call(scaleform, "SET_DATA_SLOT", 15) -- Avenger
    Scaleform.Call(scaleform, "SET_DATA_SLOT", 18) -- Terrorbyte
    Scaleform.Call(scaleform, "SET_DATA_SLOT", 25) -- Kosatka

    for i = 3, 170 do
        Scaleform.Call(scaleform, 'SET_PRICES', i, "FREE", 0, 0, 0, 0, 0, true, true)
        Scaleform.Call(scaleform, 'SET_RANKS', i, 0, 3)
    end

    Scaleform.Call(scaleform, "UPDATE_TEXT")

end

function WarstockCacheCarry:onClick()
    local _curSelection = Browser.GetCurrentSelection()
    print(GetCurrentWebpageId(), GetCurrentWebsiteId())
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