-- 255*math.sin( CurTime()*3 )

local hideHUDElements = {
    ["DarkRP_HUD"] = true,
    ["DarkRP_PlayerInfo"] = true,
    ["DarkRP_EntityDisplay"] = true,
    ["DarkRP_LocalPlayerHUD"] = true,
    ["DarkRP_Hungermod"] = true,
    ["DarkRP_Agenda"] = true,
    ["DarkRP_LockdownHUD"] = true,
    ["DarkRP_ArrestedHUD"] = true,
    ["DarkRP_ChatReceivers"] = true,
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudSuitPower"] = true,
    ["CHudDeathNotice"] = true,
    ["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true,
}

hook.Add("HUDShouldDraw", "hideElements", function(name)
    if hideHUDElements[name] then return false end
end)

surface.CreateFont( "linksMain", {font = "Montserrat Medium", size = 20, weight = 100, extended = true})

local width = ScrW()
local height = ScrH()

local start, oldhp, newhp = 0, -1, -1
local animationTime = 0.3

local start2, oldarm, newarm = 0, -1, -1

hook.Add('HUDPaint', 'links_HUD', function()
    CreateHUD()
end)

local function CreateModelHead()
    model = vgui.Create("DModelPanel")
    function model:LayoutEntity( Entity ) return end
end
hook.Add( 'InitPostEntity', 'links_HUDModel', CreateModelHead )

function CreateHUD()
    local ply = LocalPlayer()

    draw.RoundedBox( 5, width / 50 - 20, height - 170, width / 5 + 20, height / 7, Color(30, 30, 30) ) -- MAIN
    draw.RoundedBox( 5, width / 50 - 12, height - 163, width / 13 + 2, height / 8 + 5, Color(39,39,39) )
    draw.RoundedBox( 0, width / 11 + 10, height - 170, width / 750, height / 7, Color(39,39,39) )
    draw.RoundedBox( 0, width / 10 - 6, height - 48, width / 9 + 23, height / 450, Color(39,39,39) )
    draw.RoundedBox( 0, width / 10 - 6, height - 94, width / 9 + 23, height / 450, Color(39,39,39) )
    draw.DrawText( DarkRP.formatMoney(ply:getDarkRPVar("money")), "linksMain", width / 10 + 2, height - 42, Color(60, 220, 60), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    draw.SimpleText( ply:Nick(), "linksMain", width / 10 + 2, height - 70, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    draw.RoundedBox( 4, width / 10, height - 163, width / 9 + 10, height / 39, Color(21,21,21) ) -- HEALTH BACK
    draw.RoundedBox( 4, width / 10, height - 128, width / 9 + 10, height / 39, Color(21,21,21) ) -- ARMOR BACK
    

    if ( !IsValid( ply ) ) then return end

	local hp = ply:Health()
	local maxhp = ply:GetMaxHealth()

	if ( oldhp == -1 and newhp == -1 ) then
		oldhp = hp
		newhp = hp
	end

    local smoothHP = Lerp( ( SysTime() - start ) / animationTime, oldhp, newhp )
    
    if smoothHP > maxhp then smoothHP = 100 end
	if newhp ~= hp then
		if ( smoothHP ~= hp ) then
			newhp = smoothHP
		end

		oldhp = newhp
		start = SysTime()
		newhp = hp
	end

	draw.RoundedBox( 4, width / 10, height - 163, math.max( 0, smoothHP ) * 2.232, height / 39, Color(220, 60, 60, 255) )

    if ( !IsValid( ply ) ) then return end

	local arm = ply:Armor()
	local maxarmor = ply:GetMaxArmor()

	if ( oldarm == -1 and newarm == -1 ) then
		oldarm = arm
		newarm = arm
	end

    local smoothARM = Lerp( ( SysTime() - start2 ) / animationTime, oldarm, newarm )

    if smoothARM > maxarmor then smoothARM = 100 end
	if newarm ~= arm then
		if ( smoothARM ~= arm ) then
			newarm = smoothARM
		end

		oldarm = newarm
		start2 = SysTime()
		newarm = arm
	end

	draw.RoundedBox( 4, width / 10, height - 128, math.max( 0, smoothARM ) * 2.23, height / 39, Color(65, 135, 245, 255) )
    draw.SimpleText( hp, "linksMain", width / 6 - 17, height - 150, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    draw.SimpleText( arm, "linksMain", width / 6 - 17, height - 115, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

    -- AMMO HUD

    draw.RoundedBox( 5, width - 211, height - 76, width / 10, height / 18, Color(30, 30, 30) )
    draw.RoundedBox( 0, width - 190, height - 47, width / 13 + 3, height / 450, Color(39,39,39) )

    if (ply:GetActiveWeapon() != nil) and (ply:Health() > 0) then
        local Weapon = ply:GetActiveWeapon()
        local WeaponName = Weapon:GetPrintName()
        local curAmmo = Weapon:Clip1()
        local maxAmmo = ply:GetAmmoCount(Weapon:GetPrimaryAmmoType())

        if Weapon and (Weapon:Clip1() != -1) then
            draw.DrawText( WeaponName, "linksMain", width - 115, height - 72, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            draw.SimpleText( curAmmo .. " | " .. maxAmmo, "linksMain", width - 115, height - 33, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        else
            draw.DrawText( WeaponName, "linksMain", width - 115, height - 72, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            draw.DrawText( "∞", "linksMain", width - 115, height - 43, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
    end

    local nd = 0
    local nti = 360 / 15
    local noi = 15
    local ComPos = 125  
    local size = ScrW() / 5   
   
    if IsValid(ply) then
        local dir = EyeAngles().y - nd

        for i=0, nti - 1 do
            local ang = i * 15
            local dif = math.AngleDifference(ang, dir)
            local numofinst = noi           
            local offang = ( numofinst*12 )/1.7			
            if math.abs(dif) < offang then
                local alpha = math.Clamp( 2-(math.abs(dif)/(offang)) , 0, 1 ) * 255                          
                local dif2 = size / noi              
                local pos = dif/10 * dif2              
                local text = tostring(360 - ang)              
                local font = "linksMain"
				local directionfont = "linksMain"
               
                local clr = Color(225,225,225,255)
				local drt = Color(225,225,225,255)
				
                if ang == 0 then
                    direction = "N"
					text = "0"
                    font = "linksMain"
                    clr = Color(225,225,225,alpha)
					surface.SetDrawColor( 225,225,225, alpha ) 
					surface.DrawRect( ScrW()/2 - 9.5 - pos, ComPos - 95, 20, 1 )
                elseif ang == 180 then
                    direction = "S"
                    font = "linksMain"
                    clr = Color(225,225,225,alpha)
					surface.SetDrawColor( clr ) 
					surface.DrawRect( ScrW()/2 - 9.5 - pos, ComPos - 95, 20, 1 )
                elseif ang == 90 then
                    direction = "W"
                    font = "linksMain"
                    clr = Color(225,225,225,alpha)
					surface.SetDrawColor( clr ) 
					surface.DrawRect( ScrW()/2 - 9.5 - pos, ComPos - 95, 20, 1 )					
                elseif ang == 270 then
                    direction = "E"
                    font = "linksMain"
                    clr = Color(225,225,225,alpha)
					surface.SetDrawColor( clr ) 
					surface.DrawRect( ScrW()/2 - 9.5 - pos, ComPos - 95, 20, 1 )
                elseif ang == 45 then
                    direction = "NW"
                    font = "linksMain"
                    clr = Color(225,225,225,alpha)
					surface.SetDrawColor( clr ) 
					surface.DrawRect( ScrW()/2 - 9.5 - pos, ComPos - 95, 20, 1 )
                elseif ang == 135 then
                    direction = "SW"
                    font = "linksMain"
                    clr = Color(225,225,225,alpha)
					surface.SetDrawColor( clr ) 
					surface.DrawRect( ScrW()/2 - 9.5 - pos, ComPos - 95, 20, 1 )
                elseif ang == 225 then
                    direction = "SE"
                    font = "linksMain"
                    clr = Color(225,225,225,alpha)
					surface.SetDrawColor( clr ) 
					surface.DrawRect( ScrW()/2 - 9.5 - pos, ComPos - 95, 20, 1 )
                elseif ang == 315 then
                    direction = "NE"
                    font = "linksMain"
                    clr = Color(225,225,225,alpha)
					surface.SetDrawColor( clr ) 
					surface.DrawRect( ScrW()/2 - 9.5 - pos, ComPos - 95, 20, 1 )
                elseif ang == 15 then
					direction = ""
					surface.SetDrawColor( clr ) 
					surface.DrawRect( ScrW()/2 - 9.5 - pos, ComPos - 90, 20, 1 )
				elseif ang == 30 then
					direction = ""
					surface.SetDrawColor( clr ) 
					surface.DrawRect( ScrW()/2 - 9.5 - pos, ComPos - 90, 20, 1 )
                elseif ang == 60 then
					direction = ""
					surface.SetDrawColor( clr ) 
					surface.DrawRect( ScrW()/2 - 9.5 - pos, ComPos - 90, 20, 1 )
				elseif ang == 75 then
					direction = ""
					surface.SetDrawColor( clr ) 
					surface.DrawRect( ScrW()/2 - 9.5 - pos, ComPos - 90, 20, 1 )
                elseif ang == 105 then
					direction = ""
					surface.SetDrawColor( clr ) 
					surface.DrawRect( ScrW()/2 - 9.5 - pos, ComPos - 90, 20, 1 )
                elseif ang == 120 then
					direction = ""	
					surface.SetDrawColor( clr ) 
					surface.DrawRect( ScrW()/2 - 9.5 - pos, ComPos - 90, 20, 1 )
				elseif ang == 150 then
					direction = ""
					surface.SetDrawColor( clr ) 
					surface.DrawRect( ScrW()/2 - 9.5 - pos, ComPos - 90, 20, 1 )
                elseif ang == 165 then
					direction = ""
					surface.SetDrawColor( clr ) 
					surface.DrawRect( ScrW()/2 - 9.5 - pos, ComPos - 90, 20, 1 )
                elseif ang == 195 then
					direction = ""
					surface.SetDrawColor( clr ) 
					surface.DrawRect( ScrW()/2 - 9.5 - pos, ComPos - 90, 20, 1 )
                elseif ang == 210 then
					direction = ""	
					surface.SetDrawColor( clr ) 
					surface.DrawRect( ScrW()/2 - 9.5 - pos, ComPos - 90, 20, 1 )
				elseif ang == 240 then
					direction = ""
					surface.SetDrawColor( clr ) 
					surface.DrawRect( ScrW()/2 - 9.5 - pos, ComPos - 90, 20, 1 )
                elseif ang == 255 then
					direction = ""
					surface.SetDrawColor( clr ) 
					surface.DrawRect( ScrW()/2 - 9.5 - pos, ComPos - 90, 20, 1 )
                elseif ang == 285 then
					direction = ""
					surface.SetDrawColor( clr ) 
					surface.DrawRect( ScrW()/2 - 9.5 - pos, ComPos - 90, 20, 1 )
                elseif ang == 300 then
					direction = ""
					surface.SetDrawColor( clr ) 
					surface.DrawRect( ScrW()/2 - 9.5 - pos, ComPos - 90, 20, 1 )
                elseif ang == 330 then
					direction = ""
					surface.SetDrawColor( clr ) 
					surface.DrawRect( ScrW()/2 - 9.5 - pos, ComPos - 90, 20, 1 )
                elseif ang == 345 then
					direction = ""											
					surface.SetDrawColor( clr ) 
					surface.DrawRect( ScrW()/2 - 9.5 - pos, ComPos - 90, 20, 1 )
                end
               
                draw.DrawText( text, font, ScrW() / 2 - pos, ComPos - 85, clr, TEXT_ALIGN_CENTER )
                draw.DrawText( direction, directionfont, ScrW()/2 - pos, ComPos - 115, drt, TEXT_ALIGN_CENTER )     
                draw.DrawText( "▲", "linksMain", ScrW() /2 , 55, Color(255,255,255,255), TEXT_ALIGN_CENTER )     
            end          
        end  
    end

    model:SetModel(ply:GetModel())
    model:SetSize( width / 16, height / 9 )
    model:SetPos( width / 45, height - 143)
    model:SetCamPos( Vector( 15, -5, 65 ) )
    model:SetLookAt( Vector( 0, 0, 65 ) )
    model:SetAnimated( true )
end