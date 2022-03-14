local pedDisplaying = {}
local displayTime = 5000

Citizen.CreateThread(function()
    local strin = ""

	while true do
		local currentTime, html = GetGameTimer(), ""
		for k, v in pairs(pedDisplaying) do
            
			local player = GetPlayerFromServerId(k)
			if NetworkIsPlayerActive(player) then
			    local sourcePed, targetPed = GetPlayerPed(player), PlayerPedId()
        	    local sourceCoords, targetCoords = GetEntityCoords(sourcePed), GetEntityCoords(targetPed)
        	    local pedCoords = GetPedBoneCoords(sourcePed, 0x2e28, 0.0, 0.0, 0.0)
    
                if player == source or #(sourceCoords - targetCoords) < 25 then
			        if v.type == "me" then
                    	local onScreen, xxx, yyy = GetHudScreenPositionFromWorldPosition(pedCoords.x, pedCoords.y, pedCoords.z + 0.35)
                        if not onScreen then
                    	   html = html .. "<p style=\"left: ".. xxx * 100 .."%;top: ".. yyy * 105 .."%;;-webkit-transform: translate(-50%, 0%);max-width: 100%;position: fixed;text-align: center;color: #f8fe1c;background: transparent;font-family:Heebo;font-size: 20px;\"><b style=\"opacity: 1.0;\">⠀🛠 "..v.msg.."...⠀</b></p>"
                        end
        	        elseif v.type == "do" then
                    	local onScreen, xxx, yyy = GetHudScreenPositionFromWorldPosition(pedCoords.x, pedCoords.y, pedCoords.z + 1.1)
                        if not onScreen then
                    	   html = html .. "<h style=\"left: ".. xxx * 105 .."%;top: ".. yyy * 110 .."%;;box-shadow: 0px 1px 10px 5px #fff;-webkit-transform: translate(0%, 50%);max-width: 100%;position: fixed;text-align: center;color: #000;background: #ffffff7e;border-radius:20px;font-family:Heebo;font-size: 20px;\"><b style=\"opacity: 1.0;color: #000\"></h><h style=\"left: ".. xxx * 107 .."%;top: ".. yyy * 104 .."%;;box-shadow: 0px 1px 10px 8px #fff;-webkit-transform: translate(0%, 50%);max-width: 100%;position: fixed;text-align: center;color: #000;background: #ffffff7e;border-radius:20px;font-family:Heebo;font-size: 20px;\"><b style=\"opacity: 1.0;color: #000\"></h><p style=\"left: ".. xxx * 109 .."%;top: ".. yyy * 84 .."%;;box-shadow: 0px 1px 10px 5px #fff;-webkit-transform: translate(0%, 50%);max-width: 100%;position: fixed;text-align: center;color: #000;background: #fff;border-radius: 20px 20px 20px 20px;;font-family:Heebo;font-size: 20px;\"><b style=\"opacity: 1.0;color: #000\">⠀"..v.msg.."⠀</b></p>"
                        end
        	        end
                end
        	end
        	if v.time <= currentTime then
        		pedDisplaying[k] = nil
        	end
        end

        if strin ~= html then
            SendNUIMessage({
                type = "txt", 
                html = html
            })
            strin = html
        end
        
		Wait(0)
    end
end)

RegisterNetEvent("me_do:client:triggerDisplay")
AddEventHandler("me_do:client:triggerDisplay", function(playerId, message, typ)
	pedDisplaying[tonumber(playerId)] = {type = typ, msg = message, time = GetGameTimer() + displayTime}
end)