require("UI.UIBaseCtrl")

---@class UIPostRightTextDescriptionItemV2 : UIBaseCtrl
UIPostRightTextDescriptionItemV2 = class("UIPostRightTextDescriptionItemV2", UIBaseCtrl);
UIPostRightTextDescriptionItemV2.__index = UIPostRightTextDescriptionItemV2
--@@ GF Auto Gen Block Begin
UIPostRightTextDescriptionItemV2.mText_Description = nil;

function UIPostRightTextDescriptionItemV2:__InitCtrl()

	self.mText_Description = self:GetText("Text_Description");
end

--@@ GF Auto Gen Block End

function UIPostRightTextDescriptionItemV2:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIPostRightTextDescriptionItemV2:SetData(postData)

	self.mText_Description.alignment = postData.alignment
	self.mText_Description.text = " "
	TimerSys:DelayCall(0.05, function()
		if string.match(postData.text, "{uid}") then
			local text = string.gsub(postData.text, "{uid}", AccountNetCmdHandler:GetUID())
			text = string.gsub(text, '{(https://%g-)}', function(w)
				if string.match(w, "uid") then
					local strings = string.split(w, "?")
					return "{" .. strings[1] .. "?token=" .. string.gsub(CS.AesUtils.Encode(strings[2]), "-", "") .. "}"
				else
					return w
				end
			end)
			self.mText_Description.text = text
		else
			self.mText_Description.text = postData.text
		end
	end)

end