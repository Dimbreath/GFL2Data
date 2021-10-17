require("UI.UIBaseCtrl")

UIPostContentTemplete_ImageItem = class("UIPostContentTemplete_ImageItem", UIBaseCtrl);
UIPostContentTemplete_ImageItem.__index = UIPostContentTemplete_ImageItem
--@@ GF Auto Gen Block Begin

UIPostContentTemplete_ImageItem.mData = nil
UIPostContentTemplete_ImageItem.rate = 0

function UIPostContentTemplete_ImageItem:__InitCtrl()
	self.mImage_Self = self:GetSelfImage()
	self.mAspectRatioFitter = self.mUIRoot:GetComponent("AspectRatioFitter")
end

--@@ GF Auto Gen Block End

function UIPostContentTemplete_ImageItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIPostContentTemplete_ImageItem:SetData(data)
	self.mData = data
	if data.sprite == nil and data.isURLTex then
		CS.LuaUtils.DownloadTextureFromUrl(data.linkArgs, function(tex)
			data.sprite = CS.UIUtils.TextureToSprite(tex)
			self.mImage_Self.sprite = data.sprite
			local rate = data.sprite.texture.width / data.sprite.texture.height
			self.mAspectRatioFitter.aspectRatio = rate
		end)
	else
		local rate = data.sprite.texture.width / data.sprite.texture.height
		self.mImage_Self.sprite = data.sprite
		self.mAspectRatioFitter.aspectRatio = rate
	end
end
