--[[
								AccountService
     A Profile Data saving service with session locking and session backups.
		Authors:
		@realbxnnie : Creating the module
	
	// 03/16/2025
]]

------------------------------------------------------------------------------

local function assert(c: any, m: string)
	if not c then
		error(m, 1)
	end
end

local Account = {
	Blocked = false,
	Data = {}
}

local AccountService = {
	
} 

local AccountStore = {
	__name = "",
	__datastore = nil,
	__backupDatastore = nil,
	
	AccountDataTemplate = {},
	Accounts = {}
}

local DataStoreService = game:GetService("DataStoreService")

AccountStore.__index = AccountStore
Account.__index = Account


-- <strong>Sets Account's Data.</strong>
-- Example:
-- <code>AccountStore:SetAccountAsync(Player.UserId, {Coins = 100})</code>
function AccountStore:SetAccountAsync(Key: any, Value: any): any
	assert(not self.Accounts[Key].Blocked, "Attempt to set a value to a blocked Session")
	return self.__datastore:SetAsync(Key, Value)
end

-- <strong>Updates Account's Data.</strong>
-- Example:
-- <code>AccountStore:UpdateAccountAsync(Player.UserId, {Coins = 100})</code>
function AccountStore:UpdateAccountAsync(Key: any, Data: {}): any
	assert(not self.Accounts[Key].Blocked, "Attempt to update the value of a blocked Session")
	return self.__datastore:UpdateAsync(Key, function()
		return Data
	end)
end

-- <strong>Saves Account's Data.</strong>
-- Example:
-- <code>AccountStore:SaveAccountAsync(Player.UserId)</code>
function AccountStore:SaveAccountAsync(Key: any): any
	assert(not self.Accounts[Key].Blocked, "Attempt to save the value of a blocked Session")
	return self.__datastore:SetAsync(Key, self.Accounts[Key].Data)
end

-- <strong>Adds Account's Data to the AccountStore.</strong>
-- Example:
-- <code>AccountStore:AddAccountAsync(Player.UserId)</code>
function AccountStore:AddAccountAsync(Key: any): any
	if not self.__datastore:GetAsync(Key) then
		self.__datastore:SetAsync(Key, self.AccountDataTemplate)
		self.Accounts[Key] = {
			Blocked = false,
			Data = self.__datastore:GetAsync(Key)
		}
	else
		self.Accounts[Key] = {
			Blocked = false,
			Data = self.__datastore:GetAsync(Key)
		} 
		for Index, Value in ipairs(self.AccountDataTemplate) do
			if not self.Accounts[Key][Index] then
				self.Accounts[Key][Index] = Value
			end
		end
	end
end

-- <strong>Blocks Account's Session.</strong>
-- Example:
-- <code>AccountStore:BlockAccountSessionAsync(Player.UserId)</code>
function AccountStore:BlockAccountSessionAsync(Key: any, Callback: (any) -> any): boolean
	assert(not self.Accounts[Key].Blocked, "Attempt to block an already blocked Session")
	self.Accounts[Key].Blocked = true
	return self.Accounts[Key].Blocked
end

-- <strong>Unlocks Account's Session.</strong>
-- Example:
-- <code>AccountStore:BlockAccountSessionAsync(Player.UserId)</code>
function AccountStore:UnblockAccountSessionAsync(Key: any, Callback: (any) -> any): boolean
	assert(not self.Accounts[Key].Blocked, "Attempt to unblock an already unblocked Session")
	self.Accounts[Key].Blocked = false
	return not self.Accounts[Key].Blocked
end

-- <strong>Restores Account's Session using last-saved backup.</strong>
-- Example:
-- <code>AccountStore:RestoreAccountSessionAsync(Player.UserId)</code>
function AccountStore:RestoreAccountSessionAsync(Key: any): any
	assert(self.__backupDatastore:GetAsync(Key), `{Key} backup is empty!`)
	do
		local BackupData = {}
		for Index, Value in self.__backupDatastore:GetAsync(Key) do
			BackupData[Index] = Value
		end
		self.__datastore:SetAsync(Key, BackupData)
		self.Accounts[Key].Data = BackupData
	end
end

-- <strong>Saves Account's Session.</strong>
-- Example:
-- <code>AccountStore:SaveAccountSessionAsync(Player.UserId)</code>
function AccountStore:SaveAccountSessionAsync(Key: any)
	self.__backupDatastore:SetAsync(Key, self.Accounts[Key].Data)
end


-- <strong>Creates a new AccountStore.</strong>
-- Example:
-- <code>local AccountStore = AccountService.new("Data1", {Coins = 0})</code>
-- <code>game.Players.PlayerAdded:Connect(function(Player)</code>
-- <code>local Data = AccountStore:AddAccountAsync(Player.UserId)</code>
function AccountService.new(AccountStoreName: string, AccountDataTemplate: {})
	local self = setmetatable({}, AccountStore)
	
	do
		self.__name = AccountStoreName
		self.__datastore = DataStoreService:GetDataStore(self.__name)
		self.__backupDatastore = DataStoreService:GetDataStore(`{self.__name}_BACKUP`)
		self.AccountDataTemplate = AccountDataTemplate
	end

	return self
end


return table.freeze(AccountService) 
