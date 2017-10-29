local areas = {
-- Centro pokemons
	{from = {x = 1597, y = 1541, z = 7}, to = {x = 1610, y = 1553, z = 7}, priority = 0, name = 'CP - Saffron'},

	{from = {x = 1597, y = 1541, z = 6}, to = {x = 1610, y = 1553, z = 6}, priority = 0, name = 'CP - Saffron'},

	{from = {x = 1597, y = 1541, z = 6}, to = {x = 1610, y = 1553, z = 6}, priority = 0, name = 'CP - Duel'},

	{from = {x = 1653, y = 1695, z = 7}, to = {x = 1668, y = 1710, z = 7}, priority = 0, name = 'CP - Vermilion'},

	{from = {x = 1814, y = 1577, z = 7}, to = {x = 1830, y = 1592, z = 7}, priority = 0, name = 'CP - Lavander'},

	{from = {x = 1658, y = 1594, z = 4}, to = {x = 1679, y = 1616, z = 4}, priority = 0, name = 'CP - Secret'},

	{from = {x = 700, y = 1081, z = 7}, to = {x = 714, y = 1091, z = 7}, priority = 0, name = 'CP - Viridian'},
	{from = {x = 700, y = 1081, z = 6}, to = {x = 714, y = 1091, z = 6}, priority = 0, name = 'CP - Viridian'},

	{from = {x = 1065, y = 1230, z = 7}, to = {x = 1081, y = 1246, z = 7}, priority = 0, name = 'CP - Vermilion'},

	{from = {x = 712, y = 845, z = 7}, to = {x = 728, y = 853, z = 7}, priority = 0, name = 'CP - Pewter'},
	{from = {x = 728, y = 853, z = 7}, to = {x = 682, y = 1228, z = 7}, priority = 0, name = 'CP - Pallet'},
	{from = {x = 728, y = 853, z = 6}, to = {x = 682, y = 1228, z = 6}, priority = 0, name = 'CP - Pallet'},
	{from = {x = 843, y = 1394, z = 7}, to = {x = 857, y = 1407, z = 7}, priority = 0, name = 'CP - Cinnabar'},
	{from = {x = 1422, y = 1595, z = 6}, to = {x = 1438, y = 1604, z = 6}, priority = 0, name = 'CP - Frozzen'},
	{from = {x = 536, y = 668, z = 5}, to = {x = 545, y = 681, z = 5}, priority = 0, name = 'CP - White'},
	{from = {x = 536, y = 668, z = 4}, to = {x = 545, y = 681, z = 4}, priority = 0, name = 'CP - White'},
	{from = {x = 580, y = 409, z = 5}, to = {x = 594, y = 417, z = 7}, priority = 0, name = 'CP - Cherrygrove'},
	{from = {x = 1116, y = 535, z = 7}, to = {x = 1134, y = 545, z = 7}, priority = 0, name = 'CP - Azalea'},
	{from = {x = 1238, y = 294, z = 7}, to = {x = 1252, y = 303, z = 7}, priority = 0, name = 'CP - Violet'},
	{from = {x = 1131, y = 228, z = 5}, to = {x = 1148, y = 238, z = 6}, priority = 0, name = 'CP - Goldenrod'},



	}
local area = nil
local intervalo = 1
local duracao = 15
local retorno = 0
local eventAnimation = nil
local check = true
function isInRange(pos, fromPos, toPos)
    return
        pos.x>=fromPos.x and
        pos.y>=fromPos.y and
        pos.z>=fromPos.z and
        pos.x<=toPos.x and
        pos.y<=toPos.y and
        pos.z<=toPos.z
end

function init()
	placa = g_ui.displayUI('cityInfo', modules.game_interface.getRootPanel())
	placa:setVisible(false) 
	
	placaLabel = placa:getChildById('nome')
	
	connect(g_game, { onGameStart = updatePosition})
	connect(g_game, { onGameStart = AdjustSize})
	
	connect(LocalPlayer, {
		onPositionChange = updatePosition
	})
end
function AdjustSize()
	local top = (g_window.getHeight()/2) - 0
	placa:setMarginTop(-top)
end

function terminate()
	placa:destroy()

end

function updatePosition()
	local player = g_game.getLocalPlayer()
	if not player then
		return 
	end
	local pos = player:getPosition()
	if not pos then return end
	check = false
	local prioridade = nil
	for i = 1, #areas do
		if isInRange(pos, areas[i].from, areas[i].to) then
			if prioridade == nil then
				prioridade = areas[i].priority
				Table = areas[i]
			end
			
			if areas[i].priority > prioridade then
				Table = areas[i]
				prioridade = areas[i].priority
			end
			check = true
		end
	end
	if check == true then
		if Table.name == area then
			return false
		else
			reset()
			area = Table.name
			retorno = 1
			placaLabel:setText(area)
			placa:setVisible(true) 
			eventAnimation = cycleEvent(function() showPlaca(retorno) end, 200)
			check = true
		end
	else
		reset()	
	end
end

function reset()
	area = nil
	removeEvent(eventAnimation)
	removeEvent(placa.fadeEvent)
	g_effects.fadeOut(placa, 0) 
	placa:setVisible(false)	
end
function showPlaca()
	if retorno == 1 then
		g_effects.fadeIn(placa, 1500)
		retorno = 2
		removeEvent(eventAnimation)
		eventAnimation = cycleEvent(function() showPlaca(retorno) end, 4000)
		return
	elseif retorno == 2 then
		g_effects.fadeOut(placa, 1500)
		retorno = 0
		removeEvent(eventAnimation)
	end
end
