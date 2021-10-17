require("UI.UIBaseView")

---@class UIGachaMainPanelV2View : UIBaseView
UIGachaMainPanelV2View = class("UIGachaMainPanelV2View", UIBaseView);
UIGachaMainPanelV2View.__index = UIGachaMainPanelV2View

--@@ GF Auto Gen Block Begin
UIGachaMainPanelV2View.mBtn_OrderOne = nil;
UIGachaMainPanelV2View.mBtn_OrderTen = nil;
UIGachaMainPanelV2View.mImg_GashaponPic = nil;
UIGachaMainPanelV2View.mImg_Icon = nil;
UIGachaMainPanelV2View.mImg_Icon = nil;
UIGachaMainPanelV2View.mImg_Icon = nil;
UIGachaMainPanelV2View.mImg_Icon = nil;
UIGachaMainPanelV2View.mText__Name = nil;
UIGachaMainPanelV2View.mText_Name = nil;
UIGachaMainPanelV2View.mText__Name = nil;
UIGachaMainPanelV2View.mText_Name = nil;
UIGachaMainPanelV2View.mText_Id = nil;
UIGachaMainPanelV2View.mText_ = nil;
UIGachaMainPanelV2View.mText_Tittle = nil;
UIGachaMainPanelV2View.mText_AvUp = nil;
UIGachaMainPanelV2View.mText_LeftTime = nil;
UIGachaMainPanelV2View.mText_Details = nil;
UIGachaMainPanelV2View.mText_Name = nil;
UIGachaMainPanelV2View.mText_Time = nil;
UIGachaMainPanelV2View.mText_1 = nil;
UIGachaMainPanelV2View.mText_2 = nil;
UIGachaMainPanelV2View.mText_OrderOneBg = nil;
UIGachaMainPanelV2View.mText_OrderOne_Name = nil;
UIGachaMainPanelV2View.mText_OrderTenBg = nil;
UIGachaMainPanelV2View.mText_OrderTenName = nil;
UIGachaMainPanelV2View.mContent_LeftTabMobile = nil;
UIGachaMainPanelV2View.mContent_LeftTabPC = nil;
UIGachaMainPanelV2View.mScrollbar_Details = nil;
UIGachaMainPanelV2View.mScrollbar_ = nil;
UIGachaMainPanelV2View.mList_Details = nil;
UIGachaMainPanelV2View.mTrans_Chr = nil;
UIGachaMainPanelV2View.mTrans_ChrAttribute2 = nil;
UIGachaMainPanelV2View.mTrans_ChrAttribute1 = nil;
UIGachaMainPanelV2View.mTrans_Weapon = nil;
UIGachaMainPanelV2View.mTrans_WeaponAttribute2 = nil;
UIGachaMainPanelV2View.mTrans_WeaponAttribute1 = nil;

function UIGachaMainPanelV2View:__InitCtrl()
	self.mBtn_Back = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnBack"));
	self.mBtn_Home = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnHome"));
	self.mBtn_OrderOne = self:GetButton("Root/GrpOrder/GrpRight/GrpAction/Btn_OrderOne");
	self.mBtn_OrderTen = self:GetButton("Root/GrpOrder/GrpRight/GrpAction/Btn_OrderTen");
	self.mImage_Banner = self:GetImage("Root/GrpOrder/GrpAvatar/Img_GashaponPic");
	self.mText_PickUpChr2Name = self:GetText("Root/GrpOrder/GrpAvatar/Trans_Chr/Trans_GrpAttribute2/Content/GrpDes/GrpText/Text_Name");
	self.mText_PickUpChr1Name = self:GetText("Root/GrpOrder/GrpAvatar/Trans_Chr/Trans_GrpAttribute1/Content/GrpDes/GrpText/Text_Name");
	self.mText_PickUpWeapon2Name = self:GetText("Root/GrpOrder/GrpAvatar/Trans_Weapon/Trans_GrpAttribute2/Content/GrpDes/GrpText/Text_Name");
	self.mText_PickUpWeapon1Name = self:GetText("Root/GrpOrder/GrpAvatar/Trans_Weapon/Trans_GrpAttribute1/Content/GrpDes/GrpText/Text_Name");
	self.mText_Id = self:GetText("Root/GrpOrder/GrpRight/TextId/Text");
	self.mText_1 = self:GetText("Root/GrpOrder/GrpRight/GrpText1/Text");
	self.mText_Title = self:GetText("Root/GrpOrder/GrpRight/GrpMiddle/GrpDetailsList/Viewport/Content/Text_Tittle");
	self.mText_AvUp = self:GetText("Root/GrpOrder/GrpRight/GrpMiddle/GrpDetailsList/Viewport/Content/Text_AvUp");
	self.mText_LeftTime = self:GetText("Root/GrpOrder/GrpRight/GrpMiddle/GrpDetailsList/Viewport/Content/GrpLeftTime/Content/TextLeftTime/Text_LeftTime");
	self.mText_Details = self:GetText("Root/GrpOrder/GrpRight/GrpMiddle/GrpDetailsList/Viewport/Content/Text_Details");
	self.mText_DateTitle = self:GetText("Root/GrpOrder/GrpRight/GrpMiddle/Trans_GrpDate/GrpDateList/Viewport/Content/TextName");
	self.mText_Time = self:GetText("Root/GrpOrder/GrpRight/GrpMiddle/Trans_GrpDate/GrpDateList/Viewport/Content/Text_Time");
	self.mText_2 = self:GetText("Root/GrpOrder/GrpRight/GrpMiddle/Trans_GrpDate/GrpText2/Text");
	self.mText_Confirm = self:GetText("Root/GrpOrder/GrpRight/GrpTextConfirm/Text");
	self.mImg_OrderOneBg = self:GetImage("Root/GrpOrder/GrpRight/GrpAction/Btn_OrderOne/Root/GrpBg/ImgBg");
	self.mText_OrderOneName = self:GetText("Root/GrpOrder/GrpRight/GrpAction/Btn_OrderOne/Root/GrpText/Text_Name");
	self.mImg_OrderTenBg = self:GetImage("Root/GrpOrder/GrpRight/GrpAction/Btn_OrderTen/Root/GrpBg/ImgBg");
	self.mText_OrderTenName = self:GetText("Root/GrpOrder/GrpRight/GrpAction/Btn_OrderTen/Root/GrpText/Text_Name");
	self.mScrollbar_Details = self:GetScrollbar("Root/GrpOrder/GrpRight/GrpMiddle/GrpDetailsList/Scrollbar");
	self.mScrollbar_ = self:GetScrollbar("Root/GrpOrder/GrpRight/GrpMiddle/GrpDate/Scrollbar");
	self.mList_Details = self:GetScrollRect("Root/GrpOrder/GrpRight/GrpMiddle/GrpDetailsList");
	self.mTrans_Chr = self:GetRectTransform("Root/GrpOrder/GrpAvatar/Trans_Chr");
	self.mTrans_ChrAttribute2 = self:GetRectTransform("Root/GrpOrder/GrpAvatar/Trans_Chr/Trans_GrpAttribute2");
	self.mTrans_ChrAttribute1 = self:GetRectTransform("Root/GrpOrder/GrpAvatar/Trans_Chr/Trans_GrpAttribute1");
	self.mTrans_Weapon = self:GetRectTransform("Root/GrpOrder/GrpAvatar/Trans_Weapon");
	self.mTrans_Date = self:GetRectTransform("Root/GrpOrder/GrpRight/GrpMiddle/Trans_GrpDate");
	self.mTrans_WeaponAttribute2 = self:GetRectTransform("Root/GrpOrder/GrpAvatar/Trans_Weapon/Trans_GrpAttribute2");
	self.mTrans_WeaponAttribute1 = self:GetRectTransform("Root/GrpOrder/GrpAvatar/Trans_Weapon/Trans_GrpAttribute1");
	self.mTrans_ChrStarAttribute1 = self:GetRectTransform("Root/GrpOrder/GrpAvatar/Trans_Chr/Trans_GrpAttribute1/Content/GrpDes/GrpStar");
	self.mTrans_ChrStarAttribute2 = self:GetRectTransform("Root/GrpOrder/GrpAvatar/Trans_Chr/Trans_GrpAttribute2/Content/GrpDes/GrpStar");
	self.mTrans_WeaponStarAttribute1 = self:GetRectTransform("Root/GrpOrder/GrpAvatar/Trans_Weapon/Trans_GrpAttribute1/Content/GrpDes/GrpStar");
	self.mTrans_WeaponStarAttribute2 = self:GetRectTransform("Root/GrpOrder/GrpAvatar/Trans_Weapon/Trans_GrpAttribute2/Content/GrpDes/GrpStar");
	if CS.GameRoot.Instance then
		if CS.GameRoot.Instance.AdapterPlatform == CS.PlatformSetting.PlatformType.PC then
			self.mBtn_Shop = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpBottom_PC/GrpAction/BtnOrderDetails"));
			self.mBtn_OpenGachaList = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpBottom_PC/GrpAction/BtnStoreExchange"));
			self.mContent_LeftTab = self:GetHorizontalLayoutGroup("Root/GrpLeftTab_PC/Content");
		else
			self.mBtn_Shop = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpBottom_Mobile/GrpAction/BtnOrderDetails"));
			self.mBtn_OpenGachaList = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpBottom_Mobile/GrpAction/BtnStoreExchange"));
			self.mContent_LeftTab = self:GetVerticalLayoutGroup("Root/GrpLeftTab_Mobile/Content");
		end
		setactive(self:GetRectTransform("Root/GrpBottom_PC"), CS.GameRoot.Instance.AdapterPlatform == CS.PlatformSetting.PlatformType.PC)
		setactive(self:GetRectTransform("Root/GrpBottom_Mobile"), CS.GameRoot.Instance.AdapterPlatform ~= CS.PlatformSetting.PlatformType.PC)
		setactive(self:GetRectTransform("Root/GrpLeftTab_PC"), CS.GameRoot.Instance.AdapterPlatform == CS.PlatformSetting.PlatformType.PC)
		setactive(self:GetRectTransform("Root/GrpLeftTab_Mobile"), CS.GameRoot.Instance.AdapterPlatform ~= CS.PlatformSetting.PlatformType.PC)
	end
end

--@@ GF Auto Gen Block End

function UIGachaMainPanelV2View:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

	self.mChrStarList1 = {}
	for i = 1, 5 do
		local starObj = instantiate(UIUtils.GetGizmosPrefab("Gashapon/ComStarV2.prefab", self))
		CS.LuaUIUtils.SetParent(starObj, self.mTrans_ChrStarAttribute1.gameObject)
		table.insert(self.mChrStarList1, CS.LuaUIUtils.GetRectTransform(starObj.transform))
	end

	self.mChrStarList2 = {}
	for i = 1, 5 do
		local starObj = instantiate(UIUtils.GetGizmosPrefab("Gashapon/ComStarV2.prefab", self))
		CS.LuaUIUtils.SetParent(starObj, self.mTrans_ChrStarAttribute2.gameObject)
		table.insert(self.mChrStarList2, CS.LuaUIUtils.GetRectTransform(starObj.transform))
	end

	self.mWeaponStarList1 = {}
	for i = 1, 5 do
		local starObj = instantiate(UIUtils.GetGizmosPrefab("Gashapon/ComStarV2.prefab", self))
		CS.LuaUIUtils.SetParent(starObj, self.mTrans_WeaponStarAttribute1.gameObject)
		table.insert(self.mWeaponStarList1, CS.LuaUIUtils.GetRectTransform(starObj.transform))
	end

	self.mWeaponStarList2 = {}
	for i = 1, 5 do
		local starObj = instantiate(UIUtils.GetGizmosPrefab("Gashapon/ComStarV2.prefab", self))
		CS.LuaUIUtils.SetParent(starObj, self.mTrans_WeaponStarAttribute2.gameObject)
		table.insert(self.mWeaponStarList2, CS.LuaUIUtils.GetRectTransform(starObj.transform))
	end

	local dutyObj1 = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComDutyItemV2.prefab", self))
	self.mTrans_IconDuty1 = self:GetRectTransform("Root/GrpOrder/GrpAvatar/Trans_Chr/Trans_GrpAttribute1/Content/GrpDuty")
	self.mImg_DutyIcon1 = UIUtils.GetImage(dutyObj1, "Img_DutyIcon")
	CS.LuaUIUtils.SetParent(dutyObj1, self.mTrans_IconDuty1.gameObject, true)

	local dutyObj2 = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComDutyItemV2.prefab", self))
	self:GetRectTransform("Root/GrpOrder/GrpAvatar/Trans_Chr/Trans_GrpAttribute2/Content/GrpDuty")
	self.mTrans_IconDuty2 = self:GetRectTransform("Root/GrpOrder/GrpAvatar/Trans_Chr/Trans_GrpAttribute2/Content/GrpDuty")
	self.mImg_DutyIcon2 = UIUtils.GetImage(dutyObj2, "Img_DutyIcon")
	CS.LuaUIUtils.SetParent(dutyObj2, self.mTrans_IconDuty2.gameObject, true)

	local elementObj1 = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComElementItemV2.prefab", self))
	self.mTrans_IconElement1 = self:GetRectTransform("Root/GrpOrder/GrpAvatar/Trans_Weapon/Trans_GrpAttribute1/Content/GrpElement")
	self.mImg_ElementIcon1 = UIUtils.GetImage(elementObj1, "Image_ElementIcon")
	CS.LuaUIUtils.SetParent(elementObj1, self.mTrans_IconElement1.gameObject, true)

	local elementObj2 = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComElementItemV2.prefab", self))
	self.mTrans_IconElement2 = self:GetRectTransform("Root/GrpOrder/GrpAvatar/Trans_Weapon/Trans_GrpAttribute2/Content/GrpElement")
	self.mImg_ElementIcon2 = UIUtils.GetImage(elementObj2, "Image_ElementIcon")
	CS.LuaUIUtils.SetParent(elementObj2, self.mTrans_IconElement2.gameObject, true)

	self.mAnimator = self:GetRootAnimator()
	self.mImg_OneIcon = self:GetImage("Root/GrpOrder/GrpRight/GrpConsume/ConsumeOne/ImgIcon");
	self.mText_OneNum = self:GetText("Root/GrpOrder/GrpRight/GrpConsume/ConsumeOne/TextNum");
	self.mImg_TenIcon = self:GetImage("Root/GrpOrder/GrpRight/GrpConsume/ConsumeTen/ImgIcon");
	self.mText_TenNum = self:GetText("Root/GrpOrder/GrpRight/GrpConsume/ConsumeTen/TextNum");
end