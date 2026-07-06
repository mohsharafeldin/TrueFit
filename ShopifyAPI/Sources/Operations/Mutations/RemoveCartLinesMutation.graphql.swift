// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class RemoveCartLinesMutation: GraphQLMutation {
  public static let operationName: String = "RemoveCartLines"
  public static let document: ApolloAPI.DocumentType = .notPersisted(
    definition: .init(
      #"""
      mutation RemoveCartLines($cartId: ID!, $lineIds: [ID!]!) {
        cartLinesRemove(cartId: $cartId, lineIds: $lineIds) {
          __typename
          cart {
            __typename
            ...CartFields
          }
          userErrors {
            __typename
            field
            message
            code
          }
        }
      }
      """#,
      fragments: [CartFields.self, CartLineFields.self, MoneyFields.self]
    ))

  public var cartId: ID
  public var lineIds: [ID]

  public init(
    cartId: ID,
    lineIds: [ID]
  ) {
    self.cartId = cartId
    self.lineIds = lineIds
  }

  public var __variables: Variables? { [
    "cartId": cartId,
    "lineIds": lineIds
  ] }

  public struct Data: ShopifyAPI.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("cartLinesRemove", CartLinesRemove?.self, arguments: [
        "cartId": .variable("cartId"),
        "lineIds": .variable("lineIds")
      ]),
    ] }

    /// Removes one or more merchandise lines from a [`Cart`](https://shopify.dev/docs/api/storefront/current/objects/Cart). Accepts up to 250 line IDs per request. Returns the updated cart along with any errors or warnings.
    ///
    public var cartLinesRemove: CartLinesRemove? { __data["cartLinesRemove"] }

    /// CartLinesRemove
    ///
    /// Parent Type: `CartLinesRemovePayload`
    public struct CartLinesRemove: ShopifyAPI.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CartLinesRemovePayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("cart", Cart?.self),
        .field("userErrors", [UserError].self),
      ] }

      /// The updated cart.
      public var cart: Cart? { __data["cart"] }
      /// The list of errors that occurred from executing the mutation.
      public var userErrors: [UserError] { __data["userErrors"] }

      /// CartLinesRemove.Cart
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

      /// CartLinesRemove.UserError
      ///
      /// Parent Type: `CartUserError`
      public struct UserError: ShopifyAPI.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CartUserError }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("field", [String]?.self),
          .field("message", String.self),
          .field("code", GraphQLEnum<ShopifyAPI.CartErrorCode>?.self),
        ] }

        /// The path to the input field that caused the error.
        public var field: [String]? { __data["field"] }
        /// The error message.
        public var message: String { __data["message"] }
        /// The error code.
        public var code: GraphQLEnum<ShopifyAPI.CartErrorCode>? { __data["code"] }
      }
    }
  }
}
