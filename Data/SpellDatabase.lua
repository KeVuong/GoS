--Outdated

class "spellDataBase"

function spellDataBase:__init()
	self.Database = {
			["Aatrox"] = {

				["AatroxQ"] = {

					["SpellName"] = "AatroxQ",
					["Slot"] = "Q",
					["Type"] = 'Circular',
					["Delay"] = 600,
					["Range"] = 650,
					["Radius"] = 250,
					["MissileSpeed"] = 2000,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "",
				},

				["AatroxE"] = {

					["SpellName"] = "AatroxE",
					["Slot"] = "E",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1075,
					["Radius"] = 35,
					["MissileSpeed"] = 1250,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = false,
					["MissileSpellName"] = "AatroxEConeMissile",
				},

			},

			["Ahri"] = {

				["AhriOrbofDeception"] = {

					["SpellName"] = "AhriOrbofDeception",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1000,
					["Radius"] = 100,
					["MissileSpeed"] = 2500,
					["MissileAccel"] = -3200,
					["MissileMaxSpeed"] = 2500,
					["MissileMinSpeed"] = 400,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "AhriOrbMissile",
					["CanBeRemoved"] = true,
					["ForceRemove"] = true,
				},

				["AhriOrbReturn"] = {

					["SpellName"] = "AhriOrbReturn",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1000,
					["Radius"] = 100,
					["MissileSpeed"] = 60,
					["MissileAccel"] = 1900,
					["MissileMinSpeed"] = 60,
					["MissileMaxSpeed"] = 2600,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileFollowsUnit"] = true,
					["CanBeRemoved"] = true,
					["ForceRemove"] = true,
					["MissileSpellName"] = "AhriOrbReturn",
				},

				["AhriSeduce"] = {

					["SpellName"] = "AhriSeduce",
					["Slot"] = "E",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1000,
					["Radius"] = 60,
					["MissileSpeed"] = 1550,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "AhriSeduceMissile",
					["CanBeRemoved"] = true,
				},

			},

			["Amumu"] = {

				["BandageToss"] = {

					["SpellName"] = "BandageToss",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1100,
					["Radius"] = 90,
					["MissileSpeed"] = 2000,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "SadMummyBandageToss",
					["CanBeRemoved"] = true,
				},

				["CurseoftheSadMummy"] = {

					["SpellName"] = "CurseoftheSadMummy",
					["Slot"] = "R",
					["Type"] = 'Circular',
					["Delay"] = 250,
					["Range"] = 0,
					["Radius"] = 550,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = true,
					["AddHitbox"] = false,
					["DangerValue"] = 5,
					["IsDangerous"] = true,
					["MissileSpellName"] = "",
				},

			},

			["Anivia"] = {

				["FlashFrost"] = {

					["SpellName"] = "FlashFrost",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1100,
					["Radius"] = 110,
					["MissileSpeed"] = 850,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "FlashFrostSpell",
					["CanBeRemoved"] = true,
				},

			},

			["Annie"] = {

				["Incinerate"] = {

					["SpellName"] = "Incinerate",
					["Slot"] = "W",
					["Type"] = 'Cone',
					["Delay"] = 250,
					["Range"] = 825,
					["Radius"] = 80,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = false,
					["AddHitbox"] = false,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "",
				},

				["InfernalGuardian"] = {

					["SpellName"] = "InfernalGuardian",
					["Slot"] = "R",
					["Type"] = 'Circular',
					["Delay"] = 250,
					["Range"] = 600,
					["Radius"] = 251,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 5,
					["IsDangerous"] = true,
					["MissileSpellName"] = "",
				},

			},

			["Ashe"] = {

				["Volley"] = {

					["SpellName"] = "Volley",
					["Slot"] = "W",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1250,
					["Radius"] = 60,
					["MissileSpeed"] = 1500,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "VolleyAttack",
					["MultipleNumber"] = 9,
					["MultipleAngle"] = 4.62 * math.pi / 180,
					["CanBeRemoved"] = true,
				},

				["EnchantedCrystalArrow"] = {

					["SpellName"] = "EnchantedCrystalArrow",
					["Slot"] = "R",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 20000,
					["Radius"] = 130,
					["MissileSpeed"] = 1600,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 5,
					["IsDangerous"] = true,
					["MissileSpellName"] = "EnchantedCrystalArrow",
					["CanBeRemoved"] = true,
				},

			},

			["Bard"] = {

				["BardQ"] = {

					["SpellName"] = "BardQ",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 950,
					["Radius"] = 60,
					["MissileSpeed"] = 1600,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "BardQMissile",
					["CanBeRemoved"] = true,
				},

				["BardR"] = {

					["SpellName"] = "BardR",
					["Slot"] = "R",
					["Type"] = 'Circular',
					["Delay"] = 500,
					["Range"] = 3400,
					["Radius"] = 350,
					["MissileSpeed"] = 2100,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "BardR",
				},

			},

			["Blatzcrink"] = {

				["RocketGrab"] = {

					["SpellName"] = "RocketGrab",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1050,
					["Radius"] = 70,
					["MissileSpeed"] = 1800,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 4,
					["IsDangerous"] = true,
					["MissileSpellName"] = "RocketGrabMissile",
					["CanBeRemoved"] = true,
				},

				["StaticField"] = {

					["SpellName"] = "StaticField",
					["Slot"] = "R",
					["Type"] = 'Circular',
					["Delay"] = 250,
					["Range"] = 0,
					["Radius"] = 600,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = true,
					["AddHitbox"] = false,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "",
				},

			},

			["Brand"] = {

				["BrandBlaze"] = {

					["SpellName"] = "BrandBlaze",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1100,
					["Radius"] = 60,
					["MissileSpeed"] = 1600,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "BrandBlazeMissile",
					["CanBeRemoved"] = true,
				},

				["BrandFissure"] = {

					["SpellName"] = "BrandFissure",
					["Slot"] = "W",
					["Type"] = 'Circular',
					["Delay"] = 850,
					["Range"] = 900,
					["Radius"] = 240,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "",
				},

			},

			["Braum"] = {

				["BraumQ"] = {

					["SpellName"] = "BraumQ",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1050,
					["Radius"] = 60,
					["MissileSpeed"] = 1700,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "BraumQMissile",
					["CanBeRemoved"] = true,
				},

				["BraumRWrapper"] = {

					["SpellName"] = "BraumRWrapper",
					["Slot"] = "R",
					["Type"] = 'Line',
					["Delay"] = 500,
					["Range"] = 1200,
					["Radius"] = 115,
					["MissileSpeed"] = 1400,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 4,
					["IsDangerous"] = true,
					["MissileSpellName"] = "braumrmissile",
				},

			},

			["Caitlyn"] = {

				["CaitlynPiltoverPeacemaker"] = {

					["SpellName"] = "CaitlynPiltoverPeacemaker",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 625,
					["Range"] = 1300,
					["Radius"] = 90,
					["MissileSpeed"] = 2200,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "CaitlynPiltoverPeacemaker",
				},

				["CaitlynEntrapment"] = {

					["SpellName"] = "CaitlynEntrapment",
					["Slot"] = "E",
					["Type"] = 'Line',
					["Delay"] = 125,
					["Range"] = 1000,
					["Radius"] = 80,
					["MissileSpeed"] = 2000,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 1,
					["IsDangerous"] = false,
					["MissileSpellName"] = "CaitlynEntrapmentMissile",
					["CanBeRemoved"] = true,
				},

			},

			["Cassiopeia"] = {

				["CassiopeiaNoxiousBlast"] = {

					["SpellName"] = "CassiopeiaNoxiousBlast",
					["Slot"] = "Q",
					["Type"] = 'Circular',
					["Delay"] = 750,
					["Range"] = 850,
					["Radius"] = 150,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "CassiopeiaNoxiousBlast",
				},

				["CassiopeiaPetrifyingGaze"] = {

					["SpellName"] = "CassiopeiaPetrifyingGaze",
					["Slot"] = "R",
					["Type"] = 'Cone',
					["Delay"] = 600,
					["Range"] = 825,
					["Radius"] = 80,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = false,
					["AddHitbox"] = false,
					["DangerValue"] = 5,
					["IsDangerous"] = true,
					["MissileSpellName"] = "CassiopeiaPetrifyingGaze",
				},

			},

			["Chogath"] = {

				["Rupture"] = {

					["SpellName"] = "Rupture",
					["Slot"] = "Q",
					["Type"] = 'Circular',
					["Delay"] = 1200,
					["Range"] = 950,
					["Radius"] = 250,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = false,
					["MissileSpellName"] = "Rupture",
				},

			},

			["Corki"] = {

				["PhosphorusBomb"] = {

					["SpellName"] = "PhosphorusBomb",
					["Slot"] = "Q",
					["Type"] = 'Circular',
					["Delay"] = 300,
					["Range"] = 825,
					["Radius"] = 250,
					["MissileSpeed"] = 1000,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "PhosphorusBombMissile",
				},

				["MissileBarrage"] = {

					["SpellName"] = "MissileBarrage",
					["Slot"] = "R",
					["Type"] = 'Line',
					["Delay"] = 200,
					["Range"] = 1300,
					["Radius"] = 40,
					["MissileSpeed"] = 2000,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "MissileBarrageMissile",
					["CanBeRemoved"] = true,
				},

				["MissileBarrage2"] = {

					["SpellName"] = "MissileBarrage2",
					["Slot"] = "R",
					["Type"] = 'Line',
					["Delay"] = 200,
					["Range"] = 1500,
					["Radius"] = 40,
					["MissileSpeed"] = 2000,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "MissileBarrageMissile2",
					["CanBeRemoved"] = true,
				},

			},

			["Darius"] = {

				["DariusCleave"] = {

					["SpellName"] = "DariusCleave",
					["Slot"] = "Q",
					["Type"] = 'Circular',
					["Delay"] = 750,
					["Range"] = 0,
					["Radius"] = 425,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = false,
					["MissileSpellName"] = "DariusCleave",
					["FollowCaster"] = true,
					["DisabledByDefault"] = true,
				},

				["DariusAxeGrabCone"] = {

					["SpellName"] = "DariusAxeGrabCone",
					["Slot"] = "E",
					["Type"] = 'Cone',
					["Delay"] = 250,
					["Range"] = 550,
					["Radius"] = 80,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = true,
					["AddHitbox"] = false,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "DariusAxeGrabCone",
				},

			},

			["Diana"] = {

				["DianaArc"] = {

					["SpellName"] = "DianaArc",
					["Slot"] = "Q",
					["Type"] = 'Circular',
					["Delay"] = 250,
					["Range"] = 895,
					["Radius"] = 195,
					["MissileSpeed"] = 1400,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "DianaArcArc",
				},

				["DianaArcArc"] = {

					["SpellName"] = "DianaArcArc",
					["Slot"] = "Q",
					["Type"] = 'Arc',
					["Delay"] = 250,
					["Range"] = 895,
					["Radius"] = 195,
					["DontCross"] = true,
					["MissileSpeed"] = 1400,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "DianaArcArc",
					["TakeClosestPath"] = true,
				},

			},

			["DrMundo"] = {

				["InfectedCleaverMissileCast"] = {

					["SpellName"] = "InfectedCleaverMissileCast",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1050,
					["Radius"] = 60,
					["MissileSpeed"] = 2000,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = false,
					["MissileSpellName"] = "InfectedCleaverMissile",
					["CanBeRemoved"] = true,
				},

			},

			["Draven"] = {

				["DravenDoubleShot"] = {

					["SpellName"] = "DravenDoubleShot",
					["Slot"] = "E",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1100,
					["Radius"] = 130,
					["MissileSpeed"] = 1400,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "DravenDoubleShotMissile",
					["CanBeRemoved"] = true,
				},

				["DravenRCast"] = {

					["SpellName"] = "DravenRCast",
					["Slot"] = "R",
					["Type"] = 'Line',
					["Delay"] = 400,
					["Range"] = 20000,
					["Radius"] = 160,
					["MissileSpeed"] = 2000,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 5,
					["IsDangerous"] = true,
					["MissileSpellName"] = "DravenR",
				},

			},

			["Ekko"] = {

				["EkkoQ"] = {

					["SpellName"] = "EkkoQ",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 950,
					["Radius"] = 60,
					["MissileSpeed"] = 1650,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 4,
					["IsDangerous"] = true,
					["MissileSpellName"] = "ekkoqmis",
					["CanBeRemoved"] = true,
				},

				["EkkoW"] = {

					["SpellName"] = "EkkoW",
					["Slot"] = "W",
					["Type"] = 'Circular',
					["Delay"] = 3750,
					["Range"] = 1600,
					["Radius"] = 375,
					["MissileSpeed"] = 1650,
					["FixedRange"] = false,
					["DisabledByDefault"] = true,
					["AddHitbox"] = false,
					["DangerValue"] = 3,
					["IsDangerous"] = false,
					["MissileSpellName"] = "EkkoW",
					["CanBeRemoved"] = true,
				},

				["EkkoR"] = {

					["SpellName"] = "EkkoR",
					["Slot"] = "R",
					["Type"] = 'Circular',
					["Delay"] = 250,
					["Range"] = 1600,
					["Radius"] = 375,
					["MissileSpeed"] = 1650,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = false,
					["MissileSpellName"] = "EkkoR",
					["CanBeRemoved"] = true,
				},

			},

			["Elise"] = {

				["EliseHumanE"] = {

					["SpellName"] = "EliseHumanE",
					["Slot"] = "E",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1100,
					["Radius"] = 55,
					["MissileSpeed"] = 1600,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 4,
					["IsDangerous"] = true,
					["MissileSpellName"] = "EliseHumanE",
					["CanBeRemoved"] = true,
				},

			},

			["Evelynn"] = {

				["EvelynnR"] = {

					["SpellName"] = "EvelynnR",
					["Slot"] = "R",
					["Type"] = 'Circular',
					["Delay"] = 250,
					["Range"] = 650,
					["Radius"] = 350,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 5,
					["IsDangerous"] = true,
					["MissileSpellName"] = "EvelynnR",
				},

			},

			["Ezreal"] = {

				["EzrealMysticShot"] = {

					["SpellName"] = "EzrealMysticShot",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1200,
					["Radius"] = 60,
					["MissileSpeed"] = 2000,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "EzrealMysticShotMissile",
					["CanBeRemoved"] = true,
					["Id"] = 229,
				},

				["EzrealEssenceFlux"] = {

					["SpellName"] = "EzrealEssenceFlux",
					["Slot"] = "W",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1050,
					["Radius"] = 80,
					["MissileSpeed"] = 1600,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "EzrealEssenceFluxMissile",
				},

				["EzrealTrueshotBarrage"] = {

					["SpellName"] = "EzrealTrueshotBarrage",
					["Slot"] = "R",
					["Type"] = 'Line',
					["Delay"] = 1000,
					["Range"] = 20000,
					["Radius"] = 160,
					["MissileSpeed"] = 2000,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "EzrealTrueshotBarrage",
					["Id"] = 245,
				},

			},

			["Fiora"] = {

				["FioraW"] = {

					["SpellName"] = "FioraW",
					["Slot"] = "W",
					["Type"] = 'Line',
					["Delay"] = 700,
					["Range"] = 800,
					["Radius"] = 70,
					["MissileSpeed"] = 3200,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "FioraWMissile",
				},

			},

			["Fizz"] = {

				["FizzMarinerDoom"] = {

					["SpellName"] = "FizzMarinerDoom",
					["Slot"] = "R",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1300,
					["Radius"] = 120,
					["MissileSpeed"] = 1350,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 5,
					["IsDangerous"] = true,
					["MissileSpellName"] = "FizzMarinerDoomMissile",
					["CanBeRemoved"] = true,
				},

			},

			["Galio"] = {

				["GalioResoluteSmite"] = {

					["SpellName"] = "GalioResoluteSmite",
					["Slot"] = "Q",
					["Type"] = 'Circular',
					["Delay"] = 250,
					["Range"] = 900,
					["Radius"] = 200,
					["MissileSpeed"] = 1300,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "GalioResoluteSmite",
				},

				["GalioRighteousGust"] = {

					["SpellName"] = "GalioRighteousGust",
					["Slot"] = "E",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1200,
					["Radius"] = 120,
					["MissileSpeed"] = 1200,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "GalioRighteousGust",
				},

				["GalioIdolOfDurand"] = {

					["SpellName"] = "GalioIdolOfDurand",
					["Slot"] = "R",
					["Type"] = 'Circular',
					["Delay"] = 250,
					["Range"] = 0,
					["Radius"] = 550,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = true,
					["AddHitbox"] = false,
					["DangerValue"] = 5,
					["IsDangerous"] = true,
					["MissileSpellName"] = "",
				},

			},

			["Gnar"] = {

				["GnarQ"] = {

					["SpellName"] = "GnarQ",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1125,
					["Radius"] = 60,
					["MissileSpeed"] = 2500,
					["MissileAccel"] = -3000,
					["MissileMaxSpeed"] = 2500,
					["MissileMinSpeed"] = 1400,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["CanBeRemoved"] = true,
					["ForceRemove"] = true,
					["MissileSpellName"] = "gnarqmissile",
				},

				["GnarQReturn"] = {

					["SpellName"] = "GnarQReturn",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 0,
					["Range"] = 2500,
					["Radius"] = 75,
					["MissileSpeed"] = 60,
					["MissileAccel"] = 800,
					["MissileMaxSpeed"] = 2600,
					["MissileMinSpeed"] = 60,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["CanBeRemoved"] = true,
					["ForceRemove"] = true,
					["MissileSpellName"] = "GnarQMissileReturn",
					["DisableFowDetection"] = false,
					["DisabledByDefault"] = true,
				},

				["GnarBigQ"] = {

					["SpellName"] = "GnarBigQ",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 500,
					["Range"] = 1150,
					["Radius"] = 90,
					["MissileSpeed"] = 2100,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "GnarBigQMissile",
				},

				["GnarBigW"] = {

					["SpellName"] = "GnarBigW",
					["Slot"] = "W",
					["Type"] = 'Line',
					["Delay"] = 600,
					["Range"] = 600,
					["Radius"] = 80,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "GnarBigW",
				},

				["GnarE"] = {

					["SpellName"] = "GnarE",
					["Slot"] = "E",
					["Type"] = 'Circular',
					["Delay"] = 0,
					["Range"] = 473,
					["Radius"] = 150,
					["MissileSpeed"] = 903,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "GnarE",
				},

				["GnarBigE"] = {

					["SpellName"] = "GnarBigE",
					["Slot"] = "E",
					["Type"] = 'Circular',
					["Delay"] = 250,
					["Range"] = 475,
					["Radius"] = 200,
					["MissileSpeed"] = 1000,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "GnarBigE",
				},

				["GnarR"] = {

					["SpellName"] = "GnarR",
					["Slot"] = "R",
					["Type"] = 'Circular',
					["Delay"] = 250,
					["Range"] = 0,
					["Radius"] = 500,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = true,
					["AddHitbox"] = false,
					["DangerValue"] = 5,
					["IsDangerous"] = true,
					["MissileSpellName"] = "",
				},

			},

			["Gragas"] = {

				["GragasQ"] = {

					["SpellName"] = "GragasQ",
					["Slot"] = "Q",
					["Type"] = 'Circular',
					["Delay"] = 250,
					["Range"] = 1100,
					["Radius"] = 275,
					["MissileSpeed"] = 1300,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "GragasQMissile",
					["ExtraDuration"] = 4500,
					["ToggleParticleName"] = "Gragas_.+_Q_(Enemy|Ally)",
					["DontCross"] = true,
				},

				["GragasE"] = {

					["SpellName"] = "GragasE",
					["Slot"] = "E",
					["Type"] = 'Line',
					["Delay"] = 0,
					["Range"] = 950,
					["Radius"] = 200,
					["MissileSpeed"] = 1200,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "GragasE",
					["CanBeRemoved"] = true,
					["ExtraRange"] = 300,
				},

				["GragasR"] = {

					["SpellName"] = "GragasR",
					["Slot"] = "R",
					["Type"] = 'Circular',
					["Delay"] = 250,
					["Range"] = 1050,
					["Radius"] = 375,
					["MissileSpeed"] = 1800,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 5,
					["IsDangerous"] = true,
					["MissileSpellName"] = "GragasRBoom",
				},

			},

			["Graves"] = {

				["GravesClusterShot"] = {

					["SpellName"] = "GravesClusterShot",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1000,
					["Radius"] = 50,
					["MissileSpeed"] = 2000,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "GravesClusterShotAttack",
					["MultipleNumber"] = 3,
					["MultipleAngle"] = 15 * math.pi / 180,
				},

				["GravesChargeShot"] = {

					["SpellName"] = "GravesChargeShot",
					["Slot"] = "R",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1100,
					["Radius"] = 100,
					["MissileSpeed"] = 2100,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 5,
					["IsDangerous"] = true,
					["MissileSpellName"] = "GravesChargeShotShot",
				},

			},

			["Heimerdinger"] = {

				["Heimerdingerwm"] = {

					["SpellName"] = "Heimerdingerwm",
					["Slot"] = "W",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1500,
					["Radius"] = 70,
					["MissileSpeed"] = 1800,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "HeimerdingerWAttack2",
				},

				["HeimerdingerE"] = {

					["SpellName"] = "HeimerdingerE",
					["Slot"] = "E",
					["Type"] = 'Circular',
					["Delay"] = 250,
					["Range"] = 925,
					["Radius"] = 100,
					["MissileSpeed"] = 1200,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "heimerdingerespell",
				},

			},

			["Irelia"] = {

				["IreliaTranscendentBlades"] = {

					["SpellName"] = "IreliaTranscendentBlades",
					["Slot"] = "R",
					["Type"] = 'Line',
					["Delay"] = 0,
					["Range"] = 1200,
					["Radius"] = 65,
					["MissileSpeed"] = 1600,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "IreliaTranscendentBlades",
				},

			},

			["Janna"] = {

				["JannaQ"] = {

					["SpellName"] = "JannaQ",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1700,
					["Radius"] = 120,
					["MissileSpeed"] = 900,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "HowlingGaleSpell",
				},

			},

			["JarvanIV"] = {

				["JarvanIVDragonStrike"] = {

					["SpellName"] = "JarvanIVDragonStrike",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 600,
					["Range"] = 770,
					["Radius"] = 70,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = false,
				},

				["JarvanIVEQ"] = {

					["SpellName"] = "JarvanIVEQ",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 880,
					["Radius"] = 70,
					["MissileSpeed"] = 1450,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
				},

				["JarvanIVDemacianStandard"] = {

					["SpellName"] = "JarvanIVDemacianStandard",
					["Slot"] = "E",
					["Type"] = 'Circular',
					["Delay"] = 500,
					["Range"] = 860,
					["Radius"] = 175,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "JarvanIVDemacianStandard",
				},

			},

			["Jayce"] = {

				["jayceshockblast"] = {

					["SpellName"] = "jayceshockblast",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1300,
					["Radius"] = 70,
					["MissileSpeed"] = 1450,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "JayceShockBlastMis",
					["CanBeRemoved"] = true,
				},

				["JayceQAccel"] = {

					["SpellName"] = "JayceQAccel",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1300,
					["Radius"] = 70,
					["MissileSpeed"] = 2350,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "JayceShockBlastWallMis",
					["CanBeRemoved"] = true,
				},

			},

			["Jinx"] = {

				["JinxW"] = {

					["SpellName"] = "JinxW",
					["Slot"] = "W",
					["Type"] = 'Line',
					["Delay"] = 600,
					["Range"] = 1500,
					["Radius"] = 60,
					["MissileSpeed"] = 3300,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "JinxWMissile",
					["CanBeRemoved"] = true,
				},

				["JinxR"] = {

					["SpellName"] = "JinxR",
					["Slot"] = "R",
					["Type"] = 'Line',
					["Delay"] = 600,
					["Range"] = 20000,
					["Radius"] = 140,
					["MissileSpeed"] = 1700,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 5,
					["IsDangerous"] = true,
					["MissileSpellName"] = "JinxR",
					["CanBeRemoved"] = true,
				},

			},

			["Kalista"] = {

				["KalistaMysticShot"] = {

					["SpellName"] = "KalistaMysticShot",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1200,
					["Radius"] = 40,
					["MissileSpeed"] = 1700,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "kalistamysticshotmis",
					["CanBeRemoved"] = true,
				},

			},

			["Karma"] = {

				["KarmaQ"] = {

					["SpellName"] = "KarmaQ",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1050,
					["Radius"] = 60,
					["MissileSpeed"] = 1700,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "KarmaQMissile",
					["CanBeRemoved"] = true,
				},

				["KarmaQMantra"] = {

					["SpellName"] = "KarmaQMantra",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 950,
					["Radius"] = 80,
					["MissileSpeed"] = 1700,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "KarmaQMissileMantra",
					["CanBeRemoved"] = true,
				},

			},

			["Karthus"] = {

				["KarthusLayWasteA2"] = {

					["SpellName"] = "KarthusLayWasteA2",
					["ExtraSpellNames"] = "",
					["Slot"] = "Q",
					["Type"] = 'Circular',
					["Delay"] = 625,
					["Range"] = 875,
					["Radius"] = 160,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "",
				},

			},

			["Kassadin"] = {

				["RiftWalk"] = {

					["SpellName"] = "RiftWalk",
					["Slot"] = "R",
					["Type"] = 'Circular',
					["Delay"] = 250,
					["Range"] = 450,
					["Radius"] = 270,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "RiftWalk",
				},

			},

			["Kennen"] = {

				["KennenShurikenHurlMissile1"] = {

					["SpellName"] = "KennenShurikenHurlMissile1",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 125,
					["Range"] = 1050,
					["Radius"] = 50,
					["MissileSpeed"] = 1700,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "KennenShurikenHurlMissile1",
					["CanBeRemoved"] = true,
				},

			},

			["Khazix"] = {

				["KhazixW"] = {

					["SpellName"] = "KhazixW",
					["Slot"] = "W",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1025,
					["Radius"] = 73,
					["MissileSpeed"] = 1700,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "KhazixWMissile",
					["CanBeRemoved"] = true,
					["MultipleNumber"] = 3,
					["MultipleAngle"] = 22 * math.pi / 180,
				},

				["KhazixE"] = {

					["SpellName"] = "KhazixE",
					["Slot"] = "E",
					["Type"] = 'Circular',
					["Delay"] = 250,
					["Range"] = 600,
					["Radius"] = 300,
					["MissileSpeed"] = 1500,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "KhazixE",
				},

			},

			["Kogmaw"] = {

				["KogMawQ"] = {

					["SpellName"] = "KogMawQ",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1200,
					["Radius"] = 70,
					["MissileSpeed"] = 1650,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "KogMawQMis",
					["CanBeRemoved"] = true,
				},

				["KogMawVoidOoze"] = {

					["SpellName"] = "KogMawVoidOoze",
					["Slot"] = "E",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1360,
					["Radius"] = 120,
					["MissileSpeed"] = 1400,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "KogMawVoidOozeMissile",
				},

				["KogMawLivingArtillery"] = {

					["SpellName"] = "KogMawLivingArtillery",
					["Slot"] = "R",
					["Type"] = 'Circular',
					["Delay"] = 1200,
					["Range"] = 1800,
					["Radius"] = 150,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "KogMawLivingArtillery",
				},

			},

			["Leblanc"] = {

				["LeblancSlide"] = {

					["SpellName"] = "LeblancSlide",
					["Slot"] = "W",
					["Type"] = 'Circular',
					["Delay"] = 0,
					["Range"] = 600,
					["Radius"] = 220,
					["MissileSpeed"] = 1450,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "LeblancSlide",
				},

				["LeblancSlideM"] = {

					["SpellName"] = "LeblancSlideM",
					["Slot"] = "R",
					["Type"] = 'Circular',
					["Delay"] = 0,
					["Range"] = 600,
					["Radius"] = 220,
					["MissileSpeed"] = 1450,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "LeblancSlideM",
				},

				["LeblancSoulShackle"] = {

					["SpellName"] = "LeblancSoulShackle",
					["Slot"] = "E",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 950,
					["Radius"] = 70,
					["MissileSpeed"] = 1600,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "LeblancSoulShackle",
					["CanBeRemoved"] = true,
				},

				["LeblancSoulShackleM"] = {

					["SpellName"] = "LeblancSoulShackleM",
					["Slot"] = "R",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 950,
					["Radius"] = 70,
					["MissileSpeed"] = 1600,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "LeblancSoulShackleM",
					["CanBeRemoved"] = true,
				},

			},

			["LeeSin"] = {

				["BlindMonkQOne"] = {

					["SpellName"] = "BlindMonkQOne",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1100,
					["Radius"] = 65,
					["MissileSpeed"] = 1800,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "BlindMonkQOne",
					["CanBeRemoved"] = true,
				},

			},

			["Leona"] = {

				["LeonaZenithBlade"] = {

					["SpellName"] = "LeonaZenithBlade",
					["Slot"] = "E",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 905,
					["Radius"] = 70,
					["MissileSpeed"] = 2000,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["TakeClosestPath"] = true,
					["MissileSpellName"] = "LeonaZenithBladeMissile",
				},

				["LeonaSolarFlare"] = {

					["SpellName"] = "LeonaSolarFlare",
					["Slot"] = "R",
					["Type"] = 'Circular',
					["Delay"] = 1000,
					["Range"] = 1200,
					["Radius"] = 300,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 5,
					["IsDangerous"] = true,
					["MissileSpellName"] = "LeonaSolarFlare",
				},

			},

			["Lissandra"] = {

				["LissandraQ"] = {

					["SpellName"] = "LissandraQ",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 700,
					["Radius"] = 75,
					["MissileSpeed"] = 2200,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "LissandraQMissile",
				},

				["LissandraQShards"] = {

					["SpellName"] = "LissandraQShards",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 700,
					["Radius"] = 90,
					["MissileSpeed"] = 2200,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "lissandraqshards",
				},

				["LissandraE"] = {

					["SpellName"] = "LissandraE",
					["Slot"] = "E",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1025,
					["Radius"] = 125,
					["MissileSpeed"] = 850,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "LissandraEMissile",
				},

			},

			["Lucian"] = {

				["LucianQ"] = {

					["SpellName"] = "LucianQ",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 500,
					["Range"] = 1300,
					["Radius"] = 65,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "LucianQ",
				},

				["LucianW"] = {

					["SpellName"] = "LucianW",
					["Slot"] = "W",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1000,
					["Radius"] = 55,
					["MissileSpeed"] = 1600,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "lucianwmissile",
				},

				["LucianRMis"] = {

					["SpellName"] = "LucianRMis",
					["Slot"] = "R",
					["Type"] = 'Line',
					["Delay"] = 500,
					["Range"] = 1400,
					["Radius"] = 110,
					["MissileSpeed"] = 2800,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "lucianrmissileoffhand",
					["DontCheckForDuplicates"] = true,
					["DisabledByDefault"] = true,
				},

			},

			["Lulu"] = {

				["LuluQ"] = {

					["SpellName"] = "LuluQ",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 950,
					["Radius"] = 60,
					["MissileSpeed"] = 1450,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "LuluQMissile",
				},

				["LuluQPix"] = {

					["SpellName"] = "LuluQPix",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 950,
					["Radius"] = 60,
					["MissileSpeed"] = 1450,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "LuluQMissileTwo",
				},

			},

			["Lux"] = {

				["LuxLightBinding"] = {

					["SpellName"] = "LuxLightBinding",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1300,
					["Radius"] = 70,
					["MissileSpeed"] = 1200,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "LuxLightBindingMis",
					["//CanBeRemoved"] = true,
				},

				["LuxLightStrikeKugel"] = {

					["SpellName"] = "LuxLightStrikeKugel",
					["Slot"] = "E",
					["Type"] = 'Circular',
					["Delay"] = 250,
					["Range"] = 1100,
					["Radius"] = 275,
					["MissileSpeed"] = 1300,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "LuxLightStrikeKugel",
					["ExtraDuration"] = 5500,
					["ToggleParticleName"] = "Lux_.+_E_tar_aoe_",
					["DontCross"] = true,
					["CanBeRemoved"] = true,
					["DisabledByDefault"] = true,
				},

				["LuxMaliceCannon"] = {

					["SpellName"] = "LuxMaliceCannon",
					["Slot"] = "R",
					["Type"] = 'Line',
					["Delay"] = 1000,
					["Range"] = 3500,
					["Radius"] = 190,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 5,
					["IsDangerous"] = true,
					["MissileSpellName"] = "LuxMaliceCannon",
				},

			},

			["Malphite"] = {

				["UFSlash"] = {

					["SpellName"] = "UFSlash",
					["Slot"] = "R",
					["Type"] = 'Circular',
					["Delay"] = 0,
					["Range"] = 1000,
					["Radius"] = 270,
					["MissileSpeed"] = 1500,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 5,
					["IsDangerous"] = true,
					["MissileSpellName"] = "UFSlash",
				},

			},

			["Malzahar"] = {

				["AlZaharCalloftheVoid"] = {

					["SpellName"] = "AlZaharCalloftheVoid",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 1000,
					["Range"] = 900,
					["Radius"] = 85,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["DontCross"] = true,
					["MissileSpellName"] = "AlZaharCalloftheVoid",
				},

			},

			["Morgana"] = {

				["DarkBindingMissile"] = {

					["SpellName"] = "DarkBindingMissile",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1300,
					["Radius"] = 80,
					["MissileSpeed"] = 1200,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "DarkBindingMissile",
					["CanBeRemoved"] = true,
				},

			},

			["Nami"] = {

				["NamiQ"] = {

					["SpellName"] = "NamiQ",
					["Slot"] = "Q",
					["Type"] = 'Circular',
					["Delay"] = 950,
					["Range"] = 1625,
					["Radius"] = 150,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "namiqmissile",
				},

				["NamiR"] = {

					["SpellName"] = "NamiR",
					["Slot"] = "R",
					["Type"] = 'Line',
					["Delay"] = 500,
					["Range"] = 2750,
					["Radius"] = 260,
					["MissileSpeed"] = 850,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "NamiRMissile",
				},

			},

			["Nautilus"] = {

				["NautilusAnchorDrag"] = {

					["SpellName"] = "NautilusAnchorDrag",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1250,
					["Radius"] = 90,
					["MissileSpeed"] = 2000,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "NautilusAnchorDragMissile",
					["CanBeRemoved"] = true,
				},

			},

			["Nocturne"] = {

				["NocturneDuskbringer"] = {

					["SpellName"] = "NocturneDuskbringer",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1125,
					["Radius"] = 60,
					["MissileSpeed"] = 1400,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "NocturneDuskbringer",
				},

			},

			["Nidalee"] = {

				["JavelinToss"] = {

					["SpellName"] = "JavelinToss",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1500,
					["Radius"] = 40,
					["MissileSpeed"] = 1300,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "JavelinToss",
					["CanBeRemoved"] = true,
				},

			},

			["Olaf"] = {

				["OlafAxeThrowCast"] = {

					["SpellName"] = "OlafAxeThrowCast",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1000,
					["ExtraRange"] = 150,
					["Radius"] = 105,
					["MissileSpeed"] = 1600,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "olafaxethrow",
					["CanBeRemoved"] = true,
				},

			},

			["Orianna"] = {

				["OriannasQ"] = {

					["SpellName"] = "OriannasQ",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 0,
					["Range"] = 1500,
					["Radius"] = 80,
					["MissileSpeed"] = 1200,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "orianaizuna",
				},

				["OriannaQend"] = {

					["SpellName"] = "OriannaQend",
					["Slot"] = "Q",
					["Type"] = 'Circular',
					["Delay"] = 0,
					["Range"] = 1500,
					["Radius"] = 90,
					["MissileSpeed"] = 1200,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "",
				},

				["OrianaDissonanceCommand"] = {

					["SpellName"] = "OrianaDissonanceCommand",
					["Slot"] = "W",
					["Type"] = 'Circular',
					["Delay"] = 250,
					["Range"] = 0,
					["Radius"] = 255,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "OrianaDissonanceCommand",
					["FromObject"] = "yomu_ring_",
				},

				["OriannasE"] = {

					["SpellName"] = "OriannasE",
					["Slot"] = "E",
					["Type"] = 'Line',
					["Delay"] = 0,
					["Range"] = 1500,
					["Radius"] = 85,
					["MissileSpeed"] = 1850,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "orianaredact",
				},

				["OrianaDetonateCommand"] = {

					["SpellName"] = "OrianaDetonateCommand",
					["Slot"] = "R",
					["Type"] = 'Circular',
					["Delay"] = 700,
					["Range"] = 0,
					["Radius"] = 410,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 5,
					["IsDangerous"] = true,
					["MissileSpellName"] = "OrianaDetonateCommand",
					["FromObject"] = "yomu_ring_",
				},

			},

			["Quinn"] = {

				["QuinnQ"] = {

					["SpellName"] = "QuinnQ",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1050,
					["Radius"] = 80,
					["MissileSpeed"] = 1550,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "QuinnQMissile",
					["CanBeRemoved"] = true,
				},

			},

			["Rengar"] = {

				["RengarE"] = {

					["SpellName"] = "RengarE",
					["Slot"] = "E",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1000,
					["Radius"] = 70,
					["MissileSpeed"] = 1500,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "RengarEFinal",
					["CanBeRemoved"] = true,
				},

			},

			["RekSai"] = {

				["reksaiqburrowed"] = {

					["SpellName"] = "reksaiqburrowed",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 500,
					["Range"] = 1625,
					["Radius"] = 60,
					["MissileSpeed"] = 1950,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = false,
					["MissileSpellName"] = "RekSaiQBurrowedMis",
				},

			},

			["Riven"] = {

				["rivenizunablade"] = {

					["SpellName"] = "rivenizunablade",
					["Slot"] = "R",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1100,
					["Radius"] = 125,
					["MissileSpeed"] = 1600,
					["FixedRange"] = false,
					["AddHitbox"] = false,
					["DangerValue"] = 5,
					["IsDangerous"] = true,
					["MultipleNumber"] = 3,
					["MultipleAngle"] = 15 * math.pi / 180,
					["MissileSpellName"] = "RivenLightsaberMissile",
				},

			},

			["Rumble"] = {

				["RumbleGrenade"] = {

					["SpellName"] = "RumbleGrenade",
					["Slot"] = "E",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 950,
					["Radius"] = 60,
					["MissileSpeed"] = 2000,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "RumbleGrenade",
					["CanBeRemoved"] = true,
				},

				["RumbleCarpetBombM"] = {

					["SpellName"] = "RumbleCarpetBombM",
					["Slot"] = "R",
					["Type"] = 'Line',
					["Delay"] = 400,
					["MissileDelayed"] = true,
					["Range"] = 1200,
					["Radius"] = 200,
					["MissileSpeed"] = 1600,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 4,
					["IsDangerous"] = false,
					["MissileSpellName"] = "RumbleCarpetBombMissile",
					["CanBeRemoved"] = false,
				},

			},

			["Ryze"] = {

				["RyzeQ"] = {

					["SpellName"] = "RyzeQ",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 900,
					["Radius"] = 50,
					["MissileSpeed"] = 1700,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "RyzeQ",
					["CanBeRemoved"] = true,
				},

				["ryzerq"] = {

					["SpellName"] = "ryzerq",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 900,
					["Radius"] = 50,
					["MissileSpeed"] = 1700,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "ryzerq",
					["CanBeRemoved"] = true,
				},

			},

			["Sejuani"] = {

				["SejuaniArcticAssault"] = {

					["SpellName"] = "SejuaniArcticAssault",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 0,
					["Range"] = 900,
					["Radius"] = 70,
					["MissileSpeed"] = 1600,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "",
					["ExtraRange"] = 200,
				},

				["SejuaniGlacialPrisonStart"] = {

					["SpellName"] = "SejuaniGlacialPrisonStart",
					["Slot"] = "R",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1100,
					["Radius"] = 110,
					["MissileSpeed"] = 1600,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "sejuaniglacialprison",
					["CanBeRemoved"] = true,
				},

			},

			["Sion"] = {

				["SionE"] = {

					["SpellName"] = "SionE",
					["Slot"] = "E",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 800,
					["Radius"] = 80,
					["MissileSpeed"] = 1800,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "SionEMissile",
				},

				["SionR"] = {

					["SpellName"] = "SionR",
					["Slot"] = "R",
					["Type"] = 'Line',
					["Delay"] = 500,
					["Range"] = 800,
					["Radius"] = 120,
					["MissileSpeed"] = 1000,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
				},

			},

			["Soraka"] = {

				["SorakaQ"] = {

					["SpellName"] = "SorakaQ",
					["Slot"] = "Q",
					["Type"] = 'Circular',
					["Delay"] = 500,
					["Range"] = 950,
					["Radius"] = 300,
					["MissileSpeed"] = 1750,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "",
				},

			},

			["Shen"] = {

				["ShenShadowDash"] = {

					["SpellName"] = "ShenShadowDash",
					["Slot"] = "E",
					["Type"] = 'Line',
					["Delay"] = 0,
					["Range"] = 650,
					["Radius"] = 50,
					["MissileSpeed"] = 1600,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "ShenShadowDash",
					["ExtraRange"] = 200,
				},

			},

			["Shyvana"] = {

				["ShyvanaFireball"] = {

					["SpellName"] = "ShyvanaFireball",
					["Slot"] = "E",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 950,
					["Radius"] = 60,
					["MissileSpeed"] = 1700,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "ShyvanaFireballMissile",
				},

				["ShyvanaTransformCast"] = {

					["SpellName"] = "ShyvanaTransformCast",
					["Slot"] = "R",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1000,
					["Radius"] = 150,
					["MissileSpeed"] = 1500,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "ShyvanaTransformCast",
					["ExtraRange"] = 200,
				},

			},

			["Sivir"] = {

				["SivirQReturn"] = {

					["SpellName"] = "SivirQReturn",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 0,
					["Range"] = 1250,
					["Radius"] = 100,
					["MissileSpeed"] = 1350,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "SivirQMissileReturn",
					["DisableFowDetection"] = false,
					["MissileFollowsUnit"] = true,
				},

				["SivirQ"] = {

					["SpellName"] = "SivirQ",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1250,
					["Radius"] = 90,
					["MissileSpeed"] = 1350,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "SivirQMissile",
				},

			},

			["Skarner"] = {

				["SkarnerFracture"] = {

					["SpellName"] = "SkarnerFracture",
					["Slot"] = "E",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1000,
					["Radius"] = 70,
					["MissileSpeed"] = 1500,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "SkarnerFractureMissile",
				},

			},

			["Sona"] = {

				["SonaR"] = {

					["SpellName"] = "SonaR",
					["Slot"] = "R",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1000,
					["Radius"] = 140,
					["MissileSpeed"] = 2400,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 5,
					["IsDangerous"] = true,
					["MissileSpellName"] = "SonaR",
				},

			},

			["Swain"] = {

				["SwainShadowGrasp"] = {

					["SpellName"] = "SwainShadowGrasp",
					["Slot"] = "W",
					["Type"] = 'Circular',
					["Delay"] = 1100,
					["Range"] = 900,
					["Radius"] = 180,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "SwainShadowGrasp",
				},

			},

			["Syndra"] = {

				["SyndraQ"] = {

					["SpellName"] = "SyndraQ",
					["Slot"] = "Q",
					["Type"] = 'Circular',
					["Delay"] = 600,
					["Range"] = 800,
					["Radius"] = 150,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "SyndraQ",
				},

				["syndrawcast"] = {

					["SpellName"] = "syndrawcast",
					["Slot"] = "W",
					["Type"] = 'Circular',
					["Delay"] = 250,
					["Range"] = 950,
					["Radius"] = 210,
					["MissileSpeed"] = 1450,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "syndrawcast",
				},

				["syndrae5"] = {

					["SpellName"] = "syndrae5",
					["Slot"] = "E",
					["Type"] = 'Line',
					["Delay"] = 300,
					["Range"] = 950,
					["Radius"] = 90,
					["MissileSpeed"] = 1601,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "syndrae5",
					["DisableFowDetection"] = true,
				},

				["SyndraE"] = {

					["SpellName"] = "SyndraE",
					["Slot"] = "E",
					["Type"] = 'Line',
					["Delay"] = 300,
					["Range"] = 950,
					["Radius"] = 90,
					["MissileSpeed"] = 1601,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["DisableFowDetection"] = true,
					["MissileSpellName"] = "SyndraE",
				},

			},

			["Talon"] = {

				["TalonRake"] = {

					["SpellName"] = "TalonRake",
					["Slot"] = "W",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 800,
					["Radius"] = 80,
					["MissileSpeed"] = 2300,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = true,
					["MultipleNumber"] = 3,
					["MultipleAngle"] = 20 * math.pi / 180,
					["MissileSpellName"] = "talonrakemissileone",
				},

				["TalonRakeReturn"] = {

					["SpellName"] = "TalonRakeReturn",
					["Slot"] = "W",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 800,
					["Radius"] = 80,
					["MissileSpeed"] = 1850,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = true,
					["MultipleNumber"] = 3,
					["MultipleAngle"] = 20 * math.pi / 180,
					["MissileSpellName"] = "talonrakemissiletwo",
				},

			},

			["TahmKench"] = {

				["TahmKenchQ"] = {

					["SpellName"] = "TahmKenchQ",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 951,
					["Radius"] = 90,
					["MissileSpeed"] = 2800,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "tahmkenchqmissile",
					["CanBeRemoved"] = true,
				},

			},

			["Thresh"] = {

				["ThreshQ"] = {

					["SpellName"] = "ThreshQ",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 500,
					["Range"] = 1100,
					["Radius"] = 70,
					["MissileSpeed"] = 1900,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "ThreshQMissile",
					["CanBeRemoved"] = true,
				},

				["ThreshEFlay"] = {

					["SpellName"] = "ThreshEFlay",
					["Slot"] = "E",
					["Type"] = 'Line',
					["Delay"] = 125,
					["Range"] = 1075,
					["Radius"] = 110,
					["MissileSpeed"] = 2000,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["Centered"] = true,
					["MissileSpellName"] = "ThreshEMissile1",
				},

			},

			["Tristana"] = {

				["RocketJump"] = {

					["SpellName"] = "RocketJump",
					["Slot"] = "W",
					["Type"] = 'Circular',
					["Delay"] = 500,
					["Range"] = 900,
					["Radius"] = 270,
					["MissileSpeed"] = 1500,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "RocketJump",
				},

			},

			["Tryndamere"] = {

				["slashCast"] = {

					["SpellName"] = "slashCast",
					["Slot"] = "E",
					["Type"] = 'Line',
					["Delay"] = 0,
					["Range"] = 660,
					["Radius"] = 93,
					["MissileSpeed"] = 1300,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "slashCast",
				},

			},

			["TwistedFate"] = {

				["WildCards"] = {

					["SpellName"] = "WildCards",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1450,
					["Radius"] = 40,
					["MissileSpeed"] = 1000,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "SealFateMissile",
					["MultipleNumber"] = 3,
					["MultipleAngle"] = 28 * math.pi / 180,
				},

			},

			["Twitch"] = {

				["TwitchVenomCask"] = {

					["SpellName"] = "TwitchVenomCask",
					["Slot"] = "W",
					["Type"] = 'Circular',
					["Delay"] = 250,
					["Range"] = 900,
					["Radius"] = 275,
					["MissileSpeed"] = 1400,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "TwitchVenomCaskMissile",
				},

			},

			["Urgot"] = {

				["UrgotHeatseekingLineMissile"] = {

					["SpellName"] = "UrgotHeatseekingLineMissile",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 125,
					["Range"] = 1000,
					["Radius"] = 60,
					["MissileSpeed"] = 1600,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "UrgotHeatseekingLineMissile",
					["CanBeRemoved"] = true,
				},

				["UrgotPlasmaGrenade"] = {

					["SpellName"] = "UrgotPlasmaGrenade",
					["Slot"] = "E",
					["Type"] = 'Circular',
					["Delay"] = 250,
					["Range"] = 1100,
					["Radius"] = 210,
					["MissileSpeed"] = 1500,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "UrgotPlasmaGrenadeBoom",
				},

			},

			["Varus"] = {

				["VarusQMissilee"] = {

					["SpellName"] = "VarusQMissilee",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1800,
					["Radius"] = 70,
					["MissileSpeed"] = 1900,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "VarusQMissile",
				},

				["VarusE"] = {

					["SpellName"] = "VarusE",
					["Slot"] = "E",
					["Type"] = 'Circular',
					["Delay"] = 1000,
					["Range"] = 925,
					["Radius"] = 235,
					["MissileSpeed"] = 1500,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "VarusE",
				},

				["VarusR"] = {

					["SpellName"] = "VarusR",
					["Slot"] = "R",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1200,
					["Radius"] = 120,
					["MissileSpeed"] = 1950,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "VarusRMissile",
					["CanBeRemoved"] = true,
				},

			},

			["Veigar"] = {

				["VeigarBalefulStrike"] = {

					["SpellName"] = "VeigarBalefulStrike",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 950,
					["Radius"] = 70,
					["MissileSpeed"] = 2000,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "VeigarBalefulStrikeMis",
				},

				["VeigarDarkMatter"] = {

					["SpellName"] = "VeigarDarkMatter",
					["Slot"] = "W",
					["Type"] = 'Circular',
					["Delay"] = 1350,
					["Range"] = 900,
					["Radius"] = 225,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "",
				},

				["VeigarEventHorizon"] = {

					["SpellName"] = "VeigarEventHorizon",
					["Slot"] = "E",
					["Type"] = 'Ring',
					["Delay"] = 500,
					["Range"] = 700,
					["Radius"] = 80,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = false,
					["AddHitbox"] = false,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["DontAddExtraDuration"] = true,
					["RingRadius"] = 350,
					["ExtraDuration"] = 3300,
					["DontCross"] = true,
					["MissileSpellName"] = "",
				},

			},

			["Velkoz"] = {

				["VelkozQ"] = {

					["SpellName"] = "VelkozQ",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1100,
					["Radius"] = 50,
					["MissileSpeed"] = 1300,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "VelkozQMissile",
					["CanBeRemoved"] = true,
				},

				["VelkozQSplit"] = {

					["SpellName"] = "VelkozQSplit",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1100,
					["Radius"] = 55,
					["MissileSpeed"] = 2100,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "VelkozQMissileSplit",
					["CanBeRemoved"] = true,
				},

				["VelkozW"] = {

					["SpellName"] = "VelkozW",
					["Slot"] = "W",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1200,
					["Radius"] = 88,
					["MissileSpeed"] = 1700,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "VelkozWMissile",
				},

				["VelkozE"] = {

					["SpellName"] = "VelkozE",
					["Slot"] = "E",
					["Type"] = 'Circular',
					["Delay"] = 500,
					["Range"] = 800,
					["Radius"] = 225,
					["MissileSpeed"] = 1500,
					["FixedRange"] = false,
					["AddHitbox"] = false,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "VelkozEMissile",
				},

			},

			["Vi"] = {

				["Vi-q"] = {

					["SpellName"] = "Vi-q",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1000,
					["Radius"] = 90,
					["MissileSpeed"] = 1500,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "ViQMissile",
				},

			},

			["Viktor"] = {

				["Laser"] = {

					["SpellName"] = "Laser",
					["Slot"] = "E",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1500,
					["Radius"] = 80,
					["MissileSpeed"] = 780,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "ViktorDeathRayMissile",
				},

			},

			["Xerath"] = {

				["xeratharcanopulse2"] = {

					["SpellName"] = "xeratharcanopulse2",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 600,
					["Range"] = 1600,
					["Radius"] = 100,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "xeratharcanopulse2",
				},

				["XerathArcaneBarrage2"] = {

					["SpellName"] = "XerathArcaneBarrage2",
					["Slot"] = "W",
					["Type"] = 'Circular',
					["Delay"] = 700,
					["Range"] = 1000,
					["Radius"] = 200,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "XerathArcaneBarrage2",
				},

				["XerathMageSpear"] = {

					["SpellName"] = "XerathMageSpear",
					["Slot"] = "E",
					["Type"] = 'Line',
					["Delay"] = 200,
					["Range"] = 1150,
					["Radius"] = 60,
					["MissileSpeed"] = 1400,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = true,
					["MissileSpellName"] = "XerathMageSpearMissile",
					["CanBeRemoved"] = true,
				},

				["xerathrmissilewrapper"] = {

					["SpellName"] = "xerathrmissilewrapper",
					["Slot"] = "R",
					["Type"] = 'Circular',
					["Delay"] = 700,
					["Range"] = 5600,
					["Radius"] = 120,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "xerathrmissilewrapper",
				},

			},

			["Yasuo"] = {

				["yasuoq2"] = {

					["SpellName"] = "yasuoq2",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 400,
					["Range"] = 550,
					["Radius"] = 20,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = true,
					["MissileSpellName"] = "yasuoq2",
					["Invert"] = true,
				},

				["yasuoq3w"] = {

					["SpellName"] = "yasuoq3w",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 500,
					["Range"] = 1150,
					["Radius"] = 90,
					["MissileSpeed"] = 1500,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "yasuoq3w",
				},

				["yasuoq"] = {

					["SpellName"] = "yasuoq",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 400,
					["Range"] = 550,
					["Radius"] = 20,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = true,
					["MissileSpellName"] = "yasuoq",
					["Invert"] = true,
				},

			},

			["Zac"] = {

				["ZacQ"] = {

					["SpellName"] = "ZacQ",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 500,
					["Range"] = 550,
					["Radius"] = 120,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "ZacQ",
				},

			},

			["Zed"] = {

				["ZedShuriken"] = {

					["SpellName"] = "ZedShuriken",
					["Slot"] = "Q",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 925,
					["Radius"] = 50,
					["MissileSpeed"] = 1700,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "zedshurikenmisone",
				},

			},

			["Ziggs"] = {

				["ZiggsQ"] = {

					["SpellName"] = "ZiggsQ",
					["Slot"] = "Q",
					["Type"] = 'Circular',
					["Delay"] = 250,
					["Range"] = 850,
					["Radius"] = 140,
					["MissileSpeed"] = 1700,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "ZiggsQSpell",
					["CanBeRemoved"] = false,
					["DisableFowDetection"] = true,
				},

				["ZiggsQBounce1"] = {

					["SpellName"] = "ZiggsQBounce1",
					["Slot"] = "Q",
					["Type"] = 'Circular',
					["Delay"] = 250,
					["Range"] = 850,
					["Radius"] = 140,
					["MissileSpeed"] = 1700,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "ZiggsQSpell2",
					["CanBeRemoved"] = false,
					["DisableFowDetection"] = true,
				},

				["ZiggsQBounce2"] = {

					["SpellName"] = "ZiggsQBounce2",
					["Slot"] = "Q",
					["Type"] = 'Circular',
					["Delay"] = 250,
					["Range"] = 850,
					["Radius"] = 160,
					["MissileSpeed"] = 1700,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "ZiggsQSpell3",
					["CanBeRemoved"] = false,
					["DisableFowDetection"] = true,
				},

				["ZiggsW"] = {

					["SpellName"] = "ZiggsW",
					["Slot"] = "W",
					["Type"] = 'Circular',
					["Delay"] = 250,
					["Range"] = 1000,
					["Radius"] = 275,
					["MissileSpeed"] = 1750,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "ZiggsW",
					["DisableFowDetection"] = true,
				},

				["ZiggsE"] = {

					["SpellName"] = "ZiggsE",
					["Slot"] = "E",
					["Type"] = 'Circular',
					["Delay"] = 500,
					["Range"] = 900,
					["Radius"] = 235,
					["MissileSpeed"] = 1750,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "ZiggsE",
					["DisableFowDetection"] = true,
				},

				["ZiggsR"] = {

					["SpellName"] = "ZiggsR",
					["Slot"] = "R",
					["Type"] = 'Circular',
					["Delay"] = 0,
					["Range"] = 5300,
					["Radius"] = 500,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "ZiggsR",
					["DisableFowDetection"] = true,
				},

			},

			["Zilean"] = {

				["ZileanQ"] = {

					["SpellName"] = "ZileanQ",
					["Slot"] = "Q",
					["Type"] = 'Circular',
					["Delay"] = 300,
					["Range"] = 900,
					["Radius"] = 210,
					["MissileSpeed"] = 2000,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "ZileanQMissile",
				},

			},

			["Zyra"] = {

				["ZyraQFissure"] = {

					["SpellName"] = "ZyraQFissure",
					["Slot"] = "Q",
					["Type"] = 'Circular',
					["Delay"] = 850,
					["Range"] = 800,
					["Radius"] = 220,
					["MissileSpeed"] = math.huge,
					["FixedRange"] = false,
					["AddHitbox"] = true,
					["DangerValue"] = 2,
					["IsDangerous"] = false,
					["MissileSpellName"] = "ZyraQFissure",
				},

				["ZyraGraspingRoots"] = {

					["SpellName"] = "ZyraGraspingRoots",
					["Slot"] = "E",
					["Type"] = 'Line',
					["Delay"] = 250,
					["Range"] = 1150,
					["Radius"] = 70,
					["MissileSpeed"] = 1150,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "ZyraGraspingRoots",
				},

				["zyrapassivedeathmanager"] = {

					["SpellName"] = "zyrapassivedeathmanager",
					["Slot"] = "E",
					["Type"] = 'Line',
					["Delay"] = 500,
					["Range"] = 1474,
					["Radius"] = 70,
					["MissileSpeed"] = 2000,
					["FixedRange"] = true,
					["AddHitbox"] = true,
					["DangerValue"] = 3,
					["IsDangerous"] = true,
					["MissileSpellName"] = "zyrapassivedeathmanager",
				},

			},

	}
end 
function spellDataBase:GetData(Hero, Spell, Data)
	return self.Database[Hero][Spell][Data]
end
