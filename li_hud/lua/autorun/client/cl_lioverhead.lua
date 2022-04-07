local function DrawOverhead(ply)

	local dist = LocalPlayer():GetPos():Distance(ply:GetPos())
	
	if dist > 200 then return end
	
	local ang = Angle(0, LocalPlayer():EyeAngles().y-90, 90)
	
	local angle = ply:GetAngles()	
	
	local position = ply:EyePos() + angle:Up() * 12

    local health = ply:Health()
    local armor = ply:Armor()

    local playerTeam = ply:Team()
    local job = team.GetName(playerTeam)
	local jobColor = team.GetColor(playerTeam)
    local nick = ply:Nick()

    surface.SetFont("liMain")
	local nickX, nikcY = surface.GetTextSize(nick)
    local jobX, nickY = surface.GetTextSize(job)
    local w1 = nickX + 10
    local w2 = nickX - 50
    local w3 = jobX + 10

    local heart = Material( "XenithHealth.png" )
    local helmet = Material( "XenithClone.png" )
    local gun = Material( "XenithGun.png" )

	angle:RotateAroundAxis(angle:Forward(), 0)
	angle:RotateAroundAxis(angle:Right(), 0)
	angle:RotateAroundAxis(angle:Up(), 90)

	cam.Start3D2D(position, ang, 0.1)

    draw.RoundedBox( 5, -110, -20, 200, 50, Color(30, 30, 30, 255) )

    draw.RoundedBox( 5, -110, -47, w1, 25, Color(30, 30, 30, 255) )

    if health <= 30 then
		surface.SetDrawColor(255 * math.sin( CurTime()*5 ), 0, 0, 255)
		surface.SetMaterial( heart )
		surface.DrawTexturedRect( -107, 5, 35, 25 )

    else

        surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial( heart )
		surface.DrawTexturedRect( -107, 5, 35, 25 )

    end



    if health >= 5000 then

        draw.SimpleText( "5000+", "liMain", -70, 17, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

         else

        draw.SimpleText( health, "liMain", -70, 17, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

    end


    -- surface.SetDrawColor(255, 255, 255, 255)
    -- surface.SetMaterial( helmet )
    -- surface.DrawTexturedRect( -107, -30, 20, 20 )

    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial( gun )
    surface.DrawTexturedRect( -101, -16, 25, 20 )

    
    draw.SimpleText( job, "liMain", -70, -6, jobColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

    draw.SimpleText( nick, "liMain", -11, -35, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

				
	cam.End3D2D()
end

hook.Add("PostDrawOpaqueRenderables", "XenithOverhead", function ()
	for _, ply in pairs(player.GetAll()) do
		if not IsValid(ply) or ply == LocalPlayer() or not ply:Alive() or ply:GetNoDraw() or ply:IsDormant() then continue end

		DrawOverhead(ply)
	end
end)
