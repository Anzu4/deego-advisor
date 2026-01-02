local addonName = ...

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")

SLASH_DEEGO1 = "/deego"
SlashCmdList.DEEGO = function()
  DeegoUI.Toggle()
  DeegoUI.RenderSummary()
end

frame:SetScript("OnEvent", function(_, event, name)
  if event == "ADDON_LOADED" and name == addonName then
    if not DeegoDB then
      DeegoDB = {}
    end
    -- Overlay removed.
  elseif event == "PLAYER_LOGIN" then
    -- Overlay removed.
  end
end)
