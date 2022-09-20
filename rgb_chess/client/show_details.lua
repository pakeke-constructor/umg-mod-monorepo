
local showDetails = {}


local showingDetails = false


function showDetails.showDetails()
    showingDetails = true
end


function showDetails.hideDetails()
    showingDetails = false
end

function showDetails.showingDetails()
    return showingDetails
end


return showDetails

