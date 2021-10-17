require("UI.UIBaseView")

UIEquipFullMessageView = class("UIEquipFullMessageView", UIBaseView);
UIEquipFullMessageView.__index = UIEquipFullMessageView

--@@ GF Auto Gen Block Begin
UIEquipFullMessageView.mBtn_Expansion = nil;
UIEquipFullMessageView.mBtn_SortOut = nil;
UIEquipFullMessageView.mBtn_Cancel = nil;
UIEquipFullMessageView.mText_Description = nil;

function UIEquipFullMessageView:__InitCtrl()

    self.mBtn_Expansion = self:GetButton("Btn_Expansion");
    self.mBtn_SortOut = self:GetButton("Btn_SortOut");
    self.mBtn_Cancel = self:GetButton("Btn_Cancel");
    self.mText_Description = self:GetText("Text_Description");

    UIUtils.GetButtonListener(self.mBtn_Expansion.gameObject).onClick = function(obj)
        self:OnBtnGetExtraCapacityClick()
    end
    UIUtils.GetButtonListener(self.mBtn_SortOut.gameObject).onClick = function(obj)
        self:OnBtnSoldClick()
    end

    UIUtils.GetButtonListener(self.mBtn_Cancel.gameObject).onClick = function(obj)
        self:OnUIEquipFullMessageClick()
    end
end

--@@ GF Auto Gen Block End

UIEquipFullMessageView.parent = nil
UIEquipFullMessageView.curType = 0

function UIEquipFullMessageView:InitCtrl(parent)
    --实例化
    self.parent = parent
    local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/UIEquipFullMessage.prefab",self));
    self:SetRoot(obj.transform);
    setparent(parent, obj.transform);
    obj.transform.localScale = vectorone;
    obj.transform.anchoredPosition = CS.Vector2.zero;
    obj.transform.offsetMin = CS.Vector2.zero;
    obj.transform.offsetMax = CS.Vector2.zero;
    self:SetRoot(obj.transform);
    self:__InitCtrl();

    self:SetPosZ(-20);
end

--- type == 1  装备满
--- type == 2  芯片满
function UIEquipFullMessageView:SetData(type)
    self.curType = type
    local hint = ""
    local canBuyGrid = false
    if type == 1 then
        hint = TableData.GetHintById(30009)
        canBuyGrid = NetCmdStoreData:GetStoreGoodById(5).remain_times > 0
    elseif type == 2 then
        hint = TableData.GetHintById(30010)
        canBuyGrid = NetCmdStoreData:GetStoreGoodById(6).remain_times > 0
    end

    self.mText_Description.text = hint
    setactive(self.mBtn_Expansion.gameObject, canBuyGrid)
end

function UIEquipFullMessageView:OnBtnGetExtraCapacityClick()
    local extendPanel = UIExtendedPanel.New()
    extendPanel:InitCtrl(self.parent)
    extendPanel:SetData(self.curType)
    self:OnUIEquipFullMessageClick()
end

function UIEquipFullMessageView:OnBtnSoldClick()
    if self.curType == 1 then
        UIManager.OpenUIByParam(UIDef.UIRepositoryPanelV2, 2)
    elseif self.curType == 2 then
        UIManager.OpenUIByParam(UIDef.UIRepositoryPanelV2, 3)
    end
    self:OnUIEquipFullMessageClick()
    MessageSys:SendMessage(5100,nil,nil);
end

function UIEquipFullMessageView:OnUIEquipFullMessageClick()
    gfdestroy(self.mUIRoot.gameObject)
end