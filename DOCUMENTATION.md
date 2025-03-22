# AccountService
**DOCUMENTATION**

***AccountService***\
`.new(AccountStoreName: string, DataTemplate: {any}): AccountStore` *function*\
| Creates a new AccountStore with the provided AccountStore name and with the provided Data Template.\
| Example:
```luau
local DataTemplate = {
Coins = 0,
Diamonds = 0,
Inventory = {
   Pets = {}
}

local Store = AccountService.new("GameData", DataTemplate)
```




***AccountStore***\
`AccountStore:AddAccountAsync(Key: any): nil` *method*\
| Adds the provided **Key** to the AccountStore.\
| Example:
```luau
game.Players.PlayerAdded:Connect(function(Player)
     AccountStore:AddAccountAsync(Player.UserId)
     print(AccountStore.Accounts[Player.UserId))
end)
```



`AccountStore:SaveAccountAsync(Key: any): nil` *method*\
| Saves the provided **Key**'s Value to the DataStore (not affiliated with AccountStore).\
| Example:
```luau
game.Players.PlayerRemoving:Connect(function(Player)
     AccountStore:SaveAccountAsync(Player.UserId)
end)
```



`AccountStore:SetAccountAsync(Key: any, Value: any): nil` *method*\
| Sets the provided **Key**'s Value to the provided **Value**.\
| Example:
```luau
function setDiamonds(Player, a)
    AccountStore:UpdateAccountAsync(Player.UserId, {Diamonds = a))
end

setDiamonds(Player, 12345)
```


`AccountStore:UpdateAccountAsync(Key: any, Data: {}): nil` *method*\
> [!WARNING]  
> This method is deprecated and is not recommended for future use. Use `AccountStore:SetAccountAsync(Key: any, Value: any)` instead.


| Updates the provided **Key**'s Value to the provided **Data**.\
| Example:
```luau
function setCoins(Player, a)
    AccountStore:UpdateAccountAsync(Player.UserId, {Coins = a))
end

setCoins(Player, 12345)
```

`AccountStore:BlockAccountSessionAsync(Key: any): boolean` *method*\
| Blocks the provided **Key**'s Session to avoid accidental sets\
| Example:
```luau
function setDiamonds(Player, a)
    AccountStore:UpdateAccountAsync(Player.UserId, {Diamonds = a))
end

AccountStore:BlockAccountSessionAsync(Player.UserId)
setDiamonds(Player, 12345) -- error
```

`AccountStore:UnblockAccountSessionAsync(Key: any): boolean` *method*\
| Unblocks the provided **Key**'s Session\
| Example:
```luau
function setDiamonds(Player, a)
    AccountStore:UpdateAccountAsync(Player.UserId, {Diamonds = a))
end

AccountStore:BlockAccountSessionAsync(Player.UserId)
setDiamonds(Player, 12345) -- error


AccountStore:UnblockAccountSessionAsync(Player.UserId)
setDiamonds(Player, 12345)
```


`AccountStore:SaveAccountSessionAsync(Key: any): nil` *method*\
| Saves the provided **Key**'s Session (also known as session-backup) to avoid data breaks\
| Example:
```luau
function setDiamonds(Player, a)
    AccountStore:UpdateAccountAsync(Player.UserId, {Diamonds = a))
end

setDiamonds(Player, 12345)
AccountStore:SaveAccountSessionAsync(Player.UserId)
```

`AccountStore:RestoreAccountSessionAsync(Key: any): nil` *method*\
| Restores the provided **Key**'s Session (also known as session-backup restore) \
| Example:
```luau
function setDiamonds(Player, a)
    AccountStore:UpdateAccountAsync(Player.UserId, {Diamonds = a))
end

-- (the data of Player is broken)
setDiamonds(Player, 12345) -- error

AccountStore:RestoreAccountSessionAsync(Player.UserId)
setDiamonds(Player, 12345)
```

