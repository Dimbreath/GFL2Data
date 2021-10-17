require("UI.RedPoint.RedPointNode")
require("UI.RedPoint.RedPointConst")

local RedPointSystem = class("RedPointSystem")
RedPointSystem.__index = RedPointSystem

RedPointSystem.instance = nil
RedPointSystem.rootNode = nil

RedPointSystem.listRedPointTreeList =
{
	RedPointConst.Main,
	RedPointConst.Mails,
	RedPointConst.Chapters,
	RedPointConst.Chapter,
	RedPointConst.ChapterReward,
	RedPointConst.Daily,
	RedPointConst.Notice,
	RedPointConst.Barracks,
	RedPointConst.Achievement,
	RedPointConst.Chat,
	RedPointConst.UAV,
	RedPointConst.Friend,
	RedPointConst.ApplyFriend
}

function RedPointSystem:ctor()
	self.rootNode = nil
	-- self.redPointDic = {}

	MessageSys:AddListener(CS.GF2.Message.RedPointEvent.InitRedPointCount, self.InitRedPointCount)
	MessageSys:AddListener(CS.GF2.Message.RedPointEvent.RedPointUpdate, self.RedPointUpdate)
end

function RedPointSystem.OnRelease()
	self = RedPointSystem
	-- self.instance = nil
	-- self.rootNode = nil
	-- self.redPointDic = {}
	-- MessageSys:RemoveListener(CS.GF2.Message.RedPointEvent.InitRedPointCount, self.InitRedPointCount)
	-- MessageSys:RemoveListener(CS.GF2.Message.RedPointEvent.RedPointUpdate, self.RedPointUpdate)
end

function RedPointSystem:GetInstance()
	if self.instance == nil then
		self.instance = self.New()
		self.instance:InitRedPointTree()
	end
	return self.instance
end

function RedPointSystem:InitRedPointTree()
	self.rootNode = RedPointNode.New()
	self.rootNode.nodeName = RedPointConst.Main
	self.rootNode.fullName = RedPointConst.Main
	for _, value in pairs(self.listRedPointTreeList) do
		local node = self.rootNode
		local treeNodeArr = string.split(value, ':')
		if treeNodeArr[1] == self.rootNode.nodeName then
			if #treeNodeArr > 1 then
				for i = 2, #treeNodeArr do
					local name = treeNodeArr[i]
					if node.dicChild[name] == nil then
						node.dicChild[name] = RedPointNode.New()
					end
					node.dicChild[name].nodeName = name
					node.dicChild[name].fullName = node.fullName .. ":" ..name
					node.dicChild[name].parent = node

					node = node.dicChild[name]
				end
			end
		end
	end
end

function RedPointSystem:AddRedPointListener(strNode, objRedPoint, callback, systemId)
	if strNode == nil or strNode == "" then
		return
	end
	local nodeList = string.split(strNode, ":")
	if #nodeList == 1 then
		if nodeList[1] ~= RedPointConst.Main then
			printstack("Get Wrong Root Node! current is " .. nodeList[1])
			return
		end
	end

	local node = self.rootNode
	for i = 2, #nodeList do
		if node.dicChild[nodeList[i]] == nil then
			printstack("Does Not Contains Child Node :" .. nodeList[i])
			return
		end
		node = node.dicChild[nodeList[i]]
		if i == #nodeList then
			node.systemId = systemId
			node.onNumChangeCallback = callback
			node:SetRedPointObj(objRedPoint)
		end
	end
end

function RedPointSystem:RemoveRedPointListener(strNode)
	if strNode == nil or strNode == "" then
		return
	end
	local nodeList = string.split(strNode, ":")
	if #nodeList == 1 then
		if nodeList[1] ~= RedPointConst.Main then
			printstack("Get Wrong Root Node! current is " .. nodeList[1])
			return
		end
	end

	local node = self.rootNode
	for i = 2, #nodeList do
		if node.dicChild[nodeList[i]] == nil then
			printstack("Does Not Contains Child Node :" .. nodeList[i])
			return
		end
		node = node.dicChild[nodeList[i]]
		if i == #nodeList then
			node.onNumChangeCallback = nil
			node.objRedPoint = nil
			node.txtRedNum = nil
		end
	end

	-- self.redPointDic[strNode] = nil
end

function RedPointSystem:SetInvoke(strNode, redNum)
	if strNode == "" then
		return
	end
	local nodeList = string.split(strNode, ":")
	if #nodeList == 1 then
		if nodeList[1] ~= RedPointConst.Main then
			printstack("Get Wrong Root Node! current is " .. nodeList[1])
			return
		end
	end

	local node = self.rootNode
	for i = 2, #nodeList do
		if node.dicChild[nodeList[i]] == nil then
			printstack("Does Not Contains Child Node :" .. nodeList[i])
			return
		end
		node = node.dicChild[nodeList[i]]
		if i == #nodeList then
			node:SetRedPointNum(redNum)
		end
	end
end

function RedPointSystem:GetRedPointCountByType(strNode)
	if strNode == "" then
		return
	end
	local nodeList = string.split(strNode, ":")
	if #nodeList == 1 then
		if nodeList[1] ~= RedPointConst.Main then
			printstack("Get Wrong Root Node! current is " .. nodeList[1])
			return
		end

		return self.rootNode:GetRedPointNum()
	end

	local node = self.rootNode
	for i = 2, #nodeList do
		if node.dicChild[nodeList[i]] == nil then
			printstack("Does Not Contains Child Node :" .. nodeList[i])
			return
		end
		node = node.dicChild[nodeList[i]]
		if i == #nodeList then
			return node:GetRedPointNum()
		end
	end
end

function RedPointSystem.RedPointUpdate(obj)
	local id = obj.Sender
	if id then
		local type = RedPointConst[id]
		if type then
			RedPointSystem:GetInstance():UpdateRedPointByType(type)
		end
	end
end

function RedPointSystem.InitRedPointCount()
	RedPointSystem:GetInstance():UpdateAllSystem()
end

function RedPointSystem:UpdateRedPointByType(type, needMessage)
	if type == nil then
		return
	end

	needMessage = needMessage ~= nil and needMessage or true
	local count = 0
	if type == RedPointConst.Mails then
		count = NetCmdMailData:UpdateRedPoint()
	elseif type == RedPointConst.ChapterReward then
		count = NetCmdDungeonData:UpdateRewardRedPoint()
	elseif type == RedPointConst.Daily then
		count = NetCmdQuestData:UpdateRedPoint()
	elseif type == RedPointConst.Notice then
		count = PostInfoConfig.UpdateRedPoint()
	elseif type == RedPointConst.Barracks then
		count = NetCmdTeamData:UpdateBarracksRedPoint()
	elseif type == RedPointConst.Achievement then
		count = NetCmdAchieveData:UpdateAchievementRedPoint()
	elseif type == RedPointConst.Chat then
		count = NetCmdChatData:UpdateChatRedPoint()
	elseif type == RedPointConst.UAV then
		count = NetCmdUavData:UpdateUavRedPointCount()
	elseif type == RedPointConst.Friend then
		count = NetCmdFriendData:UpdateRedPoint()
	elseif type == RedPointConst.ApplyFriend then
		count = NetCmdFriendData:UpdateApplyFriendRedPoint()
	end

	-- self.redPointDic[type] = count
	if needMessage == true then
		self:SetInvoke(type, count)
	end
end

function RedPointSystem:UpdateAllSystem()
	self:UpdateRedPointByType(RedPointConst.ChapterReward)
	self:UpdateRedPointByType(RedPointConst.Mails)
	self:UpdateRedPointByType(RedPointConst.Daily)
	self:UpdateRedPointByType(RedPointConst.Notice)
	self:UpdateRedPointByType(RedPointConst.Barracks)
	self:UpdateRedPointByType(RedPointConst.Achievement)
	self:UpdateRedPointByType(RedPointConst.Chat)
	self:UpdateRedPointByType(RedPointConst.UAV)
	self:UpdateRedPointByType(RedPointConst.Friend)
end


function RedPointSystem.DebugRedPointLog(root)
	local function _dump(t, space)
		local temp = {}
		local value = RedPointSystem:GetInstance():GetRedPointCountByType(t.fullName)
		table.insert(temp, space .. "+" .. t.nodeName .. " (" .. value .. ")")
		if t.dicChild ~= nil then
			for k,v in pairs(t.dicChild) do
				table.insert(temp, space .. _dump(v, string.rep(" ",#tostring(t.nodeName))))
			end
		end

		return table.concat(temp,"\n")
	end
	print("\n" .. _dump(RedPointSystem:GetInstance().rootNode, ""))
end


return RedPointSystem
