require("UI.UIBasePanel")

UIWeaponPartCailbrationSucPanel = class("UIWeaponPartCailbrationSucPanel", UIBasePanel)
UIWeaponPartCailbrationSucPanel.__index = UIWeaponPartCailbrationSucPanel

UIWeaponPartCailbrationSucPanel.lvUpData = nil
UIWeaponPartCailbrationSucPanel.attributeList = {}

function UIWeaponPartCailbrationSucPanel:ctor()
    UIWeaponPartCailbrationSucPanel.super.ctor(self)
end

function UIWeaponPartCailbrationSucPanel.Close()
    self = UIWeaponPartCailbrationSucPanel
    UIManager.CloseUI(UIDef.UIWeaponPartCailbrationSucPanel)
end

function UIWeaponPartCailbrationSucPanel.OnRelease()
    self = UIWeaponPartCailbrationSucPanel
    UIWeaponPartCailbrationSucPanel.attributeList = {}
end

function UIWeaponPartCailbrationSucPanel.Init(root, data)
    self = UIWeaponPartCailbrationSucPanel
    UIWeaponPartCailbrationSucPanel.super.SetRoot(UIWeaponPartCailbrationSucPanel, root)

    self.lvUpData = data

    self:InitView(root)

    self.mIsPop = true
end

function UIWeaponPartCailbrationSucPanel:InitView(root)
    self.mUIRoot = root
    self.mBtn_Close = UIUtils.GetRectTransform(root,"Root/GrpBg/Btn_Close")
    self.mTrans_AttrList = UIUtils.GetRectTransform(root, "Root/GrpDialog/GrpCenter/GrpPowerUp/AttributeList/Viewport/Content")

    UIUtils.GetButtonListener(self.mBtn_Close.gameObject).onClick = function()
        UIWeaponPartCailbrationSucPanel.Close()
    end
end

function UIWeaponPartCailbrationSucPanel.OnInit()
    self = UIWeaponPartCailbrationSucPanel

    UIWeaponPartCailbrationSucPanel.super.SetPosZ(UIWeaponPartCailbrationSucPanel)

    self:UpdatePanel()
end

function UIWeaponPartCailbrationSucPanel:UpdatePanel()
    if self.lvUpData then
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
    end
end
