---------------------------------------
-- Last Revised: September 9th, 2017 --
---------------------------------------
--
---------------------------------------------
-- Gearswap Commands Specific to this File --
---------------------------------------------
-- Universal Ready Move Commands -
-- //gs c Bloodpact one
-- //gs c Bloodpact two
-- //gs c Bloodpact three
--
-- alt+F8 cycles through designated Avatars
-- ctrl+F8 cycles backwards through designated Avatars
-- ctrl+F9 cycles through Pet stances for Subtle Blow and Store TP modes
-- alt+= switches between Pet-Only (Staff Swaps) and Master (no Staff Swap) modes
-- ctrl+` can swap in the usage of Chaac Belt for Treasure Hunter on common subjob abilities.
-- ctrl+F11 cycles between Magical Defense Modes
-- ctrl+= activates a LagMode which swaps in most pet gear during precast.
--
-------------------------------
-- General Gearswap Commands --
-------------------------------
-- F9 cycles Accuracy modes
-- ctrl+F9 cycles Hybrid modes
-- F10 equips Physical Defense
-- alt+F10 toggles Kiting on or off
-- ctrl+F10 cycles Physical Defense modes
-- F11 equips Magical Defense
-- alt+F12 turns off Defense modes
-- ctrl+F12 cycles Idle modes
--
-- Keep in mind that any time you Change Jobs/Subjobs, your Avatar etc reset to default options.
-- F12 will list your current options.
--
-------------------------------------------------------------------------------------------------------------------
-- Initialization function that defines sets and variables to be used.
-------------------------------------------------------------------------------------------------------------------

-- IMPORTANT: Make sure to also get the Mote-Include.lua file (and its supplementary files) to go with this.

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
	include('sammeh_custom_functions.lua')
end

function job_setup()
    -- Display and Random Lockstyle Generator options
    DisplayModeInfo = false
    RandomLockstyleGenerator = false

    PetName = 'None';PetJob = 'None';PetInfo = 'None';BloodPactOne = 'None';BloodPactTwo = 'None';BloodPactThree = 'None';BloodPactFour = 'None'
    pet_info_update()

    -- Display Mode Info as on-screen Text
    TextBoxX = 100
    TextBoxY = 100
    TextSize = 50

    -- List of Equipment Sets created for Random Lockstyle Generator
    -- (If you want to have the same Lockstyle every time, reduce the list to a single Equipset #)
    random_lockstyle_list = {1,2,3,4,5,6,7,8,9,10,11,12}

    state.Buff['Aftermath: Lv.3'] = buffactive['Aftermath: Lv.3'] or false
    state.Buff["Avatar's Favor"] = buffactive["Avatar's Favor"] or false
    state.Buff["Astral Conduit"] = buffactive["Astral Conduit"] or false

    get_combat_form()
    get_melee_groups()
end

function user_setup()
	select_default_macro_book()
	send_command('@wait 1;input /lockstyleset 11')
	
    state.OffenseMode:options('Normal', 'MedAcc', 'HighAcc', 'MaxAcc')
    state.WeaponskillMode:options('Normal', 'WSMedAcc', 'WSHighAcc')
    state.HybridMode:options('Normal')
    state.CastingMode:options('Normal')
    state.IdleMode:options('Normal')
    state.RestingMode:options('Normal')
    state.PhysicalDefenseMode:options('PetDT', 'PDT')
    state.MagicalDefenseMode:options('MDTShell', 'MEva')
	state.TPMode = M{['description']='TP Mode', 'Normal', 'WeaponLock'}
	send_command('alias tp gs c cycle tpmode')
	send_command('alias bpphys gs equip sets.midcast.Pet.WS')
	send_command('alias bpmag gs equip sets.midcast.Pet.MABBloodPact')
	
    -- Set up Avatar cycling and keybind Alt+F8/Ctrl+F8
    state.AvatarMode = M{['description']='Avatar Mode', 'Garuda', 'Shiva', 'Ramuh', 'Carbuncle', 'Cait Sith', 'Diabolos',
        'Fenrir', 'Ifrit', 'Titan', 'Leviathan'}
    send_command('bind !f8 gs c cycle AvatarMode')
    send_command('bind ^f8 gs c cycleback AvatarMode')

    -- Set up Staff Swapping Modes and keybind alt+=
    state.StaffMode = M{['description']='Staff Mode', 'PetOnly', 'NoSwaps'}
    send_command('bind != gs c cycle StaffMode')

    -- Keybind Ctrl+F11 to cycle Magical Defense Modes
    send_command('bind ^f11 gs c cycle MagicalDefenseMode')

    -- Set up Treasure Modes and keybind Ctrl+`
    state.TreasureMode = M{['description']='Treasure Mode', 'Tag', 'Normal'}
    send_command('bind ^` gs c cycle TreasureMode')

    -- Set up Lag Modes and keybind Ctrl+=
    state.LagMode = M{['description']='Lag Mode', 'Lag', 'Normal'}
    send_command('bind ^= gs c cycle LagMode')

    -- 'Out of Range' distance; Melee WSs will auto-cancel
    target_distance = 8

    spirits = S{"LightSpirit", "DarkSpirit", "FireSpirit", "EarthSpirit", "WaterSpirit", "AirSpirit", "IceSpirit", "ThunderSpirit"}
    avatars = S{"Carbuncle", "Fenrir", "Diabolos", "Ifrit", "Titan", "Leviathan", "Garuda", "Shiva", "Ramuh", "Odin", "Alexander", "Cait Sith"}

-- Categorized list of Blood Pacts
blood_pact_list = S{'Searing Light','Poison Nails','Meteorite','Holy Mist','Healing Ruby','Shining Ruby',
    'Glittering Ruby','Healing Ruby II','Soothing Ruby','Pacifying Ruby','Inferno','Punch','Fire II',
    'Burning Strike','Double Punch','Fire IV','Flaming Crush','Meteor Strike','Conflag Strike','Crimson Howl',
    'Inferno Howl','Diamond Dust','Axe Kick','Blizzard II','Double Slap','Blizzard IV','Rush','Heavenly Strike',
    'Frost Armor','Sleepga','Diamond Storm','Crystal Blessing','Aerial Blast','Claw','Aero II','Aero IV',
    'Predator Claws','Wind Blade','Aerial Armor','Whispering Wind','Hastega','Fleet Wind','Hastega II',
    'Earthen Fury','Rock Throw','Stone II','Rock Buster','Megalith Throw','Stone IV','Mountain Buster',
    'Geocrush','Crag Throw','Earthen Ward','Earthen Armor','Judgment Bolt','Shock Strike','Thunder II',
    'Thunderspark','Thunder IV','Chaotic Strike','Thunderstorm','Volt Strike','Rolling Thunder',
    'Lightning Armor','Shock Squall','Tidal Wave','Barracuda Dive','Water II','Tail Whip','Water IV',
    'Spinning Dive','Grand Fall','Slowga','Spring Water','Tidal Roar','Soothing Current','Regal Scratch',
    'Level ? Holy','Regal Gash','Raise II','Mewing Lullaby','Reraise II','Eerie Eye','Howling Moon',
    'Moonlit Charge','Crescent Fang','Eclipse Bite','Lunar Bay','Impact','Lunar Cry','Lunar Roar',
    'Ecliptic Growl','Ecliptic Howl','Heavenward Howl','Ruinous Omen','Camisado','Nether Blast','Night Terror',
    'Blindside','Somnolence','Nightmare','Ultimate Terror','Noctoshield','Dream Shroud','Pavor Nocturnus'}

pet_buff_moves = S{'Shining Ruby','Healing Ruby II','Soothing Ruby','Crimson Howl','Inferno Howl',
    'Frost Armor','Crystal Blessing','Aerial Armor','Whispering Wind','Hastega','Fleet Wind','Hastega II',
    'Earthen Ward','Earthen Armor','Lightning Armor','Spring Water','Soothing Current','Ecliptic Growl',
    'Ecliptic Howl','Heavenward Howl','Noctoshield','Dream Shroud','Raise II','Reraise II'}

physical_blood_pacts = S{'Poison Nails','Axe Kick','Double Slap','Claw','Rock Throw','Rock Buster',
    'Megalith Throw','Mountain Buster','Crag Throw','Shock Strike','Barracuda Dive','Tail Whip',
    'Spinning Dive','Punch','Regal Scratch','Regal Gash','Moonlit Charge','Crescent Fang','Camisado',
    'Chaotic Strike','Double Punch','Eclipse Bite','Predator Claws','Rush','Volt Strike'}

magic_atk_blood_pacts = S{'Flaming Crush','Inferno','Earthen Fury','Tidal Wave','Aerial Blast','Diamond Dust','Judgment Bolt',
    'Searing Light','Howling Moon','Ruinous Omen',
    'Fire II','Stone II','Water II','Aero II','Blizzard II','Thunder II',
    'Fire IV','Stone IV','Water IV','Aero IV','Blizzard IV','Thunder IV',
    'Thunderspark','Burning Strike','Meteorite','Nether Blast',
    'Meteor Strike','Conflag Strike','Heavenly Strike','Wind Blade','Geocrush','Grand Fall','Thunderstorm',
    'Holy Mist','Lunar Bay','Night Terror','Level ? Holy','Impact','Zantetsuken'}

magic_acc_blood_pacts = S{'Sleepga','Diamond Storm','Shock Squall','Slowga','Tidal Roar','Mewing Lullaby',
    'Eerie Eye','Lunar Cry','Lunar Roar','Somnolence','Nightmare','Ultimate Terror','Pavor Nocturnus'}

multi_hit_blood_pacts = S{'Chaotic Strike','Double Punch','Eclipse Bite','Predator Claws','Rush','Volt Strike'}

tp_based_blood_pacts = S{'Impact','Heavenly Strike','Wind Blade','Geocrush','Thunderstorm','Meteor Strike','Grand Fall',
    'Healing Ruby II','Whispering Wind','Healing Ruby','Spring Water'}

-- List of abilities to reference for applying Treasure Hunter gear.
abilities_to_check = S{'Quickstep','Box Step','Stutter Step','Desperate Flourish',
    'Violent Flourish','Animated Flourish','Provoke','Dia','Dia II','Flash','Bio',
    'Bio II','Sleep','Sleep II','Drain','Aspir','Dispel','Stun','Steal','Mug'}

enmity_plus_moves = S{'Provoke','Berserk','Warcry','Aggressor','Holy Circle','Sentinel','Last Resort',
    'Souleater','Vallation','Swordplay'}

-- Random Lockstyle generator.
    if RandomLockstyleGenerator == true then
        local randomLockstyle = random_lockstyle_list[math.random(1, #random_lockstyle_list)]
        send_command('@wait 5;input /lockstyleset '.. randomLockstyle)
    end

    display_mode_info()
end

function file_unload()
    if binds_on_unload then
        binds_on_unload()
    end

    -- Unbinds the Reward, Correlation, AvatarMode, StaffMode and Treasure hotkeys.
    send_command('unbind !=')
    send_command('unbind ^=')
    send_command('unbind @=')
    send_command('unbind !f8')
    send_command('unbind ^f8')
    send_command('unbind @f8')
    send_command('unbind ^f11')

    -- Removes any Text Info Boxes
    send_command('text AvatarText delete')
    send_command('text StaffModeText delete')
    send_command('text AccuracyText delete')
end


function init_gear_sets()

    -- Define some gear

    -- Conveyance cloaks
    Conveyance = {}
        Conveyance.BPAD = { name="Conveyance Cape", augments={'Summoning magic skill +1','Pet: Enmity+15','Blood Pact Dmg.+1','Blood Pact ab. del. II -2',}}

    Campestres = {}
        Campestres.MAB = "Campestres's Cape"
        Campestres.ATT = "Campestres's Cape"

    --  Staves
    Espiritus = {}
        Espiritus.MAB = {name="Espiritus", augments={'Enmity-6','Pet: "Mag.Atk.Bns."+30','Pet: Damage taken -4%',}} -- Dont really need augs defined here

    Gridarvor = {}
        Gridarvor.ATT = {name="Gridarvor"} -- No need to define augments they're both the same

    Merlinic = {}
        Merlinic.MAB = {name="Merlinic Dastanas"} -- No need to define augments we dont have ATT gloves yet and theyre different between chars
        Merlinic.ATT = Merlinic.MAB


    -- Apogee Gear
    ApogeeBoots = {}
        ApogeeBoots.MAB = { name="Apogee Pumps +1", augments={'MP+80','Pet: "Mag.Atk.Bns."+35','Blood Pact Dmg.+8',}}
        ApogeeBoots.ATT = { name="Apogee Pumps", augments={'MP+60','Pet: Attack+30','Blood Pact Dmg.+7',}}

    ApogeeBody = {}
        ApogeeBody.MAB = { name="Apogee Dalmatica", augments={'MP+60','Pet: "Mag.Atk.Bns."+30','Blood Pact Dmg.+7',}}
        ApogeeBody.ATT = ApogeeBody.MAB

    ApogeeHead = {}
        ApogeeHead.MAB = { name="Apogee Crown", augments={'MP+60','Pet: "Mag.Atk.Bns."+30','Blood Pact Dmg.+7',}}
        ApogeeHead.ATT = { name="Apogee Crown", augments={'MP+60','Pet: Attack+30','Blood Pact Dmg.+7',}}

    ApogeeLegs = {}
        ApogeeLegs.ATT = { name="Apogee Slacks", augments={'MP+60','Pet: Attack+30','Blood Pact Dmg.+7',}}
        ApogeeLegs.MAB = ApogeeLegs.ATT

    ---------------------
    -- JA PRECAST SETS --
    ---------------------

    sets.precast.JA['Astral Flow'] = {head="Glyphic Horn +1"}
    sets.precast.JA['Mana Cede'] = {hands="Beckoner's Bracers +1"}

    sets.precast.JA['Elemental Siphon'] = {main="Espiritus",sub="Vox Grip",ammo="Esper Stone +1",
        head="Telchine Cap",neck="Incanter's Torque",ear1="Summoning Earring",ear2="Andoaa earring",
        body="Beckoner's Doublet +1",hands="Lamassu Mitts +1",ring1="Zodiac Ring",ring2="Evoker's Ring",
	    back="Conveyance Cape",waist="Kobo Obi",legs="Beckoner's Spats +1",feet="Beckoner's Pigaches +1"}

    --------------------------
    -- BLOOD PACT GEAR SETS --
    --------------------------


    sets.precast.BloodPact = {
        main=Espiritus.MAB,
        sub="Elan Strap +1",
        ammo="Sancus Sachet +1",
        head="Beckoner's Horn",
        body="Con. Doublet +1",
        legs="Glyphic Spats +1",
        left_ring="Evoker's Ring",
        back=Conveyance.BPAD,
        feet="Glyphic pigaches +1"
    }

    sets.midcast.Pet.TPBonus = {}
	
	sets.midcast.Pet.WS =  {
        main=Gridarvor.ATT,
        sub="Elan Strap +1",
        head=ApogeeHead.ATT,
        body="Con. Doublet +1",
        hands=Merlinic.ATT,
        legs=ApogeeLegs.ATT,
        feet=ApogeeBoots.ATT,
        neck="Empath Necklace",
        waist="Klouskap Sash",
        left_ring="Varar Ring",
        right_ring="Varar Ring",
        back=Campestres.ATT,
    }

    sets.midcast.Pet.MedAcc = set_combine(sets.midcast.Pet.WS, {
        ear2="Enmerkar Earring",
        waist="Incarnation Sash"})

    sets.midcast.Pet.HighAcc = set_combine(sets.midcast.Pet.WS, {
        waist="Klouskap Sash"})

    sets.midcast.Pet.MaxAcc = set_combine(sets.midcast.Pet.WS, {
        })

    sets.midcast.Pet.MABBloodPact = {
        ammo="Sancus Sachet +1",
        neck="Eidolon pendant +1",
        head=ApogeeHead.MAB,
        body=ApogeeBody.MAB,
        hands=Merlinic.MAB,
        feet=ApogeeBoots.MAB,
        waist="Lucidity Sash",
        left_ring="Varar Ring",
        right_ring="Varar Ring",
        back=Campestres.MAB
    }
	
	sets.midcast.Pet.HybridBloodPact = {
        main=Espiritus.MAB,
        sub="Elan Strap +1",
        ammo="Sancus Sachet +1",
        head=ApogeeHead.MAB,
        neck="Eidolon pendant +1",
        body=ApogeeBody.MAB,
        hands=Merlinic.MAB,
        feet=ApogeeBoots.MAB,
        waist="Klouskap Sash",
        left_ring="Varar Ring",
        right_ring="Varar Ring",
        back=Campestres.MAB
    }

    sets.midcast.Pet.MABBloodPact.MedAcc = set_combine(sets.midcast.Pet.MABBloodPact, {
        ear2="Enmerkar Earring"})

    sets.midcast.Pet.MABBloodPact.HighAcc = set_combine(sets.midcast.Pet.MABBloodPact, {
        })

    sets.midcast.Pet.MABBloodPact.MaxAcc = set_combine(sets.midcast.Pet.MABBloodPact, {
        })

    sets.midcast.Pet.MagicAccReady = set_combine(sets.midcast.Pet.WS, {
        neck="Adad Amulet",ear1="Sapphire Earring",ear2="Enmerkar Earring",waist="Incarnation Sash"})

    sets.midcast.Pet.MultiStrike = set_combine(sets.midcast.Pet.WS, {
        ear2="Domesticator's Earring",waist="Incarnation Sash"})

    sets.midcast.Pet.Buff = {
        main=Espiritus.MAB,
        sub="Vox Strap",
        ammo="Sancus Sachet +1",
        head="Beckoner's Horn",
        hands="Lamassu Mitts",
        legs="Beckoner's Spats",
        waist="Lucidity Sash",
        left_ring="Evoker's Ring",
        right_ring="Fervor Ring",
        back=Conveyance.BPAD,
    }

    ---------------
    -- IDLE SETS --
    ---------------
    
    sets.idle = set_combine(sets.idle.Pet, {feet="Herald's Gaiters"})

    sets.idle.Pet = {
        main=Gridarvor.ATT,
        head="Beckoner's Horn",
        body="Shomonjijoe +1",
        hands="Asteria Mitts +1",
        legs="Assid. Pants +1",
        feet=ApogeeBoots.MAB,
        neck="Caller's Pendant",
        waist="Lucidity Sash",
        left_ear="Evans Earring",
        left_ring="Evoker's Ring",
        back=Campestres.MAB
    }

    sets.idle.Pet.Engaged = sets.idle.Pet

    sets.idle.Pet.CaitSith = {hands="Lamassu Mitts +1"}

    sets.resting = {}

    ------------------
    -- DEFENSE SETS --
    ------------------

    -- Pet PDT and MDT sets:
    sets.defense.PetDT = {}

    -- Master PDT and MDT sets:
    sets.defense.PDT = {}

    sets.defense.MDTShell = {}

    sets.defense.MEva = set_combine(sets.defense.MDT, {})

    sets.Kiting = {feet="Herald's Gaiters"}

    --------------------
    -- FAST CAST SETS --
    --------------------

    sets.precast.FC = {}

    ------------------
    -- MIDCAST SETS --
    ------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.Cure = {}

	sets.midcast['Enhancing Magic'] = {}
	
	sets.engaged = {}
	
	
    sets.midcast.Cursna = set_combine(sets.midcast.FastRecast, {})

    sets.midcast.Protect = set_combine(sets.midcast['Enhancing Magic'], {})
    sets.midcast.Protectra = sets.midcast.Protect

    sets.midcast.Shell = set_combine(sets.midcast['Enhancing Magic'], {})
    sets.midcast.Shellra = sets.midcast.Shell

    sets.midcast['Enfeebling Magic'] = {}
		
	sets.midcast.Refresh = {}

    sets.midcast['Elemental Magic'] = {}

    ------------------
    -- ENGAGED SETS --
    ------------------

    sets.engaged = {}

    --------------------
    -- MASTER WS SETS --
    --------------------

    sets.precast.WS = {}

    sets.midcast.ExtraMAB = {}

    ----------------
    -- OTHER SETS --
    ----------------

end



-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks that are called to process player actions at specific points in time.
-------------------------------------------------------------------------------------------------------------------

function job_pretarget(spell)
checkblocking(spell)
end


function job_precast(spell, action, spellMap, eventArgs)
-- Define class for Blood Pacts.
    if blood_pact_list:contains(spell.name) then
        classes.CustomClass = "WS"
 
        if state.LagMode.value == 'Lag' then
            if physical_blood_pacts:contains(spell.name) then
                if state.OffenseMode.value == 'MaxAcc' then
                    equip(sets.midcast.Pet.MaxAcc, sets.precast.BloodPact)
                elseif state.OffenseMode.value == 'HighAcc' then
                    equip(sets.midcast.Pet.HighAcc, sets.precast.BloodPact)
                elseif state.OffenseMode.value == 'MedAcc' then
                    equip(sets.midcast.Pet.MedAcc, sets.precast.BloodPact)
                else
                    if multi_hit_blood_pacts:contains(spell.name) then
                        equip(set_combine(sets.midcast.Pet.MultiStrike, sets.precast.BloodPact))
                    else
                        equip(set_combine(sets.midcast.Pet.WS, sets.precast.BloodPact))
                    end
                end
            end

            if magic_atk_blood_pacts:contains(spell.name) then
                equip(sets.midcast.Pet.MABBloodPact, sets.precast.BloodPact)
            end

            if magic_acc_blood_pacts:contains(spell.name) then
                equip(sets.midcast.Pet.MagicAccReady, sets.precast.BloodPact)
            end

            if pet_buff_moves:contains(spell.name) then
                equip(sets.midcast.Pet.Buff, sets.precast.BloodPact)
            end

            -- If Pet TP, before bonuses, is less than a certain value then equip Nukumi Manoplas +1.
            if (physical_blood_pacts:contains(spell.name) or magic_atk_blood_pacts:contains(spell.name)) and state.OffenseMode.value ~= 'MaxAcc' then
                if tp_based_blood_pacts:contains(spell.name) and pet_tp < 2000 then
                    equip(sets.midcast.Pet.TPBonus)
                end
            end
        eventArgs.handled = true
        else
            if state.StaffMode.value == 'PetOnly' and not buffactive['Astral Conduit']then
                equip(sets.precast.BloodPact)
            end
        end
    end

    
    if player.equipment.main == 'Nirvana' then
        custom_aftermath_timers_precast(spell)
    end

    if spell.type == "WeaponSkill" and spell.target.distance > target_distance then
        cancel_spell()
        add_to_chat(123, spell.name..' Canceled: [Out of Range]')
        handle_equipping_gear(player.status)
        return
    end

end

function customize_melee_set(meleeSet)
    if state.StaffMode.value == 'PetOnly' and player.status == "Engaged" then
        if state.DefenseMode.value == "Physical" and state.PhysicalDefenseMode.value == "PetDT" then
            meleeSet = set_combine(meleeSet, sets.defense.PetDT)
        elseif state.DefenseMode.value == "None" then
            meleeSet = set_combine(meleeSet, sets.idle.Pet)
        end
    end
    return meleeSet
end

function job_post_precast(spell, action, spellMap, eventArgs)
end

function job_midcast(spell, action, spellMap, eventArgs)
    if state.StaffMode.value == 'PetOnly' then
        if spell.english == "Cure" or spell.english == "Cure II" or spell.english == "Cure III" or spell.english == "Cure IV" then
            equip(sets.CurePetOnly)
        end
        if spell.english == "Curaga" or spell.english == "Curaga II" or spell.english == "Curaga III" then
            equip(sets.CurePetOnly)
        end
    end
end

-- Return true if we handled the aftercast work.  Otherwise it will fall back
-- to the general aftercast() code in Mote-Include.
function job_aftercast(spell, action, spellMap, eventArgs)
    if blood_pact_list:contains(spell.name) and not spell.interrupted then
        if physical_blood_pacts:contains(spell.name) then
            if state.OffenseMode.value == 'MaxAcc' then
                equip(sets.midcast.Pet.MaxAcc)
            elseif state.OffenseMode.value == 'HighAcc' then
                equip(sets.midcast.Pet.HighAcc)
            elseif state.OffenseMode.value == 'MedAcc' then
                equip(sets.midcast.Pet.MedAcc)
            else
                if multi_hit_blood_pacts:contains(spell.name) then
                    equip(sets.midcast.Pet.MultiStrike)
                else
                    equip(sets.midcast.Pet.WS)
                end
            end
        end

        if magic_atk_blood_pacts:contains(spell.name) then
            equip(sets.midcast.Pet.MABBloodPact)
        end

        if magic_acc_blood_pacts:contains(spell.name) then
            equip(sets.midcast.Pet.MagicAccReady)
        end

        if pet_buff_moves:contains(spell.name) then
            equip(sets.midcast.Pet.Buff)
        end

        -- If Pet TP, before bonuses, is less than a certain value then equip Enticer's pants for certain pacts.
        if (physical_blood_pacts:contains(spell.name) or magic_atk_blood_pacts:contains(spell.name)) and state.OffenseMode.value ~= 'MaxAcc' then
            if tp_based_blood_pacts:contains(spell.name) then
                if pet_tp < 1300 then
                    equip(sets.midcast.Pet.TPBonus)
                end
            end
        end
    eventArgs.handled = true
    end

    if spell.english == 'Assault' then
        if not spell.interrupted then
            pet_info_update()
        end
    end

    if spell.english == "Release" and not spell.interrupted then
        PetName = 'None';PetJob = 'None';PetInfo = 'None';BloodPactOne = 'None';BloodPactTwo = 'None';BloodPactThree = 'None';BloodPactFour = 'None'
    end

    if player.equipment.main == 'Nirvana' then
        custom_aftermath_timers_aftercast(spell)
    end
end

function job_pet_midcast(spell, action, spellMap, eventArgs)
    eventArgs.handled = true
end

function job_pet_aftercast(spell, action, spellMap, eventArgs)
    --eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Customization hook for idle sets.
-------------------------------------------------------------------------------------------------------------------

function customize_idle_set(idleSet)
    if pet.isvalid and pet.status ~= "Engaged" and state.DefenseMode.value ~= "Physical" then
        idleSet = set_combine(idleSet, sets.idle.Pet)
        return idleSet
    elseif pet.isvalid and pet.status == "Engaged" and state.DefenseMode.value ~= "Physical" then
        idleSet = set_combine(idleSet, sets.idle.Pet.Engaged)
        return idleSet
    else
        return idleSet
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Hooks for Reward, Correlation, Treasure Hunter, and Pet Mode handling.
-------------------------------------------------------------------------------------------------------------------

function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Treasure Mode' then
        state.TreasureMode:set(newValue)
    elseif stateField == 'Pet Mode' then
        state.CombatWeapon:set(newValue)
    end
end

function get_custom_wsmode(spell, spellMap, default_wsmode)

end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called any time we attempt to handle automatic gear equips (ie: engaged or idle gear).
function job_handle_equipping_gear(playerStatus, eventArgs)    	
	disable_specialgear()

	if state.TPMode.value == "WeaponLock" then
	  equip({main=weaponlock_main,sub=weaponlock_sub})
	  disable("main")
	  disable("sub")
	else
	  enable("main")
	  enable("sub")
	end


end


-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    get_combat_form()
    get_melee_groups()
    pet_info_update()
    update_display_mode_info()
end

-- Updates gear based on pet status changes.
function job_pet_status_change(newStatus, oldStatus, eventArgs)
    if newStatus == 'Idle' or newStatus == 'Engaged' then
        if state.DefenseMode.value ~= "Physical" and state.DefenseMode.value ~= "Magical" then
            handle_equipping_gear(player.status)
        end
    end

    if pet.hpp == 0 then
        PetName = 'None';PetJob = 'None';PetInfo = 'None';BloodPactOne = 'None';BloodPactTwo = 'None';BloodPactThree = 'None';BloodPactFour = 'None'
    end

    customize_melee_set(meleeSet)
    pet_info_update()
end 

function job_buff_change(status, gain, gain_or_loss)
    --Equip Sacrifice Torque if we're asleep and have an active avatar.
    if (status == "sleep" and gain_or_loss) and pet.hpp ~= 0 then
        if gain then
            equip(sets.SacrificeTorque)
        else
            handle_equipping_gear(player.status)
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Ready Move Presets and Pet TP Evaluation Functions - Credit to Bomberto and Verda
-------------------------------------------------------------------------------------------------------------------

pet_tp=0
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'bloodpact' then
        pet_info_update()
        blood_pact(cmdParams)
        eventArgs.handled = true
    end
    if cmdParams[1] == 'summonavatar' then
        if state.AvatarMode.value == 'Cait Sith' then
            send_command('input /ma "Cait Sith" <me>')
        else
            send_command('input /ma '..state.AvatarMode.value..' <me>')
        end
    end
    if cmdParams[1]:lower() == 'siphon' then
        handle_siphoning()
        eventArgs.handled = true
    end
    if cmdParams[1] == 'pet_tp' then
	    pet_tp = tonumber(cmdParams[2])
    end
end
 
function blood_pact(cmdParams)
    local pact = cmdParams[2]:lower()
    local BloodPact = ''
    if pact == 'one' or pact == "1" then
        BloodPact = BloodPactOne
    elseif pact == 'two' or pact == "2" then
        BloodPact = BloodPactTwo
    elseif pact == 'three' or pact == "3" then
        BloodPact = BloodPactThree
    elseif pact == 'four' or pact == "4" then
        BloodPact = BloodPactFour
    end
    if pet_buff_moves:contains(BloodPact) then
        send_command('input /pet "'.. BloodPact ..'" <me>')
    else
        send_command('input /pet "'.. BloodPact ..'" <t>')
    end
end

pet_tp = 0
--Fix missing Pet.TP field by getting the packets from the fields lib
packets = require('packets')
function update_pet_tp(id,data)
    if id == 0x068 then
        pet_tp = 0
        local update = packets.parse('incoming', data)
        pet_tp = update["Pet TP"]
        windower.send_command('lua c gearswap c pet_tp '..pet_tp)
    end
end
id = windower.raw_register_event('incoming chunk', update_pet_tp)

-------------------------------------------------------------------------------------------------------------------
-- Current Job State Display
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    local msg = 'Melee'
    
    if state.CombatForm.has_value then
        msg = msg .. ' (' .. state.CombatForm.value .. ')'
    end
    
    msg = msg .. ': '
    
    msg = msg .. state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        msg = msg .. '/' .. state.HybridMode.value
    end
    msg = msg .. ', WS: ' .. state.WeaponskillMode.value
    
    if state.DefenseMode.value ~= 'None' then
        msg = msg .. ', ' .. 'Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
    end
    
    if state.Kiting.value then
        msg = msg .. ', Kiting'
    end

    if state.AvatarMode.value ~= 'None' then
        add_to_chat(8,'-- Avatar: '.. PetName ..' -- (Info: '.. PetInfo ..', '.. PetJob ..')')
    end

    add_to_chat(28,'Blood Pacts: 1.'.. BloodPactOne ..'   2.'.. BloodPactTwo ..'   3.'.. BloodPactThree ..'   4.'.. BloodPactFour ..'')
    add_to_chat(122, msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Custom uber-handling of Elemental Siphon
function handle_siphoning()
    if areas.Cities:contains(world.area) then
        add_to_chat(122, 'Cannot use Elemental Siphon in a city area.')
        return
    end
 
    local siphonElement
    local stormElementToUse
    local releasedAvatar
    local dontRelease
   
    -- If we already have a spirit out, just use that.
    if pet.isvalid and spirits:contains(pet.name) then
        siphonElement = pet.element
        dontRelease = true
        -- If current weather doesn't match the spirit, but the spirit matches the day, try to cast the storm.
        if player.sub_job == 'SCH' and pet.element == world.day_element and pet.element ~= world.weather_element then
--            if not S{'Light','Dark','Lightning'}:contains(pet.element) then
--                stormElementToUse = pet.element
--            end
	    stormElementToUse = pet.element
        end
    -- If we're subbing /sch, there are some conditions where we want to make sure specific weather is up.
    -- If current (single) weather is opposed by the current day, we want to change the weather to match
    -- the current day, if possible.
    elseif player.sub_job == 'SCH' and world.weather_element ~= 'None' then
        -- We can override single-intensity weather; leave double weather alone, since even if
        -- it's partially countered by the day, it's not worth changing.
        if get_weather_intensity() == 1 then
            -- If current weather is weak to the current day, it cancels the benefits for
            -- siphon.  Change it to the day's weather if possible (+0 to +20%), or any non-weak
            -- weather if not.
            -- If the current weather matches the current avatar's element (being used to reduce
            -- perpetuation), don't change it; just accept the penalty on Siphon.
            if world.weather_element == elements.weak_to[world.day_element] and
                (not pet.isvalid or world.weather_element ~= pet.element) then
                -- We can't cast lightning/dark/light weather, so use a neutral element
--                if S{'Light','Dark','Lightning'}:contains(world.day_element) then
--                    stormElementToUse = 'Wind'
--                else
--                    stormElementToUse = world.day_element
--                end
		stormElementToUse = world.day_element
            end
        end
    end
   
    -- If we decided to use a storm, set that as the spirit element to cast.
    if stormElementToUse then
        siphonElement = stormElementToUse
    elseif world.weather_element ~= 'None' and (get_weather_intensity() == 2 or world.weather_element ~= elements.weak_to[world.day_element]) then
        siphonElement = world.weather_element
    else
        siphonElement = world.day_element
    end
   
    local command = ''
    local releaseWait = 0
    local elementused = ''
   
    if pet.isvalid and avatars:contains(pet.name) then
        command = command..'input /pet "Release" <me>;wait 1.1;'
        releasedAvatar = pet.name
        releaseWait = 10
    end
   
    if stormElementToUse then
        command = command..'input /ma "'..elements.storm_of[stormElementToUse]..'" <me>;wait 5;'
        releaseWait = releaseWait - 4
	elementused = stormElementToUse
    end
   
    if not (pet.isvalid and spirits:contains(pet.name)) then
        command = command..'input /ma "'..elements.spirit_of[siphonElement]..'" <me>;wait 5;'
        releaseWait = releaseWait - 4
	elementused = siphonElement
    end
   
    command = command..'input /ja "Elemental Siphon" <me>;'
    releaseWait = releaseWait - 1
    releaseWait = releaseWait + 0.1
   
    if not dontRelease then
        if releaseWait > 0 then
            command = command..'wait '..tostring(releaseWait)..';'
        else
            command = command..'wait 1.1;'
        end
       
        command = command..'input /pet "Release" <me>;'
    end
   
    if releasedAvatar then
        if state.AvatarMode.value == 'Cait Sith' then
            command = command..'wait 1.1;input /ma "Cait Sith" <me>'
        else
            command = command..'wait 1.1;input /ma "'..state.AvatarMode.value..'" <me>'
        end
    end
   
    send_command(command)
end

function pet_info_update()
    if pet.isvalid then
        PetName = pet.name

        if pet.name == 'Carbuncle' then
            PetInfo = "Light-based";PetJob = 'WHM';BloodPactOne = 'Poison Nails';BloodPactTwo = 'Holy Mist';BloodPactThree = 'Shining Ruby';BloodPactFour = 'Healing Ruby II'
        elseif pet.name == 'Ifrit' then
            PetInfo = "Fire-based";PetJob = 'BLM';BloodPactOne = 'Flaming Crush';BloodPactTwo = 'Conflag Strike';BloodPactThree = 'Crimson Howl';BloodPactFour = 'Inferno Howl'
        elseif pet.name == 'Shiva' then
            PetInfo = "Ice-based";PetJob = 'BLM';BloodPactOne = 'Rush';BloodPactTwo = 'Heavenly Strike';BloodPactThree = 'Crystal Blessing';BloodPactFour = 'Sleepga'
        elseif pet.name == 'Garuda' then
            PetInfo = "Wind-based";PetJob = 'BLM';BloodPactOne = 'Predator Claws';BloodPactTwo = 'Wind Blade';BloodPactThree = 'Hastega II';BloodPactFour = 'Aerial Armor'
        elseif pet.name == 'Titan' then
            PetInfo = "Earth-based";PetJob = 'BLM';BloodPactOne = 'Crag Throw';BloodPactTwo = 'Geocrush';BloodPactThree = 'Earthen Armor';BloodPactFour = 'Earthen Ward'
        elseif pet.name == 'Ramuh' then
            PetInfo = "Thunder-based";PetJob = 'BLM';BloodPactOne = 'Volt Strike';BloodPactTwo = 'Thunderstorm';BloodPactThree = 'Lightning Armor';BloodPactFour = 'Shock Squall'
        elseif pet.name == 'Leviathan' then
            PetInfo = "Water-based";PetJob = 'BLM';BloodPactOne = 'Spinning Dive';BloodPactTwo = 'Grand Fall';BloodPactThree = 'Soothing Current';BloodPactFour = 'Spring Water'
        elseif pet.name == 'Cait Sith' then
            PetInfo = "Light-based";PetJob = 'WHM';BloodPactOne = 'Regal Gash';BloodPactTwo = 'Level ? Holy';BloodPactThree = 'Mewing Lullaby';BloodPactFour = 'Mewing Lullaby'
        elseif pet.name == 'Fenrir' then
            PetInfo = "Dark-based";PetJob = 'DRK';BloodPactOne = 'Eclipse Bite';BloodPactTwo = 'Impact';BloodPactThree = 'Ecliptic Growl';BloodPactFour = 'Ecliptic Howl'
        elseif pet.name == 'Diabolos' then
            PetInfo = "Dark-based";PetJob = 'BLM';BloodPactOne = 'Nether Blast';BloodPactTwo = 'Camisado';BloodPactThree = 'Dream Shroud';BloodPactFour = 'Noctoshield'
        end
    else
        PetName = 'None';PetJob = 'None';PetInfo = 'None';BloodPactOne = 'None';BloodPactTwo = 'None';BloodPactThree = 'None';BloodPactFour = 'None'
    end
end

function display_mode_info()
    if DisplayModeInfo == true then
        local x = TextBoxX
        local y = TextBoxY
        send_command('text AccuracyText create Acc. Mode: '..state.OffenseMode.value..'')
        send_command('text AccuracyText pos '..x..' '..y..'')
        send_command('text AccuracyText size '..TextSize..'')
        y = y + (TextSize + 6)
        send_command('text StaffModeText create Staff Mode: '..state.StaffMode.value..'')
        send_command('text StaffModeText pos '..x..' '..y..'')
        send_command('text StaffModeText size '..TextSize..'')
        y = y + (TextSize + 6)
        send_command('text AvatarText create Jug Mode: '..state.AvatarMode.value..'')
        send_command('text AvatarText pos '..x..' '..y..'')
        send_command('text AvatarText size '..TextSize..'')
        
    end
end

function update_display_mode_info()
    if DisplayModeInfo == true then
        send_command('text AccuracyText text Acc. Mode: '..state.OffenseMode.value..'')
        send_command('text StaffModeText text Staff Mode: '..state.StaffMode.value..'')
        send_command('text AvatarText text Jug Mode: '..state.AvatarMode.value..'')
    end
end

function get_melee_groups()
    classes.CustomMeleeGroups:clear()

    if buffactive['Aftermath: Lv.3'] then
        classes.CustomMeleeGroups:append('Aftermath')
    end
end

function get_combat_form()

end

function select_default_macro_book()
    set_macro_page(1, 20)
end
