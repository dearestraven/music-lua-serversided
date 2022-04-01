local MODE = "cycle"

local MarketplaceService = game:GetService("MarketplaceService")

local audio = Instance.new("Sound")
audio.Name = "MusicAudio"
audio.Parent = workspace

local remote = game.ReplicatedStorage.MusicEvent

local songs = require(script.Songs)

local rand = Random.new(tick())

local currentIndex = 0

local function pickSong()
	local i

	if MODE == "cycle" then
		if currentIndex == #songs then
			currentIndex = 1
		else
			currentIndex = currentIndex + 1
		end

		i = currentIndex
	else
		i = rand:NextInteger(1, #songs)
	end


	return songs[i]
end

local nowPlaying = ""

local function getSongName(id)
	local data = MarketplaceService:GetProductInfo(id)

	nowPlaying = data.Name	

	return data.Name
end

remote.OnServerEvent:Connect(function(plr)
	remote:FireClient(plr, nowPlaying)
end)

while true do
	local song = pickSong()	

	print("Now Playing:", song)

	remote:FireAllClients(getSongName(song))

	audio.SoundId = "rbxassetid://" .. song
	audio.TimePosition=0
	audio:Play()

	audio.Ended:Wait()
	
	wait(2)

	audio:Stop()
end