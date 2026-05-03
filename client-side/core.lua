-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS GLOBAIS
-----------------------------------------------------------------------------------------------------------------------------------------
local policeRadar = false
local policeFreeze = false
local isDragging = false

-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD RADAR (APENAS DIANTEIRO)
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()

		if IsPedInAnyPoliceVehicle(Ped) and policeRadar and not policeFreeze and CheckPolice() then
			TimeDistance = 100

			local Vehicle = GetVehiclePedIsUsing(Ped)
			local Dimension = GetOffsetFromEntityInWorldCoords(Vehicle, 0.0, 1.0, 1.0)
			
            -- Raio de captura frontal
			local VehicleFront = GetOffsetFromEntityInWorldCoords(Vehicle, 0.0, 105.0, 0.0)
			local VehicleFrontShape = StartShapeTestCapsule(Dimension, VehicleFront, 3.0, 10, Vehicle, 7)
			local _, _, _, _, Front = GetShapeTestResult(VehicleFrontShape)

			if IsEntityAVehicle(Front) then
				local Model = vRP.VehicleModel(Front)
				local PlateText = GetVehicleNumberPlateText(Front)
				
				-- Consulta direta ao GlobalState do Gov.xp para verificar queixa de roubo
				local CleanPlate = string.gsub(PlateText, "%s+", "")
				local isStolen = false
				if GlobalState.StolenPlates and GlobalState.StolenPlates[CleanPlate] then
					isStolen = true
				end

				SendNUIMessage({ 
                    radar = "update", 
                    plate = PlateText, 
                    Model = VehicleName(Model), 
                    stolen = isStolen 
                })
            else
                -- Limpa o radar se não houver carro na frente
                SendNUIMessage({ radar = "clear" })
			end
		end

		if not IsPedInAnyVehicle(Ped) and policeRadar then
			policeRadar = false
			SendNUIMessage({ radar = false })
		end

		Wait(TimeDistance)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- COMANDOS E CALLBACKS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("toggleRadar", function()
	local Ped = PlayerPedId()
	if IsPedInAnyPoliceVehicle(Ped) and not IsPauseMenuActive() and CheckPolice() then
		if policeRadar then
			policeRadar = false
			SendNUIMessage({ radar = false })
		else
			policeRadar = true
			SendNUIMessage({ radar = true })
		end
	end
end)

RegisterCommand("toggleFreeze", function()
	local Ped = PlayerPedId()
	if IsPedInAnyPoliceVehicle(Ped) and not IsPauseMenuActive() and CheckPolice() then
		policeFreeze = not policeFreeze
	end
end)

-- Sistema de Mover o Radar (Drag)
RegisterCommand("radar", function()
    local Ped = PlayerPedId()
    if IsPedInAnyPoliceVehicle(Ped) and CheckPolice() and policeRadar then
        isDragging = not isDragging
        SetNuiFocus(isDragging, isDragging)
        SendNUIMessage({ action = "dragMode", state = isDragging })
    end
end)

RegisterNUICallback("closeDrag", function(data, cb)
    isDragging = false
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterKeyMapping("toggleRadar", "Ativar/Desativar radar das viaturas.", "keyboard", "N")
RegisterKeyMapping("toggleFreeze", "Travar/Destravar radar das viaturas.", "keyboard", "M")