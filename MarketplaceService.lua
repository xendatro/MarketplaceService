local _MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--REQUIRES EXTEND MODULE
local extend = require(ReplicatedStorage.Modules.extend)

local MarketplaceService = {}

--Automatically types ReceiptInfo for you
type ReceiptInfo = {
	PurchaseId: number,
	PlayerId: number,
	ProductId: number,
	PlaceId: number,
	CurrencySpent: number,
	CurrencyType: number,
	ProductPurchaseChannel: Enum.ProductPurchaseChannel
}

local Functions = {}

function MarketplaceService:CreateReceipt(productId: number, f: (receiptInfo: ReceiptInfo) -> Enum.ProductPurchaseDecision)
	assert(productId ~= nil, "Argument 1 is nil")
	assert(f ~= nil, "Argument 2 is nil")
	Functions[productId] = f
end

function MarketplaceService:DeleteReceipt(productId: number)
	if Functions[productId] then
		Functions[productId] = nil
	end
end

_MarketplaceService.ProcessReceipt = function(receiptInfo: ReceiptInfo)
	if Functions[receiptInfo.ProductId] then
		return Functions[receiptInfo.ProductId](receiptInfo: ReceiptInfo)
	end
	warn("Product function not found")
	return Enum.ProductPurchaseDecision.NotProcessedYet
end

extend(MarketplaceService, _MarketplaceService)
local metatable = getmetatable(MarketplaceService)
local newindexFunction = metatable.__newindex
metatable.__newindex = function(t, i, v)
	if i == "ProcessReceipt" then
		error("Cannot assign to native ProcessReceipt")
	end
	newindexFunction(t, i, v)
end

local module: typeof(MarketplaceService) & typeof(_MarketplaceService) = MarketplaceService
return module