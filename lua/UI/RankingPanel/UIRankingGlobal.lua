UIRankingGlobal = {}

UIRankingGlobal.LeaderBoardType =
{
    AllLeaderBoardType = 0,
    WeeklySimCombatLeaderBoardType = 1,
    NrtPvpLeaderBoardType = 2
}

function UIRankingGlobal:GetColorByRank(rank)
    local color = "ffffff"
    if rank == 1 then
        color = "44b00"
    elseif rank == 2 then
        color = "3a73c1"
    elseif rank == 3 then
        color = "70b05f"
    end
    return CS.GF2.UI.UITool.StringToColor(color)
end
