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
    state.Buff['Afflatus Solace'] = buffactive['Afflatus Solace'] or false
    state.Buff['Afflatus Misery'] = buffactive['Afflatus Misery'] or false
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('None', 'Normal')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT')

    select_default_macro_book()
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    -- Precast Sets

    -- Fast cast sets for spells
    sets.precast.FC = {
        ammo="Incantor Stone",
        right_ear="Loquac. Earring",
        hands={ name="Fanatic Gloves", augments={'MP+5','"Fast Cast"+7',}},
        waist="Embla Sash",
        back="Swith Cape",
    }


    sets.precast.FC['Healing Magic'] = set_combine(sets.precast.FC, {legs="Orison Pantaloons +1"})

    sets.precast.FC.StatusRemoval = sets.precast.FC['Healing Magic']

    sets.precast.FC.Cure = set_combine(sets.precast.FC['Healing Magic'], {})
    sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC.CureSolace = sets.precast.FC.Cure
    -- CureMelee spell map should default back to Healing Magic.
    
    -- Precast sets to enhance JAs
    sets.precast.JA.Benediction = {body="Piety Briault"}


    -- Midcast Sets
    
    sets.midcast.FastRecast = {
        back="Swith Cape"
    }
    
    -- Cure sets
    sets.midcast.CureSolace = {
        main="Chatoyant Staff",
        sub="Giuoco Grip",
        ammo="Incantor Stone",
        head={ name="Vanya Hood", augments={'MP+50','"Cure" potency +7%','Enmity-6',}},
        body="Orison Bliaud +1",
        hands="Theophany Mitts +2",
        legs="Orsn. Pantaln. +1",
        feet={ name="Vanya Clogs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
        neck="Cleric's Torque",
        waist="Korin Obi",
        left_ear="Mendi. Earring",
        right_ear="Nourish. Earring +1",
        left_ring="Janniston Ring",
        right_ring="Mediator's Ring",
        back={ name="Alaunus's Cape", augments={'MND+20','Eva.+20 /Mag. Eva.+20','MND+10','"Cure" potency +10%',}},
    }

    sets.midcast.Cure = sets.midcast.CureSolace
    sets.midcast.Curaga = sets.midcast.CureSolace

    sets.midcast.CureMelee = sets.midcast.CureSolace

    sets.midcast.Cursna = {
        body="Orison Bliaud +1",
        hands={ name="Fanatic Gloves", augments={'MP+5','"Fast Cast"+7',}},
        left_ring="Ephedra Ring",
        right_ring="Sirona's Ring",
        legs="Theo. Pantaloons"
    }

    sets.midcast.StatusRemoval = {
		neck="Cleric's Torque",
        legs="Orison Pantaloons +1"
    }

    -- 110 total Enhancing Magic Skill; caps even without Light Arts
    sets.midcast['Enhancing Magic'] = {}

    sets.midcast.Stoneskin = {}

    sets.midcast.Auspice = {}

    sets.midcast.BarElement = {
        body="Orison Bliaud +1"
    }

    sets.midcast.Regen = {}

    sets.midcast.Protectra = {}

    sets.midcast.Shellra = {}


    sets.midcast['Divine Magic'] = {}

    sets.midcast['Dark Magic'] = {}

    -- Custom spell classes
    sets.midcast.MndEnfeebles = {}

    sets.midcast.IntEnfeebles = {}

    
    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {}
    

    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    sets.idle = {
		main="Malignance Pole",
        sub="Mensch Strap",
        ammo="Incantor Stone",
        head="Inyanga Tiara +2",
        body="Theo. Briault +2",
        hands="Theophany Mitts +2",
        legs="Assid. Pants +1",
        feet="Inyan. Crackows +2",
        neck="Wiglen Gorget",
        waist="Embla Sash",
        left_ear="Mendi. Earring",
        right_ear="Hearty Earring",
        left_ring="Janniston Ring",
        right_ring="Inyanga Ring",
        back={ name="Alaunus's Cape", augments={'MND+20','Eva.+20 /Mag. Eva.+20','MND+10','"Cure" potency +10%',}},
    }

    sets.idle.PDT = sets.idle

    sets.idle.Town = sets.idle
    
    sets.idle.Weak = sets.idle
    
    -- Defense sets

    sets.defense.PDT = {}

    sets.defense.MDT = {}

    sets.Kiting = {feet="Herald's Gaiters"}

    sets.latent_refresh = {}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Basic set for if no TP weapon is defined.
    sets.engaged = {}


    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    sets.buff['Divine Caress'] = {}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if spell.english == "Paralyna" and buffactive.Paralyzed then
        -- no gear swaps if we're paralyzed, to avoid blinking while trying to remove it.
        eventArgs.handled = true
    end
end


function job_post_midcast(spell, action, spellMap, eventArgs)
    -- Apply Divine Caress boosting items as highest priority over other gear, if applicable.
    if spellMap == 'StatusRemoval' and buffactive['Divine Caress'] then
        equip(sets.buff['Divine Caress'])
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Offense Mode' then
        if newValue == 'Normal' then
            disable('main','sub','range')
        else
            enable('main','sub','range')
        end
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if (default_spell_map == 'Cure' or default_spell_map == 'Curaga') and player.status == 'Engaged' then
            return "CureMelee"
        elseif default_spell_map == 'Cure' and state.Buff['Afflatus Solace'] then
            return "CureSolace"
        elseif spell.skill == "Enfeebling Magic" then
            if spell.type == "WhiteMagic" then
                return "MndEnfeebles"
            else
                return "IntEnfeebles"
            end
        end
    end
end


function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    return idleSet
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    if cmdParams[1] == 'user' and not areas.Cities:contains(world.area) then
        local needsArts = 
            player.sub_job:lower() == 'sch' and
            not buffactive['Light Arts'] and
            not buffactive['Addendum: White'] and
            not buffactive['Dark Arts'] and
            not buffactive['Addendum: Black']
            
        if not buffactive['Afflatus Solace'] and not buffactive['Afflatus Misery'] then
            if needsArts then
                send_command('@input /ja "Afflatus Solace" <me>;wait 1.2;input /ja "Light Arts" <me>')
            else
                send_command('@input /ja "Afflatus Solace" <me>')
            end
        end
    end
end


-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    set_macro_page(4, 14)
end
