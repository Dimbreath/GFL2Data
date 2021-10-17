---@class UIChatPanelView : UIBaseView
UIChatPanelView = class("UIChatPanelView", UIBaseView)
UIChatPanelView.__index = UIChatPanelView

function UIChatPanelView:__InitCtrl()
	self.mBtn_Close = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpContent/GrpLeft/GrpClose/BtnBack"))
	self.mBtn_Send = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpContent/GrpRight/GrpBottom/Trans_GrpSpeechOn/BtnSearch"))
	self.mBtn_BgClose = self:GetButton("Root/GrpBg/Btn_Close")
	self.mBtn_Emoji = self:GetButton("Root/GrpContent/GrpRight/GrpBottom/Trans_GrpSpeechOn/BtnEmoji/Btn_Emoji")
	self.mBtn_More = self:GetButton("Root/GrpContent/GrpRight/Trans_GrpFriend/BtnMore/Btn_More")
	self.mBtn_NewMessage = self:GetButton("Root/GrpContent/GrpRight/GrpBottom/Trans_BtnNewMessage/Btn_NewMessage")
	self.mBtn_CloseEmoji = self:GetButton("Root/GrpContent/GrpRight/GrpBottom/Trans_GrpEmojiList/Btn_Close")
	self.mBtn_CloseMore = self:GetButton("Root/GrpContent/GrpRight/Trans_GrpFriend/Btn_Close")

	self.mTrans_TabContent = self:GetRectTransform("Root/GrpContent/GrpLeft/GrpTab/GrpTabList")
	self.mTrans_LeftContent = self:GetRectTransform("Root/GrpContent/GrpLeft")
	self.mTrans_ListContent = self:GetRectTransform("Root/GrpContent/GrpRight")
	self.mTrans_TabList = self:GetRectTransform("Root/GrpContent/GrpLeft/GrpTab/GrpTabList/Content")
	self.mTrans_FriendList = self:GetRectTransform("Root/GrpContent/GrpLeft/GrpTab/GrpContentList")

	self.mTrans_SystemChat = self:GetRectTransform("Root/GrpContent/GrpRight/Trans_GrpSystem")
	self.mTrans_WorldChat = self:GetRectTransform("Root/GrpContent/GrpRight/Trans_GrpWorld")
	self.mTrans_FriendChat = self:GetRectTransform("Root/GrpContent/GrpRight/Trans_GrpFriend")
	self.mTrans_SystemChatList = self:GetRectTransform("Root/GrpContent/GrpRight/Trans_GrpSystem/GrpContentList")
	self.mTrans_WorldChatList = self:GetRectTransform("Root/GrpContent/GrpRight/Trans_GrpWorld/GrpContentList")
	self.mTrans_FriendChatList = self:GetRectTransform("Root/GrpContent/GrpRight/Trans_GrpFriend/GrpContentList")

	self.mTrans_EmojiList = self:GetRectTransform("Root/GrpContent/GrpRight/GrpBottom/Trans_GrpEmojiList")
	self.mTrans_EmojiContent = self:GetRectTransform("Root/GrpContent/GrpRight/GrpBottom/Trans_GrpEmojiList/GrpContentList/Viewport/Content")

	self.mTrans_NewMessage = self:GetRectTransform("Root/GrpContent/GrpRight/GrpBottom/Trans_BtnNewMessage")
	self.mText_NewMessage = self:GetText("Root/GrpContent/GrpRight/GrpBottom/Trans_BtnNewMessage/Btn_NewMessage/Text_Num")
	self.mInput_Message = self:GetInputField("Root/GrpContent/GrpRight/GrpBottom/Trans_GrpSpeechOn/GrpInputField/Btn_InputField")
	self.mTrans_SpeechOff = self:GetRectTransform("Root/GrpContent/GrpRight/GrpBottom/Trans_GrpSpeechOff")
	self.mTrans_SpeechOn = self:GetRectTransform("Root/GrpContent/GrpRight/GrpBottom/Trans_GrpSpeechOn")
	self.mText_Send = self:GetText("Root/GrpContent/GrpRight/GrpBottom/Trans_GrpSpeechOn/BtnSearch/Btn_Content/Root/GrpText/Text_Name")
	self.mText_SendCD = self:GetText("Root/GrpContent/GrpRight/GrpBottom/Trans_GrpSpeechOn/BtnSearch/Btn_Content/Root/GrpText/Trans_Text_Time")

	self.mText_FriendName = self:GetText("Root/GrpContent/GrpRight/Trans_GrpFriend/GrpPlayerName/Text_Name")

	self.mTrans_MoreContent = self:GetRectTransform("Root/GrpContent/GrpRight/Trans_GrpFriend/BtnMore/Trans_GrpMoreDropDownList")
	self.mTrans_MoreList = self:GetRectTransform("Root/GrpContent/GrpRight/Trans_GrpFriend/BtnMore/Trans_GrpMoreDropDownList/GrpScreenList/Viewport/Content")

	self.mSystemContent = UIUtils.GetLoopScrollView(self.mTrans_SystemChatList)
	self.mWorldContent = UIUtils.GetLoopScrollView(self.mTrans_WorldChatList)
	self.mFriendContent = UIUtils.GetLoopScrollView(self.mTrans_FriendChatList)
	self.mFriendList = UIUtils.GetVirtualList(self.mTrans_FriendList)

	self.mAnimator = self:GetRectTransform("Root"):GetComponent("Animator")
end

--@@ GF Auto Gen Block End

function UIChatPanelView:InitCtrl(root)
	self:SetRoot(root)
	self:__InitCtrl()
end