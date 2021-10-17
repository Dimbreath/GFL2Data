--region *.lua

require("UI.UIBaseView")
require("UI.Carrier.UICarrierItem")
require("UI.Formation.UIFormationTeamTipItem")

UIFormationView = class("UIFormationView", UIBaseView);
UIFormationView.__index = UIFormationView;

-----------------------[控件]----------------------
UIFormationView.mText_TeamName = nil;
UIFormationView.mText_Power = nil;

UIFormationView.mButton_Return = nil;

UIFormationView.mGroup_Characters = {};
UIFormationView.mList_TeamTips = {};

UIFormationView.mObj_3DCharacterNodes = {};
UIFormationView.mObj_NoneCharacterNodes = {};

UIFormationView.mList_Characters = {};
UIFormationView.mList_CharactersBtn = {};

UIFormationView.mObj_CarrierSelect = nil;
UIFormationView.mObj_NodeCarrier = nil;

-----------------------[载具]----------------------
UIFormationView.mCarrierItem = nil;
UIFormationView.mObj_VechileNode = nil;

--构造
function UIFormationView:ctor()
    UIFormationView.super.ctor(self);
end

--初始化
function UIFormationView:InitCtrl(root)

    self:SetRoot(root);

    self.mButton_Return = self:GetButton("TopPanel/Return");

    self.mText_TeamName = self:GetText("TopPanel/TeamOverview/TeamName/Text");
    self.mText_Power = self:GetText("TopPanel/TeamOverview/TeamPower");

    self.mList_TeamTips = List:New(UIFormationTeamTipItem);
    self.mObj_CarrierSelect = self:FindChild("VehicleSelected");

    --左侧队伍标签
    local teamNode = self:FindChild("LeftPanel/TeamList");
    for i = 0, teamNode.childCount - 1 do
        local nodeChild = teamNode:GetChild(i);
        self:InitTeamTips(nodeChild);
    end

    --中间四个点击区域
    local cBtnNode = self:FindChild("CenterPanel");
    for i = 0, cBtnNode.childCount - 1 do
        local nodeChild = cBtnNode:GetChild(i);
        self.mList_CharactersBtn[i + 1] = UIUtils.GetListener(nodeChild);;
    end

    --下面人形简介
    local characterNode = self:FindChild("ButtonPanel/UnitsPanel");
    for i = 0, characterNode.childCount - 1 do
        local nodeChild = characterNode:GetChild(i);
        self.mList_Characters[i + 1] = nodeChild;
    end

    --3D模型节点
    local modNode = UIUtils.FindTransform("UnitRoot");

    if modNode ~= nil then
        for i = 0, modNode.childCount - 1 do
            local nodeChild = modNode:GetChild(i);
            self.mObj_3DCharacterNodes[i + 1] = nodeChild;
            self.mObj_NoneCharacterNodes[i + 1] = nodeChild:GetChild(0);
        end
    end

    self.mObj_NodeCarrier = UIUtils.FindGameObject("Vehicle/VehicleEmpty");
    self.mObj_VechileNode = UIUtils.FindTransform("Vehicle");
    self:InitCarrierItem(self:FindChild("ButtonPanel/vehiclesPanel/VehicleInfo").transform);
end

function UIFormationView:InitCarrierItem(carrierRoot)

    self.mCarrierItem = UICarrierItem.New();
    self.mCarrierItem:InitCtrl(carrierRoot);

end

function UIFormationView:InitTeamTips(teammateTipRoot)
    local item = UIFormationTeamTipItem.New();
    item:InitCtrl(teammateTipRoot);

    self.mList_TeamTips:Add(item);
end

function UIFormationView:ShowTeam(teamIndex)
    self.mList_TeamTips[teamIndex]:ShowSelected();

    for i = 1, self.mList_Team:Count() do
        if teamIndex ~= i then
            self.mList_TeamTips[teamIndex]:ShowRegular();
        end
    end
end

function UIFormationView:SetCarrierSelected(enable)
    setactive(self.mObj_NodeCarrier, enable);
    setactive(self.mObj_CarrierSelect.gameObject, enable);
end

--endregion
