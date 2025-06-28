--written by xendatro
local _MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

--REQUIRES EXTEND MODULE
local extend = require(ReplicatedStorage.Modules.extend)

local MarketplaceService = {}

--Automatically types ReceiptInfo for you
export type ReceiptInfo = {
	PurchaseId: number,
	PlayerId: number,
	ProductId: number,
	PlaceId: number,
	CurrencySpent: number,
	CurrencyType: number,
	ProductPurchaseChannel: Enum.ProductPurchaseChannel
}

export type ProductInfo = {
	AssetId: number,
	AssetTypeId: number,
	Created: string,
	Creator: {
		CreatorTargetId: number,
		CreatorType: Enum.CreatorType,
		HasVerifiedBadge: boolean?,
		Name: string,
	},
	DisplayIconImageAssetId: number,
	DisplayName: string,
	IconImageAssetId: number,
	IsForSale: boolean,
	IsLimited: boolean,
	IsLimitedUnique: boolean,
	IsNew: boolean,
	IsPublicDomain: boolean,
	MinimumMembershipLevel: number,
	Name: string,
	PriceInRobux: number,
	ProductId: number,
	ProductType: Enum.InfoType,
	TargetId: number,
	Updated: string,
}

if RunService:IsClient() then
	extend(MarketplaceService, _MarketplaceService)
	return MarketplaceService:: typeof(MarketplaceService) & typeof(_MarketplaceService)
end

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

function MarketplaceService:GetProductInfo(assetId: number, infoType: Enum.InfoType?)
	return _MarketplaceService:GetProductInfo(assetId, infoType):: ProductInfo
end

_MarketplaceService.ProcessReceipt = function(receiptInfo: ReceiptInfo)
	print(Functions, receiptInfo)
	if Functions[receiptInfo.ProductId] then
		return Functions[receiptInfo.ProductId](receiptInfo)
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