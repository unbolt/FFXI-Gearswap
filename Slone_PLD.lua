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
    state.Buff.Sentinel = buffactive.sentinel or false
    state.Buff.Cover = buffactive.cover or false
    state.Buff.Doom = buffactive.Doom or false
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'PDT', 'Reraise')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Resistant')
    state.PhysicalDefenseMode:options('PDT', 'HP', 'Reraise', 'Charm')
    state.MagicalDefenseMode:options('MDT', 'HP', 'Reraise', 'Charm')
    
    state.ExtraDefenseMode = M{['description']='Extra Defense Mode', 'None', 'MP', 'Knockback', 'MP_Knockback'}
    state.EquipShield = M(false, 'Equip Shield w/Defense')

    update_defense_mode()
    
    send_command('bind ^f11 gs c cycle MagicalDefenseMode')
    send_command('bind !f11 gs c cycle ExtraDefenseMode')
    send_command('bind @f10 gs c toggle EquipShield')
    send_command('bind @f11 gs c toggle EquipShield')

    select_default_macro_book()
end

function user_unload()
    send_command('unbind ^f11')
    send_command('unbind !f11')
    send_command('unbind @f10')
    send_command('unbind @f11')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Precast sets
    --------------------------------------
    
    -- Precast sets to enhance JAs
    sets.precast.JA['Invincible'] = {legs="Caballarius Breeches +1"}
    sets.precast.JA['Holy Circle'] = {feet="Reverence Leggings +1"}
    sets.precast.JA['Shield Bash'] = {hands="Caballarius Gauntlets"}
    sets.precast.JA['Sentinel'] = {feet="Caballarius Leggings +1"}
    sets.precast.JA['Rampart'] = {head="Caballarius Coronet +1"}
    sets.precast.JA['Fealty'] = {body="Caballarius Surcoat +1"}
    sets.precast.JA['Divine Emblem'] = {feet="Creed Sabatons +1"}
    sets.precast.JA['Cover'] = {head="Reverence Coronet +1"}

    -- add mnd for Chivalry
    sets.precast.JA['Chivalry'] = {
        head="Reverence Coronet +1",
        body="Reverence Surcoat +1",
        hands="Reverence Gauntlets +1",
        --ring1="Leviathan Ring",
        --ring2="Aquasoul Ring",
        --back="Weard Mantle",
        legs="Reverence Breeches +1",
        --feet="Whirlpool Greaves"
    }
    

    -- Fast cast sets for spells
    sets.precast.FC = {
        ear2="Loquac. Earring",
        ring1="Lebeche Ring",
        ammo="Incantor Stone",
    }

    sets.precast.Cure = set_combine(sets.precast.FC, {neck="Diemer Gorget"})

       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        range="Ginsen",
        neck="Asperity Necklace",
        ear1="Ishvara Earring",
        ear2="Brutal Earring",
        waist="Kentarch Belt +1",
        ring1="Petrov Ring",
        ring2="Rajas Ring",
        legs="Reverence Breeches +1",

    }

    sets.precast.WS.Acc = sets.precast.WS


    sets.precast.WS['Savage Blade'] = {
        range="Ginsen",
        neck="Asperity Necklace",
        ear1="Ishvara Earring",
        ear2="Brutal Earring",
        waist="Kentarch Belt +1",
        ring1="Petrov Ring",
        ring2="Rajas Ring",
        legs="Reverence Breeches +1",
    }

    sets.precast.WS['Sanguine Blade'] = {
        ammo="Ginsen",
        head="Reverence Coronet +1",
       -- ear1="Friomisi Earring",
        --ear2="Hecate's Earring",
        body="Reverence Surcoat +1",
        hands="Reverence Gauntlets +1",
        --ring1="Shiva Ring",
       -- ring2="K'ayres Ring",
        --back="Toro Cape",
       -- waist="Caudata Belt",
        legs="Reverence Breeches +1",
        feet="Reverence Leggings +1"
    }
    
    sets.precast.WS['Atonement'] = {
        --ammo="Iron Gobbet",
        head="Reverence Coronet +1",
        --neck=gear.ElementalGorget,
        --ear1="Creed Earring",
        ear2="Steelflash Earring",
        body="Reverence Surcoat +1",
        hands="Reverence Gauntlets +1",
        ring1="Rajas Ring",
        --ring2="Vexer Ring",
        --back="Fierabras's Mantle",
        --waist=gear.ElementalBelt,
        legs="Reverence Breeches +1",
        feet="Caballarius Leggings +1"
    }
    
    --------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.midcast = {
        ammo="Staunch Tathlum",
        head="Souveran Schaller +1",
        neck="Moonbeam Necklace",
        ear2="Knightly Earring",
        hands="Souveran Handschuhs +1",
        waist="Creed Baudrier",
        legs="Carmine Cuisses +1",
        feet="Odyssean Greaves"
    }
    
    sets.midcast.Stun = sets.midcast.Flash
    
    sets.midcast.Cure = set_combine(sets.midcast, {
        ear1="Mendicant's Earring"
    })

    sets.midcast['Enhancing Magic'] = {legs="Reverence Breeches +1"}
    
    sets.midcast.Protect = {ring1="Sheltered Ring"}
    sets.midcast.Shell = {ring1="Sheltered Ring"}
    
    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------
    
    sets.resting = {
        neck="Creed Collar",
        ring1="Sheltered Ring",
        ring2="Paguroidea Ring",
        waist="Austerity Belt"
    }
    

    -- Idle sets
    sets.idle = {
        ammo="Staunch Tathlum",
        head="Souveran Schaller +1",
        neck="Wiglen Gorget",
        ear1="Odnowa Earring +1",
        ear2="Thureous Earring",
        body="Reverence Surcoat +1",
        hands="Souveran Handschuhs +1",
        ring1="Warden's Ring",
        ring2="Defending Ring",
        back="Fierabras's Mantle",
        waist="Flume Belt +1",
        legs="Carmine Cuisses +1",
        feet="Souveran Schuhs +1"
    }

    sets.Kiting = {legs="Carmine Cuisses +1"}

    --------------------------------------
    -- Defense sets
    --------------------------------------
    
    -- If EquipShield toggle is on (Win+F10 or Win+F11), equip the weapon/shield combos here
    -- when activating or changing defense mode:
    --sets.PhysicalShield = {main="Anahera Sword",sub="Killedar Shield"} -- Ochain
    --sets.MagicalShield = {main="Anahera Sword",sub="Beatific Shield +1"} -- Aegis

    -- Basic defense sets.
        
    sets.defense.PDT =  {
        ammo="Staunch Tathlum",
        head="Souveran Schaller +1",
        neck="Creed Collar",
        ear1="Odnowa Earring +1",
        ear2="Thureous Earring",
        body="Reverence Surcoat +1",
        hands="Souveran Handschuhs +1",
        ring1="Warden's Ring",
        ring2="Defending Ring",
        back="Fierabras's Mantle",
        waist="Flume Belt +1",
        legs="Carmine Cuisses +1",
        feet="Souveran Schuhs +1"
    }
    -- To cap MDT with Shell IV (52/256), need 76/256 in gear.
    -- Shellra V can provide 75/256, which would need another 53/256 in gear.
    sets.defense.MDT =  sets.defense.PDT


    --------------------------------------
    -- Engaged sets
    --------------------------------------
    
    sets.engaged = {
        ammo="Staunch Tathlum",
        head="Souveran Schaller +1",
        neck="Creed Collar",
        ear1="Odnowa Earring +1",
        ear2="Thureous Earring",
        body="Reverence Surcoat +1",
        hands="Souveran Handschuhs +1",
        ring1="Warden's Ring",
        ring2="Defending Ring",
        back="Fierabras's Mantle",
        waist="Flume Belt +1",
        legs="Carmine Cuisses +1",
        feet="Reverence Leggings +1"
    }

    sets.engaged.Acc = sets.engaged


    --------------------------------------
    -- Custom buff sets
    --------------------------------------

    sets.buff.Cover = {head="Reverence Coronet +1", body="Caballarius Surcoat +1"}
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_midcast(spell, action, spellMap, eventArgs)
    -- If DefenseMode is active, apply that gear over midcast
    -- choices.  Precast is allowed through for fast cast on
    -- spells, but we want to return to def gear before there's
    -- time for anything to hit us.
    -- Exclude Job Abilities from this restriction, as we probably want
    -- the enhanced effect of whatever item of gear applies to them,
    -- and only one item should be swapped out.
    if state.DefenseMode.value ~= 'None' and spell.type ~= 'JobAbility' then
        handle_equipping_gear(player.status)
        eventArgs.handled = true
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when the player's status changes.
function job_state_change(field, new_value, old_value)
    classes.CustomDefenseGroups:clear()
    classes.CustomDefenseGroups:append(state.ExtraDefenseMode.current)
    if state.EquipShield.value == true then
        classes.CustomDefenseGroups:append(state.DefenseMode.current .. 'Shield')
    end

    classes.CustomMeleeGroups:clear()
    classes.CustomMeleeGroups:append(state.ExtraDefenseMode.current)
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    update_defense_mode()
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    if state.Buff.Doom then
        idleSet = set_combine(idleSet, sets.buff.Doom)
    end
    
    return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if state.Buff.Doom then
        meleeSet = set_combine(meleeSet, sets.buff.Doom)
    end
    
    return meleeSet
end

function customize_defense_set(defenseSet)
    if state.ExtraDefenseMode.value ~= 'None' then
        defenseSet = set_combine(defenseSet, sets[state.ExtraDefenseMode.value])
    end
    
    if state.EquipShield.value == true then
        defenseSet = set_combine(defenseSet, sets[state.DefenseMode.current .. 'Shield'])
    end
    
    if state.Buff.Doom then
        defenseSet = set_combine(defenseSet, sets.buff.Doom)
    end
    
    return defenseSet
end


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
        msg = msg .. ', Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
    end

    if state.ExtraDefenseMode.value ~= 'None' then
        msg = msg .. ', Extra: ' .. state.ExtraDefenseMode.value
    end
    
    if state.EquipShield.value == true then
        msg = msg .. ', Force Equip Shield'
    end
    
    if state.Kiting.value == true then
        msg = msg .. ', Kiting'
    end

    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: '..state.PCTargetMode.value
    end

    if state.SelectNPCTargets.value == true then
        msg = msg .. ', Target NPCs'
    end

    add_to_chat(122, msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function update_defense_mode()
    if player.equipment.main == 'Kheshig Blade' and not classes.CustomDefenseGroups:contains('Kheshig Blade') then
        classes.CustomDefenseGroups:append('Kheshig Blade')
    end
    
    if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
        if player.equipment.sub and not player.equipment.sub:contains('Shield') and
           player.equipment.sub ~= 'Aegis' and player.equipment.sub ~= 'Ochain' then
            state.CombatForm:set('DW')
        else
            state.CombatForm:reset()
        end
    end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'WAR' then
        set_macro_page(1, 6)
    elseif player.sub_job == 'BLU' then
        set_macro_page(2, 6)
    elseif player.sub_job == 'RDM' then
        set_macro_page(3, 6)
    else
        set_macro_page(1, 6)
    end
end
