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


    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {}

    sets.precast.WS.Acc = set_combine(sets.precast.WS, {})

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    -- sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {waist="Thunder Belt"})


    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {}

    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    sets.idle = {
        legs={ name="Carmine Cuisses +1", augments={'HP+80','STR+12','INT+12',}}
    }
    
    -- Defense sets
    sets.defense = {}

    -- Engaged sets
    sets.engaged = {
        main={ name="Aettir", augments={'Accuracy+70','Mag. Evasion+50','Weapon skill damage +10%',}},
        sub="Refined Grip +1",
        ammo="Staunch Tathlum",
        head={ name="Fu. Bandeau +1", augments={'Enhances "Battuta" effect',}},
        body={ name="Futhark Coat +1", augments={'Enhances "Elemental Sforzo" effect',}},
        hands="Turms Mittens +1",
        legs="Eri. Leg Guards +1",
        feet="Erilaz Greaves +1",
        neck={ name="Futhark Torque +1", augments={'Path: A',}},
        waist="Flume Belt +1",
        left_ear="Odnowa Earring +1",
        right_ear="Tuisto Earring",
        left_ring="Moonbeam Ring",
        right_ring="Defending Ring",
        back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},
    }
    
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
    if player.sub_job == 'DRK' then
        set_macro_page(1, 10)
    elseif player.sub_job == 'BLU' then
        set_macro_page(2, 10)
    elseif player.sub_job == 'THF' then
        set_macro_page(3, 10)
    elseif player.sub_job == 'DNC' then
        set_macro_page(4, 10)
    else
        set_macro_page(1, 10)
    end
end
