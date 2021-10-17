require("UI.UIBaseCtrl")

UIEquipSetItem = class("UIEquipSetItem", UIBaseCtrl);
UIEquipSetItem.__index = UIEquipSetItem

function UIEquipSetItem:__InitCtrl()
    self.mText_Name = self:GetText("GrpSuitInfo/Text_Name")
    self.mText_SetCount = self:GetText("GrpSuitInfo/GrpNum/Text_Num")
    self.mText_Desc = self:GetText("Text_Describe")
end

function UIEquipSetItem:InitCtrl(parent)
    local itemPrefab = UIUtils.GetGizmosPrefab("Character/ChrEquipSkillItemV2.prefab", self)
    local instObj = instantiate(itemPrefab)

    UIUtils.AddListItem(instObj.gameObject, parent.gameObject)

    self:SetRoot(instObj.transform)
    self:__InitCtrl()
end

function UIEquipSetItem:SetData(setId, count)
    if setId then
        local tableData = TableData.listEquipSetDatas:GetDataById(setId)
        local setNum = 0
        local propName = ""
        local propValue = ""
        local skillDesc = ""
        if count == tableData.set1_num then
            local arg = tableData.args1
            local skillId = tableData.effect1_id
            if arg and arg ~= "" then
                local prop = string.split(arg, ",")
                local propData = TableData.GetPropertyDataByName(tostring(prop[1]), tonumber(prop[3]))
                if propData then
                    propName = propData.show_name.str
                    if propData.show_type == 2 then
                        propValue = (tonumber(prop[2]) / 10) .. "%"
                    else
                        propValue = (tonumber(prop[2]))
                    end
                end

            end
            if skillId and skillId ~= 0 then
                local skillData = TableData.listBattleSkillDatas:GetDataById(tonumber(skillId))
                skillDesc = skillData.description.str
            end

        elseif count == tableData.set2_num then
            local arg = tableData.args2
            local skillId = tableData.effect2_id
            if arg and arg ~= "" then
                local prop = string.split(arg, ",")
                local propData = TableData.GetPropertyDataByName(tostring(prop[1]), tonumber(prop[3]))
                if propData then
                    propName = propData.show_name.str
                    if propData.show_type == 2 then
                        propValue = (tonumber(prop[2]) / 10) .. "%"
                    else
                        propValue = (tonumber(prop[2]))
                    end
                end
            end
            if skillId and skillId ~= 0 then
                local skillData = TableData.listBattleSkillDatas:GetDataById(tonumber(skillId))
                skillDesc = skillData.description.str
            end
        end

        self.mText_Name.text = tableData.name.str
        self.mText_SetCount.text = count

        local desc = tableData.description.str
        if(count == tableData.set2_num) then
            desc = tableData.description2.str
        end
        self.mText_Desc.text = string_format(desc, skillDesc, propName, propValue)
        setactive(self.mUIRoot, true)
    else
        setactive(self.mUIRoot, false)
    end
end