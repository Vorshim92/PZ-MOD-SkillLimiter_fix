SkillLimiter XP BLOCKING Workflow
1.) SkillLimiter.lua

Events.AddXP.Add(AddXP)
local function AddXP(character, perk, level)
-- quando un perk riceve XP viene chiamata la funzione sottostante
    blockLevel.checkLevelMax(character, perk, CreateCharacterMaxSkillObj)
end


2.) BlockLevel.lua
function BlockLevel.checkLevelMax(character, perk, CreateCharacterMaxSkillObj)
-- dopo i controlli dei parametri viene chiamata la funzione sottostante
    BlockLevel.calculateBlockLevel(character, CreateCharacterMaxSkillObj, perk)
end


function BlockLevel.calculateBlockLevel(character, CreateCharacterMaxSkillObj, perk)
-- viene acquisito il lvl corrente del perk
    local currentPerkLevel = characterPz.getPerkLevel_PZ(character, perk)
-- impostata variabile maxLevel a 10 come massimo lvl per tutti i Perk a prescindere
    local maxLevel = characterPz.EnumNumbers.TEN

-- vengono ciclati tutti i perk del personaggio salvati nell’oggetto all’inizio con SkillLimiter.initCharacter()
    for _, v in pairs(CreateCharacterMaxSkillObj:getPerkDetails()) do
-- una volta trovato il perk corrispondente
        if v:getPerk() == perk then 
-- prima si assicura che non sia già a lvl 10
            if v:getCurrentLevel() == maxLevel then
                return
            end
-- se non è a lvl 10 controlla se è maggiore o uguale al MaxLevel impostato dallo SkillLimiter
            if currentPerkLevel >= v:getMaxLevel() then
-- se lo è fa partire la funzione sottostante
                BlockLevel.blockLevel(character, v:getPerk(), currentPerkLevel, v:getMaxLevel())
            end
        end
    end
end


function BlockLevel.blockLevel(character, perk, currentPerkLevel, maxLevel)
    local convertLevelToXp_ = 0.0

-- inutile controllo già fatto nella funzione precedente… 
    if currentPerkLevel >= maxLevel then
-- ciclo fino al maxLevel consentito per capire a quanto corrisponde il totalXP di tutti i lvl messi assieme
-- se lo skill cap è lvl 4 per quel perk per esempio sarà = lvl 1 75xp, lvl 2 150xp, lvl 3 300xp, lvl 4 750xp, convertLevelToXp_ = 1275
        for level_ = 1, maxLevel do
            convertLevelToXp_ = convertLevelToXp_ +
                    perkFactoryPZ.convertLevelToXp(perk, level_)
        end
    end

-- convertLevelToXp_ sottrati agli XP attuali del perk del giocatore in tempo reale
    local totalXp = ( convertLevelToXp_ -
            characterPz.getXp(character, perk))

    if totalXp == 0 then
        return
    end
-- la differenza viene aggiunta come XP al giocatore (anche se è un valore negativo)
    characterPz.addXP_PZ(character, perk, totalXp, true, false, false)
end

SkillLimiter modData Workflow
1.) SkillLimiter.lua

Events.OnGameStart.Add(OnGameStart)
Events.OnCreatePlayer.Add(OnCreatePlayer)

-- questi 2 eventi triggherano SkillLimiter.initCharacter() che fa:

-- creazione di un oggetto CharacterBaseObj con dentro i dettagli dei perk
CreateCharacterMaxSkillObj =
            characterMaxSkill.getCreateMaxSkill( debugDiagnostics.characterUpdate() )

            -- getCreateMaxSkill(), alla quale viene passato l'isoplayer, richiama a sua volta una funzione characterCreation.getCharacterCreation 
    2.) CharacterCreation.lua

        --getCharacterCreatio:
        characterAllPerks(character)
        mergeTraitPerkFromProfession(character) --roba inutile??
        setNoLimitsGroup()
        setProfessionGroup()
        setGenericGroup()


        --- **Encode ModData**
        characterMaxSkillTable =
            codePerkDetails.encodePerkDetails(CreateCharacterMaxSkillObj)

        --- **Save ModData**
        modDataManager.save(characterMaxSkillModData, characterMaxSkillTable)
