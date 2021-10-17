require("UI.UIBaseView")

UICharacterSkinPanelView = class("UICharacterSkinPanelView", UIBaseView);
UICharacterSkinPanelView.__index = UICharacterSkinPanelView

--@@ GF Auto Gen Block Begin
UICharacterSkinPanelView.mBtn_ConfirmButton = nil;
UICharacterSkinPanelView.mBtn_SkinDetailButton = nil;
UICharacterSkinPanelView.mBtn_ViewButton = nil;
UICharacterSkinPanelView.mBtn_CloseView = nil;
UICharacterSkinPanelView.mImage_ConfirmButton = nil;
UICharacterSkinPanelView.mImage_SkinDetailButton = nil;
UICharacterSkinPanelView.mImage_1 = nil;
UICharacterSkinPanelView.mImage_2 = nil;
UICharacterSkinPanelView.mImage_3 = nil;
UICharacterSkinPanelView.mText_OverView_GunName = nil;
UICharacterSkinPanelView.mText_OverView_GunType = nil;
UICharacterSkinPanelView.mText_OverView_SkinHavePerCent = nil;
UICharacterSkinPanelView.mText_SkinName = nil;
UICharacterSkinPanelView.mText_SkinDSC = nil;
UICharacterSkinPanelView.mText_again = nil;
UICharacterSkinPanelView.mLayout_SkinListPanel = nil;
UICharacterSkinPanelView.mVLayout_SkinDetailPanel = nil;
UICharacterSkinPanelView.mTrans_SkinOption = nil;
UICharacterSkinPanelView.mTrans_OverView_GunGrade = nil;
UICharacterSkinPanelView.mTrans_SkinListPanel = nil;
UICharacterSkinPanelView.mTrans_SkinDetailPanel = nil;

function UICharacterSkinPanelView:__InitCtrl()

	self.mBtn_ConfirmButton = self:GetButton("Trans_SkinOption/Image_Btn_ConfirmButton");
	self.mBtn_SkinDetailButton = self:GetButton("Trans_SkinOption/Image_Btn_SkinDetailButton");
	self.mBtn_ViewButton = self:GetButton("Trans_SkinOption/Btn_ViewButton");
	self.mBtn_CloseView = self:GetButton("SkinView/Btn_CloseView");
	self.mImage_ConfirmButton = self:GetImage("Trans_SkinOption/Image_Btn_ConfirmButton");
	self.mImage_SkinDetailButton = self:GetImage("Trans_SkinOption/Image_Btn_SkinDetailButton");
	self.mImage_1 = self:GetImage("Trans_SkinOption/Image_Btn_SkinDetailButton/Image_Icon_1");
	self.mImage_2 = self:GetImage("Trans_SkinOption/Image_Btn_SkinDetailButton/Image_Icon_2");
	self.mImage_3 = self:GetImage("Trans_SkinOption/Image_Btn_SkinDetailButton/Image_Icon_3");
	self.mText_OverView_GunName = self:GetText("Trans_SkinOption/UI_OverView/Text_GunName");
	self.mText_OverView_GunType = self:GetText("Trans_SkinOption/UI_OverView/Text_GunType");
	self.mText_OverView_SkinHavePerCent = self:GetText("Trans_SkinOption/UI_OverView/Text_SkinHavePerCent");
	self.mText_SkinName = self:GetText("Trans_SkinOption/DetailPanel/Trans_VLayout_SkinDetailPanel/Text_SkinName");
	self.mText_SkinDSC = self:GetText("Trans_SkinOption/DetailPanel/Trans_VLayout_SkinDetailPanel/Text_SkinDSC");
	self.mText_again = self:GetText("Trans_SkinOption/SkinName/Text_SkinName_again");
	self.mLayout_SkinListPanel = self:GetGridLayoutGroup("Trans_SkinOption/DetailPanel/Trans_Layout_SkinListPanel");
	self.mVLayout_SkinDetailPanel = self:GetVerticalLayoutGroup("Trans_SkinOption/DetailPanel/Trans_VLayout_SkinDetailPanel");
	self.mTrans_SkinOption = self:GetRectTransform("Trans_SkinOption");
	self.mTrans_OverView_GunGrade = self:GetRectTransform("Trans_SkinOption/UI_OverView/UI_Trans_GunGrade");
	self.mTrans_SkinListPanel = self:GetRectTransform("Trans_SkinOption/DetailPanel/Trans_Layout_SkinListPanel");
	self.mTrans_SkinDetailPanel = self:GetRectTransform("Trans_SkinOption/DetailPanel/Trans_VLayout_SkinDetailPanel");
end

--@@ GF Auto Gen Block End

UICharacterSkinPanelView.mDetailBtnCloseColorStr = "#313131FF";
UICharacterSkinPanelView.mDetailBtnCloseColor = Color.white;

UICharacterSkinPanelView.mDetailBtnOpenColorStr = "#DCDDDDFF";
UICharacterSkinPanelView.mDetailBtnOpenColor = Color.white;

UICharacterSkinPanelView.mStars = {};

function UICharacterSkinPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

	self.mDetailBtnCloseColor = CSUIUtils.ConvertEngineColor(self.mDetailBtnCloseColorStr);
	self.mDetailBtnOpenColor = CSUIUtils.ConvertEngineColor(self.mDetailBtnOpenColorStr);

	for i = 1, self.mTrans_OverView_GunGrade.childCount do
		if i ~= 1 then
			self.mStars[i - 1] = self.mTrans_OverView_GunGrade.transform:GetChild(i - 1);
		end
	end

	self:SetPanelState(false);
end

--以打开详情为主
function UICharacterSkinPanelView:SetPanelState(enable)
	setactive(self.mTrans_SkinListPanel.gameObject, not enable);
	setactive(self.mTrans_SkinDetailPanel.gameObject, enable);

	if enable then
		self.mImage_SkinDetailButton.color = self.mDetailBtnOpenColor;
	else
		self.mImage_SkinDetailButton.color = self.mDetailBtnCloseColor;
	end
end

function UICharacterSkinPanelView:SetBaseView(gunInfo)
	if gunInfo == nil then
		return;
	end

	self.mText_OverView_GunName.text = gunInfo.TabGunData.name;
	self.mText_OverView_GunType.text = gunInfo.GunDefineData.name;

	for i = 1, #self.mStars do
		if i <= gunInfo.upgrade then
			setactive(self.mStars[i].gameObject, true);
		else
			setactive(self.mStars[i].gameObject, false);
		end
	end
end



function UICharacterSkinPanelView:SetAdjutantBaseView(adjutantData)

    if adjutantData == nil then
        return;
    end




    if adjutantData.type==1 then
        local gunData = TableData.GetGunData(adjutantData.detail_id);

        if gunData==nil then
            gferror("Gun表不存在ID："..adjutantData.detail_id);
            return;
        end


        self.mText_OverView_GunName.text = gunData.name;
        --local definedata=TableData.GetDefineGunData(gunData.typeInt);

        --self.mText_OverView_GunType.text = definedata.name;

        for i = 1, #self.mStars do
            if i <= gunData.rank then
                setactive(self.mStars[i].gameObject, true);
            else
                setactive(self.mStars[i].gameObject, false);
            end
        end

    else
        local npcData = TableData.GetNpcData(adjutantData.detail_id);

        if npcData==nil then
            gferror("NPC表不存在ID："..adjutantData.detail_id);
            return;
        end

        self.mText_OverView_GunName.text = npcData.name;

    end

end





function UICharacterSkinPanelView:SetChoseCostume(costumeData, isLocked)
	print("设置颜色！！！")
	self.mText_again.text = costumeData.name;
	self.mText_SkinName.text = costumeData.name;
	self.mText_SkinDSC.text = costumeData.description;

	setactive(self.mBtn_ViewButton.gameObject, not isLocked);

    if isLocked then
        gfdebug("true");
    else
        gfdebug("false");
    end

	setactive(self.mBtn_CloseView.gameObject, false);
	CSUIUtils.SetUIImageEnable(self.mBtn_ConfirmButton.gameObject, not isLocked);
	if isLocked then
		self.mImage_ConfirmButton.color = CS.UnityEngine.Color(173 / 255, 173 / 255, 173 / 255);
	else
		self.mImage_ConfirmButton.color = CS.UnityEngine.Color(255 / 255, 180 / 255, 0);
	end
end

function UICharacterSkinPanelView:SetPreviewState(isPreview)
	setactive(self.mBtn_ViewButton.gameObject, not isPreview);
	setactive(self.mBtn_CloseView.gameObject,  isPreview);

	setactive(self.mTrans_SkinOption.gameObject, not isPreview);
end