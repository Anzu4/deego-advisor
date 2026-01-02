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
    if not DeegoDB.overlay then
      DeegoDB.overlay = {
        point = "TOPLEFT",
        x = 18,
        y = -120,
      }
    end
    DeegoUI.RenderOverlay()
  elseif event == "PLAYER_LOGIN" then
    DeegoUI.RenderOverlay()
  end
end)
