-- Please don't remove the Credits variable or credits command, Feel free to add yourself to them but don't remove any existing credits.
-- Removing credits is just mean



-- Requires
package.path = package.path .. ";./deps/?.lua;./deps/?/?.lua;./deps/?/init.lua"
package.cpath = package.cpath .. ";./deps/?.so;./deps/?/?.so;./deps/?/init.so"
_G.spawn = require('coro-spawn')
_G.discordia = require('discordia')
_G.client = discordia.Client {
	cacheAllMembers = true
}
discordia.extensions()
_G.http = require('http')
_G.https = require('https')
_G.url = require('url')
_G.fs = require('fs')
_G.uv = require('uv')
_G.re =  require('re')
_G.f = string.format
_G.json = require('json')
_G.base64 = require('base64')
_G.logstemp = {}
_G.embedcolor = discordia.Color.fromRGB(218, 137, 218).value
_G.supported = {functions=true}
_G.commands = {}
_G.commandaliases = {}
_G.globalfooter=function(message) return "Responding to " .. message.author.name end
local filecmds = {builtin={}}
local builtin = filecmds.builtin
builtin['help'] = {
	info="`{prefix}help [command]` to query the info about a command or get the help message",
	exec=function(message,args,content)
		local args = string.gsub(content," <@!?[%d]*>",""):split(" ")
		local mention = ""
		if message.mentionedUsers then
			for k,v in message.mentionedUsers:__pairs() do
				ment = isuserbool(v.id)
				if ment then
					ment = ment.mentionString
					if mention == "" then
						mention = ment
					else
						mention = mention .. ", " .. ment
					end
				end
						
			end
		end
		if args[2] then 
			local commandquery = args[2]
			local query = false
			if commandquery:startswith('?') then 
				query = true
				commandquery = commandquery:sub(2)
			elseif compatcommands[commandquery] then
				cmd = "'" .. commandquery .. "' is a deprecated command, No help available" 
			elseif commands[commandquery] and commands[commandquery].info then
				cmd = commands[commandquery].info
			elseif commands[commandquery] then
				cmd = "'" .. commandquery .. "' doesn't have any help to list" 
			else
				cmd = "'" .. commandquery .. "' doesn't seem to be a valid command" 
			end
			local cmdlist = {}
			if query then 
				for k in pairs(compatcommands) do
					if string.match(k,commandquery) then
						k = string.gsub(k,commandquery,"**" .. commandquery .. "**")
						table.insert(cmdlist,k)
					end
				end		
				for k in pairs(commands) do

					if string.match(k,commandquery) then
						k = string.gsub(k,commandquery,"**" .. commandquery .. "**")
						table.insert(cmdlist,k)
					end
				end
				for i,v in pairs(cmdlist) do
					table.sort(cmdlist, function(a, b) return a < b end)
				end
			end
			local list = (cmdtrigger..table.concat(cmdlist,", " .. cmdtrigger)) or f("No results found for '%s'",commandquery)
			local embed = {
						title = "Help",
						fields = {},
						color = discordia.Color.fromRGB(218, 137, 218).value,
						
						timestamp = discordia.Date():toISO('T', 'Z')
					  }
			if query then 
				table.insert(embed.fields,{name = f("Search for %s:",commandquery),value = list, inline = false})
				embed.footer = {text = "Responding to " .. message.author.name}
			else
				embed.footer = {text = "()'s mean required, []'s mean optional. Responding to " .. message.author.name}
				table.insert(embed.fields,{name = "Info about " .. commandquery,value = string.gsub(cmd,"{prefix}",cmdtrigger), inline = false})
			end

			if mention ~= "" then
				return message.channel:send {
					  content = mention,
					  embed = embed
				}
			else
			 	return message.channel:send {
					  embed = embed
				}	
			end
		end
		messdel(message)
		-- return message.channel:send("Help is broken right now and I need to not throw my keyboard out of a window, It'll be fixed later, Sorry for the inconvenience")

		local embed = {
					title = "Help",
					fields = {},
					color = discordia.Color.fromRGB(218, 137, 218).value,
					footer = {text = "Responding to " .. message.author.name},
					timestamp = discordia.Date():toISO('T', 'Z')
				  }
		for k,v in pairs(filecmds) do
			print(k,v)
			local cmds = ""
			local count = 0
			if type(v) == 'table' then 
				for _ in pairs(v) do
					table.sort(v, function(a, b) return a < b end)
				end
				for i,c in pairs(v) do
					count=count+1
					local cmd = cmdtrigger .. i
					if c.aliases then 

						for _,alias in ipairs(c.aliases) do
							cmd = cmd .. "/" .. cmdtrigger .. alias
						end
					end
					if cmds == "" then
						cmds = cmd
					else
						cmds = cmds .. ", " .. cmd
					end
				end
			end
			if cmds and cmds ~= "" then table.insert(embed.fields,{name=f("%s(%s)",k,count),value=cmds,count=count,inline=true}) end

			
		end
		for _ in pairs(embed.fields) do
			table.sort(embed.fields, function(a, b) return a.count < b.count end)
		end
		local oldcmds = {}
		table.insert(embed.fields,1,{name = "Info",value = cfg.botinfo, inline = false})
		for k in pairs(compatcommands) do
			table.insert(oldcmds,k)
		end	
		if oldcmds[1] then
			for _ in pairs(oldcmds) do
				table.sort(oldcmds, function(a, b) return a < b end)
			end
			table.insert(embed.fields,{name='Old commands',value=cmdtrigger .. table.concat(oldcmds,", " .. cmdtrigger),inline=true})
		end
		if mention ~= "" then		return message.channel:send {
						  content = mention,
						  embed = embed
					}	 else 		return message.channel:send {
						  embed = embed
					}	 
			end
		end
}
builtin['credits'] = {
	info="`{prefix}credits` Lists the credits",
	exec=function(message,args,content)
		if not credits then return sendembed(message,'Credits',client.owner.name .." removed the credits but didn't remove the command!\n<@267737465152864256> - `Creator`\nRaVen - `Original bot/Idea`\n<https://lua.org> - `Programming Language used for this bot`\n<https://luvit.io/> - `Fork of lua used that adds node-like functions for IO and Web`\n<https://github.com/SinisterRectus/Discordia> - `API/Library used to create this`\n") end
		return sendembed(message,'Credits',credits)
	end
}
_G.compatcommands = {}


_G.credits = "<@267737465152864256> - `Creator`\n<https://github.com/superpowers04/SuperBot-Public> - Github\nRaVen - `Original bot/Idea`\n<https://lua.org> - `Programming Language used for this bot`\n<https://luvit.io/> - `Fork of lua used that adds node-like functions for IO and Web`\n<https://github.com/SinisterRectus/Discordia> - `API/Library used to create this`\n"
_G.registeredfuncs = {}
if not io.open('bot.cfg') then 
	local config = io.open('bot.cfg','w')
	config:write([[{
	"version" : 1.4,
	"admins" : ["ADMINID"],
	"objects" : ["macbook","notification","xkcd comic","book","stapler","notebook","suspicious book named 'rule34'","toaster","microwave","phone","dog","cat","car","dishwasher","computer","Commodore 64","NES","Xbox","Playstation","Nintendo Switch","laptop","Windows install CD","power button","unknown object","random girl","random guy","outfit","man","woman","keyboard","mouse","bottle","flatscreen","TV","video game case","gun","pill bottle","discord logo","sun","moon","earth","planet","icon","seeker","jellyfish","keycap"],
	"cmdtrigger" : "<>",
	"token" : "TOKEN",
	"dir" : "BOT DIRECTORY",
	"botinfo" : "I am a bot created by Superpowers04, Directed towards minecraft helpers.\n/ specifies a alternate version of a command, for example >>hjt/checkhjt means that hjt corrasponds to both `>>hjt` and `>>checkhjt`\n You can find a Trello list here: https://trello.com/b/WXKhkplB\n Due to discord's message size limit, command info/use has been moved to `help (Command)`",
	"mcstatuses" : [
		"authserver.mojang.com",
		"sessionserver.mojang.com",
		"launchermeta.mojang.com",
		"piston-meta.mojang.com",
		"mojang.com",
		"minecraft.net",
		"textures.minecraft.net",
		"auth.xboxlive.com","account.mojang.com"],
	"votingchannels" : ["796109386715758652","804023704459018280","812510158152007720"],
	"serverroles" : {
		"GUILDID" : {
			"Rolename":"ROLEID","Rolename":"ROLEID"
		}
	},
	"mcguilds" : ["GUILD1ID","GUILD2ID"],
	"servers" : {
		"GUILDID":{"muted":"CHANNELID","join":"CHANNELID","loggingchannel":"CHANNELID","name":"Custom name for server"},
	}
}]])
	config:close()
	print('Bot.cfg was missing, New file generated. You need to modify this file to use this bot.\nPress enter to exit.')
	io.read()
	error('Bot.cfg Missing!')
end


-- Core functions

function table.count(tbl)
	local count = 0
	if tbl and type(tbl) == 'table' then 
		for _ in pairs(tbl) do
			count = count + 1
		end
	else
		error('Not a valid table!')
	end
	return count
end

function loadjsonfile(file)
	if not file or not type(file) == "string" then 
		error("File name is nil or not a string!")
		return false
	end 
	local jsonfile,err = io.open(file,'r')
	if not jsonfile then
		print(err)
		return false
	end
	str = jsonfile:read("*a")
	if not str or str == "" then
		print(jsonfile .." is empty!")
		return false		
	end
	parsedjson = json.parse(str)
	jsonfile:close()
	if not parsedjson then
		print("Unable to parse " .. tostring(str))
		return false
	end
	return parsedjson
end
function savejsonfile(file,contents)
	if not contents then 
		print("No contents to write!")
		return false, "No contents to write!" end

	local jsonfile = io.open(file,'w')
	if not jsonfile then print("Invalid file '" .. file .. "', but writing anyways!") end
	if type(contents) ~= 'string' then
		if type(contents) == 'table' then
			local contentsstring = contents
			contents,err = json.encode(contents)
			if not contents then 
				print("Unable to parse " .. tostring(contentsstring))
				return false, "Unable to parse JSON, this should not happen!"
			end
		else
			print("Invalid type!")
			return false 
		end
	end
	jsonfile:write(contents)
	jsonfile:close()
	return true
end
function hasperms(message)
	print("Checking perms for " .. message.author.name .. "!")
	-- return true
	local args = message.content:split(" ")
	if message.channel then
		if string.match(args[1],"tag") and message.channel.id == "658292552411381760" then
			return true
		end
	end
	if message.author then
		if not hasadmin(message.author.id) then
			-- message.channel:send("You don't have perms for this!")
			if message.addReaction then
				message:addReaction("❓")
			end
			return false
		else
			return true
		end	
	else
		print("Message author could not be found, This shouldn't happen!")
		message.channel:send("Something that shouldn't of happened happened. Please report this to superpowers04")
		return false
	end
end
function Errorhandler(message, runtimeError)
	print(runtimeError)
	local function filter(str)
		str = string.gsub(str,"/matt/","/super/")
		return string.gsub(str," matt"," super")
	end
	runtimeErrorfilt = filter(runtimeError,"matt","super")
	lasterror = runtimeErrorfilt
	if message ~= nil then
		local mess = f("Error has been logged, Please let Superpowers04 know about this: ```%s```",runtimeErrorfilt)
		
		pcall(function() message.channel:send(mess) end)
	end
	-- if not runtimeError:startswith('/') then runtimeError = '/' .. runtimeError end

	client.owner:send(string.gsub(runtimeError,"matt","super"))
end
function hasadmin(id)
	print("Checking perms for " .. id .. "!")
	if id == "123456789123456789123456789" then return false end 
	if id == client.owner.id or cfg.admins[id]then
		print("Has perms for command!")
		return true
	else
		print("Doesn't have perms for command")
		return false
	end
end
function registerEvent(scope,event,func)
	if not scope then error('No scope specified!') end
	if not event then error('No event specified!') end
	if not func then error('No function to run on ' .. event .. '!') end
	if type(scope) ~= 'string' then error("Scope isn't a string!") end
	if type(event) ~= 'string'then error("Event isn't a string!") end
	if type(func) ~= 'function' then error("Func isn't a function!") end
	if registeredfuncs[scope] and registeredfuncs[scope][event] then
		registeredfuncs[scope][event] = {exec=func}
		print(f('Modified event %q in scope %q',event,scope))
	else
		if not registeredfuncs[scope] then registeredfuncs[scope] = {} end
		registeredfuncs[scope][event] = {exec=func}
		client:on(event,registeredfuncs[scope][event].exec)
		print(f('Registered event %q in scope %q',event,scope))
	end
end
function loadmodules(mod)
	if not io.open('./modules/') then return "No modules folder to load!" end
	local loadmod = function(k,v) 
		if string.match(v,'.+%.lua') then
			local name = string.gsub(v,'%.lua','')
			if (file and name == file) or not file then
				v = './modules/' .. v
				print('Loading ' .. v)
				success,err = pcall(function() 
					_G.cmdfunctions,_G.cmdaliases,_G.helpinfo = {},{},{}
					filecmds[name] = dofile(v) or false
					if istable(_G.cmdfunctions) then
						for nam,cm in pairs(cmdfunctions) do
							compatcommands[nam] = cm
						end
					end
					if istable(_G.cmdaliases) then
						for nam,cm in pairs(_G.cmdaliases) do
							commandaliases[nam] = cm
						end
					end
				end)
				if success then
					retstr = retstr .. ":green_square:Reloaded " .. name .. "\n"
				else
					loaderr = true
					retstr = retstr .. ":red_square: Unable to reload " .. v .. "! ```" .. err .. "```\n"
				end
			end
		end
	end
	if not mod then 
		local modules = fs.readdirSync('./modules/')
		for k,v in pairs(modules) do
			loadmod(k,v)
		end
	else
		if string.sub(mod,-4) ~= ".lua" then mod = mod .. '.lua' end
		if not io.open('./modules/' .. mod) then 
			retstr = retstr ..  ":red_square: Unable to reload " .. mod .. "! Invalid module!\n"
		else
			loadmod(nil,mod)
		end
	end
	_G.cmdfunctions,_G.cmdaliases,_G.helpinfo = nil,nil,nil
	return table.count(filecmds)
end
function istable(tabl)
	if not tabl then return false end
	if type(tabl) ~= 'table' then return false end
	if tabl[1] then return true end
	for k,v in pairs(tabl) do
		return true
	end
	return false
end
function tocommands()
	for index,list in pairs(filecmds) do
		if type(list) == 'table' then 
			for i,v in pairs(list) do 
				commands[i] = v
				if v.aliases then
					print(f('Registering aliases from %s',i))
					for _,from in pairs(v.aliases) do
						commandaliases[from] = i
					end
				end
			end
		end
	end
end
function reload(file)
	print("Loading config..")
	for k,v in pairs(getfenv()) do
		if not _G[k] then _G[k] = v end
	end	
	-- local cfgfile = io.open("bot.cfg")
	_G.cfg = loadjsonfile("bot.cfg")
	if not cfg then
		error("No config found!")
	end
	cfg.moderatedservers = cfg.servers
	-- cfgfile:close()
	cmdtrigger = cfg.cmdtrigger
	cfg.words = loadjsonfile("words.json")
	cfg.names = loadjsonfile("names.json")
	cfg.votingchannels = convswitch(cfg.votingchannels)

	loaderr = false

	retstr = "Reloaded config!\n"
	compatcommands = {}
	local count = loadmodules(file)
	tocommands()
	return f("%s Loaded %s modules!",retstr,count)
end
function convswitch(array)
	local convertedarray = {}
	for i,v in ipairs(array) do
		convertedarray[v] = true
	end
	return convertedarray
end
function exec(cmd)
		local returned = assert(io.popen(cmd, 'r')) 
		local output = returned:read('*a')
		returned:close()
		return output
end
function curl(url)
	if not string.find(url," ") and not string.find(url,"'") then 
		url = "'" .. url .. "'"
	end
	local returned = assert(io.popen("curl -s " .. url, 'r')) 
	local output = returned:read('*a')
	returned:close()
	return output
end
function messdel(message)
	if message.guild ~= nil and message.channel.id ~= "658292552411381760" and message.delete then
		message:delete()
	end
end
print(reload())

client:once('ready', function() 
	starttime = os.time(os.date("!*t"))
end)
client:on('ready', function()
	print('Logged in as '.. client.user.username)
	local date = string.gsub(os.date("%x.%H.%M"),"/","-")
	client:setGame("As a bot, '" .. cmdtrigger .. "help' for help, I work in DM's too!")
	client.owner:send("Reconnected/Ready!")
end)
client:on('messageCreate', function(message)


	-- Stop and Restart, Hardcoded using if statements to prevent broken variables from breaking
	if message.content == cmdtrigger .. "stop" and hasperms(message) then
		message.channel:send("Stopping!")
		print("Error is expected")
		error("Exiting..")
	elseif message.content == cmdtrigger .. "restart" and hasperms(message) then
		messdel(message)

		message.channel:send("Restarting!")
		local child = assert(spawn("luvit", {
		args = {cfg.dir .. "/bot.lua"},
		stdio = {nil, 1, 1}}))
		print("Error is expected")
		os.exit()
	end


	local proc = coroutine.create(function()
		local success, runtimeError = pcall(function()
			local chatmessage = "[" .. os.date("%H:%M") .. " - " .. message.channel.id .. "(#" .. message.channel.name .. ")] " .. message.author.name .. " : " .. message.content
			if message.channel.nsfw then chatmessage = "[NSFW]".. chatmessage end
			if message.attachment then
				chatmessage = chatmessage .. " [Attachment : " .. message.attachment.url .. " ]"
			end

			-- Error command, Hardcoded using if statements to prevent broken variables from breaking
			if string.lower(message.content) == cmdtrigger .. "error" and hasperms(message) then
				message.channel:send("Doing le error")
				print("Error is expected")
				error("Fake error")
			end

			print(chatmessage)
			local args = message.content:split(' ') 
			client:emit('beforeCommand',message,args)
			-- Reload, Hardcoded using if statements to prevent broken variables from breaking
			if string.lower(args[1]) == cmdtrigger .. "reload" and hasperms(message) then
				local mess = message.channel:send {embed = {
				title = "Reloading",
				color = discordia.Color.fromRGB(218, 137, 218).value,
				footer = {text = "Responding to " .. message.author.name},
				timestamp = discordia.Date():toISO('T', 'Z')
			  }}
				print("Reloading!")
				local ret = reload(args[2])
				return mess:update{embed = {
				title = "Reload results:",
				description=ret,
				color = discordia.Color.fromRGB(218, 137, 218).value,
				footer = {text = "Responding to " .. message.author.name},
				timestamp = discordia.Date():toISO('T', 'Z')
			  }}
			end

			if (message.author ~= client.user) then
				if string.sub(args[1],1,string.len(cmdtrigger)) == cmdtrigger then
					args[1] = string.lower(args[1])
					local cmd = string.sub(args[1],string.len(cmdtrigger) + 1)
					if commandaliases[cmd] then
						args[1] = cmdtrigger .. commandaliases[cmd]
						cmd = commandaliases[cmd]
					end
					if commands[cmd] then
						print("Command registered")
						if commands[cmd].guildreq then
							if not message.guild or not cfg.servers[message.guild.id] or not cfg.servers[message.guild.id][commands[cmd].guildreq] then
								return message.reply and message:reply('This command cannot be run here!') or message.channel:send('This command cannot be run here!')
							end
						end
						if not commands[cmd].exec then return message.channel:send(f('Command does not have an exec! Please contact %s!',client.owner.name)) end
						return commands[cmd].exec(message,args,message.content)
					end				
					if compatcommands[cmd] then
						print("Command registered")
						for k in pairs(cfg) do
							_G[k] = cfg[k] 
						end
						_G.cmdfunctions = compatcommands
						compatcommands[cmd](message,args,message.content,message.channel.name)
						for k in pairs(cfg) do
							_G[k] = nil
						end
						_G.cmdfunctions = nil
						return
					end
					if message.addReaction then
						message:addReaction("❓")
					end
				elseif message.channel.name == message.author.name and message.channel == message.author:getPrivateChannel() and respondmess then
					respondmess(message,args)
				end
			end
		end)
	if not success then 
		local success2, runtimeError2 =  Errorhandler(message, runtimeError)
	return end
end)
	coroutine.resume(proc)
	end)
if not cfg.token or cfg.token == "" or cfg.token == "PUT TOKEN HERE" then
	error("Invalid token specified in config!")
end


client:run('Bot ' .. cfg.token)