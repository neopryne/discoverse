local vter = mods.multiverse.vter
local lwl = mods.lightweight_lua
local lwui = mods.lightweight_user_interface
local dvsd = mods.discoVerseStaticDefinitions
local mde = mods.multiverseDiscoEngine

local MAIN_LAYER = "MOUSE_CONTROL_PRE"
local DISCO_TRAIT_RATIO = (368/512)
local imageHeight = 135
local imageWidth = imageHeight * DISCO_TRAIT_RATIO
local textHeight = 20

local mGuiMode = 0 -- 1=stats, 2= crew, 0= normal


---------------------------------------UI------------------------------------------------
---Open issues: no sound
local function NOOP() end

local function statScreenToggle()
    if mGuiMode == 0 then
        mGuiMode = 1
    else
        mGuiMode = 0
    end
end

local function statScreenSwitch()
    if mGuiMode == 1 then
        mGuiMode = 2
    elseif mGuiMode == 2 then
        mGuiMode = 1
    end
end

script.on_internal_event(Defines.InternalEvents.ON_KEY_DOWN, function(Key)
    --esc makes this 0
    if Key == 27 then
        if mGuiMode ~= 0 then
            mGuiMode = 0
            return Defines.Chain.PREEMPT
        end
    elseif Key == 9 then
        statScreenSwitch()
    end
end)

--todo this should probably be its own class.
local function inGame()
    local commandGui = Hyperspace.Global.GetInstance():GetCApp().gui
    return Hyperspace.ships(0) and (Hyperspace.ships(0).iCustomizeMode == 0) and not commandGui.menu_pause
end

local function statScreenVisibility()
    return inGame and mGuiMode == 1
end

local function crewScreenVisibility()
    return inGame and mGuiMode == 2
end

local function eitherScreenVisibility()
    return statScreenVisibility() or crewScreenVisibility()
end


local mDefaultShipIcon = Hyperspace.Resources:CreateImagePrimitiveString("map/map_icon_ship.png", 0, 0, 0, Graphics.GL_Color(1, 1, 1, 1), 1, false)
--local mDefaultShipIcon = Hyperspace.Resources:CreateImagePrimitiveString("d6_6.png", 0, 0, 0, Graphics.GL_Color(1, 1, 1, 1), 1, false)
local function traitBoxRender(textBox)
    if textBox.statSource then
        textBox.text = "       "..(math.floor(textBox.statSource.stat*100)/100) --two decimal places
        --

        local baseId = textBox.statSource.species
        local fallbackId = textBox.statSource.race
        local animHolder = lwl.getCrewPortraitAnim(baseId, fallbackId)
        textBox.crewAnim = animHolder and animHolder.anim or nil
        local mask = textBox.maskFunction()
        Graphics.CSurface.GL_PushMatrix()
        
        if textBox.crewAnim then
            textBox.crewAnim.position = Hyperspace.Pointf(mask.getPos().x - 3, mask.getPos().y - 10)
            textBox.crewAnim:SetCurrentFrame(0)
            --Graphics.CSurface.GL_DrawRect(mask.getPos().x, mask.getPos().y, mask.width, mask.height, Graphics.GL_Color(.42, .61, .61, .6))
            textBox.crewAnim:OnRender(1, Graphics.GL_Color(1, 1, 1, 1), false)
        else --TODO render miniship icon
            Graphics.CSurface.GL_PushMatrix()
            Graphics.CSurface.GL_Translate(mask.getPos().x - 24, mask.getPos().y - 24, 0)
            Graphics.CSurface.GL_RenderPrimitive(mDefaultShipIcon)
            Graphics.CSurface.GL_PopMatrix()
        end
        Graphics.CSurface.GL_PopMatrix()
    else
        lwui.solidRectRenderFunction(Graphics.GL_Color(.8, .2, .2, .3))(textBox)
    end
end



--The render function of the containers is off.  Idk what's up with it.
local backgroundFilter = lwui.buildObject(0, 0, 1280, 720, eitherScreenVisibility, lwui.solidRectRenderFunction(Graphics.GL_Color(0, 0, .0, .5)))
local backgroundFilter2 = lwui.buildObject(0, 0, 1280, 720, eitherScreenVisibility, lwui.solidRectRenderFunction(Graphics.GL_Color(.303, .284, .055, .9)))
local backgroundFilter3 = lwui.buildObject(0, 0, 1280, 720, eitherScreenVisibility, lwui.solidRectRenderFunction(Graphics.GL_Color(.23, .097, .39, .55)))
lwui.addTopLevelObject(backgroundFilter, MAIN_LAYER)
lwui.addTopLevelObject(backgroundFilter2, MAIN_LAYER)
lwui.addTopLevelObject(backgroundFilter3, MAIN_LAYER)
local statRowsContainer = lwui.buildVerticalContainer(183, 9, 900, 1, statScreenVisibility, lwui.solidRectRenderFunction(Graphics.GL_Color(.024, .131, .292, .6)), {}, false, true, 0)
for _,category in ipairs(dvsd.TRAIT_CATEGORIES) do
    --The height of this row needs to be exactly right.
    local currentRow = lwui.buildHorizontalContainer(0, 0, 1, imageHeight + (textHeight * 2), statScreenVisibility, NOOP, {}, true, false, 15)
    local rowTitleText = lwui.buildFixedTextBox(0, 0, imageWidth, imageWidth,
        statScreenVisibility, NOOP, 30)
    rowTitleText.text = category.name
    rowTitleText.textColor = category.color
    currentRow.addObject(rowTitleText)
    for _,trait in pairs(dvsd.TRAIT_DEFINITIONS) do
        if trait.category == category then
            local traitContainer = lwui.buildVerticalContainer(0, 0, imageWidth, 1, statScreenVisibility, NOOP, {}, true, false, 0)
            traitContainer.addObject(lwui.buildObject(0, 0, imageWidth, imageHeight,
                statScreenVisibility, lwui.spriteRenderFunction("attributes/"..trait.definition.internalName..".png")))
            local traitNameBox = lwui.buildFixedTextBox(0, 0, imageWidth, textHeight,
                statScreenVisibility, NOOP, 30)
            traitNameBox.text = trait.definition.name
            traitNameBox.textColor = category.color
            local traitValueBox = lwui.buildFixedTextBox(0, 0, imageWidth, textHeight,
                statScreenVisibility, traitBoxRender, 30)
            --traitValue.textColor = category.color
            mde.mTraitBoxes[trait.definition.internalName] = traitValueBox
            traitContainer.addObject(traitNameBox)
            traitContainer.addObject(traitValueBox)
            currentRow.addObject(traitContainer)
        end
    end
    statRowsContainer.addObject(currentRow)
end
lwui.addTopLevelObject(statRowsContainer, MAIN_LAYER)


-----------Crew Screen--------------
--Actually I decided I didn't want this
--[[
local statScreen = lwui.buildObject(0, 0, 300, 400,
    statScreenVisibility, lwui.solidRectRenderFunction(Graphics.GL_Color(1, 1, 1, 1)))
lwui.addTopLevelObject(statScreen, "MOUSE_CONTROL_PRE")]]

local switchScreenButton = lwui.buildButton(1218, 585, 30, 30, --disco icon?
    eitherScreenVisibility, lwui.solidRectRenderFunction(Graphics.GL_Color(1, 0, 0, 1)), statScreenSwitch, NOOP)

local statScreenButtonIcons = {"d6_6.png", "d6_1.png"}
local function statScreenButtonIndex()
    if mGuiMode == 0 then
        return 1
    else
        return 2
    end
end
local statScreenButton = lwui.buildButton(1218, 625, 30, 30, --disco icon?
    inGame, lwui.dynamicSpriteRenderFunction(statScreenButtonIcons, statScreenButtonIndex), statScreenToggle, NOOP)
--lwui.addTopLevelObject(switchScreenButton, MAIN_LAYER)
lwui.addTopLevelObject(statScreenButton, MAIN_LAYER)