require("UI.UIBaseCtrl")

PreparationNameplate = class("PreparationNameplate", UIBaseCtrl);
PreparationNameplate.__index = PreparationNameplate
--@@ GF Auto Gen Block Begin
PreparationNameplate.mImage_HPSlider = nil;
PreparationNameplate.mTrans_Elite = nil;
PreparationNameplate.mTrans_HPSlider = nil;
PreparationNameplate.mTrans_NameplateImage = nil;
PreparationNameplate.mTrans_Attribute1 = nil;
PreparationNameplate.mTrans_Attribute2 = nil;
PreparationNameplate.mTrans_Attribute3 = nil;
PreparationNameplate.mTrans_Attribute4 = nil;
PreparationNameplate.mTrans_Attribute5 = nil;
PreparationNameplate.mTrans_Attribute6 = nil;
PreparationNameplate.mTrans_Guntype1 = nil;
PreparationNameplate.mTrans_Guntype2 = nil;
PreparationNameplate.mTrans_Guntype3 = nil;
PreparationNameplate.mTrans_Guntype4 = nil;

function PreparationNameplate:__InitCtrl()

	self.mImage_HPSlider = self:GetImage("FillArea/Mask/Trans_Image_HPSlider");
	self.mTrans_Elite = self:GetRectTransform("FillArea/Mask/EXHP");
	self.mTrans_HPSlider = self:GetRectTransform("FillArea/Mask/Trans_Image_HPSlider");
	self.mTrans_NameplateImage = self:GetRectTransform("FillArea/Mask/UI_Trans_NameplateImage");
	self.mTrans_Attribute1 = self:GetRectTransform("Attribute/UI_Trans_Attribute1");
	self.mTrans_Attribute2 = self:GetRectTransform("Attribute/UI_Trans_Attribute2");
	self.mTrans_Attribute3 = self:GetRectTransform("Attribute/UI_Trans_Attribute3");
	self.mTrans_Attribute4 = self:GetRectTransform("Attribute/UI_Trans_Attribute4");
	self.mTrans_Attribute5 = self:GetRectTransform("Attribute/UI_Trans_Attribute5");
	self.mTrans_Attribute6 = self:GetRectTransform("Attribute/UI_Trans_Attribute6");
	self.mTrans_Guntype1 = self:GetRectTransform("Guntype/UI_Trans_Guntype1");
	self.mTrans_Guntype2 = self:GetRectTransform("Guntype/UI_Trans_Guntype2");
	self.mTrans_Guntype3 = self:GetRectTransform("Guntype/UI_Trans_Guntype3");
	self.mTrans_Guntype4 = self:GetRectTransform("Guntype/UI_Trans_Guntype4");
end

--@@ GF Auto Gen Block End
PreparationNameplate.worldPos = nil;
function PreparationNameplate:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function PreparationNameplate:InitData(duty,element,pos,rank)
	for i = 1,6 do
		setactive(self["mTrans_Attribute"..i].gameObject,i == element);
	end
	for i = 1,4 do
		setactive(self["mTrans_Guntype"..i].gameObject,i == duty);
	end
	self.worldPos = pos;
	setactive(self.mTrans_Elite.gameObject,rank==2)
end


function PreparationNameplate:UpdatePosition()
	self.mUIRoot.position = CS.LuaUtils.WorldToScreenPoint(self.worldPos);
end

function PreparationNameplate:UpdateScale(CameraPosition)

    local distance = math.abs(0 - CameraPosition.y);

    if distance < 1 then
        distance = 1;
    end
    local scale = 12 / distance;
    if scale > 2 then
        scale = 2;
    end
    self.mUIRoot.localScale = Vector3(scale,scale,scale);
end