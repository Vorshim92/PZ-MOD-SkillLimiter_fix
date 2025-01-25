local original_skillRenderPerk = ISSkillProgressBar.renderPerkRect
local isB42 = false
local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local SKILL_POINT_HGT = math.floor((FONT_HGT_SMALL + 6)/2)
local SKILL_POINT_SPACING = getCore():getOptionFontSize()
if getActivatedMods():contains("skillb42") then
    isB42 = true
end

function ISSkillProgressBar:renderPerkRect()
    original_skillRenderPerk(self)
    local listPerksLimit = getPlayer():getModData().skillLimiter
    -- self.SkillLimitRect = getTexture("media/ui/SkillLimit"..(isB42 and "42" or "")..".png")
    
    if not listPerksLimit then
        --print("checkSkillLimiter: SkillLimiter non è definito o non è una tabella")
        return
    end
    local perkData = listPerksLimit[self.perk:getId()]
    if perkData then
        local limitLevel = perkData["maxLevel"]
        -- Calculate the x position based on the limit level
        local skillX = (limitLevel - 1) * (isB42 and SKILL_POINT_HGT+SKILL_POINT_SPACING or 20)
        if isB42 then
            self:drawTextureScaled(self.SkillUnitBorder, skillX, 0, SKILL_POINT_HGT, SKILL_POINT_HGT, 1, 1, 0, 0)
        else
            self:drawTexture(self.SkillBtnEmptWhitey, skillX, 0, 1, 1, 0, 0)
        end
    end
end
