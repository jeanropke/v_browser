GenericWebsite = {}
GenericWebsite.__index = GenericWebsite

function GenericWebsite:initialise(scaleform, url)
    repeat Wait(0) until HasScaleformMovieFilenameLoaded(url)

    Scaleform.Call(scaleform, 'INITIALISE_WEBSITE')
    --Scaleform.Call(scaleform, 'UPDATE_TEXT')
end