// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetCartQuery: GraphQLQuery {
  public static let operationName: String = "GetCart"
  public static let document: ApolloAPI.DocumentType = .notPersisted(
    definition: .init(
      #"""
      query GetCart($cartId: ID!) {
        cart(id: $cartId) {
          __typename
          ...CartFields
        }
      }
      """#,
      fragments: [CartFields.self, CartLineFields.self, MoneyFields.self]
    ))

  public var cartId: ID

  public init(cartId: ID) {
    self.cartId = cartId
  }

  public var __variables: Variables? { ["cartId": cartId] }

  public struct Data: ShopifyAPI.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.QueryRoot }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("cart", Cart?.self, arguments: ["id": .variable("cartId")]),
    ] }

    /// Returns a [`Cart`](https://shopify.dev/docs/api/storefront/current/objects/Cart) by its ID. The cart contains the merchandise lines a buyer intends to purchase, along with estimated costs, applied discounts, gift cards, and delivery options.
    ///
    /// Use the [`checkoutUrl`](https://shopify.dev/docs/api/storefront/latest/queries/cart#returns-Cart.fields.checkoutUrl) field to redirect buyers to Shopify's web checkout when they're ready to complete their purchase. For more information, refer to [Manage a cart with the Storefront API](https://shopify.dev/docs/storefronts/headless/building-with-the-storefront-api/cart/manage).
    ///
    public var cart: Cart? { __data["cart"] }

    /// Cart
    ///
    /// Parent Type: `Cart`
    public struct Cart: ShopifyAPI.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Cart }
      public static var __selections: [ApolloAPI.Selection] { [
        .fragment(CartFields.self),
      ] }

      /// A globally-unique ID.
      public var id: ShopifyAPI.ID { __data["id"] }
      /// The total number of items in the cart.
      public var totalQuantity: Int { __data["totalQuantity"] }
      /// A list of lines containing information about the items the customer intends to purchase.
      public var lines: CartFields.Lines { __data["lines"] }
      /// The estimated costs that the buyer will pay at checkout. The costs are subject to change and changes will be reflected at checkout. The `cost` field uses the `buyerIdentity` field to determine [international pricing](https://shopify.dev/custom-storefronts/internationalization/international-pricing).
      public var cost: CartFields.Cost { __data["cost"] }
      /// The case-insensitive discount codes that the customer added at checkout.
      public var discountCodes: [CartFields.DiscountCode] { __data["discountCodes"] }
      /// The URL of the checkout for the cart.
      public var checkoutUrl: ShopifyAPI.URL { __data["checkoutUrl"] }

      public struct Fragments: FragmentContainer {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public var cartFields: CartFields { _toFragment() }
      }
    }
  }
}
