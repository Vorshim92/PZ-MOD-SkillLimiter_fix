local onlyOnce = true
local isVisible = false
local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)

local function ModalSkillLimiter()
    local texture = getTexture("media/ui/exampleSkillLimiter.png")
    local windowSize = 600+(getCore():getOptionFontSize()*100);
        if texture then
            windowSize = texture:getWidth()
            windowSize = windowSize + (getCore():getOptionFontSize()*100)
        end

    local modalPopup = ISModalRichText:new((getCore():getScreenWidth()-windowSize)/2, getCore():getScreenHeight()/2-300,windowSize,200, getText("UI_SL_Description"), false, nil, function() isVisible = false end);
    modalPopup:initialise();
    modalPopup.backgroundColor = {r=0, g=0, b=0, a=0.9};
    modalPopup.alwaysOnTop = true;
    modalPopup.chatText:paginate();
    modalPopup:setHeightToContents()
    modalPopup:ignoreHeightChange()
    modalPopup:setY(getCore():getScreenHeight()/2-(modalPopup:getHeight()/2));
    modalPopup:setVisible(true);
    modalPopup:addToUIManager();
    isVisible = true
end

-- local original_CharacterCreationProfession_new = CharacterCreationProfession.new
-- function CharacterCreationProfession:new(...)
--     local o = original_CharacterCreationProfession_new(self, ...)
--     o.modalSL = true
--     return o
-- end

local original_CharacterCreationProfession_prerender = CharacterCreationProfession.prerender
function CharacterCreationProfession:prerender()
    original_CharacterCreationProfession_prerender(self)
    if onlyOnce then
        ModalSkillLimiter()
        onlyOnce = false
    end
end

local original_CharacterCreationProfession_create = CharacterCreationProfession.create
function CharacterCreationProfession:create()
    original_CharacterCreationProfession_create(self)
    local buttonHgt = FONT_HGT_SMALL + 3 * 2
    self.SLBtn = ISButton:new(self.infoBtn:getX() - self.infoBtn.width, 15, 70, buttonHgt, "Skill Limiter", self, function()
        if not isVisible then onlyOnce = true end
    end);
    self.SLBtn.internal = "SLINFO";
    self.SLBtn:initialise();
    self.SLBtn:instantiate();
    self.SLBtn:setAnchorLeft(false);
    self.SLBtn:setAnchorRight(true);
    self.SLBtn:setAnchorTop(true);
    self.SLBtn:setAnchorBottom(false);
    self.SLBtn.borderColor = { r = 1, g = 1, b = 1, a = 0.1 };
    
    if self.mainPanel then self.mainPanel:addChild(self.SLBtn)
    else self:addChild(self.SLBtn) end
end