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
    case "Mutation": return ShopifyAPI.Objects.Mutation
    case "CustomerAddressCreatePayload": return ShopifyAPI.Objects.CustomerAddressCreatePayload
    case "MailingAddress": return ShopifyAPI.Objects.MailingAddress
    case "AppliedGiftCard": return ShopifyAPI.Objects.AppliedGiftCard
    case "Article": return ShopifyAPI.Objects.Article
    case "Blog": return ShopifyAPI.Objects.Blog
    case "Collection": return ShopifyAPI.Objects.Collection
    case "Page": return ShopifyAPI.Objects.Page
    case "Product": return ShopifyAPI.Objects.Product
    case "SearchQuerySuggestion": return ShopifyAPI.Objects.SearchQuerySuggestion
    case "Metaobject": return ShopifyAPI.Objects.Metaobject
    case "Cart": return ShopifyAPI.Objects.Cart
    case "Company": return ShopifyAPI.Objects.Company
    case "CompanyLocation": return ShopifyAPI.Objects.CompanyLocation
    case "Customer": return ShopifyAPI.Objects.Customer
    case "Location": return ShopifyAPI.Objects.Location
    case "Market": return ShopifyAPI.Objects.Market
    case "Order": return ShopifyAPI.Objects.Order
    case "ProductVariant": return ShopifyAPI.Objects.ProductVariant
    case "SellingPlan": return ShopifyAPI.Objects.SellingPlan
    case "Shop": return ShopifyAPI.Objects.Shop
    case "CartLine": return ShopifyAPI.Objects.CartLine
    case "ComponentizableCartLine": return ShopifyAPI.Objects.ComponentizableCartLine
    case "Comment": return ShopifyAPI.Objects.Comment
    case "CompanyContact": return ShopifyAPI.Objects.CompanyContact
    case "ExternalVideo": return ShopifyAPI.Objects.ExternalVideo
    case "MediaImage": return ShopifyAPI.Objects.MediaImage
    case "Model3d": return ShopifyAPI.Objects.Model3d
    case "Video": return ShopifyAPI.Objects.Video
    case "GenericFile": return ShopifyAPI.Objects.GenericFile
    case "MediaPresentation": return ShopifyAPI.Objects.MediaPresentation
    case "Menu": return ShopifyAPI.Objects.Menu
    case "MenuItem": return ShopifyAPI.Objects.MenuItem
    case "Metafield": return ShopifyAPI.Objects.Metafield
    case "ProductOption": return ShopifyAPI.Objects.ProductOption
    case "ProductOptionValue": return ShopifyAPI.Objects.ProductOptionValue
    case "ShopPayInstallmentsFinancingPlan": return ShopifyAPI.Objects.ShopPayInstallmentsFinancingPlan
    case "ShopPayInstallmentsFinancingPlanTerm": return ShopifyAPI.Objects.ShopPayInstallmentsFinancingPlanTerm
    case "ShopPayInstallmentsProductVariantPricing": return ShopifyAPI.Objects.ShopPayInstallmentsProductVariantPricing
    case "ShopPolicy": return ShopifyAPI.Objects.ShopPolicy
    case "TaxonomyCategory": return ShopifyAPI.Objects.TaxonomyCategory
    case "UrlRedirect": return ShopifyAPI.Objects.UrlRedirect
    case "CustomerUserError": return ShopifyAPI.Objects.CustomerUserError
    case "CartUserError": return ShopifyAPI.Objects.CartUserError
    case "MetafieldDeleteUserError": return ShopifyAPI.Objects.MetafieldDeleteUserError
    case "MetafieldsSetUserError": return ShopifyAPI.Objects.MetafieldsSetUserError
    case "UserError": return ShopifyAPI.Objects.UserError
    case "UserErrorsShopPayPaymentRequestSessionUserErrors": return ShopifyAPI.Objects.UserErrorsShopPayPaymentRequestSessionUserErrors
    case "CustomerAddressDeletePayload": return ShopifyAPI.Objects.CustomerAddressDeletePayload
    case "CustomerAddressUpdatePayload": return ShopifyAPI.Objects.CustomerAddressUpdatePayload
    case "QueryRoot": return ShopifyAPI.Objects.QueryRoot
    case "MailingAddressConnection": return ShopifyAPI.Objects.MailingAddressConnection
    case "MailingAddressEdge": return ShopifyAPI.Objects.MailingAddressEdge
    case "BaseCartLineConnection": return ShopifyAPI.Objects.BaseCartLineConnection
    case "BaseCartLineEdge": return ShopifyAPI.Objects.BaseCartLineEdge
    case "MoneyV2": return ShopifyAPI.Objects.MoneyV2
    case "Image": return ShopifyAPI.Objects.Image
    case "CartLineCost": return ShopifyAPI.Objects.CartLineCost
    case "CartCost": return ShopifyAPI.Objects.CartCost
    case "CartDiscountCode": return ShopifyAPI.Objects.CartDiscountCode
    case "CartCreatePayload": return ShopifyAPI.Objects.CartCreatePayload
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
