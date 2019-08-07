local skynet = require 'skynet'
local cjson = require 'cjson.safe'
local hwtest = require 'hwtest'
local log = require 'utils.log'

skynet.start(function()
	local runner = hwtest:new('thingslink', 'x1')
	runner:start()
	while true do
		if runner:finished() then
			break
		end
		skynet.sleep(100)
	end

	local result, err = cjson.encode(runner:result())
	if not result then
		os.execute("echo "..(err or "N???").." > /dev/console")
		return
	else
		log.debug(result)

		local f, err = io.open('/tmp/hwtest.result', 'w+')
		if f then
			f:write(result)
			f:close()
		else
			os.execute("echo AAAAAAAAAAAAAAAAAAAAAAAAAAAA > /dev/console")
		end
	end
end)
