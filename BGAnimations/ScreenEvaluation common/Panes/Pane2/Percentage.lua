local pn = ...

local mods = SL[ToEnumShortString(pn)].ActiveModifiers
-- No judgement in DoNotJudgeMe mode.
if mods.DoNotJudgeMe then return end

local stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)
local PercentDP = stats:GetPercentDancePoints()
local percent = FormatPercentScore(PercentDP)
-- Format the Percentage string, removing the % symbol
percent = percent:gsub("%%", "")

return Def.ActorFrame{
	Name="PercentageContainer"..ToEnumShortString(pn),
	InitCommand=function(self)
		self:x( -70 )
		self:y( _screen.cy-39 )
	end,

	-- dark background quad behind player percent score
	Def.Quad{
		InitCommand=function(self)
			self:diffuse( color("#101519") )
				:y(-2)
				:zoomto(70, 28)
		end
	},

	LoadFont("Wendy/_wendy white")..{
		Text=percent,
		Name="Percent",
		InitCommand=function(self) self:horizalign(right):zoom(0.25):xy( 30, -2) end,
	}
}
