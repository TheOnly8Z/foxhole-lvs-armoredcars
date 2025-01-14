ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "T3 Xiphos"
ENT.Author = "Kalamari"
ENT.Information = "Kalamari's Foxhole Vehicles"
ENT.Category = "[LVS] - Cars"

ENT.VehicleCategory = "Tanks"
ENT.VehicleSubCategory = "Foxhole"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/car_xiphos.mdl"

ENT.GibModels = {
	"models/wheel_xiphos.mdl",
	"models/wheel_xiphos.mdl",
	"models/wheel_xiphos.mdl",
	"models/wheel_xiphos.mdl",
}

ENT.AITEAM = 2

ENT.MaxHealth = 1000

ENT.SpawnNormalOffset = 40

ENT.AITEAM = 2

//damage system
ENT.DSArmorIgnoreForce = 1200
ENT.CannonArmorPenetration = 3900

ENT.MaxVelocity = 433
ENT.MaxVelocityReverse = 450

ENT.EngineCurve = 0.2
ENT.EngineTorque = 350

ENT.TransGears = 5
ENT.TransGearsReverse = 5

ENT.FastSteerAngleClamp = 15
ENT.FastSteerDeactivationDriftAngle = 12

ENT.PhysicsWeightScale = 1.5
ENT.PhysicsDampingForward = true
ENT.PhysicsDampingReverse = true

ENT.lvsShowInSpawner = true

ENT.WheelBrakeAutoLockup = true
ENT.WheelBrakeLockupRPM = 15

ENT.EngineSounds = {
	{
		sound = "vehicles/ACIdle.wav",
		Volume = 0.66,
		Pitch = 100,
		PitchMul = 25,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "vehicles/ACDrive.wav",
		Volume = 1.33,
		Pitch = 100,
		PitchMul = 100,
		SoundLevel = 75,
		UseDoppler = true,
	},
}

ENT.Lights = {
	{
		Trigger = "main",
		SubMaterialID = 1,
		Sprites = {
			[1] = {
				pos = Vector(79.6,34.6,59.4),
				colorB = 200,
				colorA = 150,
			},
			[2] = {
				pos = Vector(79.6,-34.6,59.4),
				colorB = 200,
				colorA = 150,
			},
		},
		ProjectedTextures = {
			[1] = {
				pos = Vector(79.6,34.6,59.4),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
			[2] = {
				pos = Vector(79.6,-34.6,59.4),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
		},
	},
}

function ENT:OnSetupDataTables()
	self:AddDT( "Entity", "GunnerSeat" )
end

function ENT:InitWeapons()
	local COLOR_WHITE = Color(255,255,255,255)

	//MACHINEGUN
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/mg.png")
	weapon.Ammo = 500
	weapon.Delay = 0.1
	weapon.HeatRateUp = 0.15
	weapon.HeatRateDown = 0.2
	weapon.Attack = function( ent )
		//Machinegun 1
		local ID = ent:LookupAttachment( "muzzle_mg1" )

		local Muzzle = ent:GetAttachment( ID )

		if not Muzzle then return end

		local bullet = {}
		bullet.Src 	= Muzzle.Pos
		bullet.Dir 	= -Muzzle.Ang:Forward()
		bullet.Spread 	= Vector(0.015,0.015,0.015)
		bullet.TracerName = "lvs_tracer_yellow_small"
		bullet.Force	= 10
		bullet.HullSize = 0
		bullet.Damage	= 12
		bullet.Velocity = 30000
		bullet.Attacker = ent:GetDriver()
		ent:LVSFireBullet( bullet )

		local effectdata = EffectData()
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( bullet.Dir )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle", effectdata )

		local PhysObj = ent:GetPhysicsObject()
		if IsValid( PhysObj ) then
			PhysObj:ApplyForceOffset( -bullet.Dir * 10000, bullet.Src )
		end

		//Machinegun 2
		local ID2 = ent:LookupAttachment( "muzzle_mg2" )

		local Muzzle2 = ent:GetAttachment( ID2 )

		if not Muzzle2 then return end

		local bullet2 = {}
		bullet2.Src 	= Muzzle2.Pos
		bullet2.Dir 	= -Muzzle2.Ang:Forward()
		bullet2.Spread 	= Vector(0.015,0.015,0.015)
		bullet2.TracerName = "lvs_tracer_yellow_small"
		bullet2.Force	= 10
		bullet2.HullSize = 0
		bullet2.Damage	= 12
		bullet2.Velocity = 30000
		bullet2.Attacker = ent:GetDriver()
		ent:LVSFireBullet( bullet2 )

		local effectdata2 = EffectData()
		effectdata:SetOrigin( bullet2.Src )
		effectdata:SetNormal( bullet2.Dir )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle", effectdata2 )

		ent:TakeAmmo( 1 )
	end
	weapon.StartAttack = function( ent )
		if not IsValid( ent.SNDTurretMG ) then return end
		ent.SNDTurretMG:Play()
	end
	weapon.FinishAttack = function( ent )
		if not IsValid( ent.SNDTurretMG ) then return end
		ent.SNDTurretMG:Stop()
	end
	weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/overheat.wav") end
	weapon.HudPaint = function( ent, X, Y, ply )
		local ID = ent:LookupAttachment( "muzzle_mg1" )

		local Muzzle = ent:GetAttachment( ID )

		if Muzzle then
			local traceTurret = util.TraceLine( {
				start = Muzzle.Pos, 
				endpos = Muzzle.Pos + -Muzzle.Ang:Forward() * 50000,
				filter = ent:GetCrosshairFilterEnts()
			} )

			local MuzzlePos2D = traceTurret.HitPos:ToScreen() 

			ent:PaintCrosshairCenter( MuzzlePos2D, COLOR_WHITE )
			ent:LVSPaintHitMarker( MuzzlePos2D )
		end
	end
	weapon.OnOverheat = function( ent )
		ent:EmitSound("lvs/overheat.wav")
	end
	self:AddWeapon( weapon, 1 )

	//NOTHING
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/tank_noturret.png")
	weapon.Ammo = -1
	weapon.Delay = 0
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0
	weapon.OnSelect = function( ent )
		if ent.SetTurretEnabled then
			ent:SetTurretEnabled( false )
		end
	end
	weapon.OnDeselect = function( ent )
		if ent.SetTurretEnabled then
			ent:SetTurretEnabled( true )
		end
	end
	self:AddWeapon( weapon, 1 )
end


ENT.ExhaustPositions = {
	{
		pos = Vector(-107,6,56),
		ang = Angle(0,180,0),
	},
}