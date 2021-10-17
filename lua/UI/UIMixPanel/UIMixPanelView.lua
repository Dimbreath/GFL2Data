require("UI.UIBaseView")

UIMixPanelView = class("UIMixPanelView", UIBaseView);
UIMixPanelView.__index = UIMixPanelView

--@@ GF Auto Gen Block Begin
UIMixPanelView.mBtn_GrpBg_Close = nil;
UIMixPanelView.mBtn_GrpDialog_Close = nil;
UIMixPanelView.mBtn_GrpDialog_GrpLeft_LeftItem = nil;
UIMixPanelView.mBtn_GrpDialog_GrpRight_RightItem = nil;
UIMixPanelView.mBtn_GrpDialog_GrpRight_GrpBig_ResultItem = nil;
UIMixPanelView.mBtn_GrpDialog_ComBtnReduce = nil;
UIMixPanelView.mBtn_GrpDialog_ComBtnAdd = nil;
UIMixPanelView.mBtn_GrpDialog_Mix_Mix = nil;
UIMixPanelView.mBtn_GrpDialog_TotalMix_Mix = nil;
UIMixPanelView.mImage_GrpDialog_GrpLeft_Bg = nil;
UIMixPanelView.mImage_GrpDialog_GrpLeft_Item = nil;
UIMixPanelView.mImage_GrpDialog_GrpRight_Bg = nil;
UIMixPanelView.mImage_GrpDialog_GrpRight_Item = nil;
UIMixPanelView.mImage_GrpDialog_GrpRight_GrpBig_Bg = nil;
UIMixPanelView.mImage_GrpDialog_GrpRight_GrpBig_Item = nil;
UIMixPanelView.mImage_GrpDialog_Fill = nil;
UIMixPanelView.mText_GrpDialog_GrpLeft_Num = nil;
UIMixPanelView.mText_GrpDialog_GrpLeft_First = nil;
UIMixPanelView.mText_GrpDialog_GrpRight_Num = nil;
UIMixPanelView.mText_GrpDialog_GrpRight_First = nil;
UIMixPanelView.mText_GrpDialog_GrpRight_GrpBig_Num = nil;
UIMixPanelView.mText_GrpDialog_GrpRight_GrpBig_First = nil;
UIMixPanelView.mText_GrpDialog_CompoundNum = nil;
UIMixPanelView.mText_GrpDialog_MinNum = nil;
UIMixPanelView.mText_GrpDialog_MaxNum = nil;
UIMixPanelView.mText_GrpDialog_CostNum = nil;
UIMixPanelView.mText_GrpDialog_Mix_Name = nil;
UIMixPanelView.mText_GrpDialog_TotalMix_Name = nil;
UIMixPanelView.mSlider_GrpDialog_Line = nil;
UIMixPanelView.mTrans_GrpBg = nil;
UIMixPanelView.mTrans_GrpDialog = nil;
UIMixPanelView.mTrans_GrpDialog_Content = nil;
UIMixPanelView.mTrans_GrpDialog_GrpLeft = nil;
UIMixPanelView.mTrans_GrpDialog_GrpLeft_GrpNum = nil;
UIMixPanelView.mTrans_GrpDialog_GrpLeft_GrpFirst = nil;
UIMixPanelView.mTrans_GrpDialog_GrpRight = nil;
UIMixPanelView.mTrans_GrpDialog_GrpRight_GrpNum = nil;
UIMixPanelView.mTrans_GrpDialog_GrpRight_GrpFirst = nil;
UIMixPanelView.mTrans_GrpDialog_GrpRight_GrpBig = nil;
UIMixPanelView.mTrans_GrpDialog_GrpRight_GrpBig_GrpNum = nil;
UIMixPanelView.mTrans_GrpDialog_GrpRight_GrpBig_GrpFirst = nil;
UIMixPanelView.mTrans_GrpDialog_Mix = nil;
UIMixPanelView.mTrans_GrpDialog_Mix_ImgIconConfirm = nil;
UIMixPanelView.mTrans_GrpDialog_Mix_ImgIconCancel = nil;
UIMixPanelView.mTrans_GrpDialog_TotalMix = nil;
UIMixPanelView.mTrans_GrpDialog_TotalMix_ImgIconConfirm = nil;
UIMixPanelView.mTrans_GrpDialog_TotalMix_ImgIconCancel = nil;

function UIMixPanelView:__InitCtrl()

	self.mBtn_GrpBg_Close = self:GetButton("Root/GrpBg/Btn_Close");
	self.mBtn_GrpDialog_Close = self:GetButton("Root/GrpDialog/GrpTop/GrpClose/Btn_Close");
	self.mBtn_GrpDialog_GrpLeft_LeftItem = self:GetButton("Root/GrpDialog/GrpCenter/GrpCompose/Trans_GrpLeft/GrpItem/Btn_LeftItem");
	self.mBtn_GrpDialog_GrpRight_RightItem = self:GetButton("Root/GrpDialog/GrpCenter/GrpCompose/GrpRight/GrpSmall/GrpItemSmall/Btn_RightItem");
	self.mBtn_GrpDialog_GrpRight_GrpBig_ResultItem = self:GetButton("Root/GrpDialog/GrpCenter/GrpCompose/GrpRight/GrpBig/GrpItemBig/Btn_ResultItem");
	self.mBtn_GrpDialog_ComBtnReduce = self:GetButton("Root/GrpDialog/GrpCenter/GrpSlider/GrpBtnReduce/Btn_ComBtnReduce");
	self.mBtn_GrpDialog_ComBtnAdd = self:GetButton("Root/GrpDialog/GrpCenter/GrpSlider/GrpBtnIncrease/Btn_ComBtnAdd");
	self.mBtn_GrpDialog_Mix_Mix = self:GetButton("Root/GrpDialog/GrpAction/Trans_Mix/Btn_Mix");
	self.mBtn_GrpDialog_TotalMix_Mix = self:GetButton("Root/GrpDialog/GrpAction/Trans_TotalMix/Btn_Mix");
	self.mImage_GrpDialog_GrpLeft_Bg = self:GetImage("Root/GrpDialog/GrpCenter/GrpCompose/Trans_GrpLeft/GrpItem/Btn_LeftItem/GrpBg/Img_Bg");
	self.mImage_GrpDialog_GrpLeft_Item = self:GetImage("Root/GrpDialog/GrpCenter/GrpCompose/Trans_GrpLeft/GrpItem/Btn_LeftItem/GrpItem/Image_Item");
	self.mImage_GrpDialog_GrpRight_Bg = self:GetImage("Root/GrpDialog/GrpCenter/GrpCompose/GrpRight/GrpSmall/GrpItemSmall/Btn_RightItem/GrpBg/Img_Bg");
	self.mImage_GrpDialog_GrpRight_Item = self:GetImage("Root/GrpDialog/GrpCenter/GrpCompose/GrpRight/GrpSmall/GrpItemSmall/Btn_RightItem/GrpItem/Image_Item");
	self.mImage_GrpDialog_GrpRight_GrpBig_Bg = self:GetImage("Root/GrpDialog/GrpCenter/GrpCompose/GrpRight/GrpBig/GrpItemBig/Btn_ResultItem/GrpBg/Img_Bg");
	self.mImage_GrpDialog_GrpRight_GrpBig_Item = self:GetImage("Root/GrpDialog/GrpCenter/GrpCompose/GrpRight/GrpBig/GrpItemBig/Btn_ResultItem/GrpItem/Image_Item");
	self.mImage_GrpDialog_Fill = self:GetImage("Root/GrpDialog/GrpCenter/GrpSlider/GrpSlider/SliderLine/Slider_Line/Fill Area/Image_Fill");
	self.mText_GrpDialog_GrpLeft_Num = self:GetText("Root/GrpDialog/GrpCenter/GrpCompose/Trans_GrpLeft/GrpItem/Btn_LeftItem/Trans_GrpNum/ImgBg/Text_Num");
	self.mText_GrpDialog_GrpLeft_First = self:GetText("Root/GrpDialog/GrpCenter/GrpCompose/Trans_GrpLeft/GrpItem/Btn_LeftItem/Trans_GrpFirst/Img_Bg/Text_First");
	self.mText_GrpDialog_GrpRight_Num = self:GetText("Root/GrpDialog/GrpCenter/GrpCompose/GrpRight/GrpSmall/GrpItemSmall/Btn_RightItem/Trans_GrpNum/ImgBg/Text_Num");
	self.mText_GrpDialog_GrpRight_First = self:GetText("Root/GrpDialog/GrpCenter/GrpCompose/GrpRight/GrpSmall/GrpItemSmall/Btn_RightItem/Trans_GrpFirst/Img_Bg/Text_First");
	self.mText_GrpDialog_GrpRight_GrpBig_Num = self:GetText("Root/GrpDialog/GrpCenter/GrpCompose/GrpRight/GrpBig/GrpItemBig/Btn_ResultItem/Trans_GrpNum/ImgBg/Text_Num");
	self.mText_GrpDialog_GrpRight_GrpBig_First = self:GetText("Root/GrpDialog/GrpCenter/GrpCompose/GrpRight/GrpBig/GrpItemBig/Btn_ResultItem/Trans_GrpFirst/Img_Bg/Text_First");
	self.mText_GrpDialog_CompoundNum = self:GetText("Root/GrpDialog/GrpCenter/GrpSlider/GrpTextNow/Text_CompoundNum");
	self.mText_GrpDialog_MinNum = self:GetText("Root/GrpDialog/GrpCenter/GrpSlider/GrpTextMin/Text_MinNum");
	self.mText_GrpDialog_MaxNum = self:GetText("Root/GrpDialog/GrpCenter/GrpSlider/GrpTextMax/Text_MaxNum");
	self.mText_GrpDialog_CostNum = self:GetText("Root/GrpDialog/GrpCenter/GrpSlider/GrpGoldConsume/Text_CostNum");
	self.mText_GrpDialog_Mix_Name = self:GetText("Root/GrpDialog/GrpAction/Trans_Mix/Btn_Mix/Root/GrpText/Text_Name");
	self.mText_GrpDialog_TotalMix_Name = self:GetText("Root/GrpDialog/GrpAction/Trans_TotalMix/Btn_Mix/Root/GrpText/Text_Name");
	self.mSlider_GrpDialog_Line = self:GetSlider("Root/GrpDialog/GrpCenter/GrpSlider/GrpSlider/SliderLine/Slider_Line");
	self.mTrans_GrpBg = self:GetRectTransform("Root/GrpBg");
	self.mTrans_GrpDialog = self:GetRectTransform("Root/GrpDialog");
	self.mTrans_GrpDialog_Content = self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpLeft/GrpMaterialList/Viewport/Content");
	self.mTrans_GrpDialog_GrpLeft = self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpCompose/Trans_GrpLeft");
	self.mTrans_GrpDialog_GrpLeft_GrpNum = self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpCompose/Trans_GrpLeft/GrpItem/Btn_LeftItem/Trans_GrpNum");
	self.mTrans_GrpDialog_GrpLeft_GrpFirst = self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpCompose/Trans_GrpLeft/GrpItem/Btn_LeftItem/Trans_GrpFirst");
	self.mTrans_GrpDialog_GrpRight = self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpCompose/GrpRight");
	self.mTrans_GrpDialog_GrpRight_GrpNum = self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpCompose/GrpRight/GrpSmall/GrpItemSmall/Btn_RightItem/Trans_GrpNum");
	self.mTrans_GrpDialog_GrpRight_GrpFirst = self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpCompose/GrpRight/GrpSmall/GrpItemSmall/Btn_RightItem/Trans_GrpFirst");
	self.mTrans_GrpDialog_GrpRight_GrpBig = self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpCompose/GrpRight/GrpBig");
	self.mTrans_GrpDialog_GrpRight_GrpBig_GrpNum = self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpCompose/GrpRight/GrpBig/GrpItemBig/Btn_ResultItem/Trans_GrpNum");
	self.mTrans_GrpDialog_GrpRight_GrpBig_GrpFirst = self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpCompose/GrpRight/GrpBig/GrpItemBig/Btn_ResultItem/Trans_GrpFirst");
	self.mTrans_GrpDialog_Mix = self:GetRectTransform("Root/GrpDialog/GrpAction/Trans_Mix");
	self.mTrans_GrpDialog_Mix_ImgIconConfirm = self:GetRectTransform("Root/GrpDialog/GrpAction/Trans_Mix/Btn_Mix/Root/GrpIconState/ImgIconConfirm");
	self.mTrans_GrpDialog_Mix_ImgIconCancel = self:GetRectTransform("Root/GrpDialog/GrpAction/Trans_Mix/Btn_Mix/Root/GrpIconState/ImgIconCancel");
	self.mTrans_GrpDialog_TotalMix = self:GetRectTransform("Root/GrpDialog/GrpAction/Trans_TotalMix");
	self.mTrans_GrpDialog_TotalMix_ImgIconConfirm = self:GetRectTransform("Root/GrpDialog/GrpAction/Trans_TotalMix/Btn_Mix/Root/GrpIconState/UI_Trans_ImgIconConfirm");
	self.mTrans_GrpDialog_TotalMix_ImgIconCancel = self:GetRectTransform("Root/GrpDialog/GrpAction/Trans_TotalMix/Btn_Mix/Root/GrpIconState/UI_Trans_ImgIconCancel");

	self.mTrans_GrpDialog_Viewport = self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpLeft/GrpMaterialList/Viewport");
	self.mTrans_GrpDialog_ScrollRect = self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpLeft/GrpMaterialList");
	
end

--@@ GF Auto Gen Block End

function UIMixPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end



--require("UI.UIBaseView")
--
--UIMixPanelView = class("UIMixPanelView", UIBaseView);
--UIMixPanelView.__index = UIMixPanelView
--
----@@ GF Auto Gen Block Begin
--UIMixPanelView.mBtn_BGCloseButton = nil;
--UIMixPanelView.mBtn_Cancel = nil;
--UIMixPanelView.mBtn_MaterialItem1_Select = nil;
--UIMixPanelView.mBtn_MaterialItem1_Lock = nil;
--UIMixPanelView.mBtn_MaterialItem1_Reduce = nil;
--UIMixPanelView.mBtn_MaterialItem2_Select = nil;
--UIMixPanelView.mBtn_MaterialItem2_Lock = nil;
--UIMixPanelView.mBtn_MaterialItem2_Reduce = nil;
--UIMixPanelView.mBtn_MixItem_Select = nil;
--UIMixPanelView.mBtn_MixItem_Lock = nil;
--UIMixPanelView.mBtn_MixItem_Reduce = nil;
--UIMixPanelView.mBtn_AmountPlusButton = nil;
--UIMixPanelView.mBtn_AmountMinusButton = nil;
--UIMixPanelView.mBtn_AmountMaxButton = nil;
--UIMixPanelView.mBtn_Mix = nil;
--UIMixPanelView.mBtn_TotalMix = nil;
--UIMixPanelView.mImage_MaterialItem1_Icon = nil;
--UIMixPanelView.mImage_MaterialItem1_Rank = nil;
--UIMixPanelView.mImage_MaterialItem1_HeadIcon = nil;
--UIMixPanelView.mImage_MaterialItem2_Icon = nil;
--UIMixPanelView.mImage_MaterialItem2_Rank = nil;
--UIMixPanelView.mImage_MaterialItem2_HeadIcon = nil;
--UIMixPanelView.mImage_MixItem_Icon = nil;
--UIMixPanelView.mImage_MixItem_Rank = nil;
--UIMixPanelView.mImage_MixItem_HeadIcon = nil;
--UIMixPanelView.mImage_Mask = nil;
--UIMixPanelView.mText_MaterialItem1_Count = nil;
--UIMixPanelView.mText_MaterialItem2_Count = nil;
--UIMixPanelView.mText_MixItem_Count = nil;
--UIMixPanelView.mText_AmountText = nil;
--UIMixPanelView.mText_Gold_Price = nil;
--UIMixPanelView.mTrans_MaterialItem1 = nil;
--UIMixPanelView.mTrans_MaterialItem1_DisableFrame = nil;
--UIMixPanelView.mTrans_MaterialItem1_EnableFrame = nil;
--UIMixPanelView.mTrans_MaterialItem1_equipIcon = nil;
--UIMixPanelView.mTrans_MaterialItem1_arrow = nil;
--UIMixPanelView.mTrans_MaterialItem1_Selected = nil;
--UIMixPanelView.mTrans_MaterialItem1_GradeDetail = nil;
--UIMixPanelView.mTrans_MaterialItem1_Star1 = nil;
--UIMixPanelView.mTrans_MaterialItem1_Star2 = nil;
--UIMixPanelView.mTrans_MaterialItem1_Star3 = nil;
--UIMixPanelView.mTrans_MaterialItem1_Star4 = nil;
--UIMixPanelView.mTrans_MaterialItem1_Star5 = nil;
--UIMixPanelView.mTrans_MaterialItem1_Star6 = nil;
--UIMixPanelView.mTrans_MaterialItem1_Locked = nil;
--UIMixPanelView.mTrans_MaterialItem1_MaxLV = nil;
--UIMixPanelView.mTrans_MaterialItem1_UseDetail = nil;
--UIMixPanelView.mTrans_MaterialItem1_Equipped = nil;
--UIMixPanelView.mTrans_MaterialItem1_CantSel = nil;
--UIMixPanelView.mTrans_MaterialItem2 = nil;
--UIMixPanelView.mTrans_MaterialItem2_DisableFrame = nil;
--UIMixPanelView.mTrans_MaterialItem2_EnableFrame = nil;
--UIMixPanelView.mTrans_MaterialItem2_equipIcon = nil;
--UIMixPanelView.mTrans_MaterialItem2_arrow = nil;
--UIMixPanelView.mTrans_MaterialItem2_Selected = nil;
--UIMixPanelView.mTrans_MaterialItem2_GradeDetail = nil;
--UIMixPanelView.mTrans_MaterialItem2_Star1 = nil;
--UIMixPanelView.mTrans_MaterialItem2_Star2 = nil;
--UIMixPanelView.mTrans_MaterialItem2_Star3 = nil;
--UIMixPanelView.mTrans_MaterialItem2_Star4 = nil;
--UIMixPanelView.mTrans_MaterialItem2_Star5 = nil;
--UIMixPanelView.mTrans_MaterialItem2_Star6 = nil;
--UIMixPanelView.mTrans_MaterialItem2_Locked = nil;
--UIMixPanelView.mTrans_MaterialItem2_MaxLV = nil;
--UIMixPanelView.mTrans_MaterialItem2_UseDetail = nil;
--UIMixPanelView.mTrans_MaterialItem2_Equipped = nil;
--UIMixPanelView.mTrans_MaterialItem2_CantSel = nil;
--UIMixPanelView.mTrans_MixItem = nil;
--UIMixPanelView.mTrans_MixItem_DisableFrame = nil;
--UIMixPanelView.mTrans_MixItem_EnableFrame = nil;
--UIMixPanelView.mTrans_MixItem_equipIcon = nil;
--UIMixPanelView.mTrans_MixItem_arrow = nil;
--UIMixPanelView.mTrans_MixItem_Selected = nil;
--UIMixPanelView.mTrans_MixItem_GradeDetail = nil;
--UIMixPanelView.mTrans_MixItem_Star1 = nil;
--UIMixPanelView.mTrans_MixItem_Star2 = nil;
--UIMixPanelView.mTrans_MixItem_Star3 = nil;
--UIMixPanelView.mTrans_MixItem_Star4 = nil;
--UIMixPanelView.mTrans_MixItem_Star5 = nil;
--UIMixPanelView.mTrans_MixItem_Star6 = nil;
--UIMixPanelView.mTrans_MixItem_Locked = nil;
--UIMixPanelView.mTrans_MixItem_MaxLV = nil;
--UIMixPanelView.mTrans_MixItem_UseDetail = nil;
--UIMixPanelView.mTrans_MixItem_Equipped = nil;
--UIMixPanelView.mTrans_MixItem_CantSel = nil;
--UIMixPanelView.mTrans_Gold = nil;
--UIMixPanelView.mTrans_Disable = nil;
--UIMixPanelView.mTrans_MixList = nil;
--
--function UIMixPanelView:__InitCtrl()
--
--	self.mBtn_BGCloseButton = self:GetButton("Btn_BGCloseButton");
--	self.mBtn_Cancel = self:GetButton("BG/Btn_Cancel");
--	self.mBtn_MaterialItem1_Select = self:GetButton("MainPanel/MaterialItem1/Itempoint/UICommonItemL/Btn_Select");
--	self.mBtn_MaterialItem1_Lock = self:GetButton("MainPanel/UI_Trans_MaterialItem1/Itempoint/UICommonItemL/Btn_Lock");
--	self.mBtn_MaterialItem1_Reduce = self:GetButton("MainPanel/UI_Trans_MaterialItem1/Itempoint/UICommonItemL/Trans_UseDetail/Btn_Reduce");
--	self.mBtn_MaterialItem2_Select = self:GetButton("MainPanel/UI_Trans_MaterialItem2/Itempoint/UICommonItemL/Btn_Select");
--	self.mBtn_MaterialItem2_Lock = self:GetButton("MainPanel/UI_Trans_MaterialItem2/Itempoint/UICommonItemL/Btn_Lock");
--	self.mBtn_MaterialItem2_Reduce = self:GetButton("MainPanel/UI_Trans_MaterialItem2/Itempoint/UICommonItemL/Trans_UseDetail/Btn_Reduce");
--	self.mBtn_MixItem_Select = self:GetButton("MainPanel/UI_Trans_MixItem/Itempoint/UICommonItemL/Btn_Select");
--	self.mBtn_MixItem_Lock = self:GetButton("MainPanel/UI_Trans_MixItem/Itempoint/UICommonItemL/Btn_Lock");
--	self.mBtn_MixItem_Reduce = self:GetButton("MainPanel/UI_Trans_MixItem/Itempoint/UICommonItemL/Trans_UseDetail/Btn_Reduce");
--	self.mBtn_AmountPlusButton = self:GetButton("MainPanel/Amount/Btn_AmountPlusButton");
--	self.mBtn_AmountMinusButton = self:GetButton("MainPanel/Amount/Btn_AmountMinusButton");
--	self.mBtn_AmountMaxButton = self:GetButton("MainPanel/Amount/Btn_AmountMaxButton");
--	self.mBtn_Mix = self:GetButton("MainPanel/Btn_Mix");
--	self.mBtn_TotalMix = self:GetButton("MainPanel/Btn_TotalMix");
--	self.mImage_MaterialItem1_Icon = self:GetImage("MainPanel/UI_Trans_MaterialItem1/Itempoint/UICommonItemL/Image_Icon");
--	self.mImage_MaterialItem1_Rank = self:GetImage("MainPanel/UI_Trans_MaterialItem1/Itempoint/UICommonItemL/Image_Rank");
--	self.mImage_MaterialItem1_HeadIcon = self:GetImage("MainPanel/UI_Trans_MaterialItem1/Itempoint/UICommonItemL/Trans_Equipped/HeadFrame/Image_HeadIcon");
--	self.mImage_MaterialItem2_Icon = self:GetImage("MainPanel/UI_Trans_MaterialItem2/Itempoint/UICommonItemL/Image_Icon");
--	self.mImage_MaterialItem2_Rank = self:GetImage("MainPanel/UI_Trans_MaterialItem2/Itempoint/UICommonItemL/Image_Rank");
--	self.mImage_MaterialItem2_HeadIcon = self:GetImage("MainPanel/UI_Trans_MaterialItem2/Itempoint/UICommonItemL/Trans_Equipped/HeadFrame/Image_HeadIcon");
--	self.mImage_MixItem_Icon = self:GetImage("MainPanel/UI_Trans_MixItem/Itempoint/UICommonItemL/Image_Icon");
--	self.mImage_MixItem_Rank = self:GetImage("MainPanel/UI_Trans_MixItem/Itempoint/UICommonItemL/Image_Rank");
--	self.mImage_MixItem_HeadIcon = self:GetImage("MainPanel/UI_Trans_MixItem/Itempoint/UICommonItemL/Trans_Equipped/HeadFrame/Image_HeadIcon");
--	self.mImage_Mask = self:GetImage("Image_Mask");
--	self.mText_MaterialItem1_Count = self:GetText("MainPanel/UI_Trans_MaterialItem1/Itempoint/UICommonItemL/Text_Count");
--	self.mText_MaterialItem2_Count = self:GetText("MainPanel/UI_Trans_MaterialItem2/Itempoint/UICommonItemL/Text_Count");
--	self.mText_MixItem_Count = self:GetText("MainPanel/UI_Trans_MixItem/Itempoint/UICommonItemL/Text_Count");
--	self.mText_AmountText = self:GetText("MainPanel/Amount/GoodsAmount/Text_AmountText");
--	self.mText_Gold_Price = self:GetText("MainPanel/UI_Trans_Gold/Text_Price");
--	self.mTrans_MaterialItem1 = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem1");
--	self.mTrans_MaterialItem1_DisableFrame = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem1/Trans_DisableFrame");
--	self.mTrans_MaterialItem1_EnableFrame = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem1/Trans_EnableFrame");
--	self.mTrans_MaterialItem1_equipIcon = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem1/Itempoint/UICommonItemL/Trans_equipIcon");
--	self.mTrans_MaterialItem1_arrow = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem1/Itempoint/UICommonItemL/Trans_equipIcon/base/Trans_arrow");
--	self.mTrans_MaterialItem1_Selected = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem1/Itempoint/UICommonItemL/Trans_Selected");
--	self.mTrans_MaterialItem1_GradeDetail = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem1/Itempoint/UICommonItemL/Trans_GradeDetail");
--	self.mTrans_MaterialItem1_Star1 = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem1/Itempoint/UICommonItemL/Trans_GradeDetail/Trans_Star1");
--	self.mTrans_MaterialItem1_Star2 = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem1/Itempoint/UICommonItemL/Trans_GradeDetail/Trans_Star2");
--	self.mTrans_MaterialItem1_Star3 = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem1/Itempoint/UICommonItemL/Trans_GradeDetail/Trans_Star3");
--	self.mTrans_MaterialItem1_Star4 = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem1/Itempoint/UICommonItemL/Trans_GradeDetail/Trans_Star4");
--	self.mTrans_MaterialItem1_Star5 = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem1/Itempoint/UICommonItemL/Trans_GradeDetail/Trans_Star5");
--	self.mTrans_MaterialItem1_Star6 = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem1/Itempoint/UICommonItemL/Trans_GradeDetail/Trans_Star6");
--	self.mTrans_MaterialItem1_Locked = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem1/Itempoint/UICommonItemL/Trans_Locked");
--	self.mTrans_MaterialItem1_MaxLV = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem1/Itempoint/UICommonItemL/Trans_MaxLV");
--	self.mTrans_MaterialItem1_UseDetail = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem1/Itempoint/UICommonItemL/Trans_UseDetail");
--	self.mTrans_MaterialItem1_Equipped = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem1/Itempoint/UICommonItemL/Trans_Equipped");
--	self.mTrans_MaterialItem1_CantSel = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem1/Itempoint/UICommonItemL/Trans_CantSel");
--	self.mTrans_MaterialItem2 = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem2");
--	self.mTrans_MaterialItem2_DisableFrame = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem2/Trans_DisableFrame");
--	self.mTrans_MaterialItem2_EnableFrame = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem2/Trans_EnableFrame");
--	self.mTrans_MaterialItem2_equipIcon = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem2/Itempoint/UICommonItemL/Trans_equipIcon");
--	self.mTrans_MaterialItem2_arrow = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem2/Itempoint/UICommonItemL/Trans_equipIcon/base/Trans_arrow");
--	self.mTrans_MaterialItem2_Selected = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem2/Itempoint/UICommonItemL/Trans_Selected");
--	self.mTrans_MaterialItem2_GradeDetail = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem2/Itempoint/UICommonItemL/Trans_GradeDetail");
--	self.mTrans_MaterialItem2_Star1 = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem2/Itempoint/UICommonItemL/Trans_GradeDetail/Trans_Star1");
--	self.mTrans_MaterialItem2_Star2 = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem2/Itempoint/UICommonItemL/Trans_GradeDetail/Trans_Star2");
--	self.mTrans_MaterialItem2_Star3 = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem2/Itempoint/UICommonItemL/Trans_GradeDetail/Trans_Star3");
--	self.mTrans_MaterialItem2_Star4 = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem2/Itempoint/UICommonItemL/Trans_GradeDetail/Trans_Star4");
--	self.mTrans_MaterialItem2_Star5 = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem2/Itempoint/UICommonItemL/Trans_GradeDetail/Trans_Star5");
--	self.mTrans_MaterialItem2_Star6 = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem2/Itempoint/UICommonItemL/Trans_GradeDetail/Trans_Star6");
--	self.mTrans_MaterialItem2_Locked = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem2/Itempoint/UICommonItemL/Trans_Locked");
--	self.mTrans_MaterialItem2_MaxLV = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem2/Itempoint/UICommonItemL/Trans_MaxLV");
--	self.mTrans_MaterialItem2_UseDetail = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem2/Itempoint/UICommonItemL/Trans_UseDetail");
--	self.mTrans_MaterialItem2_Equipped = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem2/Itempoint/UICommonItemL/Trans_Equipped");
--	self.mTrans_MaterialItem2_CantSel = self:GetRectTransform("MainPanel/UI_Trans_MaterialItem2/Itempoint/UICommonItemL/Trans_CantSel");
--	self.mTrans_MixItem = self:GetRectTransform("MainPanel/UI_Trans_MixItem");
--	self.mTrans_MixItem_DisableFrame = self:GetRectTransform("MainPanel/UI_Trans_MixItem/Trans_DisableFrame");
--	self.mTrans_MixItem_EnableFrame = self:GetRectTransform("MainPanel/UI_Trans_MixItem/Trans_EnableFrame");
--	self.mTrans_MixItem_equipIcon = self:GetRectTransform("MainPanel/UI_Trans_MixItem/Itempoint/UICommonItemL/Trans_equipIcon");
--	self.mTrans_MixItem_arrow = self:GetRectTransform("MainPanel/UI_Trans_MixItem/Itempoint/UICommonItemL/Trans_equipIcon/base/Trans_arrow");
--	self.mTrans_MixItem_Selected = self:GetRectTransform("MainPanel/UI_Trans_MixItem/Itempoint/UICommonItemL/Trans_Selected");
--	self.mTrans_MixItem_GradeDetail = self:GetRectTransform("MainPanel/UI_Trans_MixItem/Itempoint/UICommonItemL/Trans_GradeDetail");
--	self.mTrans_MixItem_Star1 = self:GetRectTransform("MainPanel/UI_Trans_MixItem/Itempoint/UICommonItemL/Trans_GradeDetail/Trans_Star1");
--	self.mTrans_MixItem_Star2 = self:GetRectTransform("MainPanel/UI_Trans_MixItem/Itempoint/UICommonItemL/Trans_GradeDetail/Trans_Star2");
--	self.mTrans_MixItem_Star3 = self:GetRectTransform("MainPanel/UI_Trans_MixItem/Itempoint/UICommonItemL/Trans_GradeDetail/Trans_Star3");
--	self.mTrans_MixItem_Star4 = self:GetRectTransform("MainPanel/UI_Trans_MixItem/Itempoint/UICommonItemL/Trans_GradeDetail/Trans_Star4");
--	self.mTrans_MixItem_Star5 = self:GetRectTransform("MainPanel/UI_Trans_MixItem/Itempoint/UICommonItemL/Trans_GradeDetail/Trans_Star5");
--	self.mTrans_MixItem_Star6 = self:GetRectTransform("MainPanel/UI_Trans_MixItem/Itempoint/UICommonItemL/Trans_GradeDetail/Trans_Star6");
--	self.mTrans_MixItem_Locked = self:GetRectTransform("MainPanel/UI_Trans_MixItem/Itempoint/UICommonItemL/Trans_Locked");
--	self.mTrans_MixItem_MaxLV = self:GetRectTransform("MainPanel/UI_Trans_MixItem/Itempoint/UICommonItemL/Trans_MaxLV");
--	self.mTrans_MixItem_UseDetail = self:GetRectTransform("MainPanel/UI_Trans_MixItem/Itempoint/UICommonItemL/Trans_UseDetail");
--	self.mTrans_MixItem_Equipped = self:GetRectTransform("MainPanel/UI_Trans_MixItem/Itempoint/UICommonItemL/Trans_Equipped");
--	self.mTrans_MixItem_CantSel = self:GetRectTransform("MainPanel/UI_Trans_MixItem/Itempoint/UICommonItemL/Trans_CantSel");
--	self.mTrans_Gold = self:GetRectTransform("MainPanel/UI_Trans_Gold");
--	self.mTrans_Disable = self:GetRectTransform("MainPanel/Trans_Disable");
--	self.mTrans_MixList = self:GetRectTransform("Trans_MixList");
--
--	self.mVirtualList = UIUtils.GetVirtualList(self.mTrans_MixList)
--	self.mText_AmountText = self:GetInputField("MainPanel/Amount/GoodsAmount/Text_AmountText");
--end
--
----@@ GF Auto Gen Block End
--
--function UIMixPanelView:InitCtrl(root)
--
--	self:SetRoot(root);
--
--	self:__InitCtrl();
--
--end