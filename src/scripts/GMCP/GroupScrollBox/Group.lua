-- Initialize font size for the group list
local groupCurrentFontSize = content_preferences["GUI.GroupScrollBox"] and content_preferences["GUI.GroupScrollBox"].fontSize or 12
local groupMinFontSize = 1 -- Minimum allowed font size

-- Define CSS for the group list with dynamic font size
function getGroupListCSS(fontSize)
    return CSSMan.new([[
        qproperty-wordWrap: true;
        qproperty-alignment: 'AlignTop';
        font-size: ]] .. fontSize .. [[px;
    ]])
end

-- Function to adjust the font size of the group list
function adjustFontSizeGroupList(adjustment)
    groupCurrentFontSize = groupCurrentFontSize + adjustment
    if groupCurrentFontSize < groupMinFontSize then
        groupCurrentFontSize = groupMinFontSize
    end -- Ensure font size doesn't drop below the minimum
    -- Update preferences and save
    content_preferences["GUI.GroupScrollBox"].fontSize = groupCurrentFontSize
    table.save(content_preferences_file, content_preferences)
    Group() -- Rebuild the group list with the updated font size
end

-- Create the font adjustment panel for the group list
function createFontAdjustmentPanelForGroup()
    -- Background label for the adjustment panel
    GUI.GroupFontAdjustmentBackgroundLabel = Geyser.Label:new({
        name = "GUI.GroupFontAdjustmentBackgroundLabel",
        x = 0,
        y = 0,
        width = "100%",
        height = "25px"
    }, GUI.GroupScrollBox)

    -- Set the background color for the panel
    GUI.GroupFontAdjustmentBackgroundLabel:setStyleSheet([[
        QLabel{
            background-color: rgba(0,0,0,255);
        }
    ]])

    -- Main container (HBox) to hold the "+" and "-" buttons
    GUI.GroupFontAdjustmentHBox = Geyser.Label:new({
        name = "GUI.GroupFontAdjustmentHBox",
        x = 0,
        y = 0,
        width = "100%",
        height = "25px"
    }, GUI.GroupFontAdjustmentBackgroundLabel)

    -- Left filler to center the "+" and "-" buttons
    GUI.GroupLeftFillerLabel = Geyser.Label:new({
        name = "GUI.GroupLeftFillerLabel",
        x = 0,
        y = 0,
        width = "75%",
        height = "25px"
    }, GUI.GroupFontAdjustmentHBox)

    -- Empty left filler area
    GUI.GroupLeftFillerLabel:setStyleSheet([[
        background-color: rgba(0,0,0,255);
        border-style: solid;
        border-width: 0px;
        text-align: left;
    ]])

    -- Label for the "+" button to increase font size
    GUI.GroupPlusLabel = Geyser.Label:new({
        name = "GUI.GroupPlusLabel",
        x = "75%",
        y = 0,
        width = "11%",
        height = "25px",
        message = "<center><font size=\"4\" color=\"green\">+</font></center>"
    }, GUI.GroupFontAdjustmentHBox)

    -- Attach the click callback to increase the font size when "+" is clicked
    GUI.GroupPlusLabel:setClickCallback(function()
        adjustFontSizeGroupList(1)
    end)

    -- Style the "+" button
    GUI.GroupPlusLabel:setStyleSheet([[
        background-color: rgba(0,0,0,255);
        border-style: solid;
        border-width: 1px;
        text-align: center;
    ]])

    -- Label for the "-" button to decrease font size
    GUI.GroupMinusLabel = Geyser.Label:new({
        name = "GUI.GroupMinusLabel",
        x = "85%",
        y = 0,
        width = "10%",
        height = "25px",
        message = "<center><font size=\"4\" color=\"red\">-</font></center>"
    }, GUI.GroupFontAdjustmentHBox)

    -- Attach the click callback to decrease the font size when "-" is clicked
    GUI.GroupMinusLabel:setClickCallback(function()
        adjustFontSizeGroupList(-1)
    end)

    -- Style the "-" button
    GUI.GroupMinusLabel:setStyleSheet([[
        background-color: rgba(0,0,0,255);
        border-style: solid;
        border-width: 1px;
        text-align: center;
    ]])
end

-- Generate group member entry HTML
local function generateGroupMemberEntry(member, leader)
    local entry = string.format(
        "<tr><td width=\"100%%\" valign=\"center\" align=\"left\"><font size=\"%d\" color=\"yellow\"><b>%s</b></font>",
        groupCurrentFontSize, firstToUpper(member.name)
    )

    if member.name == leader then
        entry = entry .. string.format(" <font size=\"%d\" color=\"magenta\">(Leader)</font>", groupCurrentFontSize)
    end
    if member.info.here == "Yes" then
        entry = entry .. string.format(" <font size=\"%d\" color=\"green\">(Here)</font>", groupCurrentFontSize)
    else
        entry = entry .. string.format(" <font size=\"%d\" color=\"red\">(Not Here)</font>", groupCurrentFontSize)
    end

    -- Add HP, SP, FP percentages
    local percent_hp = math.floor((member.info.hp / member.info.maxhp) * 100)
    local percent_sp = math.floor((member.info.sp / member.info.maxsp) * 100)
    local percent_fp = math.floor((member.info.fp / member.info.maxfp) * 100)

    entry = entry .. string.format(
        "<br><font size=\"%d\" color=\"white\">HP:</font> <font size=\"%d\" color=\"silver\">%d%%</font>, " ..
        "<font size=\"%d\" color=\"white\">SP:</font> <font size=\"%d\" color=\"silver\">%d%%</font>, " ..
        "<font size=\"%d\" color=\"white\">FP:</font> <font size=\"%d\" color=\"silver\">%d%%</font>",
        groupCurrentFontSize, groupCurrentFontSize, percent_hp,
        groupCurrentFontSize, groupCurrentFontSize, percent_sp,
        groupCurrentFontSize, groupCurrentFontSize, percent_fp
    )

    return entry .. "</td></tr>"
end

-- Create the Group List HTML
function Group()
    local groupListHTML = "<table>"

    if not gmcp.Group or not gmcp.Group.members then
        groupListHTML = groupListHTML .. string.format(
            "<tr><td><font size=\"%d\" color=\"red\">No group data available.</font></td></tr>",
            groupCurrentFontSize
        )
    else
        local group_members = gmcp.Group.members
        local leader = gmcp.Group.leader
        local group_name = gmcp.Group.groupname or nil

        if group_name then
            groupListHTML = groupListHTML .. string.format(
                "<tr><td colspan=\"2\"><font size=\"%d\" color=\"cyan\"><b>%s</b></font></td></tr>",
                groupCurrentFontSize, group_name
            )
        end

        for _, member in ipairs(group_members) do
            groupListHTML = groupListHTML .. generateGroupMemberEntry(member, leader)
        end
    end

    groupListHTML = groupListHTML .. "</table>"

    -- Display the group list in the GUI
    GUI.GroupListLabel = GUI.GroupListLabel or Geyser.Label:new({
        name = "GUI.GroupListLabel",
        x = 0,
        y = "25px",
        width = "100%",
        height = "400%"
    }, GUI.GroupScrollBox)

    GUI.GroupListLabel:setStyleSheet(getGroupListCSS(groupCurrentFontSize):getCSS())
    setBackgroundColor("GUI.GroupListLabel", 0, 0, 0)
    GUI.GroupListLabel:echo(groupListHTML)
end

-- Create the font adjustment panel and the group list
createFontAdjustmentPanelForGroup()
Group()
