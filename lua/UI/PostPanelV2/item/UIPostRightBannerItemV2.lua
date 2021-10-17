require("UI.UIBaseCtrl")

---@class UIPostRightBannerItemV2 : UIBaseCtrl
UIPostRightBannerItemV2 = class("UIPostRightBannerItemV2", UIBaseCtrl);
UIPostRightBannerItemV2.__index = UIPostRightBannerItemV2
--@@ GF Auto Gen Block Begin
UIPostRightBannerItemV2.mImage_Banner = nil;

function UIPostRightBannerItemV2:__InitCtrl()

	self.mImage_Banner = self:GetImage("Image_Banner");
end

--@@ GF Auto Gen Block End

function UIPostRightBannerItemV2:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIPostRightBannerItemV2:SetData(data)
	self.mData = data
	if data.sprite == nil and data.isURLTex then
		CS.LuaUtils.DownloadTextureFromUrl(data.linkArgs, function(tex)
			data.sprite = CS.UIUtils.TextureToSprite(tex)
			self.mImage_Banner.sprite = data.sprite
			--local rate = data.sprite.texture.width / data.sprite.texture.height
			--self.mAspectRatioFitter.aspectRatio = rate
		end)
	else
		local rate = data.sprite.texture.width / data.sprite.texture.height
		self.mImage_Banner.sprite = data.sprite
		--self.mAspectRatioFitter.aspectRatio = rate
	end
end
