require("UI.UIBaseView")

UIExpeditionTaskPanelView = class("UIExpeditionTaskPanelView", UIBaseView);
UIExpeditionTaskPanelView.__index = UIExpeditionTaskPanelView

--@@ GF Auto Gen Block Begin
UIExpeditionTaskPanelView.mBtn_TopInformation_Return = nil;
UIExpeditionTaskPanelView.mBtn_ExpeditionTask_CharacterSelection_CharacterSelection1 = nil;
UIExpeditionTaskPanelView.mBtn_ExpeditionTask_CharacterSelection_CharacterSelection2 = nil;
UIExpeditionTaskPanelView.mBtn_ExpeditionTask_CharacterSelection_CharacterSelection3 = nil;
UIExpeditionTaskPanelView.mBtn_ExpeditionTask_CharacterSelection_CharacterSelection4 = nil;
UIExpeditionTaskPanelView.mBtn_ExpeditionTask_ExpeditionTaskAward_GoExpedition_GoExpedition = nil;
UIExpeditionTaskPanelView.mBtn_ExpeditionTask_ExpeditionTaskAward_GoExpedition_CancelExpedition = nil;
UIExpeditionTaskPanelView.mImage_TopInformation_Coin_BodyCoin_CoinImage = nil;
UIExpeditionTaskPanelView.mImage_TopInformation_Coin_GoldCoin_CoinImage = nil;
UIExpeditionTaskPanelView.mImage_TopInformation_Coin_TokenCoin_CoinImage = nil;
UIExpeditionTaskPanelView.mText_TopInformation_Coin_BodyCoin_CoinAmount = nil;
UIExpeditionTaskPanelView.mText_TopInformation_Coin_GoldCoin_CoinAmount = nil;
UIExpeditionTaskPanelView.mText_TopInformation_Coin_TokenCoin_CoinAmount = nil;
UIExpeditionTaskPanelView.mText_ExpeditionTask_ExpeditionTeamDispatch_ExpeditionTeamDispatchName = nil;
UIExpeditionTaskPanelView.mText_ExpeditionTask_ExpeditionTaskAward_CharacterUp_CharacterUp = nil;
UIExpeditionTaskPanelView.mText_ExpeditionTask_ExpeditionTaskAward_LevelLimit_LevelLimit = nil;
UIExpeditionTaskPanelView.mText_ExpeditionTask_ExpeditionTaskAward_GoExpedition_ExpeditionConsumption = nil;
UIExpeditionTaskPanelView.mText_ExpeditionTask_ExpeditionTaskAward_GoExpedition_ExpeditionTime = nil;
UIExpeditionTaskPanelView.mScrRect_ExpeditionTask_ExpeditionTaskAward_DropItemList_ItemList = nil;
UIExpeditionTaskPanelView.mTrans_ExpeditionTask_CharacterSelection_CharacterSelection1_Text = nil;
UIExpeditionTaskPanelView.mTrans_ExpeditionTask_CharacterSelection_CharacterSelection2_Text = nil;
UIExpeditionTaskPanelView.mTrans_ExpeditionTask_CharacterSelection_CharacterSelection3_Text = nil;
UIExpeditionTaskPanelView.mTrans_ExpeditionTask_CharacterSelection_CharacterSelection4_Text = nil;
UIExpeditionTaskPanelView.mTrans_ExpeditionTask_ExpeditionTaskAward_DropItemList_DropItemList = nil;
UIExpeditionTaskPanelView.mTrans_ExpeditionTask_ExpeditionTaskAward_GoExpedition_GoExpedition = nil;
UIExpeditionTaskPanelView.mTrans_ExpeditionTask_ExpeditionTaskAward_GoExpedition_CancelExpedition = nil;

UIExpeditionTaskPanelView.mText_UserEXPItem_Count = nil;
UIExpeditionTaskPanelView.mText_CharacterEXPItem_Count = nil;

UIExpeditionTaskPanelView.mPath_UICommonItemS = "UICommonFramework/UICommonItemS.prefab";

function UIExpeditionTaskPanelView:__InitCtrl()

	self.mBtn_TopInformation_Return = self:GetButton("UI_TopInformation/Btn_Return");
	self.mBtn_ExpeditionTask_CharacterSelection_CharacterSelection1 = self:GetButton("UI_ExpeditionTask/UI_CharacterSelection/UI_Btn_CharacterSelection1");
	self.mBtn_ExpeditionTask_CharacterSelection_CharacterSelection2 = self:GetButton("UI_ExpeditionTask/UI_CharacterSelection/UI_Btn_CharacterSelection2");
	self.mBtn_ExpeditionTask_CharacterSelection_CharacterSelection3 = self:GetButton("UI_ExpeditionTask/UI_CharacterSelection/UI_Btn_CharacterSelection3");
	self.mBtn_ExpeditionTask_CharacterSelection_CharacterSelection4 = self:GetButton("UI_ExpeditionTask/UI_CharacterSelection/UI_Btn_CharacterSelection4");
	self.mBtn_ExpeditionTask_ExpeditionTaskAward_GoExpedition_GoExpedition = self:GetButton("UI_ExpeditionTask/UI_ExpeditionTaskAward/UI_GoExpedition/Trans_Btn_GoExpedition");
	self.mBtn_ExpeditionTask_ExpeditionTaskAward_GoExpedition_CancelExpedition = self:GetButton("UI_ExpeditionTask/UI_ExpeditionTaskAward/UI_GoExpedition/Trans_Btn_CancelExpedition");
	self.mImage_TopInformation_Coin_BodyCoin_CoinImage = self:GetImage("UI_TopInformation/UI_Coin/UI_BodyCoin/Image_CoinImage");
	self.mImage_TopInformation_Coin_GoldCoin_CoinImage = self:GetImage("UI_TopInformation/UI_Coin/UI_GoldCoin/Image_CoinImage");
	self.mImage_TopInformation_Coin_TokenCoin_CoinImage = self:GetImage("UI_TopInformation/UI_Coin/UI_TokenCoin/Image_CoinImage");
	self.mText_TopInformation_Coin_BodyCoin_CoinAmount = self:GetText("UI_TopInformation/UI_Coin/UI_BodyCoin/Text_CoinAmount");
	self.mText_TopInformation_Coin_GoldCoin_CoinAmount = self:GetText("UI_TopInformation/UI_Coin/UI_GoldCoin/Text_CoinAmount");
	self.mText_TopInformation_Coin_TokenCoin_CoinAmount = self:GetText("UI_TopInformation/UI_Coin/UI_TokenCoin/Text_CoinAmount");
	self.mText_ExpeditionTask_ExpeditionTeamDispatch_ExpeditionTeamDispatchName = self:GetText("UI_ExpeditionTask/UI_ExpeditionTeamDispatch/Text_ExpeditionTeamDispatchName");
	self.mText_ExpeditionTask_ExpeditionTaskAward_CharacterUp_CharacterUp = self:GetText("UI_ExpeditionTask/UI_ExpeditionTaskAward/UI_CharacterUp/Text_CharacterUp");
	self.mText_ExpeditionTask_ExpeditionTaskAward_LevelLimit_LevelLimit = self:GetText("UI_ExpeditionTask/UI_ExpeditionTaskAward/UI_LevelLimit/Text_LevelLimit");
	self.mText_ExpeditionTask_ExpeditionTaskAward_GoExpedition_ExpeditionConsumption = self:GetText("UI_ExpeditionTask/UI_ExpeditionTaskAward/UI_GoExpedition/Trans_Btn_GoExpedition/ExpeditionConsumption/Text_ExpeditionConsumption");
	self.mText_ExpeditionTask_ExpeditionTaskAward_GoExpedition_ExpeditionTime = self:GetText("UI_ExpeditionTask/UI_ExpeditionTaskAward/UI_GoExpedition/Text_ExpeditionTime");
	self.mScrRect_ExpeditionTask_ExpeditionTaskAward_DropItemList_ItemList = self:GetScrollRect("UI_ExpeditionTask/UI_ExpeditionTaskAward/UI_DropItemList/ScrRect_ItemList");
	self.mTrans_ExpeditionTask_CharacterSelection_CharacterSelection1_Text = self:GetRectTransform("UI_ExpeditionTask/UI_CharacterSelection/UI_Btn_CharacterSelection1/Trans_Text");
	self.mTrans_ExpeditionTask_CharacterSelection_CharacterSelection2_Text = self:GetRectTransform("UI_ExpeditionTask/UI_CharacterSelection/UI_Btn_CharacterSelection2/Trans_Text");
	self.mTrans_ExpeditionTask_CharacterSelection_CharacterSelection3_Text = self:GetRectTransform("UI_ExpeditionTask/UI_CharacterSelection/UI_Btn_CharacterSelection3/Trans_Text");
	self.mTrans_ExpeditionTask_CharacterSelection_CharacterSelection4_Text = self:GetRectTransform("UI_ExpeditionTask/UI_CharacterSelection/UI_Btn_CharacterSelection4/Trans_Text");
	self.mTrans_ExpeditionTask_ExpeditionTaskAward_DropItemList_DropItemList = self:GetRectTransform("UI_ExpeditionTask/UI_ExpeditionTaskAward/UI_DropItemList/ScrRect_ItemList/Trans_DropItemList");
	self.mTrans_ExpeditionTask_ExpeditionTaskAward_GoExpedition_GoExpedition = self:GetRectTransform("UI_ExpeditionTask/UI_ExpeditionTaskAward/UI_GoExpedition/Trans_Btn_GoExpedition");
	self.mTrans_ExpeditionTask_ExpeditionTaskAward_GoExpedition_CancelExpedition = self:GetRectTransform("UI_ExpeditionTask/UI_ExpeditionTaskAward/UI_GoExpedition/Trans_Btn_CancelExpedition");

	self.mText_UserEXPItem_Count = self:GetText("UI_ExpeditionTask/UI_ExpeditionTaskAward/UI_DropItemList/ScrRect_ItemList/Trans_DropItemList/UI_UserEXPItem/Trans_CountBGImage/Text_Count");
	self.mText_CharacterEXPItem_Count = self:GetText("UI_ExpeditionTask/UI_ExpeditionTaskAward/UI_DropItemList/ScrRect_ItemList/Trans_DropItemList/UI_CharacterEXPItem/Trans_CountBGImage/Text_Count");
end

--@@ GF Auto Gen Block End

function UIExpeditionTaskPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIExpeditionTaskPanelView:InitData(data)
	self.mText_ExpeditionTask_ExpeditionTeamDispatch_ExpeditionTeamDispatchName.text = data.Name;
	self.mText_ExpeditionTask_ExpeditionTaskAward_LevelLimit_LevelLimit.text = "最低等级" .. data.Level;
	self.mText_ExpeditionTask_ExpeditionTaskAward_GoExpedition_ExpeditionTime.text = data.TotalTime;
	
	local types = data.FitTypes;
	local str = "无";
	if(types.Length > 0) then
		str = GunTypeStr[types[0]];

		for i = 1, types.Length - 1 do
			str = str..","..GunTypeStr[types[i]];
		end
	end

	self.mText_ExpeditionTask_ExpeditionTaskAward_CharacterUp_CharacterUp.text = str .. "高适应性";

	self.mBtn_ExpeditionTask_ExpeditionTaskAward_GoExpedition_GoExpedition.interactable = false;

	self.mText_UserEXPItem_Count.text = data.GunExp;
	self.mText_CharacterEXPItem_Count.text = data.CommanderExp;

	local reward = string.split(data.Reward, ':');
	local prefab =  UIUtils.GetGizmosPrefab(self.mPath_UICommonItemS,self);
	local instObj = instantiate(prefab);
    local itemS = UICommonItemS.New();
    itemS:InitCtrl(instObj.transform);
    itemS:SetData(tonumber(reward[1]),tonumber(reward[2]));
	UIUtils.AddListItem(instObj, self.mTrans_ExpeditionTask_ExpeditionTaskAward_DropItemList_DropItemList.transform);
end