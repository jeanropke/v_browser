Eyefind = {}
Eyefind.__index = Eyefind

--[[
    Sponsored: 
        "WWW_DOCKTEASE_COM", "WWW_DYNASTY8REALESTATE_COM", "WWW_ELITASTRAVEL_COM", "WWW_LEGENDARYMOTORSPORT_NET", "WWW_BENNYSORIGINALMOTORWORKS_COM",
        "WWW_PANDMCYCLES_COM", "WWW_SOUTHERNSANANDREASSUPERAUTOS_COM","WWW_WARSTOCK_D_CACHE_D_AND_D_CARRY_COM", "WWW_DYNASTY8EXECUTIVEREALTY_COM",
        "FORECLOSURES_MAZE_D_BANK_COM", "WWW_ELITASTRAVEL_COM", "WWW_WARSTOCK_D_CACHE_D_AND_D_CARRY_COM", "WWW_WARSTOCK_D_CACHE_D_AND_D_CARRY_COM"

]]

function Eyefind:initialise(scaleform)
    repeat Wait(0) until HasScaleformMovieFilenameLoaded('WWW_EYEFIND_INFO')

    Scaleform.Call(scaleform, 'INITIALISE_WEBSITE')
    
    Scaleform.Call(scaleform, "SET_DATA_SLOT", 0, GetNextWeatherTypeHashName())
    Scaleform.Call(scaleform, "SET_DATA_SLOT", 2, GetLabelText(GetNameOfZone(GetEntityCoords(GetPlayerPed(PlayerId())))))
    Scaleform.Call(scaleform, "SET_DATA_SLOT", 3, GetLabelText('CELL_92'..GetClockDayOfWeek()))

    Scaleform.Call(scaleform, "SET_DATA_SLOT", 9, 0, GetLabelText('EYEDISC_SA'), 1, GetLabelText('EYEDISC_SA'), 3, GetLabelText('EYEDISC_SA'), 5, 6, 7, 8, 9, 10, 11, 15, 2, 3)
    Scaleform.Call(scaleform, "UPDATE_TEXT", true)

end