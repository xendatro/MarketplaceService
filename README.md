## MarketplaceService
An extension of Roblox's [MarketplaceService](https://create.roblox.com/docs/reference/engine/classes/MarketplaceService#summary-callbacks) that supports "multiple" callbacks. Autofills for native MarketplaceService as well as its own methods.

I made it so you cannot access the native ProcessReceipt function to prevent any overlap. If you try it will throw an error

## Methods
### :CreateReceipt
#### Parameters:
`productId: number`: the productId to associate the receipt function to
`f` `(receiptInfo: ReceiptInfo) -> Enum.ProductPurchaseDecision`: a function that takes in a processRceipt (acts just like a normal callback). you must return back a ProductPurchaseDecision value. `receiptInfo` is also typed for your convenience. you can get the ReceiptInfo type manually from the module as it is exported.

### :DeleteReceipt
#### Parameters:
`productId: number`: the productId of the function to remove

