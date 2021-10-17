require("UI.Common.UICommonHintItem");
require("UI.Common.UICommonHintTipsItem");

CommonHintManager = {};
this = CommonHintManager;
CommonHintManager.canvasPath = "UICommonFramework/CommonHintCanvas.prefab";
CommonHintManager.hintPath = "UICommonFramework/UICommonHintItem.prefab";
CommonHintManager.hintTipsPath = "UICommonFramework/UICommonHintTipsItem.prefab";
CommonHintManager.canvas = nil;
CommonHintManager.topHints = {};
CommonHintManager.index = 0;
CommonHintManager.maxHintCount = 5;
CommonHintManager.hint = nil;
function CommonHintManager.ShowTopHint(msg)
    if this.index == #this.topHints then
        this.__initCanvas();
        local instObj = instantiate(UIUtils.GetGizmosPrefab(this.hintTipsPath,self));
        local item = UICommonHintTipsItem.New();
        item:InitCtrl(instObj.transform,this.index);
        instObj.transform:SetParent(this.canvas.transform);
        local rect = CS.LuaUIUtils.GetRectTransform(instObj)
        rect.offsetMin = Vector2.zero;
        rect.offsetMax  = Vector2.zero;
        table.insert(this.topHints,item);
    end
    this.topHints[this.index + 1]:ShowHint(msg);
    this.index = (this.index + 1) % this.maxHintCount;
end

function CommonHintManager.ShowHint(msg)
    if this.hint == nil then
        this.__initCanvas();
        local instObj = instantiate(UIUtils.GetGizmosPrefab(this.hintPath,self));
        local item = UICommonHintItem.New();
        item:InitCtrl(instObj.transform,this.index);
        instObj.transform:SetParent(this.canvas.transform);
        local rect = CS.LuaUIUtils.GetRectTransform(instObj)
        rect.offsetMin = Vector2.zero;
        rect.offsetMax  = Vector2.zero;
        this.hint = item;
    end
    this.hint:ShowHint(msg);
end

function CommonHintManager.__initCanvas()
    if this.canvas == nil then
        local prefab = UIUtils.GetUIRes(this.canvasPath);
        this.canvas = instantiate(prefab);
        CS.UnityEngine.GameObject.DontDestroyOnLoad(this.canvas);
    end
end