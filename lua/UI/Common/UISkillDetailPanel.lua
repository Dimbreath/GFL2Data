require("UI.UIBasePanel")

UISkillDetailPanel = class("UISkillDetailPanel", UIBasePanel)
UISkillDetailPanel.__index = UISkillDetailPanel

UISkillDetailPanel.skillGroupId = 0
UISkillDetailPanel.curSkillLevel = 0
UISkillDetailPanel.skillDetailList = {}

function UISkillDetailPanel:ctor()
    UISkillDetailPanel.super.ctor(self)
end

function UISkillDetailPanel.Close()
    self = UISkillDetailPanel
    UIManager.CloseUI(UIDef.UISkillDetailPanel)
end

function UISkillDetailPanel.OnRelease()
    self = UISkillDetailPanel
    UISkillDetailPanel.skillDetailList = {}
end

function UISkillDetailPanel.Init(root, data)
    self = UISkillDetailPanel

    UISkillDetailPanel.super.SetRoot(UISkillDetailPanel, root)

    self:InitView(root)

    self.skillGroupId = data[1]
    self.curSkillLevel = data[2]

    self.mIsPop = true
end

function UISkillDetailPanel:InitView(root)
    self.mUIRoot = root
    self.mBtn_Close = UIUtils.GetRectTransform(root,"panel/Btn_Close")
    self.mTrans_SkillList = UIUtils.GetRectTransform(root, "panel/Scroll View/Viewport/Trans_Content")

    UIUtils.GetButtonListener(self.mBtn_Close.gameObject).onClick = function()
        UISkillDetailPanel.Close()
    end
end

function UISkillDetailPanel.OnInit()
    self = UISkillDetailPanel

    self:SetDataById(self.skillGroupId, self.curSkillLevel)
end

function UISkillDetailPanel.OnShow()
    self = UISkillDetailPanel
    self.mUIRoot.transform.localPosition = Vector3(0, 0, -1500)
end

function UISkillDetailPanel:SetDataById(skillGroupId, curSkillLevel)
    if skillGroupId and curSkillLevel then
        local maxLevel = NetCmdGunSkillData:GetSkillGroupMaxLevel(skillGroupId)
        local skillList = {}
        for i = 1, maxLevel do
            local skillData = TableData.GetGroupSkill(skillGroupId, i)
            table.insert(skillList, skillData)
        end

        for i = 1, #skillList do
            local item = nil
            if i <= #self.skillDetailList then
                item = self.skillDetailList[i]
            else
                item = UISkillDetailItem.New()
                item:InitCtrl(self.mTrans_SkillList)
                table.insert(self.skillDetailList, item)
            end
            item:SetData(skillList[i], curSkillLevel)
            item:SetCurrent(curSkillLevel == skillList[i].level)
        end
    end
end

function UISkillDetailPanel:UpdateSkillDetail(curSkill)
    if curSkill then
        local skillList = {}
        for i = 1, curSkill.maxLevel do
            local skillData = TableData.GetGroupSkill(curSkill.skillGroup.group_id, i)
            table.insert(skillList, skillData)
        end

        for i = 1, #skillList do
            local item = nil
            if i <= #self.skillDetailList then
                item = self.skillDetailList[i]
            else
                item = UISkillDetailItem.New()
                item:InitCtrl(self.mTrans_SkillList)
                table.insert(self.skillDetailList, item)
            end
            item:SetData(skillList[i], curSkill.data.level)
            item:SetCurrent(curSkill.data.level == skillList[i].level)
        end
    end
end
