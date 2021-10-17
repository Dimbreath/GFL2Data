require("UI.UIBaseCtrl")

UIBattleIndexLine = class("UIBattleIndexLine", UIBaseCtrl);
UIBattleIndexLine.__index = UIBattleIndexLine
--@@ GF Auto Gen Block Begin
UIBattleIndexLine.mTrans_Line = nil

function UIBattleIndexLine:__InitCtrl()
    self.mTrans_Line = UIUtils.GetObject(self.mUIRoot, "line01")
    self.animator = self.mUIRoot:GetComponent("Animator")
end

--@@ GF Auto Gen Block End


function UIBattleIndexLine:InitCtrl(parent)
    local obj = instantiate(UIUtils.GetGizmosPrefab("BattleIndex/Effect/UIEF_BattleIndexLine.prefab", self))
    self:SetRoot(obj.transform)
    setparent(parent,obj.transform)
    obj.transform.localScale = vectorone

    self:SetRoot(obj.transform)
    self:__InitCtrl();
end

function UIBattleIndexLine:EnableLine(enable)
    setactive(self.mUIRoot.gameObject, enable)
end

function UIBattleIndexLine:SetLineDir(pos ,startPos, endPos)
    self:GetSelfRectTransform().anchoredPosition = pos
    -- self.mUIRoot.transform.localPosition = pos
    self.mTrans_Line.localScale = Vector3(1, 1, Vector3.Distance(startPos, endPos) / 7)
    local angle = math.deg(math.atan(endPos.y - startPos.y, endPos.x - startPos.x))
    self.mUIRoot.transform.rotation = CS.UnityEngine.Quaternion.Euler(0, 0, angle + 180)
end

function UIBattleIndexLine:PlayLineAni(enable)
    local aniName = enable and "UIEF_BattleIndexLine_flash" or "UIEF_BattleIndexLine_fadeaway"
    self.animator:Play(aniName, 0, 0)
end

function UIBattleIndexLine:ResetAni()
    self.animator:Play("UIEF_BattleIndexLine_fadeaway", 0, 1)
end

function UIBattleIndexLine:OnRelease()
    self.supportLine = nil
end