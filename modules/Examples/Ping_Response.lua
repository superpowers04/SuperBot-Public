if not supported or not registerEvent then return "Not supported here!" end -- Don't run on bots that don't support this
registerEvent('pingresponse','beforeCommand',function(message) -- Registers an event for "beforeCommand" in the scope pingresponse
	if string.match(message.content,client.user.id) then
		message.channel:send{
			embed = {
				color = embedcolor,
				title = "You can do >>help for my commands!",
				image = {url = "https://i.imgflip.com/3ia3r2.png"},
				footer = {text = "Responding to " .. message.author.name}
			  }} -- Send an embed with https://i.imgflip.com/3ia3r2.png as the image and "You can do >>help for my commands!" as the title
	end
end)
return false -- Tells the bot this doesn't contain any commands