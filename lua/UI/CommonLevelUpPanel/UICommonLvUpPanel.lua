require("UI.UIBasePanel")

UICommonLvUpPanel = class("UICommonLvUpPanel", UIBasePanel)
UICommonLvUpPanel.__index = UICommonLvUpPanel

UICommonLvUpPanel.lvUpData = nil
UICommonLvUpPanel.attributeList = {}

function UICommonLvUpPanel:ctor()
    UICommonLvUpPanel.super.ctor(self)
end

function UICommonLvUpPanel.Close()
    self = UICommonLvUpPanel
    UIManager.CloseUI(UIDef.UICommonLvUpPanel)
end

function UICommonLvUpPanel.OnRelease()
    self = UICommonLvUpPanel
    UICommonLvUpPanel.attributeList = {}
end

function UICommonLvUpPanel.Init(root, data)
    self = UICommonLvUpPanel
    UICommonLvUpPanel.super.SetRoot(UICommonLvUpPanel, root)

    self.lvUpData = data

    self:InitView(root)

    self.mIsPop = true
end

function UICommonLvUpPanel:InitView(root)
    self.mUIRoot = root
    self.mBtn_Close = UIUtils.GetRectTransform(root,"Root/GrpBg/Btn_Close")
    self.mText_FromLv = UIUtils.GetText(root, "Root/GrpDialog/GrpCenter/GrpLevelUp/GrpTextNow/Text_Level")
    self.mText_ToLv = UIUtils.GetText(root, "Root/GrpDialog/GrpCenter/GrpLevelUp/GrpTextSoon/Text_Level")
    self.mTrans_AttrList = UIUtils.GetRectTransform(root, "Root/GrpDialog/GrpCenter/GrpPowerUp/AttributeList/Viewport/Content")
    self.mTrans_UnlockLevel = UIUtils.GetRectTransform(root, "Root/GrpDialog/GrpCenter/GrpPowerUp/Trans_UnLocked")
    self.mText_BreakLv = UIUtils.GetText(root, "Root/GrpDialog/GrpCenter/GrpPowerUp/Trans_UnLocked/Text_Name")
    self.mText_Title1 = UIUtils.GetText(root, "Root/GrpText/GrpContent/TextName")
    self.mText_Title2 = UIUtils.GetText(root, "Root/GrpDialog/GrpText/TitleText")

    UIUtils.GetButtonListener(self.mBtn_Close.gameObject).onClick = function()
        UICommonLvUpPanel.Close()
    end
end

function UICommonLvUpPanel.OnInit()
    self = UICommonLvUpPanel

    UICommonLvUpPanel.super.SetPosZ(UICommonLvUpPanel)

    self:UpdatePanel()
end

function UICommonLvUpPanel:UpdatePanel()
    if self.lvUpData then
        local title = TableData.GetHintById(self.lvUpData.titleHint)
        self.mText_FromLv.text = self.lvUpData.fromLv
        self.mText_ToLv.text = self.lvUpData.toLv
        self.mText_Title1.text = title
        self.mText_Title2.text = title

        if self.lvUpData.attrList then
            for i = 1, #self.lvUpData.attrList do
                local item = nil
                if i <= #self.attributeList then
                    item = self.attributeList[i]
                else
                    item = UICommonPropertyItem.New()
                    item:InitCtrl(self.mTrans_AttrList)
                    table.insert(self.attributeList, item)
                end

                item:SetData(self.lvUpData.attrList[i].data, self.lvUpData.attrList[i].value, false, false, i % 2 == 0, false)
                if self.lvUpData.attrList[i].isNew then
                    item:SetEquipNewProp()
                else
                    item:SetValueUp(self.lvUpData.attrList[i].upValue)
                end
            end
        end

        if self.lvUpData.breakLevel then
            self.mText_BreakLv.text = string_format(TableData.GetHintById(40008), self.lvUpData.breakLevel)
            setactive(self.mTrans_UnlockLevel, self.lvUpData.breakLevel > 0)
        else
            setactive(self.mTrans_UnlockLevel, false)
        end
    end
end
