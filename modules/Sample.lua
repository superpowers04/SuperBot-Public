if not supported then return "I'm not supported here!" end -- Don't execute on other bots, to prevent undocumented behaivor

registerEvent('Sample','ready',function() client.owner:send("You have the sample module neabled, You should replace it with your own code!") end)
local cmds = {}

cmds['sample'] = {
	info="`{cmdprefix}sample (Text)` a sample command",exec=function(message,args,content)
	message:reply('I am a sample command, You should try making your own modules! https://github.com/SinisterRectus/Discordia/wiki contains a lot of info for getting started!')
end
}
function random(var)
	if type(var) == 'table' then return var[math.floor(math.random(1,table.maxn(var)))] else return math.random(0,1) end
end -- A function that can be used anywhere
return cmds --Returns commands, Change this to false if module doesn't have any commands