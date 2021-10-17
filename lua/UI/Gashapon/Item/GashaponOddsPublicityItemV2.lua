---zhai xing
require("UI.UIBaseCtrl")

GashaponOddsPublicityItemV2=class("GashaponOddsPublicityItemV2",UIBaseCtrl)
GashaponOddsPublicityItemV2.__Index=GashaponOddsPublicityItemV2

function GashaponOddsPublicityItemV2:__InitCtrl()
    self.mTrans_GrpChrStar=self:GetRectTransform("GrpChrStar")
    self.mTrans_Content=self:GetRectTransform("Content")
    self.mTrans_ImgBg=self:GetImage("GrpChrStar/Img_Bg")
end

function GashaponOddsPublicityItemV2:InitCtrl(parent)
    local obj=instantiate(UIUtils.GetGizmosPrefab("Gashapon/GashaponOddsPublicityItemV2.prefab",self))
    if parent then
        CS.LuaUIUtils.SetParent(obj.gameObject,parent.gameObject,false)
    end
    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function GashaponOddsPublicityItemV2:SetData(data)

end

function GashaponOddsPublicityItemV2:SetSelect(isSelect)

end
