// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class AddCartLinesMutation: GraphQLMutation {
  public static let operationName: String = "AddCartLines"
  public static let document: ApolloAPI.DocumentType = .notPersisted(
    definition: .init(
      #"""
      mutation AddCartLines($cartId: ID!, $lines: [CartLineInput!]!) {
        cartLinesAdd(cartId: $cartId, lines: $lines) {
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
  public var lines: [CartLineInput]

  public init(
    cartId: ID,
    lines: [CartLineInput]
  ) {
    self.cartId = cartId
    self.lines = lines
  }

  public var __variables: Variables? { [
    "cartId": cartId,
    "lines": lines
  ] }

  public struct Data: ShopifyAPI.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("cartLinesAdd", CartLinesAdd?.self, arguments: [
        "cartId": .variable("cartId"),
        "lines": .variable("lines")
      ]),
    ] }

    /// Adds one or more merchandise lines to an existing [`Cart`](https://shopify.dev/docs/api/storefront/current/objects/Cart). Each line specifies the [product variant](https://shopify.dev/docs/api/storefront/current/objects/ProductVariant) to purchase. Quantity defaults to `1` if not provided.
    ///
    /// You can add up to 250 lines in a single request. Use [`CartLineInput`](https://shopify.dev/docs/api/storefront/current/input-objects/CartLineInput) to configure each line's merchandise, quantity, selling plan, custom attributes, and any parent relationships for nested line items such as warranties or add-ons.
    ///
    public var cartLinesAdd: CartLinesAdd? { __data["cartLinesAdd"] }

    /// CartLinesAdd
    ///
    /// Parent Type: `CartLinesAddPayload`
    public struct CartLinesAdd: ShopifyAPI.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CartLinesAddPayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("cart", Cart?.self),
        .field("userErrors", [UserError].self),
      ] }

      /// The updated cart.
      public var cart: Cart? { __data["cart"] }
      /// The list of errors that occurred from executing the mutation.
      public var userErrors: [UserError] { __data["userErrors"] }

      /// CartLinesAdd.Cart
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

      /// CartLinesAdd.UserError
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
