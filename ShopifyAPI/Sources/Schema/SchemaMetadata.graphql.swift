// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public typealias ID = String

public protocol SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == ShopifyAPI.SchemaMetadata {}

public protocol InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == ShopifyAPI.SchemaMetadata {}

public protocol MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == ShopifyAPI.SchemaMetadata {}

public protocol MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == ShopifyAPI.SchemaMetadata {}

public enum SchemaMetadata: ApolloAPI.SchemaMetadata {
  public static let configuration: ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

  public static func objectType(forTypename typename: String) -> Object? {
    switch typename {
    case "QueryRoot": return ShopifyAPI.Objects.QueryRoot
    case "Customer": return ShopifyAPI.Objects.Customer
    case "Article": return ShopifyAPI.Objects.Article
    case "AppliedGiftCard": return ShopifyAPI.Objects.AppliedGiftCard
    case "Blog": return ShopifyAPI.Objects.Blog
    case "Collection": return ShopifyAPI.Objects.Collection
    case "Page": return ShopifyAPI.Objects.Page
    case "Product": return ShopifyAPI.Objects.Product
    case "SearchQuerySuggestion": return ShopifyAPI.Objects.SearchQuerySuggestion
    case "Metaobject": return ShopifyAPI.Objects.Metaobject
    case "Cart": return ShopifyAPI.Objects.Cart
    case "CartLine": return ShopifyAPI.Objects.CartLine
    case "ComponentizableCartLine": return ShopifyAPI.Objects.ComponentizableCartLine
    case "Comment": return ShopifyAPI.Objects.Comment
    case "Company": return ShopifyAPI.Objects.Company
    case "CompanyContact": return ShopifyAPI.Objects.CompanyContact
    case "CompanyLocation": return ShopifyAPI.Objects.CompanyLocation
    case "ExternalVideo": return ShopifyAPI.Objects.ExternalVideo
    case "MediaImage": return ShopifyAPI.Objects.MediaImage
    case "Model3d": return ShopifyAPI.Objects.Model3d
    case "Video": return ShopifyAPI.Objects.Video
    case "GenericFile": return ShopifyAPI.Objects.GenericFile
    case "Location": return ShopifyAPI.Objects.Location
    case "MailingAddress": return ShopifyAPI.Objects.MailingAddress
    case "Market": return ShopifyAPI.Objects.Market
    case "MediaPresentation": return ShopifyAPI.Objects.MediaPresentation
    case "Menu": return ShopifyAPI.Objects.Menu
    case "MenuItem": return ShopifyAPI.Objects.MenuItem
    case "Metafield": return ShopifyAPI.Objects.Metafield
    case "Order": return ShopifyAPI.Objects.Order
    case "ProductOption": return ShopifyAPI.Objects.ProductOption
    case "ProductOptionValue": return ShopifyAPI.Objects.ProductOptionValue
    case "ProductVariant": return ShopifyAPI.Objects.ProductVariant
    case "Shop": return ShopifyAPI.Objects.Shop
    case "ShopPayInstallmentsFinancingPlan": return ShopifyAPI.Objects.ShopPayInstallmentsFinancingPlan
    case "ShopPayInstallmentsFinancingPlanTerm": return ShopifyAPI.Objects.ShopPayInstallmentsFinancingPlanTerm
    case "ShopPayInstallmentsProductVariantPricing": return ShopifyAPI.Objects.ShopPayInstallmentsProductVariantPricing
    case "ShopPolicy": return ShopifyAPI.Objects.ShopPolicy
    case "TaxonomyCategory": return ShopifyAPI.Objects.TaxonomyCategory
    case "UrlRedirect": return ShopifyAPI.Objects.UrlRedirect
    case "SellingPlan": return ShopifyAPI.Objects.SellingPlan
    case "OrderConnection": return ShopifyAPI.Objects.OrderConnection
    case "OrderEdge": return ShopifyAPI.Objects.OrderEdge
    case "MoneyV2": return ShopifyAPI.Objects.MoneyV2
    case "OrderLineItemConnection": return ShopifyAPI.Objects.OrderLineItemConnection
    case "OrderLineItemEdge": return ShopifyAPI.Objects.OrderLineItemEdge
    case "OrderLineItem": return ShopifyAPI.Objects.OrderLineItem
    case "Image": return ShopifyAPI.Objects.Image
    case "Fulfillment": return ShopifyAPI.Objects.Fulfillment
    case "FulfillmentTrackingInfo": return ShopifyAPI.Objects.FulfillmentTrackingInfo
    case "BaseCartLineConnection": return ShopifyAPI.Objects.BaseCartLineConnection
    case "BaseCartLineEdge": return ShopifyAPI.Objects.BaseCartLineEdge
    case "CartLineCost": return ShopifyAPI.Objects.CartLineCost
    case "CartCost": return ShopifyAPI.Objects.CartCost
    case "CartDiscountCode": return ShopifyAPI.Objects.CartDiscountCode
    case "Mutation": return ShopifyAPI.Objects.Mutation
    case "CartCreatePayload": return ShopifyAPI.Objects.CartCreatePayload
    case "CartUserError": return ShopifyAPI.Objects.CartUserError
    case "CustomerUserError": return ShopifyAPI.Objects.CustomerUserError
    case "MetafieldDeleteUserError": return ShopifyAPI.Objects.MetafieldDeleteUserError
    case "MetafieldsSetUserError": return ShopifyAPI.Objects.MetafieldsSetUserError
    case "UserError": return ShopifyAPI.Objects.UserError
    case "UserErrorsShopPayPaymentRequestSessionUserErrors": return ShopifyAPI.Objects.UserErrorsShopPayPaymentRequestSessionUserErrors
    case "CartLinesAddPayload": return ShopifyAPI.Objects.CartLinesAddPayload
    case "CartLinesUpdatePayload": return ShopifyAPI.Objects.CartLinesUpdatePayload
    case "CartLinesRemovePayload": return ShopifyAPI.Objects.CartLinesRemovePayload
    case "CartDiscountCodesUpdatePayload": return ShopifyAPI.Objects.CartDiscountCodesUpdatePayload
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}
