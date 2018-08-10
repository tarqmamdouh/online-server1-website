require'SQL'
class RankingController < ApplicationController
  def uniques
    @DB= SQL.connect_shard
    @ranking = @DB.fetch("SELECT  CharName16, Points FROM [_Char] INNER JOIN Ranking_UniquePoints ON [_Char].CharID = Ranking_UniquePoints.CharID ORDER BY Points DESC;").all.first(50)
  end
end