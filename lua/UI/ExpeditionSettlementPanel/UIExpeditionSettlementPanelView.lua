require("UI.UIBaseView")
require("UI.CharacterSettlementItem.CharacterSettlementItem")
require("UI.Common.UICommonItemS")

UIExpeditionSettlementPanelView = class("UIExpeditionSettlementPanelView", UIBaseView);
UIExpeditionSettlementPanelView.__index = UIExpeditionSettlementPanelView

--@@ GF Auto Gen Block Begin
UIExpeditionSettlementPanelView.mBtn_TopInformation_Return = nil;
UIExpeditionSettlementPanelView.mBtn_ExpeditionTask_ExpeditionTaskAward_GoExpedition = nil;
UIExpeditionSettlementPanelView.mBtn_ExpeditionTask_ExpeditionTaskAward_CancelExpedition = nil;
UIExpeditionSettlementPanelView.mImage_TopInformation_Coin_BodyCoin_CoinImage = nil;
UIExpeditionSettlementPanelView.mImage_TopInformation_Coin_GoldCoin_CoinImage = nil;
UIExpeditionSettlementPanelView.mImage_TopInformation_Coin_TokenCoin_CoinImage = nil;
UIExpeditionSettlementPanelView.mImage_ExpeditionTask_ExpeditionTaskAward_UserEXP_UserEXPGet = nil;
UIExpeditionSettlementPanelView.mImage_ExpeditionTask_ExpeditionTaskAward_UserEXP_UserEXPNow = nil;
UIExpeditionSettlementPanelView.mText_TopInformation_Coin_BodyCoin_CoinAmount = nil;
UIExpeditionSettlementPanelView.mText_TopInformation_Coin_GoldCoin_CoinAmount = nil;
UIExpeditionSettlementPanelView.mText_TopInformation_Coin_TokenCoin_CoinAmount = nil;
UIExpeditionSettlementPanelView.mText_ExpeditionTask_ExpeditionTitleInformation_ExpeditionDispatchReport_ExpeditionDispatchReport = nil;
UIExpeditionSettlementPanelView.mText_ExpeditionTask_ExpeditionTitleInformation_ExpeditionDispatchName_ExpeditionDispatchName = nil;
UIExpeditionSettlementPanelView.mText_ExpeditionTask_ExpeditionTitleInformation_ExpeditionDispatchResult = nil;
UIExpeditionSettlementPanelView.mText_ExpeditionTask_ExpeditionTaskAward_UserEXP_UserEXP = nil;
UIExpeditionSettlementPanelView.mScrRect_ExpeditionTask_ExpeditionTaskAward_DropItemList_ItemList = nil;
UIExpeditionSettlementPanelView.mTrans_ExpeditionTask_ExpeditionTitleInformation_ExpeditionDispatchResult = nil;
UIExpeditionSettlementPanelView.mTrans_ExpeditionTask_ExpeditionTaskAward_DropItemList_DropItemList = nil;
UIExpeditionSettlementPanelView.mTrans_ExpeditionTask_UI_CharacterSettlementList = nil;

UIExpeditionSettlementPanelView.mPath_CharacterSettlementItem = "Expedition/CharacterSettlementItem.prefab";
UIExpeditionSettlementPanelView.mPath_UICommonItemS = "UICommonFramework/UICommonItemS.prefab";

function UIExpeditionSettlementPanelView:__InitCtrl()

	self.mBtn_TopInformation_Return = self:GetButton("UI_TopInformation/Btn_Return");
	self.mBtn_ExpeditionTask_ExpeditionTaskAward_GoExpedition = self:GetButton("UI_ExpeditionTask/UI_ExpeditionTaskAward/Btn_GoExpedition");
	self.mBtn_ExpeditionTask_ExpeditionTaskAward_CancelExpedition = self:GetButton("UI_ExpeditionTask/UI_ExpeditionTaskAward/Btn_CancelExpedition");
	self.mImage_TopInformation_Coin_BodyCoin_CoinImage = self:GetImage("UI_TopInformation/UI_Coin/UI_BodyCoin/Image_CoinImage");
	self.mImage_TopInformation_Coin_GoldCoin_CoinImage = self:GetImage("UI_TopInformation/UI_Coin/UI_GoldCoin/Image_CoinImage");
	self.mImage_TopInformation_Coin_TokenCoin_CoinImage = self:GetImage("UI_TopInformation/UI_Coin/UI_TokenCoin/Image_CoinImage");
	self.mImage_ExpeditionTask_ExpeditionTaskAward_UserEXP_UserEXPGet = self:GetImage("UI_ExpeditionTask/UI_ExpeditionTaskAward/UI_UserEXP/UserEXP/Image_UserEXPGet");
	self.mImage_ExpeditionTask_ExpeditionTaskAward_UserEXP_UserEXPNow = self:GetImage("UI_ExpeditionTask/UI_ExpeditionTaskAward/UI_UserEXP/UserEXP/Image_UserEXPNow");
	self.mText_TopInformation_Coin_BodyCoin_CoinAmount = self:GetText("UI_TopInformation/UI_Coin/UI_BodyCoin/Text_CoinAmount");
	self.mText_TopInformation_Coin_GoldCoin_CoinAmount = self:GetText("UI_TopInformation/UI_Coin/UI_GoldCoin/Text_CoinAmount");
	self.mText_TopInformation_Coin_TokenCoin_CoinAmount = self:GetText("UI_TopInformation/UI_Coin/UI_TokenCoin/Text_CoinAmount");
	self.mText_ExpeditionTask_ExpeditionTitleInformation_ExpeditionDispatchReport_ExpeditionDispatchReport = self:GetText("UI_ExpeditionTask/UI_ExpeditionTitleInformation/UI_ExpeditionDispatchReport/Text_ExpeditionDispatchReport");
	self.mText_ExpeditionTask_ExpeditionTitleInformation_ExpeditionDispatchName_ExpeditionDispatchName = self:GetText("UI_ExpeditionTask/UI_ExpeditionTitleInformation/UI_ExpeditionDispatchName/Text_ExpeditionDispatchName");
	self.mText_ExpeditionTask_ExpeditionTitleInformation_ExpeditionDispatchResult = self:GetText("UI_ExpeditionTask/UI_ExpeditionTitleInformation/Trans_Text_ExpeditionDispatchResult");
	self.mText_ExpeditionTask_ExpeditionTaskAward_UserEXP_UserEXP = self:GetText("UI_ExpeditionTask/UI_ExpeditionTaskAward/UI_UserEXP/UserEXP/Text_UserEXP");
	self.mScrRect_ExpeditionTask_ExpeditionTaskAward_DropItemList_ItemList = self:GetScrollRect("UI_ExpeditionTask/UI_ExpeditionTaskAward/UI_DropItemList/ScrRect_ItemList");
	self.mTrans_ExpeditionTask_ExpeditionTitleInformation_ExpeditionDispatchResult = self:GetRectTransform("UI_ExpeditionTask/UI_ExpeditionTitleInformation/Trans_Text_ExpeditionDispatchResult");
	self.mTrans_ExpeditionTask_ExpeditionTaskAward_DropItemList_DropItemList = self:GetRectTransform("UI_ExpeditionTask/UI_ExpeditionTaskAward/UI_DropItemList/ScrRect_ItemList/Trans_DropItemList");
	self.mTrans_ExpeditionTask_UI_CharacterSettlementList = self:GetRectTransform("UI_ExpeditionTask/UI_CharacterSettlementList");
end

--@@ GF Auto Gen Block End

function UIExpeditionSettlementPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIExpeditionSettlementPanelView:InitData(data)
	local mission = NetCmdExpeditionData:GetExpeditionById(data.cmd.mission_id);
	local gunAddExp = 0;
	local commanderAddExp = 0;
	local gunIds = data.gunIds;
	local reward = nil;

	self.mText_ExpeditionTask_ExpeditionTitleInformation_ExpeditionDispatchName_ExpeditionDispatchName.text = mission.Name;

	if(data.cmd.perfect == 1) then
		gunAddExp = mission.GunExpPerfect;
		commanderAddExp = mission.CommanderExpPerfect;
		reward = string.split(mission.RewardPerfect, ':');
		setactive(self.mTrans_ExpeditionTask_ExpeditionTitleInformation_ExpeditionDispatchResult.gameObject,true);
	else
		gunAddExp = mission.GunExp;
		commanderAddExp = mission.CommanderExp;
		reward = string.split(mission.Reward, ':');
	end

	local prefab = UIUtils.GetGizmosPrefab(self.mPath_CharacterSettlementItem,self);
	for i = 0, gunIds.Length - 1 do
		local instObj = instantiate(prefab);
        local item = CharacterSettlementItem.New();
        item:InitCtrl(instObj.transform);
        item:InitData(gunIds[i],gunAddExp);
        
        UIUtils.AddListItem(instObj, self.mTrans_ExpeditionTask_UI_CharacterSettlementList.transform);
	end

	prefab =  UIUtils.GetGizmosPrefab(self.mPath_UICommonItemS,self);
	local instObj = instantiate(prefab);
    local itemS = UICommonItemS.New();
    itemS:InitCtrl(instObj.transform);
    itemS:SetData(tonumber(reward[1]),tonumber(reward[2]));
	UIUtils.AddListItem(instObj, self.mTrans_ExpeditionTask_ExpeditionTaskAward_DropItemList_DropItemList.transform);
	
	-- TODO 指挥官经验
	-- local prevLv = 0;
	-- local nowLv = 0;

	-- local expRatioBefore = beforeExp / TableData.listGunLevelExpDatas:GetDataById(lvBefore+1).exp;
	-- self.mImage_CharacterEXP_CharacterEXPNow.fillAmount = expRatioBefore;

end