require("UI.UIBasePanel")

UIWeaponSkillInfoPanel = class("UIWeaponSkillInfoPanel", UIBasePanel)
UIWeaponSkillInfoPanel.__index = UIWeaponSkillInfoPanel

UIWeaponSkillInfoPanel.skillId = 0
UIWeaponSkillInfoPanel.curSkillLevel = 0
UIWeaponSkillInfoPanel.skillDetailList = {}

function UIWeaponSkillInfoPanel:ctor()
    UIWeaponSkillInfoPanel.super.ctor(self)
end

function UIWeaponSkillInfoPanel.Close()
    self = UIWeaponSkillInfoPanel
    UIManager.CloseUI(UIDef.UIWeaponSkillInfoPanel)
end

function UIWeaponSkillInfoPanel.OnRelease()
    self = UIWeaponSkillInfoPanel
    UIWeaponSkillInfoPanel.skillDetailList = {}
end

function UIWeaponSkillInfoPanel.Init(root, data)
    self = UIWeaponSkillInfoPanel
    UIWeaponSkillInfoPanel.super.SetRoot(UIWeaponSkillInfoPanel, root)

    UIWeaponSkillInfoPanel.mView = UIWeaponSkillInfoPanelView.New()
    UIWeaponSkillInfoPanel.mView:InitCtrl(root)

    self.skillId = data[1]
    self.curSkillLevel = data[2]

    self.mIsPop = true
end

function UIWeaponSkillInfoPanel.OnInit()
    self = UIWeaponSkillInfoPanel

    UIWeaponSkillInfoPanel.super.SetPosZ(UIWeaponSkillInfoPanel)

    UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = function()
        UIWeaponSkillInfoPanel.Close()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_BgClose.gameObject).onClick = function()
        UIWeaponSkillInfoPanel.Close()
    end


    self:SetDataById(self.skillId, self.curSkillLevel)
end

function UIWeaponSkillInfoPanel:SetDataById(skillId, curSkillLevel)
    if skillId and curSkillLevel then
        local groupData = TableData.listSkillGroupDatas:GetDataById(skillId)
        if groupData then
            local maxLevel = NetCmdGunSkillData:GetSkillGroupMaxLevel(groupData.group_id)
            local skillList = {}
            for i = 1, maxLevel do
                local skillData = TableData.GetGroupSkill(groupData.group_id, i)
                if i == 1 then
                    self.mView.mText_LevelDesc.text = skillData.description.str
                else
                    table.insert(skillList, skillData)
                end
            end

            for i = 1, #skillList do
                local item = nil
                if i <= #self.skillDetailList then
                    item = self.skillDetailList[i]
                else
                    item = UISkillDetailItem.New()
                    item:InitCtrl(self.mView.mTrans_DescList)
                    table.insert(self.skillDetailList, item)
                end
                item:SetData(skillList[i], curSkillLevel, ColorUtils.BlackColor)
            end
        end
    end
end



