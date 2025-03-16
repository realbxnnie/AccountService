# AccountService
A Simple DataStoreService wrapper with session backups and session locking.

**Why AccountService?**
* Easy to use
* Asynchronous
* Session locking & Session backuping

**Example of use:**
```luau
local AccountService = require("./path/to/accountService")
local Template = { coins = 0 }

local AccountStore = AccountService.new("DataBlahBlahBlah", Template)
game.Players.PlayerAdded:Connect(function(Player)
        AccountStore:AddAccountAsync(Player.UserId)
        local acc = AccountStore.Accounts[Player.UserId]
        
        print(acc)
end)

game.Players.PlayerRemoving:Connect(function(Player)
        AccountStore:SaveAccountAsync(Player.UserId)
end)
```

**Download:**\
[GitHub](https://github.com/realbxnnie/AccountService/releases/latest)\
[Roblox](https://create.roblox.com/store/asset/107747870734588)
