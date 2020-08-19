-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'PDT', 'Reraise')
    state.WeaponskillMode:options('Normal', 'Acc', 'Mod')
    state.PhysicalDefenseMode:options('PDT', 'Reraise')

    update_combat_form()

    select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()

end


-- Define sets and vars used by this job file.
function init_gear_sets()

    -- Define our cloaks
    --Smertrios = {}
    --    Smertrios.WS = {name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Attack+10','Weapon skill damage +10%',}}
    --    Smertrios.TP = {name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+7','"Store TP"+10',}}

    --------------------------------------
    -- Start defining the sets
    --------------------------------------
    
    -- Precast Sets
    -- Precast sets to enhance JAs
    --sets.precast.JA.Meditate = {head="Myochin Kabuto",hands="Sakonji Kote"}
    --sets.precast.JA['Warding Circle'] = {head="Myochin Kabuto"}
    --sets.precast.JA['Blade Bash'] = {hands="Sakonji Kote"}


    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        ammo="Knobkierrie",
		left_ear="Thrud Earring",
        right_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
        body={ name="Valorous Mail", augments={'"Fast Cast"+4','Mag. Acc.+22','Weapon skill damage +6%','Accuracy+10 Attack+10',}},
        hands={ name="Odyssean Gauntlets", augments={'Attack+23','Weapon skill damage +4%','DEX+10','Accuracy+9',}},
		ring1="Karieyh Ring",
		ring2="Flamma Ring",
        legs={ name="Valor. Hose", augments={'Attack+18','Weapon skill damage +5%','Accuracy+5',}},
        feet="Sulev. Leggings +2"
    }
    sets.precast.WS.Acc = set_combine(sets.precast.WS, {})

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {waist="Thunder Belt"})


    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {}

    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    sets.idle = {
		head={ name="Souv. Schaller +1", augments={'HP+105','VIT+12','Phys. dmg. taken -4',}},
		body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs="Pumm. Cuisses +2",
		feet="Sulev. Leggings +2",
		neck="Homeric Gorget",
		left_ear="Odnowa Earring +1",
		left_ring="Karieyh Ring",
		right_ring="Flamma Ring",
	}
    
    -- Defense sets
    sets.defense = {}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
    -- Delay 450 GK, 25 Save TP => 65 Store TP for a 5-hit (25 Store TP in gear)
    sets.engaged = {
        main="Kaja Sword",
        sub={ name="Renaud's Axe +2", augments={'TP Bonus +1000',}},
        ammo="Ginsen",
        head="Flam. Zucchetto +2",
        body={ name="Valorous Mail", augments={'Accuracy+1 Attack+1','"Dbl.Atk."+5','DEX+10','Accuracy+3',}},
        hands={ name="Emi. Gauntlets +1", augments={'Accuracy+25','"Dual Wield"+6','Pet: Accuracy+25',}},
        legs="Pumm. Cuisses +2",
        feet="Pumm. Calligae +2",
        neck={ name="War. Beads +1", augments={'Path: A',}},
        waist="Ioskeha Belt",
        left_ear="Suppanomimi",
        right_ear="Brutal Earring",
        ring2="Flamma Ring",
        ring1="Petrov Ring",
        back="Cichol's Mantle",
    }
    
    --sets.buff.Sekkanoki = {hands="Unkai Kote +2"}
    --sets.buff.Sengikori = {feet="Unkai Sune-ate +2"}
    --sets.buff['Meikyo Shisui'] = {feet="Sakonji Sune-ate"}
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    -- Effectively lock these items in place.
    if state.HybridMode.value == 'Reraise' or
        (state.DefenseMode.value == 'Physical' and state.PhysicalDefenseMode.value == 'Reraise') then
        equip(sets.Reraise)
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    update_combat_form()
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)

end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function update_combat_form()
    if areas.Adoulin:contains(world.area) and buffactive.ionis then
        state.CombatForm:set('Adoulin')
    else
        state.CombatForm:reset()
    end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'NIN' then
        set_macro_page(1, 2)
    elseif player.sub_job == 'SAM' then
        set_macro_page(2, 2)
    elseif player.sub_job == 'THF' then
        set_macro_page(3, 2)
    elseif player.sub_job == 'DNC' then
        set_macro_page(4, 2)
    else
        set_macro_page(1, 2)
    end
end
