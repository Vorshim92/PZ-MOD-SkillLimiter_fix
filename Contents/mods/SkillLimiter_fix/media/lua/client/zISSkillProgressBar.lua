local original_skillRenderPerk = ISSkillProgressBar.renderPerkRect

function ISSkillProgressBar:renderPerkRect()
    original_skillRenderPerk(self)
    local listPerksLimit = getPlayer():getModData().skillLimiter
    self.SkillLimitRect = getTexture("media/ui/SkillLimit.png")
    
    if not listPerksLimit then
        print("checkSkillLimiter: SkillLimiter non è definito o non è una tabella")
        return
    end
    local perkData = listPerksLimit[self.perk:getId()]
    if perkData then
        local limitLevel = perkData["maxLevel"]
        -- Calculate the x position based on the limit level
        local skillX = (limitLevel - 1) * 20
        self:drawTexture(self.SkillLimitRect, skillX, 0, 1, 1, 1, 1)
    end

end