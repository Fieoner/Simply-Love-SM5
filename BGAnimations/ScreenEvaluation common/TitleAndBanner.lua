local banner = {
	directory = { Hearts="Hearts", Arrows="Arrows" },
	width = 418,
	zoom = 0.5,
}

local title = {
	height = 30,
	zoom = 0.65
}

-- the Quad containing the bpm and music rate doesn't appear in Casual mode
-- so nudge the song title and banner down a bit when in Casual
local y_offset = SL.Global.GameMode=="Casual" and 50 or 46
local banner_y_offset = y_offset + 2.5

local af = Def.ActorFrame{
	InitCommand=function(self) self:xy(_screen.cx, y_offset) end,

	-- quad behind the song/course title text
	Def.Quad{
		InitCommand=function(self) self:diffuse(color("#1E282F")):setsize(banner.width,title.height):zoom(banner.zoom) end,
	},

	-- song/course title text
	LoadFont("_miso")..{
		InitCommand=function(self)
			local songtitle = (GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse():GetDisplayFullTitle()) or GAMESTATE:GetCurrentSong():GetDisplayFullTitle()
			if songtitle then self:settext(songtitle):maxwidth(banner.width*banner.zoom):zoom(title.zoom) end
		end
	}
}

local SongOrCourse = GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse() or GAMESTATE:GetCurrentSong()

if SongOrCourse and SongOrCourse:HasBanner() then
	--song or course banner, if there is one
	af[#af+1] = Def.Banner{
		Name="Banner",
		InitCommand=function(self)
			if GAMESTATE:IsCourseMode() then
				self:LoadFromCourse( GAMESTATE:GetCurrentCourse() )
			else
				self:LoadFromSong( GAMESTATE:GetCurrentSong() )
			end
			self:y(banner_y_offset):setsize(banner.width, 164):zoom(banner.zoom)
		end
	}
else
	--fallback banner
	af[#af+1] = LoadActor( THEME:GetPathB("ScreenSelectMusic", "overlay/colored_banners/" .. (banner.directory[ThemePrefs.Get("VisualTheme")] or "Hearts") .. "/banner" .. SL.Global.ActiveColorIndex .. " (doubleres).png"))..{
		InitCommand=function(self) self:y(banner_y_offset):zoom(banner.zoom) end
	}
end

return af