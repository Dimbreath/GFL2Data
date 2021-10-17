require("UI.UIBasePanel")

UIUnitInfoPanel = class("UIUnitInfoPanel", UIBasePanel)
UIUnitInfoPanel.__index = UIUnitInfoPanel

UIUnitInfoPanel.ShowType =
{
    Enemy    = 1,
    Gun      = 2,
    GunItem  = 3,
}

UIUnitInfoPanel.mSortLayer = 0;
--- static func ---
function UIUnitInfoPanel.Open(type, data, level)
    UIManager.OpenUIByParam(UIDef.UIUnitInfoPanel, {type, data, level})
end
--- static func ---


function UIUnitInfoPanel:ctor()
    UIUnitInfoPanel.super.ctor(self)
end

function UIUnitInfoPanel.Close()
    UIManager.CloseUI(UIDef.UIUnitInfoPanel)
end

function UIUnitInfoPanel.OnRelease()
    self = UIUnitInfoPanel
    self.infoItem:Release()
end

function UIUnitInfoPanel.Init(root, data)
    self = UIUnitInfoPanel

    UIUnitInfoPanel.super.SetRoot(UIUnitInfoPanel, root)

    UIUnitInfoPanel.mView = UIUnitInfoPanelView.New()
    UIUnitInfoPanel.mView:InitCtrl(root)

    self.mIsPop = true

    if type(data) == "userdata" and data.Length >= 4 then
        UIUtils.AddSubCanvas(self.mUIRoot.gameObject, data[3], false)
        self.mSortLayer = data[3] 
    end

    if type(data) == "userdata" then
        data = { data[0], data[1], data[2] }
    end

   
    self.type = data[1]
    if self.type == UIUnitInfoPanel.ShowType.Enemy then
        self.data = TableData.GetEnemyData(data[2])
        self.stageLevel = data[3]
    elseif self.type == UIUnitInfoPanel.ShowType.Gun then
        self.data = data[2]
    elseif self.type == UIUnitInfoPanel.ShowType.GunItem then
        self.data = data[2]
    end

end

function UIUnitInfoPanel.OnInit()
    self = UIUnitInfoPanel

    UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = self.OnCloseClick
    self:UpdatePanel()
end


function UIUnitInfoPanel:UpdatePanel()
    self.infoItem = UICharacterInfoItem:New();
    self.infoItem:InitCtrl(self.mView.mTrans_GrpInfo)

    if self.type == UIUnitInfoPanel.ShowType.Enemy then
        self.infoItem:UpdateEnemyPanel(self.data, self.stageLevel, self.mSortLayer)
    elseif self.type == UIUnitInfoPanel.ShowType.Gun then
        self.infoItem:UpdateGunPanel(self.data)
    elseif self.type == UIUnitInfoPanel.ShowType.GunItem then
        self.infoItem:UpdateGunItemPanel(self.data)
    end
end

function UIUnitInfoPanel.OnCloseClick()
    UIUnitInfoPanel.Close()
end

