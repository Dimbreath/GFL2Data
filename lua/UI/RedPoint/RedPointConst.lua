--- 红点根据字符串的定义构建树状结构，根据叶子的红点变化来通知上层节点发生变化
---                 Main
---         Mail       Chapters         Daily        Notice
---                    Chapter
---                    Reward


RedPointConst = {}
RedPointConst.Main           = "Main"
RedPointConst.Mails          = "Main:Mail"
RedPointConst.Chapters       = "Main:Chapters"
RedPointConst.Notice         = "Main:Notice"
RedPointConst.Chapter        = "Main:Chapters:Chapter"
RedPointConst.ChapterReward  = "Main:Chapters:Chapter:Reward"
RedPointConst.Friend         = "Main:Friend"
RedPointConst.ApplyFriend    = "Main:Friend:ApplyFriend"

RedPointConst.Daily          = "Main:Daily"

RedPointConst.Barracks       = "Main:Barracks"

RedPointConst.Achievement    = "Main:Achievement"

RedPointConst.Chat           = "Main:Chat"

RedPointConst.UAV            = "Main:UAV"
