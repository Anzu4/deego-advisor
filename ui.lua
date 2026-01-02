DeegoUI = {}
DeegoUI.view = "summary"
DeegoUI.selectedClass = nil
DeegoUI.selectedSpecName = nil

local frame = CreateFrame("Frame", "DeegoAdvisorFrame", UIParent, "BackdropTemplate")
frame:SetSize(520, 660)
frame:SetPoint("CENTER")
frame:Hide()
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", function(self)
  self:StartMoving()
end)
frame:SetScript("OnDragStop", function(self)
  self:StopMovingOrSizing()
end)
tinsert(UISpecialFrames, "DeegoAdvisorFrame")

frame:SetBackdrop({
  bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
  edgeFile = nil,
  tile = false,
  tileSize = 0,
  edgeSize = 0,
  insets = { left = 0, right = 0, top = 0, bottom = 0 },
})
frame:SetBackdropColor(0, 0, 0, 0.6)

frame.border = CreateFrame("Frame", nil, frame, "BackdropTemplate")
frame.border:SetAllPoints()
frame.border:SetBackdrop({
  edgeFile = "Interface\\Buttons\\WHITE8X8",
  edgeSize = 1,
  insets = { left = 1, right = 1, top = 1, bottom = 1 },
})
frame.border:SetBackdropBorderColor(1, 1, 1, 0.3)

frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
frame.title:SetPoint("TOP", 0, -16)
frame.title:SetText("Deego Advisor")

frame.classBackground = frame:CreateTexture(nil, "BACKGROUND")
frame.classBackground:SetAllPoints()
frame.classBackground:SetTexture("Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES")
frame.classBackground:SetAlpha(0.08)
frame.classBackground:Hide()

frame.gearBackground = frame:CreateTexture(nil, "BACKGROUND")
frame.gearBackground:SetParent(frame.tabBody)
frame.gearBackground:SetAllPoints()
frame.gearBackground:SetTexture("Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES")
frame.gearBackground:SetAlpha(0.12)
frame.gearBackground:Hide()

frame.classBar = CreateFrame("Frame", nil, frame)
frame.classBar:SetSize(500, 82)
frame.classBar:SetPoint("TOP", 0, -40)
frame.classBar.buttons = {}

frame.specBar = CreateFrame("Frame", nil, frame)
frame.specBar:SetSize(480, 68)
frame.specBar:SetPoint("TOP", 0, -130)
frame.specBar.items = {}

frame.specStatsText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
frame.specStatsText:SetPoint("TOP", 0, -198)
frame.specStatsText:SetWidth(480)
frame.specStatsText:SetJustifyH("CENTER")

frame.tabs = CreateFrame("Frame", nil, frame)
frame.tabs:SetSize(480, 52)
frame.tabs:SetPoint("TOP", 0, -216)
frame.tabs.buttons = {}
frame.tabs.selected = "Overall"

frame.tabBody = CreateFrame("Frame", nil, frame)
frame.tabBody:SetSize(480, 420)
frame.tabBody:SetPoint("TOP", 0, -272)
frame.tabBody.items = {}

frame.body = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
frame.body:SetPoint("TOP", 0, -272)
frame.body:SetWidth(480)
frame.body:SetJustifyH("LEFT")
frame.body:SetText("Data not loaded yet. Use /deego to toggle this window.")

frame.close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
frame.close:SetPoint("TOPRIGHT", -4, -4)

local function getClassColor(classTag)
  if not classTag then
    _, classTag = UnitClass("player")
  end
  local classColor = RAID_CLASS_COLORS[classTag]
  if not classColor then
    return "", "", classTag
  end
  local prefix = string.format("|cff%02x%02x%02x", classColor.r * 255, classColor.g * 255, classColor.b * 255)
  return prefix, "|r", classTag
end

local function abbreviateStat(stat)
  if stat == "Mastery" then
    return "Mast"
  end
  return stat
end

local function specShortName(name)
  name = string.gsub(name, " Death Knight$", "")
  name = string.gsub(name, " Demon Hunter$", "")
  name = string.gsub(name, " Druid$", "")
  name = string.gsub(name, " Evoker$", "")
  name = string.gsub(name, " Hunter$", "")
  name = string.gsub(name, " Mage$", "")
  name = string.gsub(name, " Monk$", "")
  name = string.gsub(name, " Paladin$", "")
  name = string.gsub(name, " Priest$", "")
  name = string.gsub(name, " Rogue$", "")
  name = string.gsub(name, " Shaman$", "")
  name = string.gsub(name, " Warlock$", "")
  name = string.gsub(name, " Warrior$", "")
  return name
end

local function statLine(spec)
  local parts = {}
  for _, stat in ipairs(spec.bestStats) do
    table.insert(parts, abbreviateStat(stat))
  end
  return string.format("%s: %s", specShortName(spec.name), table.concat(parts, " > "))
end

local function statPriorityLine(spec)
  local parts = {}
  for _, stat in ipairs(spec.bestStats) do
    table.insert(parts, abbreviateStat(stat))
  end
  return table.concat(parts, " > ")
end

local function matchesSpecName(spec, specName)
  if not specName then
    return true
  end
  return string.find(string.lower(spec.name), string.lower(specName), 1, true) ~= nil
end

local function getPlayerClassSpec()
  local _, classTag = UnitClass("player")
  local specName = nil
  local specIndex = GetSpecialization()
  if specIndex then
    local _, name = GetSpecializationInfo(specIndex)
    specName = name
  end
  return classTag, specName
end

local function updateTitle()
  frame.title:SetText("Deego Advisor")
end

local function classifySourceType(sourceText)
  if not sourceText or sourceText == "" then
    return "unknown"
  end
  local lower = string.lower(sourceText)
  if string.find(lower, "quest") then
    return "quest"
  end
  if string.find(lower, "craft") or string.find(lower, "inscription") or string.find(lower, "leatherworking") or string.find(lower, "blacksmithing") or string.find(lower, "tailoring") then
    return "craft"
  end
  if string.find(lower, "catalyst") or string.find(lower, "vault") or string.find(lower, "raid") or string.find(lower, "tier") then
    return "mixed"
  end
  if string.find(lower, "mythic") or string.find(lower, "dungeon") or string.find(lower, "operation:") then
    return "dungeon"
  end
  if string.find(lower, "halls of") or string.find(lower, "tazavesh") or string.find(lower, "eco%-dome") then
    return "dungeon"
  end
  return "boss"
end

local function formatSource(entry)
  if not entry or not entry.source then
    return "Source unknown"
  end
  local sourceType = entry.sourceType or classifySourceType(entry.source)
  local colors = {
    dungeon = "00ff00",
    boss = "3399ff",
    mixed = "ff3333",
    craft = "ffd100",
    quest = "ffffff",
  }
  local color = colors[sourceType] or "ffffff"
  return string.format("|cff%s%s|r", color, entry.source)
end

local function displaySlotLabel(slot)
  if not slot then
    return ""
  end
  if slot == "Ring 1" or slot == "Ring 2" then
    return "Ring"
  end
  if slot == "Trinket 1" or slot == "Trinket 2" then
    return "Trinket"
  end
  return slot
end

local heroIconCache = {}

local function normalizeHeroKey(name)
  if not name then
    return ""
  end
  return string.lower(name):gsub("[%s%-%_]+", "")
end

local function getClassIdForTag(classTag)
  if not classTag then
    return nil
  end
  local numClasses = GetNumClasses and GetNumClasses() or 0
  for i = 1, numClasses do
    local _, tag, classID = GetClassInfo(i)
    if tag == classTag then
      return classID
    end
  end
  return nil
end

local function resolveHeroIcon(symbol, classTag)
  if not symbol or symbol == "" then
    return nil
  end
  local key = normalizeHeroKey(symbol:gsub("^wow%-hero%-talent%-", ""))
  if heroIconCache[key] ~= nil then
    return heroIconCache[key] or nil
  end
  local specs = nil
  local classID = getClassIdForTag(classTag)
  if C_ClassTalents and classID then
    if C_ClassTalents.GetHeroTalentSpecsForClassID then
      specs = C_ClassTalents.GetHeroTalentSpecsForClassID(classID)
    end
  end
  if not specs and C_ClassTalents and C_ClassTalents.GetHeroTalentSpecs then
    specs = C_ClassTalents.GetHeroTalentSpecs()
  end
  for _, spec in ipairs(specs or {}) do
    local name = spec.name or spec.specName or spec.heroTalentSpecName or spec.heroSpecName
    if name and normalizeHeroKey(name) == key then
      local icon = spec.iconFileID or spec.icon or spec.iconFile
      heroIconCache[key] = icon or false
      return icon
    end
  end
  heroIconCache[key] = false
  return nil
end

local function addHeroIcon(parent, symbol, anchor, classTag)
  if not symbol or symbol == "" then
    return nil
  end
  local icon = parent:CreateTexture(nil, "ARTWORK")
  icon:SetSize(14, 14)
  icon:SetPoint("LEFT", anchor, "RIGHT", 4, 0)
  local resolved = resolveHeroIcon(symbol, classTag)
  if resolved then
    icon:SetTexture(resolved)
  elseif C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo(symbol) then
    icon:SetAtlas(symbol, true)
  else
    icon:Hide()
  end
  return icon
end

local function getBisSpecForClass(classTag, specName)
  if not DeegoData or not DeegoData.specs then
    return nil
  end
  for _, spec in ipairs(DeegoData.specs) do
    if spec.class == classTag and spec.bisSources and matchesSpecName(spec, specName) then
      return spec
    end
  end
  if not specName then
    for _, spec in ipairs(DeegoData.specs) do
      if spec.class == classTag and spec.bisSources then
        return spec
      end
    end
  end
  return nil
end

local classIDByTag = {}
do
  local numClasses = GetNumClasses and GetNumClasses() or 0
  for i = 1, numClasses do
    local _, classTag, classID = GetClassInfo(i)
    if classTag and classID then
      classIDByTag[classTag] = classID
    end
  end
end

local function getSpecIcon(classTag, specName)
  local classID = classIDByTag[classTag]
  if not classID or not specName then
    return nil
  end
  local numSpecs = GetNumSpecializationsForClassID(classID) or 0
  for i = 1, numSpecs do
    local _, name, _, icon = GetSpecializationInfoForClassID(classID, i)
    if name and string.find(string.lower(specName), string.lower(name), 1, true) then
      return icon
    end
  end
  return nil
end

function DeegoUI.Toggle()
  if frame:IsShown() then
    frame:Hide()
  else
    DeegoUI.SyncSelection()
    frame:Show()
    DeegoUI.RenderSummary()
  end
end

function DeegoUI.RenderSummary()
  DeegoUI.view = "summary"
  if not DeegoData or not DeegoData.specs then
    frame.body:SetText("No data available.")
    return
  end

  local classTag = DeegoUI.selectedClass or getPlayerClassSpec()
  local colorPrefix, colorSuffix = getClassColor(classTag)
  updateTitle()
  frame.specBar:Show()
  DeegoUI.UpdateSpecBar()
  DeegoUI.UpdateTabs()

  local lines = {}
  local found = false
  for _, spec in ipairs(DeegoData.specs) do
    if spec.class == classTag and matchesSpecName(spec, DeegoUI.selectedSpecName) then
      found = true
      table.insert(lines, colorPrefix .. statLine(spec) .. colorSuffix)
      table.insert(lines, "")
    end
  end

  if not found then
    frame.body:SetText("No data for your class yet.")
    return
  end

  frame.body:SetText("")
end

function DeegoUI.RenderBisSources()
  DeegoUI.view = "bis"
  if not DeegoData or not DeegoData.specs then
    frame.body:SetText("No data available.")
    return
  end

  frame.specBar:Hide()
  frame.tabs:Hide()
  frame.tabBody:Hide()
  local classTag = DeegoUI.selectedClass or getPlayerClassSpec()
  local colorPrefix, colorSuffix = getClassColor(classTag)
  updateTitle()
  local lines = {}
  local found = false

  for _, spec in ipairs(DeegoData.specs) do
    if spec.class == classTag and spec.bisSources and matchesSpecName(spec, DeegoUI.selectedSpecName) then
      found = true
      table.insert(lines, colorPrefix .. specShortName(spec.name) .. " BiS Sources" .. colorSuffix)
      for _, entry in ipairs(spec.bisSources) do
        table.insert(lines, string.format("%s: %s", displaySlotLabel(entry.slot), entry.source))
      end
      if spec.bisSource and spec.bisSource.name then
        table.insert(lines, "Guide: " .. spec.bisSource.name)
      end
      if spec.bisSource and spec.bisSource.url then
        table.insert(lines, spec.bisSource.url)
      end
      table.insert(lines, "")
    end
  end

  if not found then
    table.insert(lines, "No BiS sources for your class yet.")
  end

  frame.body:SetText(table.concat(lines, "\n"))
end

function DeegoUI.SelectClass(classTag)
  DeegoUI.selectedClass = classTag
  DeegoUI.selectedSpecName = nil
  DeegoUI.UpdateClassBar()
  DeegoUI.UpdateClassBackground()
  DeegoUI.UpdateSpecBar()
  DeegoUI.UpdateTabs()
  if DeegoUI.view == "bis" then
    DeegoUI.RenderBisSources()
  else
    DeegoUI.RenderSummary()
  end
end

function DeegoUI.SyncSelection()
  local classTag, specName = getPlayerClassSpec()
  DeegoUI.selectedClass = classTag
  DeegoUI.selectedSpecName = nil
  DeegoUI.UpdateClassBar()
  DeegoUI.UpdateClassBackground()
  DeegoUI.UpdateSpecBar()
  DeegoUI.UpdateTabs()
  if classTag and frame.border then
    local classColor = RAID_CLASS_COLORS[classTag]
    if classColor then
      frame.border:SetBackdropBorderColor(classColor.r, classColor.g, classColor.b, 0.6)
    end
  end
end

function DeegoUI.UpdateClassBackground()
  if not frame.classBackground or not frame.classBar then
    return
  end
  local playerClass = select(2, UnitClass("player"))
  if DeegoUI.selectedClass and DeegoUI.selectedClass ~= playerClass then
    local coords = CLASS_ICON_TCOORDS[DeegoUI.selectedClass]
    if coords then
      frame.classBackground:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
    end
    frame.classBackground:Show()
    frame.classBar:Show()
  else
    frame.classBackground:Hide()
    frame.classBar:Show()
  end
end

function DeegoUI.UpdateClassBar()
  if not frame.classBar or not frame.classBar.buttons then
    return
  end
  for classTag, button in pairs(frame.classBar.buttons) do
    local classColor = RAID_CLASS_COLORS[classTag]
    if classTag == DeegoUI.selectedClass then
      button:SetAlpha(1)
      if button.border and classColor then
        button.border:SetBackdropBorderColor(classColor.r, classColor.g, classColor.b, 1)
        button.border:Show()
      end
    else
      button:SetAlpha(0.75)
      if button.border then
        button.border:Hide()
      end
    end
  end
end

function DeegoUI.UpdateSpecBar()
  if not frame.specBar then
    return
  end

  for _, item in ipairs(frame.specBar.items) do
    item:Hide()
  end
  wipe(frame.specBar.items)

  if not DeegoData or not DeegoData.specs then
    return
  end

  local classTag = DeegoUI.selectedClass or getPlayerClassSpec()
  local playerClass, playerSpecName = getPlayerClassSpec()
  local specs = {}
  for _, spec in ipairs(DeegoData.specs) do
    if spec.class == classTag then
      table.insert(specs, spec)
    end
  end

  local count = #specs
  if count == 0 then
    return
  end

  local barWidth = frame.specBar:GetWidth()
  local itemWidth = barWidth / count
  local startX = 0
  local iconSize = 36
  local activeSpecName = DeegoUI.selectedSpecName
  if not activeSpecName and frame.tabs and frame.tabs.selected == "Overall" and classTag == playerClass then
    activeSpecName = playerSpecName
  end

  for index, spec in ipairs(specs) do
    local item = CreateFrame("Frame", nil, frame.specBar)
    item:SetSize(itemWidth, frame.specBar:GetHeight())
    item:SetPoint("LEFT", startX + (index - 1) * itemWidth, 0)
    item:EnableMouse(true)
    item.specName = spec.name
    item:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_TOP")
      GameTooltip:SetText(spec.name)
      GameTooltip:Show()
    end)
    item:SetScript("OnLeave", function()
      GameTooltip:Hide()
    end)
    item:SetScript("OnMouseUp", function(self)
      if frame.tabs and (frame.tabs.selected == "Mythic +" or frame.tabs.selected == "Raid" or frame.tabs.selected == "Trinkets")
        and DeegoUI.selectedSpecName == self.specName then
        DeegoUI.selectedSpecName = nil
      else
        DeegoUI.selectedSpecName = self.specName
      end
      DeegoUI.UpdateSpecBar()
      DeegoUI.UpdateTabs()
    end)

    item.bg = item:CreateTexture(nil, "BACKGROUND")
    item.bg:SetAllPoints()
    item.bg:SetColorTexture(1, 1, 1, 0.08)
    item.border = CreateFrame("Frame", nil, item, "BackdropTemplate")
    item.border:SetAllPoints()
    item.border:SetBackdrop({
      edgeFile = "Interface\\Buttons\\WHITE8X8",
      edgeSize = 1,
    })
    item.border:Hide()

    local icon = item:CreateTexture(nil, "ARTWORK")
    icon:SetSize(iconSize, iconSize)
    icon:SetPoint("TOP", item, "TOP", 0, -2)
    local iconTexture = getSpecIcon(classTag, spec.name)
    if iconTexture then
      icon:SetTexture(iconTexture)
    end
    item.icon = icon

    local text = item:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    text:SetPoint("TOP", icon, "BOTTOM", 0, -2)
    text:SetJustifyH("CENTER")
    text:SetText(specShortName(spec.name))
    item.text = text

    local statText = item:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    statText:SetPoint("TOP", text, "BOTTOM", 0, -1)
    statText:SetJustifyH("CENTER")
    statText:SetText(statPriorityLine(spec))
    item.statText = statText

    local isSelected = not activeSpecName or matchesSpecName(spec, activeSpecName)
    if activeSpecName and not matchesSpecName(spec, activeSpecName) then
      item:SetAlpha(0.6)
      item.bg:Hide()
      item.border:Hide()
    else
      item:SetAlpha(1)
      item.bg:Show()
      local classColor = RAID_CLASS_COLORS[classTag]
      if classColor then
        item.bg:SetColorTexture(classColor.r, classColor.g, classColor.b, 0.12)
        item.border:SetBackdropBorderColor(classColor.r, classColor.g, classColor.b, 1)
        item.border:Show()
      end
    end
    if isSelected then
      if not item.highlight then
        item.highlight = CreateFrame("Frame", nil, item, "BackdropTemplate")
        item.highlight:SetAllPoints()
        item.highlight:SetBackdrop({
          edgeFile = "Interface\\Buttons\\WHITE8X8",
          edgeSize = 2,
        })
        item.highlight:SetFrameLevel(item:GetFrameLevel() + 2)
      end
      item.highlight:SetBackdropBorderColor(0.9, 0.5, 1, 1)
      item.highlight:Show()
    elseif item.highlight then
      item.highlight:Hide()
    end

    table.insert(frame.specBar.items, item)
  end
  frame.specStatsText:SetText("")
end

function DeegoUI.SelectTab(name)
  frame.tabs.selected = name
  DeegoUI.UpdateTabs()
end

function DeegoUI.UpdateTabs()
  if not frame.tabs then
    return
  end
  frame.tabs:Show()
  frame.tabBody:Show()

  local row1 = { "Overall", "Trinkets" }
  local row2 = { "Mythic +", "Raid" }
  local tabWidth = frame.tabs:GetWidth() / 2

  for _, button in pairs(frame.tabs.buttons) do
    button:Hide()
  end
  wipe(frame.tabs.buttons)

  for index, label in ipairs(row1) do
    local button = CreateFrame("Button", nil, frame.tabs, "UIPanelButtonTemplate")
    button:SetSize(tabWidth - 6, 22)
    button:SetPoint("TOPLEFT", (index - 1) * tabWidth + 2, 0)
    button:SetText(label)
    button:SetScript("OnClick", function()
      DeegoUI.SelectTab(label)
    end)
    if frame.tabs.selected == label then
      button:Disable()
    else
      button:Enable()
    end
    frame.tabs.buttons[label] = button
  end

  for index, label in ipairs(row2) do
    local button = CreateFrame("Button", nil, frame.tabs, "UIPanelButtonTemplate")
    button:SetSize(tabWidth - 6, 22)
    button:SetPoint("TOPLEFT", (index - 1) * tabWidth + 2, -24)
    button:SetText(label)
    button:SetScript("OnClick", function()
      DeegoUI.SelectTab(label)
    end)
    if frame.tabs.selected == label then
      button:Disable()
    else
      button:Enable()
    end
    frame.tabs.buttons[label] = button
  end

  DeegoUI.UpdateTabContent()
end

local function layoutTabButtons()
  if not frame.tabs or not frame.tabs.buttons then
    return
  end
  local row1 = { "Overall", "Trinkets" }
  local row2 = { "Mythic +", "Raid" }
  local tabWidth = frame.tabs:GetWidth() / 2
  for index, label in ipairs(row1) do
    local button = frame.tabs.buttons[label]
    if button then
      button:ClearAllPoints()
      button:SetSize(tabWidth - 6, 22)
      button:SetPoint("TOPLEFT", (index - 1) * tabWidth + 2, 0)
    end
  end
  for index, label in ipairs(row2) do
    local button = frame.tabs.buttons[label]
    if button then
      button:ClearAllPoints()
      button:SetSize(tabWidth - 6, 22)
      button:SetPoint("TOPLEFT", (index - 1) * tabWidth + 2, -24)
    end
  end
end

function DeegoUI.UpdateTabContent()
  if not frame.tabBody then
    return
  end
  for _, item in ipairs(frame.tabBody.items) do
    item:Hide()
  end
  wipe(frame.tabBody.items)

  local selectedTab = frame.tabs.selected or "Overall"
  if selectedTab ~= "Overall" and selectedTab ~= "Raid" and selectedTab ~= "Mythic +" and selectedTab ~= "Trinkets" then
    if frame.gearBackground then
      frame.gearBackground:Hide()
    end
    local text = frame.tabBody:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    text:SetPoint("TOPLEFT", 0, 0)
    text:SetWidth(frame.tabBody:GetWidth())
    text:SetJustifyH("LEFT")
    text:SetText("Coming soon.")
    table.insert(frame.tabBody.items, text)
    return
  end

  local classTag = DeegoUI.selectedClass or getPlayerClassSpec()
  local playerClass, playerSpecName = getPlayerClassSpec()
  if DeegoUI.selectedClass and DeegoUI.selectedClass ~= playerClass and not DeegoUI.selectedSpecName
    and frame.tabs.selected ~= "Mythic +" and frame.tabs.selected ~= "Raid"
    and frame.tabs.selected ~= "Trinkets" then
    if frame.gearBackground then
      local coords = CLASS_ICON_TCOORDS[DeegoUI.selectedClass]
      if coords then
        frame.gearBackground:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
      end
      frame.gearBackground:Show()
    end
    return
  end
  if frame.gearBackground then
    frame.gearBackground:Hide()
  end
  local specFilterName = DeegoUI.selectedSpecName
  if selectedTab == "Overall" and not specFilterName and classTag == playerClass then
    specFilterName = playerSpecName
  end
  local spec = getBisSpecForClass(classTag, specFilterName)
  if not spec then
    local text = frame.tabBody:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    text:SetPoint("TOPLEFT", 0, 0)
    text:SetWidth(frame.tabBody:GetWidth())
    text:SetJustifyH("LEFT")
    text:SetText("No BiS sources available for this class.")
    table.insert(frame.tabBody.items, text)
    return
  end

  if selectedTab == "Mythic +" then
    if frame.gearBackground then
      frame.gearBackground:Hide()
    end

    local function normalizeSource(text)
      if not text then
        return ""
      end
      local trimmed = string.gsub(text, "^%s*(.-)%s*$", "%1")
      return string.lower(trimmed)
    end

    local raidSources = {}
    for _, specEntry in ipairs(DeegoData.specs or {}) do
      if specEntry.bisSourcesRaid then
        for _, entry in ipairs(specEntry.bisSourcesRaid) do
          if entry.source and entry.source ~= "" then
            raidSources[normalizeSource(entry.source)] = true
          end
        end
      end
    end

    local dungeonSourceByItemId = {}
    for _, specEntry in ipairs(DeegoData.specs or {}) do
      if specEntry.bisSourcesMythicPlus then
        for _, entry in ipairs(specEntry.bisSourcesMythicPlus) do
          if entry.itemId and entry.source and entry.source ~= "" then
            local lower = normalizeSource(entry.source)
            if not string.find(lower, "catalyst", 1, true) and not string.find(lower, "tier", 1, true) then
              if not raidSources[lower] then
                local sourceType = classifySourceType(entry.source)
                if sourceType ~= "craft" and sourceType ~= "quest" and sourceType ~= "mixed" then
                  dungeonSourceByItemId[entry.itemId] = entry.source
                end
              end
            end
          end
        end
      end
    end

    local grouped = {}
    local debug = DeegoDB and DeegoDB.debugMythic
    for _, specEntry in ipairs(DeegoData.specs or {}) do
      if specEntry.class == classTag and specEntry.bisSourcesMythicPlus then
        if matchesSpecName(specEntry, DeegoUI.selectedSpecName) then
          for _, entry in ipairs(specEntry.bisSourcesMythicPlus) do
            local skip = false
            if entry.itemId == 235499 then
              -- Skip Reshii Wraps in Mythic+ lists.
              skip = true
            end
            local dungeon = entry.source or ""
            if dungeon == "" and entry.itemId and dungeonSourceByItemId[entry.itemId] then
              dungeon = dungeonSourceByItemId[entry.itemId]
            end
            if dungeon == "" then
              dungeon = "Unknown"
            end
            if string.find(string.lower(dungeon), "catalyst", 1, true) then
              skip = true
            end
            if string.find(string.lower(dungeon), "tier", 1, true) then
              skip = true
            end
            local normalized = normalizeSource(dungeon)
            if raidSources[normalized] then
              skip = true
            end
            local sourceType = classifySourceType(dungeon)
            if sourceType == "craft" or sourceType == "quest" or sourceType == "mixed" then
              skip = true
            end
            if debug then
              print("Mythic+ entry", specEntry.name, entry.slot or "slot?", entry.itemId or "noid", dungeon, sourceType, skip and "skip" or "keep")
            end
            if not skip then
              grouped[dungeon] = grouped[dungeon] or {}
              local itemKey = nil
              if entry.itemId then
                itemKey = tostring(entry.itemId)
              else
                itemKey = string.format("slot:%s:source:%s", entry.slot or "", entry.source or "")
              end
              local bucket = grouped[dungeon][itemKey]
              if not bucket then
                bucket = { entry = entry, specs = {} }
                grouped[dungeon][itemKey] = bucket
              end
              local icon = getSpecIcon(specEntry.class, specEntry.name)
              local specKey = icon or specEntry.name
              bucket.specs[specKey] = { icon = icon, name = specEntry.name }
            end
          end
        end
      end
    end

    local dungeons = {}
    for name in pairs(grouped) do
      table.insert(dungeons, name)
    end
    table.sort(dungeons)

    if #dungeons == 0 then
      local text = frame.tabBody:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
      text:SetPoint("TOPLEFT", 0, 0)
      text:SetWidth(frame.tabBody:GetWidth())
      text:SetJustifyH("LEFT")
      text:SetText("No BiS sources available for this section.")
      table.insert(frame.tabBody.items, text)
      return
    end

    local groups = {}
    for _, dungeon in ipairs(dungeons) do
      local items = {}
      for _, bucket in pairs(grouped[dungeon]) do
        table.insert(items, bucket)
      end
      local slotOrder = {
        "Head",
        "Neck",
        "Shoulders",
        "Back",
        "Cloak",
        "Chest",
        "Wrist",
        "Gloves",
        "Belt",
        "Legs",
        "Boots",
        "Ring 1",
        "Ring 2",
        "Trinket 1",
        "Trinket 2",
        "Main Hand",
        "Off Hand",
        "Weapon Alt 1",
        "Weapon Alt 2",
        "Trinket Alt 1",
        "Trinket Alt 2",
      }
      local slotRank = {}
      for index, name in ipairs(slotOrder) do
        slotRank[name] = index
      end
      table.sort(items, function(a, b)
        local aSlot = a.entry.slot or ""
        local bSlot = b.entry.slot or ""
        local aRank = slotRank[aSlot] or 999
        local bRank = slotRank[bSlot] or 999
        if aRank ~= bRank then
          return aRank < bRank
        end
        return aSlot < bSlot
      end)
      local itemLines = {}
      for _, item in ipairs(items) do
        local itemName = "Unknown"
        if item.entry.itemId then
          itemName = GetItemInfo(item.entry.itemId)
          if not itemName or itemName == "" then
            itemName = "Item #" .. item.entry.itemId
          end
        end
        local slot = displaySlotLabel(item.entry.slot) or "Item"
        local icons = {}
        local fallbackSpecs = {}
        for _, specInfo in pairs(item.specs) do
          if specInfo.icon then
            table.insert(icons, string.format("|T%s:14:14|t", specInfo.icon))
          else
            table.insert(fallbackSpecs, specShortName(specInfo.name))
          end
        end
        local specLabel = table.concat(icons, " ")
        if specLabel == "" and #fallbackSpecs > 0 then
          specLabel = table.concat(fallbackSpecs, ", ")
        elseif #fallbackSpecs > 0 then
          specLabel = specLabel .. " " .. table.concat(fallbackSpecs, ", ")
        end
        table.insert(itemLines, {
          text = string.format("%s - %s - %s", slot, specLabel, itemName),
          itemId = item.entry.itemId,
          heroSymbol = item.entry.heroSymbol,
        })
      end
      table.insert(groups, { dungeon = dungeon, items = items, lines = itemLines })
    end

    local lineHeight = 16
    local headerHeight = 18
    local columnGap = 20
    local minColumnWidth = (frame.tabBody:GetWidth() - columnGap) / 2

    local measureHeader = frame.tabBody:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    measureHeader:SetWidth(0)
    measureHeader:SetWordWrap(false)
    local measureItem = frame.tabBody:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    measureItem:SetWidth(0)
    measureItem:SetWordWrap(false)
    measureHeader:Hide()
    measureItem:Hide()

    local maxLineWidth = 0
    for _, group in ipairs(groups) do
      measureHeader:SetText(group.dungeon)
      maxLineWidth = math.max(maxLineWidth, measureHeader:GetStringWidth())
      for _, line in ipairs(group.lines) do
        measureItem:SetText(line.text)
        maxLineWidth = math.max(maxLineWidth, measureItem:GetStringWidth())
      end
    end

    local columnWidth = math.max(minColumnWidth, math.ceil(maxLineWidth))
    local desiredTabBodyWidth = (columnWidth * 2) + columnGap
    local minTabBodyWidth = frame.tabBody:GetWidth()
    if desiredTabBodyWidth < minTabBodyWidth then
      desiredTabBodyWidth = minTabBodyWidth
    end
    local chromeWidth = frame:GetWidth() - frame.tabBody:GetWidth()
    frame.tabBody:SetWidth(desiredTabBodyWidth)
    frame.body:SetWidth(desiredTabBodyWidth)
    frame.tabs:SetWidth(desiredTabBodyWidth)
    frame.specBar:SetWidth(desiredTabBodyWidth)
    frame.specStatsText:SetWidth(desiredTabBodyWidth)
    frame.classBar:SetWidth(desiredTabBodyWidth + 20)
    frame:SetWidth(desiredTabBodyWidth + chromeWidth)

    frame.tabs:ClearAllPoints()
    frame.tabs:SetPoint("TOP", 0, -216)
    frame.tabBody:ClearAllPoints()
    frame.tabBody:SetPoint("TOP", 0, -272)
    frame.body:ClearAllPoints()
    frame.body:SetPoint("TOP", 0, -272)
    layoutTabButtons()
    DeegoUI.UpdateSpecBar()
    if DeegoUI.LayoutClassBar then
      DeegoUI.LayoutClassBar()
    end

    columnWidth = (frame.tabBody:GetWidth() - columnGap) / 2
    local columns = {
      { x = 0, y = 0 },
      { x = columnWidth + columnGap, y = 0 },
    }

    local function groupHeight(group)
      return headerHeight + (#group.items * lineHeight)
    end

    for _, group in ipairs(groups) do
      local col = columns[1]
      if columns[2].y < columns[1].y then
        col = columns[2]
      end

      local header = frame.tabBody:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      header:SetPoint("TOPLEFT", col.x, -col.y)
      header:SetWidth(columnWidth)
      header:SetWordWrap(false)
      header:SetJustifyH("LEFT")
      header:SetText(group.dungeon)
      table.insert(frame.tabBody.items, header)
      col.y = col.y + headerHeight

      for _, line in ipairs(group.lines) do
        local row = CreateFrame("Frame", nil, frame.tabBody)
        row:SetSize(columnWidth, lineHeight)
        row:SetPoint("TOPLEFT", col.x, -col.y)
        row:EnableMouse(true)

        if line.itemId then
          row:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetHyperlink("item:" .. line.itemId)
            GameTooltip:Show()
          end)
          row:SetScript("OnLeave", function()
            GameTooltip:Hide()
          end)
        end

        local text = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        text:SetPoint("TOPLEFT", 0, 0)
        local textWidth = columnWidth
        if line.heroSymbol then
          textWidth = textWidth - 18
        end
        text:SetWidth(textWidth)
        text:SetWordWrap(false)
        text:SetJustifyH("LEFT")
        text:SetText(line.text)
        if line.heroSymbol then
          addHeroIcon(row, line.heroSymbol, text, classTag)
        end
        table.insert(frame.tabBody.items, row)
        col.y = col.y + lineHeight
      end
    end

    local bottomPadding = 36
    local desiredTabBodyHeight = math.max(columns[1].y, columns[2].y) + bottomPadding
    if desiredTabBodyHeight < 260 then
      desiredTabBodyHeight = 260
    end
    local chromeHeight = frame:GetHeight() - frame.tabBody:GetHeight()
    frame.tabBody:SetHeight(desiredTabBodyHeight)
    frame:SetHeight(chromeHeight + desiredTabBodyHeight)
    return
  end

  if selectedTab == "Trinkets" then
    if frame.gearBackground then
      frame.gearBackground:Hide()
    end

    local specs = {}
    if DeegoUI.selectedSpecName then
      if spec and spec.trinketTiers then
        table.insert(specs, spec)
      end
    else
      for _, specEntry in ipairs(DeegoData.specs or {}) do
        if specEntry.class == classTag and specEntry.trinketTiers then
          table.insert(specs, specEntry)
        end
      end
    end

    if #specs == 0 then
      local text = frame.tabBody:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
      text:SetPoint("TOPLEFT", 0, 0)
      text:SetWidth(frame.tabBody:GetWidth())
      text:SetJustifyH("LEFT")
      text:SetText("No trinket tier list available for this class.")
      table.insert(frame.tabBody.items, text)
      return
    end

    local lineHeight = 18
    local headerHeight = 18
    local tierHeaderHeight = 16
    local columnGap = 16
    local columns = #specs

    local minColumnWidth = (frame.tabBody:GetWidth() - (columnGap * (columns - 1))) / columns
    local measureHeader = frame.tabBody:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    measureHeader:SetWidth(0)
    measureHeader:SetWordWrap(false)
    local measureItem = frame.tabBody:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    measureItem:SetWidth(0)
    measureItem:SetWordWrap(false)
    measureHeader:Hide()
    measureItem:Hide()

    local maxLineWidth = 0
    for _, specEntry in ipairs(specs) do
      if #specs > 1 then
        measureHeader:SetText(specShortName(specEntry.name))
        maxLineWidth = math.max(maxLineWidth, measureHeader:GetStringWidth())
      end
      for _, tier in ipairs(specEntry.trinketTiers or {}) do
        measureHeader:SetText(tier.tier .. " Tier")
        maxLineWidth = math.max(maxLineWidth, measureHeader:GetStringWidth())
        for _, itemId in ipairs(tier.items or {}) do
          local itemName = GetItemInfo(itemId)
          if not itemName or itemName == "" then
            itemName = "Item #" .. itemId
          end
          measureItem:SetText(itemName)
          maxLineWidth = math.max(maxLineWidth, measureItem:GetStringWidth())
        end
      end
    end

    local columnWidth = math.max(minColumnWidth, math.ceil(maxLineWidth + 20))
    local desiredTabBodyWidth = (columnWidth * columns) + (columnGap * (columns - 1))
    local minTabBodyWidth = frame.tabBody:GetWidth()
    if desiredTabBodyWidth < minTabBodyWidth then
      desiredTabBodyWidth = minTabBodyWidth
    end
    local chromeWidth = frame:GetWidth() - frame.tabBody:GetWidth()
    frame.tabBody:SetWidth(desiredTabBodyWidth)
    frame.body:SetWidth(desiredTabBodyWidth)
    frame.tabs:SetWidth(desiredTabBodyWidth)
    frame.specBar:SetWidth(desiredTabBodyWidth)
    frame.specStatsText:SetWidth(desiredTabBodyWidth)
    frame.classBar:SetWidth(desiredTabBodyWidth + 20)
    frame:SetWidth(desiredTabBodyWidth + chromeWidth)

    frame.tabs:ClearAllPoints()
    frame.tabs:SetPoint("TOP", 0, -216)
    frame.tabBody:ClearAllPoints()
    frame.tabBody:SetPoint("TOP", 0, -272)
    frame.body:ClearAllPoints()
    frame.body:SetPoint("TOP", 0, -272)
    layoutTabButtons()
    DeegoUI.UpdateSpecBar()
    if DeegoUI.LayoutClassBar then
      DeegoUI.LayoutClassBar()
    end

    local tierOrder = { S = 1, ["A+"] = 2, A = 3, ["A-"] = 4, B = 5 }
    local maxColumnHeight = 0

    for index, specEntry in ipairs(specs) do
      local colX = (index - 1) * (columnWidth + columnGap)
      local y = 0

      if #specs > 1 then
        local header = frame.tabBody:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        header:SetPoint("TOPLEFT", colX, -y)
        header:SetWidth(columnWidth)
        header:SetJustifyH("LEFT")
        header:SetText(specShortName(specEntry.name))
        table.insert(frame.tabBody.items, header)
        y = y + headerHeight
      end

      local tiers = {}
      for _, tier in ipairs(specEntry.trinketTiers or {}) do
        if tierOrder[tier.tier] and tierOrder[tier.tier] <= tierOrder.B then
          table.insert(tiers, tier)
        end
      end
      table.sort(tiers, function(a, b)
        return (tierOrder[a.tier] or 99) < (tierOrder[b.tier] or 99)
      end)

      for _, tier in ipairs(tiers) do
        local tierHeader = frame.tabBody:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        tierHeader:SetPoint("TOPLEFT", colX, -y)
        tierHeader:SetWidth(columnWidth)
        tierHeader:SetJustifyH("LEFT")
        tierHeader:SetText(tier.tier .. " Tier")
        table.insert(frame.tabBody.items, tierHeader)
        y = y + tierHeaderHeight

        for _, itemId in ipairs(tier.items or {}) do
          local row = CreateFrame("Frame", nil, frame.tabBody)
          row:SetSize(columnWidth, lineHeight)
          row:SetPoint("TOPLEFT", colX, -y)
          row:EnableMouse(true)
          row:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetHyperlink("item:" .. itemId)
            GameTooltip:Show()
          end)
          row:SetScript("OnLeave", function()
            GameTooltip:Hide()
          end)

          local icon = row:CreateTexture(nil, "ARTWORK")
          icon:SetSize(14, 14)
          icon:SetPoint("TOPLEFT", 0, -1)
          icon:SetTexture(GetItemIcon(itemId) or "Interface\\Icons\\INV_Misc_QuestionMark")

          local itemName = GetItemInfo(itemId)
          if not itemName or itemName == "" then
            itemName = "Item #" .. itemId
          end

          local text = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
          text:SetPoint("TOPLEFT", icon, "TOPRIGHT", 6, 0)
          text:SetWidth(columnWidth - 20)
          text:SetWordWrap(false)
          text:SetJustifyH("LEFT")
          text:SetText(itemName)
          table.insert(frame.tabBody.items, row)
          y = y + lineHeight
        end
      end

      maxColumnHeight = math.max(maxColumnHeight, y)
    end

    local bottomPadding = 36
    local desiredTabBodyHeight = maxColumnHeight + bottomPadding
    if desiredTabBodyHeight < 260 then
      desiredTabBodyHeight = 260
    end
    local chromeHeight = frame:GetHeight() - frame.tabBody:GetHeight()
    frame.tabBody:SetHeight(desiredTabBodyHeight)
    frame:SetHeight(chromeHeight + desiredTabBodyHeight)
    return
  end

  if selectedTab == "Raid" then
    if frame.gearBackground then
      frame.gearBackground:Hide()
    end

    local grouped = {}
    for _, specEntry in ipairs(DeegoData.specs or {}) do
      if specEntry.class == classTag and specEntry.bisSourcesRaid then
        if matchesSpecName(specEntry, DeegoUI.selectedSpecName) then
          for _, entry in ipairs(specEntry.bisSourcesRaid) do
            local skip = false
            local source = entry.source or ""
            local boss = source
            local tierBoss = string.match(source, "^Tier %((.+)%)$")
            if tierBoss then
              boss = tierBoss
            end
            if boss == "" then
              skip = true
            end
            local sourceType = classifySourceType(source)
            if tierBoss then
              sourceType = "boss"
            end
            if sourceType ~= "boss" then
              skip = true
            end
            if not skip then
              grouped[boss] = grouped[boss] or {}
              local itemKey = nil
              if entry.itemId then
                itemKey = tostring(entry.itemId)
              else
                itemKey = string.format("slot:%s:source:%s", entry.slot or "", entry.source or "")
              end
              local bucket = grouped[boss][itemKey]
              if not bucket then
                bucket = { entry = entry, specs = {} }
                grouped[boss][itemKey] = bucket
              end
              local icon = getSpecIcon(specEntry.class, specEntry.name)
              local specKey = icon or specEntry.name
              bucket.specs[specKey] = { icon = icon, name = specEntry.name }
            end
          end
        end
      end
    end

    local bosses = {}
    for name in pairs(grouped) do
      table.insert(bosses, name)
    end
    table.sort(bosses)

    if #bosses == 0 then
      local text = frame.tabBody:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
      text:SetPoint("TOPLEFT", 0, 0)
      text:SetWidth(frame.tabBody:GetWidth())
      text:SetJustifyH("LEFT")
      text:SetText("No BiS sources available for this section.")
      table.insert(frame.tabBody.items, text)
      return
    end

    local slotOrder = {
      "Head",
      "Neck",
      "Shoulders",
      "Back",
      "Cloak",
      "Chest",
      "Wrist",
      "Gloves",
      "Belt",
      "Legs",
      "Boots",
      "Ring 1",
      "Ring 2",
      "Trinket 1",
      "Trinket 2",
      "Main Hand",
      "Off Hand",
      "Weapon Alt 1",
      "Weapon Alt 2",
      "Trinket Alt 1",
      "Trinket Alt 2",
    }
    local slotRank = {}
    for index, name in ipairs(slotOrder) do
      slotRank[name] = index
    end

    local groups = {}
    for _, boss in ipairs(bosses) do
      local items = {}
      for _, bucket in pairs(grouped[boss]) do
        table.insert(items, bucket)
      end
      table.sort(items, function(a, b)
        local aSlot = a.entry.slot or ""
        local bSlot = b.entry.slot or ""
        local aRank = slotRank[aSlot] or 999
        local bRank = slotRank[bSlot] or 999
        if aRank ~= bRank then
          return aRank < bRank
        end
        return aSlot < bSlot
      end)
      local itemLines = {}
      for _, item in ipairs(items) do
        local itemName = "Unknown"
        if item.entry.itemId then
          itemName = GetItemInfo(item.entry.itemId)
          if not itemName or itemName == "" then
            itemName = "Item #" .. item.entry.itemId
          end
        end
        local slot = displaySlotLabel(item.entry.slot) or "Item"
        local icons = {}
        local fallbackSpecs = {}
        for _, specInfo in pairs(item.specs) do
          if specInfo.icon then
            table.insert(icons, string.format("|T%s:14:14|t", specInfo.icon))
          else
            table.insert(fallbackSpecs, specShortName(specInfo.name))
          end
        end
        local specLabel = table.concat(icons, " ")
        if specLabel == "" and #fallbackSpecs > 0 then
          specLabel = table.concat(fallbackSpecs, ", ")
        elseif #fallbackSpecs > 0 then
          specLabel = specLabel .. " " .. table.concat(fallbackSpecs, ", ")
        end
        table.insert(itemLines, {
          text = string.format("%s - %s - %s", slot, specLabel, itemName),
          itemId = item.entry.itemId,
          heroSymbol = item.entry.heroSymbol,
        })
      end
      table.insert(groups, { boss = boss, items = items, lines = itemLines })
    end

    local lineHeight = 16
    local headerHeight = 18
    local columnGap = 20
    local minColumnWidth = (frame.tabBody:GetWidth() - columnGap) / 2

    local measureHeader = frame.tabBody:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    measureHeader:SetWidth(0)
    measureHeader:SetWordWrap(false)
    local measureItem = frame.tabBody:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    measureItem:SetWidth(0)
    measureItem:SetWordWrap(false)
    measureHeader:Hide()
    measureItem:Hide()

    local maxLineWidth = 0
    for _, group in ipairs(groups) do
      measureHeader:SetText(group.boss)
      maxLineWidth = math.max(maxLineWidth, measureHeader:GetStringWidth())
      for _, line in ipairs(group.lines) do
        measureItem:SetText(line.text)
        maxLineWidth = math.max(maxLineWidth, measureItem:GetStringWidth())
      end
    end

    local columnWidth = math.max(minColumnWidth, math.ceil(maxLineWidth))
    local desiredTabBodyWidth = (columnWidth * 2) + columnGap
    local minTabBodyWidth = frame.tabBody:GetWidth()
    if desiredTabBodyWidth < minTabBodyWidth then
      desiredTabBodyWidth = minTabBodyWidth
    end
    local chromeWidth = frame:GetWidth() - frame.tabBody:GetWidth()
    frame.tabBody:SetWidth(desiredTabBodyWidth)
    frame.body:SetWidth(desiredTabBodyWidth)
    frame.tabs:SetWidth(desiredTabBodyWidth)
    frame.specBar:SetWidth(desiredTabBodyWidth)
    frame.specStatsText:SetWidth(desiredTabBodyWidth)
    frame.classBar:SetWidth(desiredTabBodyWidth + 20)
    frame:SetWidth(desiredTabBodyWidth + chromeWidth)

    frame.tabs:ClearAllPoints()
    frame.tabs:SetPoint("TOP", 0, -216)
    frame.tabBody:ClearAllPoints()
    frame.tabBody:SetPoint("TOP", 0, -272)
    frame.body:ClearAllPoints()
    frame.body:SetPoint("TOP", 0, -272)
    layoutTabButtons()
    DeegoUI.UpdateSpecBar()
    if DeegoUI.LayoutClassBar then
      DeegoUI.LayoutClassBar()
    end

    columnWidth = (frame.tabBody:GetWidth() - columnGap) / 2
    local columns = {
      { x = 0, y = 0 },
      { x = columnWidth + columnGap, y = 0 },
    }

    for _, group in ipairs(groups) do
      local col = columns[1]
      if columns[2].y < columns[1].y then
        col = columns[2]
      end

      local header = frame.tabBody:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      header:SetPoint("TOPLEFT", col.x, -col.y)
      header:SetWidth(columnWidth)
      header:SetWordWrap(false)
      header:SetJustifyH("LEFT")
      header:SetText(group.boss)
      table.insert(frame.tabBody.items, header)
      col.y = col.y + headerHeight

      for _, line in ipairs(group.lines) do
        local row = CreateFrame("Frame", nil, frame.tabBody)
        row:SetSize(columnWidth, lineHeight)
        row:SetPoint("TOPLEFT", col.x, -col.y)
        row:EnableMouse(true)

        if line.itemId then
          row:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetHyperlink("item:" .. line.itemId)
            GameTooltip:Show()
          end)
          row:SetScript("OnLeave", function()
            GameTooltip:Hide()
          end)
        end

        local text = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        text:SetPoint("TOPLEFT", 0, 0)
        local textWidth = columnWidth
        if line.heroSymbol then
          textWidth = textWidth - 18
        end
        text:SetWidth(textWidth)
        text:SetWordWrap(false)
        text:SetJustifyH("LEFT")
        text:SetText(line.text)
        if line.heroSymbol then
          addHeroIcon(row, line.heroSymbol, text, classTag)
        end
        table.insert(frame.tabBody.items, row)
        col.y = col.y + lineHeight
      end
    end

    local bottomPadding = 36
    local desiredTabBodyHeight = math.max(columns[1].y, columns[2].y) + bottomPadding
    if desiredTabBodyHeight < 260 then
      desiredTabBodyHeight = 260
    end
    local chromeHeight = frame:GetHeight() - frame.tabBody:GetHeight()
    frame.tabBody:SetHeight(desiredTabBodyHeight)
    frame:SetHeight(chromeHeight + desiredTabBodyHeight)
    return
  end

  local sources = spec.bisSources
  local noteText = spec.bisNote
  if selectedTab == "Raid" then
    sources = spec.bisSourcesRaid
    noteText = spec.bisNoteRaid
  elseif selectedTab == "Mythic +" then
    sources = spec.bisSourcesMythicPlus
    noteText = spec.bisNoteMythicPlus
  end

  if not sources then
    local text = frame.tabBody:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    text:SetPoint("TOPLEFT", 0, 0)
    text:SetWidth(frame.tabBody:GetWidth())
    text:SetJustifyH("LEFT")
    text:SetText("No BiS sources available for this section.")
    table.insert(frame.tabBody.items, text)
    return
  end

  local slotEntries = {}
  local primaryBySlot = {}
  local weaponEntries = {}
  local ringEntries = {}
  local trinketEntries = {}
  local function addEntry(slot, entry)
    if not slot then
      return
    end
    slotEntries[slot] = slotEntries[slot] or {}
    table.insert(slotEntries[slot], entry)
  end
  local slotAliases = {
    ["weapon"] = "Main Hand",
    ["weapons"] = "Main Hand",
    ["weapon(s)"] = "Main Hand",
    ["feet"] = "Boots",
    ["foot"] = "Boots",
    ["helm"] = "Head",
    ["helmet"] = "Head",
    ["hands"] = "Gloves",
    ["hand"] = "Gloves",
    ["bracer"] = "Wrist",
    ["bracers"] = "Wrist",
    ["main weapon"] = "Main Hand",
    ["main hand"] = "Main Hand",
    ["mainhand"] = "Main Hand",
    ["off hand"] = "Off Hand",
    ["off-hand"] = "Off Hand",
    ["offhand"] = "Off Hand",
    ["cape"] = "Cloak",
    ["cloak"] = "Cloak",
    ["back"] = "Cloak",
    ["finger"] = "Ring",
    ["ring"] = "Ring",
    ["waist"] = "Belt",
    ["two-hand weapon"] = "Main Hand",
    ["two-hand"] = "Main Hand",
    ["2h weapon"] = "Main Hand",
    ["2h"] = "Main Hand",
    ["weapon (2h)"] = "Main Hand",
    ["one-hand weapon"] = "One-Hand Weapon",
    ["one-hand"] = "One-Hand Weapon",
    ["1h weapon"] = "One-Hand Weapon",
    ["weapon (1h)"] = "One-Hand Weapon",
  }

  local function normalizeSlot(slot)
    if not slot then
      return nil
    end
    local trimmed = string.gsub(slot, "^%s*(.-)%s*$", "%1")
    local key = string.lower(trimmed)
    return slotAliases[key] or trimmed
  end

  local hasTwoHand = false
  local hasOffHandEntry = false
  for _, entry in ipairs(sources) do
    local slot = normalizeSlot(entry.slot)
    if slot == "Main Hand" and entry.slot and string.find(string.lower(entry.slot), "2h", 1, true) then
      hasTwoHand = true
      break
    end
    if slot == "Main Hand" and entry.slot and string.find(string.lower(entry.slot), "two%-hand", 1, true) then
      hasTwoHand = true
      break
    end
    if slot == "Main Hand" and entry.slot and string.find(string.lower(entry.slot), "(2h)", 1, true) then
      hasTwoHand = true
      break
    end
    if entry.slot == "Two-Hand Weapon" or entry.slot == "Two-Hand" or entry.slot == "2h Weapon"
      or entry.slot == "2H Weapon" or entry.slot == "Weapon (2h)" then
      hasTwoHand = true
      break
    end
    if slot == "Off Hand" then
      hasOffHandEntry = true
    end
  end

  for _, entry in ipairs(sources) do
    local slot = normalizeSlot(entry.slot)
    local isWeapon = false
    local isRing = false
    local isTrinket = false
    if slot == "Ring" then
      if slotEntries["Ring 1"] then
        slot = "Ring 2"
      else
        slot = "Ring 1"
      end
      isRing = true
    elseif slot == "One-Hand Weapon" then
      if hasTwoHand and hasOffHandEntry then
        slot = "Main Hand"
      elseif hasTwoHand then
        slot = "Off Hand"
      else
        slot = primaryBySlot["Main Hand"] and "Off Hand" or "Main Hand"
      end
      isWeapon = true
    elseif slot == "Main Hand" or slot == "Off Hand" then
      isWeapon = true
    elseif slot == "Ring 1" or slot == "Ring 2" then
      isRing = true
    elseif slot == "Trinkets" then
      if slotEntries["Trinket 1"] then
        slot = "Trinket 2"
      else
        slot = "Trinket 1"
      end
      isTrinket = true
    elseif slot == "Trinket 1" or slot == "Trinket 2" then
      isTrinket = true
    end
    if slot then
      if slot == "Main Hand" or slot == "Off Hand" then
        if not primaryBySlot[slot] then
          primaryBySlot[slot] = entry
          addEntry(slot, entry)
        end
      else
        addEntry(slot, entry)
      end
    end
    if isWeapon then
      table.insert(weaponEntries, entry)
    end
    if isRing then
      table.insert(ringEntries, entry)
    end
    if isTrinket then
      table.insert(trinketEntries, entry)
    end
  end
  if not primaryBySlot["Main Hand"] and weaponEntries[1] then
    primaryBySlot["Main Hand"] = weaponEntries[1]
    addEntry("Main Hand", weaponEntries[1])
  end
  if not primaryBySlot["Off Hand"] and weaponEntries[2] then
    primaryBySlot["Off Hand"] = weaponEntries[2]
    addEntry("Off Hand", weaponEntries[2])
  end
  local weaponAltSlots = {}
  if #weaponEntries > 2 then
    local mainEntry = primaryBySlot["Main Hand"]
    local offEntry = primaryBySlot["Off Hand"]
    local altIndex = 1
    for _, entry in ipairs(weaponEntries) do
      if entry ~= mainEntry and entry ~= offEntry then
        local label = "Weapon Alt " .. altIndex
        addEntry(label, entry)
        table.insert(weaponAltSlots, label)
        altIndex = altIndex + 1
      end
    end
  end
  if not slotEntries["Ring 1"] and ringEntries[1] then
    addEntry("Ring 1", ringEntries[1])
  end
  if not slotEntries["Ring 2"] and ringEntries[2] then
    addEntry("Ring 2", ringEntries[2])
  end
  if not slotEntries["Trinket 1"] and trinketEntries[1] then
    addEntry("Trinket 1", trinketEntries[1])
  end
  if not slotEntries["Trinket 2"] and trinketEntries[2] then
    addEntry("Trinket 2", trinketEntries[2])
  end
  local trinketAltSlots = {}
  if #trinketEntries > 2 then
    local trinketOne = slotEntries["Trinket 1"] and slotEntries["Trinket 1"][1] or nil
    local trinketTwo = slotEntries["Trinket 2"] and slotEntries["Trinket 2"][1] or nil
    local altIndex = 1
    for _, entry in ipairs(trinketEntries) do
      if entry ~= trinketOne and entry ~= trinketTwo then
        local label = "Trinket Alt " .. altIndex
        addEntry(label, entry)
        table.insert(trinketAltSlots, label)
        altIndex = altIndex + 1
      end
    end
  end

  local slotIcons = {
    ["Head"] = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Head",
    ["Neck"] = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Neck",
    ["Shoulders"] = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Shoulder",
    ["Back"] = "Interface\\Icons\\INV_Misc_Cape_19",
    ["Chest"] = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Chest",
    ["Wrist"] = "Interface\\Icons\\INV_Bracer_09",
    ["Main Hand"] = "Interface\\PaperDoll\\UI-PaperDoll-Slot-MainHand",
    ["Off Hand"] = "Interface\\PaperDoll\\UI-PaperDoll-Slot-SecondaryHand",
    ["Gloves"] = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Hands",
    ["Belt"] = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Waist",
    ["Legs"] = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Legs",
    ["Boots"] = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Feet",
    ["Ring 1"] = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Finger",
    ["Ring 2"] = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Finger",
    ["Trinket 1"] = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Trinket",
    ["Trinket 2"] = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Trinket",
  }
  for _, label in ipairs(trinketAltSlots) do
    slotIcons[label] = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Trinket"
  end
  for _, label in ipairs(weaponAltSlots) do
    slotIcons[label] = "Interface\\PaperDoll\\UI-PaperDoll-Slot-MainHand"
  end

  local leftColumn = {
    "Head",
    "Neck",
    "Shoulders",
    "Back",
    "Chest",
    "Wrist",
  }
  local weaponCount = 0
  if slotEntries["Main Hand"] and #slotEntries["Main Hand"] > 0 then
    weaponCount = weaponCount + 1
  end
  if slotEntries["Off Hand"] and #slotEntries["Off Hand"] > 0 then
    weaponCount = weaponCount + 1
  end
  if weaponCount <= 1 then
    if slotEntries["Main Hand"] and #slotEntries["Main Hand"] > 0 then
      table.insert(leftColumn, "Main Hand")
    elseif slotEntries["Off Hand"] and #slotEntries["Off Hand"] > 0 then
      table.insert(leftColumn, "Off Hand")
    else
      table.insert(leftColumn, "Main Hand")
    end
  else
    table.insert(leftColumn, "Main Hand")
    table.insert(leftColumn, "Off Hand")
  end
  for _, label in ipairs(weaponAltSlots) do
    table.insert(leftColumn, label)
  end
  local rightColumn = {
    "Gloves",
    "Belt",
    "Legs",
    "Boots",
    "Ring 1",
    "Ring 2",
  }
  local trinketCount = 0
  if slotEntries["Trinket 1"] and #slotEntries["Trinket 1"] > 0 then
    trinketCount = trinketCount + 1
  end
  if slotEntries["Trinket 2"] and #slotEntries["Trinket 2"] > 0 then
    trinketCount = trinketCount + 1
  end
  if trinketCount <= 1 then
    if slotEntries["Trinket 1"] and #slotEntries["Trinket 1"] > 0 then
      table.insert(rightColumn, "Trinket 1")
    elseif slotEntries["Trinket 2"] and #slotEntries["Trinket 2"] > 0 then
      table.insert(rightColumn, "Trinket 2")
    end
  else
    table.insert(rightColumn, "Trinket 1")
    table.insert(rightColumn, "Trinket 2")
  end
  for _, label in ipairs(trinketAltSlots) do
    table.insert(rightColumn, label)
  end

  local columnWidth = (frame.tabBody:GetWidth() - 20) / 2
  local iconSize = 22
  local noteOffset = 0

  if noteText then
    local note = frame.tabBody:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    note:SetPoint("TOPLEFT", 0, 0)
    note:SetWidth(frame.tabBody:GetWidth())
    note:SetJustifyH("LEFT")
    note:SetText(noteText)
    table.insert(frame.tabBody.items, note)
    noteOffset = 18
  end

  -- Spec selection is highlighted on the spec buttons.

  local function entriesForLabel(label)
    local dataSlot = label
    if label == "Back" then
      dataSlot = "Cloak"
    end
    return slotEntries[dataSlot] or {}
  end

  local leftRows = {}
  for _, label in ipairs(leftColumn) do
    local entries = entriesForLabel(label)
    if #entries == 0 then
      table.insert(leftRows, { label = label, entry = nil })
    else
      for _, entry in ipairs(entries) do
        table.insert(leftRows, { label = label, entry = entry })
      end
    end
  end
  local rightRows = {}
  for _, label in ipairs(rightColumn) do
    local entries = entriesForLabel(label)
    if #entries == 0 then
      table.insert(rightRows, { label = label, entry = nil })
    else
      for _, entry in ipairs(entries) do
        table.insert(rightRows, { label = label, entry = entry })
      end
    end
  end

  local maxRows = math.max(#leftRows, #rightRows)
  local rowHeight = 40
  local bottomPadding = 40
  local desiredTabBodyHeight = noteOffset + (maxRows * rowHeight) + bottomPadding
  if desiredTabBodyHeight < 260 then
    desiredTabBodyHeight = 260
  end
  local chromeHeight = frame:GetHeight() - frame.tabBody:GetHeight()
  frame.tabBody:SetHeight(desiredTabBodyHeight)
  frame:SetHeight(chromeHeight + desiredTabBodyHeight)

  local function addSlotRow(row, columnX, rowIndex)
    local label = row.label
    local entry = row.entry
    local itemId = entry and entry.itemId or nil
    local itemName = "Unknown"
    if itemId then
      itemName = GetItemInfo(itemId)
      if not itemName or itemName == "" then
        itemName = "Item #" .. itemId
      end
    end
    local sourceText = formatSource(entry)

    local row = CreateFrame("Frame", nil, frame.tabBody)
    row:SetSize(columnWidth, rowHeight)
    row:SetPoint("TOPLEFT", columnX, -noteOffset - ((rowIndex - 1) * rowHeight))

    local icon = row:CreateTexture(nil, "ARTWORK")
    icon:SetSize(iconSize, iconSize)
    icon:SetPoint("TOPLEFT", 0, -2)
    if itemId then
      icon:SetTexture(GetItemIcon(itemId) or "Interface\\Icons\\INV_Misc_QuestionMark")
    else
      icon:SetTexture(slotIcons[label])
    end

    row:EnableMouse(true)
    row:SetScript("OnEnter", function(self)
      if itemId then
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetHyperlink("item:" .. itemId)
        GameTooltip:Show()
      end
    end)
    row:SetScript("OnLeave", function()
      GameTooltip:Hide()
    end)

    local itemText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    itemText:SetPoint("TOPLEFT", icon, "TOPRIGHT", 6, 0)
    local textWidth = columnWidth - iconSize - 6
    if entry and entry.heroSymbol then
      textWidth = textWidth - 18
    end
    itemText:SetWidth(textWidth)
    itemText:SetJustifyH("LEFT")
    itemText:SetText(itemName)
    if entry and entry.heroSymbol then
      addHeroIcon(row, entry.heroSymbol, itemText, classTag)
    end

    local source = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    source:SetPoint("TOPLEFT", icon, "BOTTOMRIGHT", 6, 3)
    source:SetWidth(columnWidth - iconSize - 6)
    source:SetJustifyH("LEFT")
    source:SetText(sourceText)

    table.insert(frame.tabBody.items, row)
  end

  for index, row in ipairs(leftRows) do
    addSlotRow(row, 0, index)
  end

  for index, row in ipairs(rightRows) do
    addSlotRow(row, columnWidth + 20, index)
  end
end

if not DeegoUI.itemInfoFrame then
  DeegoUI.itemInfoFrame = CreateFrame("Frame")
  DeegoUI.itemInfoFrame:RegisterEvent("GET_ITEM_INFO_RECEIVED")
  DeegoUI.itemInfoFrame:SetScript("OnEvent", function()
    if frame:IsShown() and DeegoUI.view == "summary" and frame.tabs.selected == "Overall" then
      DeegoUI.UpdateTabContent()
    end
    if frame:IsShown() and DeegoUI.view == "summary" and frame.tabs.selected == "Mythic +" then
      DeegoUI.UpdateTabContent()
    end
    if frame:IsShown() and DeegoUI.view == "summary" and frame.tabs.selected == "Raid" then
      DeegoUI.UpdateTabContent()
    end
    if frame:IsShown() and DeegoUI.view == "summary" and frame.tabs.selected == "Trinkets" then
      DeegoUI.UpdateTabContent()
    end
  end)
end

local classOrder = {
  "DEATHKNIGHT",
  "DEMONHUNTER",
  "DRUID",
  "EVOKER",
  "HUNTER",
  "MAGE",
  "MONK",
  "PALADIN",
  "PRIEST",
  "ROGUE",
  "SHAMAN",
  "WARLOCK",
  "WARRIOR",
}

function DeegoUI.LayoutClassBar()
  if not frame.classBar or not frame.classBar.buttons then
    return
  end
  local size = 36
  local count = #classOrder
  local columns = math.ceil(count / 2)
  local barWidth = frame.classBar:GetWidth() or (size * columns)
  local spacing = 2
  if columns > 1 then
    spacing = math.max(1, math.min(2, (barWidth - (size * columns)) / (columns - 1)))
  end
  local topCount = columns
  local bottomCount = count - columns
  local function rowPadding(items)
    if items <= 0 then
      return 0
    end
    local rowWidth = (items * size) + (spacing * (items - 1))
    if barWidth > rowWidth then
      return (barWidth - rowWidth) / 2
    end
    return 0
  end
  local topPadding = rowPadding(topCount)
  local bottomPadding = rowPadding(bottomCount)
  for index, classTag in ipairs(classOrder) do
    local button = frame.classBar.buttons[classTag]
    if button then
      local row = math.floor((index - 1) / columns)
      local col = (index - 1) % columns
      local padding = row == 0 and topPadding or bottomPadding
      button:ClearAllPoints()
      button:SetSize(size, size)
      button:SetPoint("TOPLEFT", padding + col * (size + spacing), -(row * (size + spacing)))
    end
  end
end

do
  local size = 36
  for _, classTag in ipairs(classOrder) do
    local button = CreateFrame("Button", nil, frame.classBar)
    button:SetSize(size, size)
    button.border = CreateFrame("Frame", nil, button, "BackdropTemplate")
    button.border:SetAllPoints()
    button.border:SetBackdrop({
      edgeFile = "Interface\\Buttons\\WHITE8X8",
      edgeSize = 1,
    })
    button.border:Hide()
    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetAllPoints()
    icon:SetTexture("Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES")
    local coords = CLASS_ICON_TCOORDS[classTag]
    if coords then
      icon:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
    end
    button.icon = icon
    button:SetScript("OnClick", function()
      DeegoUI.SelectClass(classTag)
    end)
    frame.classBar.buttons[classTag] = button
  end
  DeegoUI.LayoutClassBar()
end

function DeegoUI.RenderOverlay()
  return
end
