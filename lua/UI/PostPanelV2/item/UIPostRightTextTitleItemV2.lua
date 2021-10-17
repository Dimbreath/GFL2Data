require("UI.UIBaseCtrl")

---@class UIPostRightTextTitleItemV2 : UIBaseCtrl
UIPostRightTextTitleItemV2 = class("UIPostRightTextTitleItemV2", UIBaseCtrl);
UIPostRightTextTitleItemV2.__index = UIPostRightTextTitleItemV2
--@@ GF Auto Gen Block Begin
UIPostRightTextTitleItemV2.mText_Title = nil;

function UIPostRightTextTitleItemV2:__InitCtrl()

	self.mText_Title = self:GetText("Text_Title");
end

--@@ GF Auto Gen Block End

function UIPostRightTextTitleItemV2:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIPostRightTextTitleItemV2:SetData(postData)

	self.mText_Title.text = postData

end