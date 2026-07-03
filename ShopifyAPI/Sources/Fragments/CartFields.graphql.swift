// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct CartFields: ShopifyAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString { """
    fragment CartFields on Cart {
      __typename
      id
      totalQuantity
      lines(first: 50) {
        __typename
        edges {
          __typename
          node {
            __typename
            ...CartLineFields
          }
        }
      }
      cost {
        __typename
        subtotalAmount {
          __typename
          ...MoneyFields
        }
        totalAmount {
          __typename
          ...MoneyFields
        }
        totalTaxAmount {
          __typename
          ...MoneyFields
        }
      }
      discountCodes {
        __typename
        code
        applicable
      }
      checkoutUrl
    }
    """ }

  public let __data: DataDict
  public init(data: DataDict) { __data = data }

  public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Cart }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("id", ShopifyAPI.ID.self),
    .field("totalQuantity", Int.self),
    .field("lines", Lines.self, arguments: ["first": 50]),
    .field("cost", Cost.self),
    .field("discountCodes", [DiscountCode].self),
    .field("checkoutUrl", ShopifyAPI.URL.self),
  ] }

  /// A globally-unique ID.
  public var id: ShopifyAPI.ID { __data["id"] }
  /// The total number of items in the cart.
  public var totalQuantity: Int { __data["totalQuantity"] }
  /// A list of lines containing information about the items the customer intends to purchase.
  public var lines: Lines { __data["lines"] }
  /// The estimated costs that the buyer will pay at checkout. The costs are subject to change and changes will be reflected at checkout. The `cost` field uses the `buyerIdentity` field to determine [international pricing](https://shopify.dev/custom-storefronts/internationalization/international-pricing).
  public var cost: Cost { __data["cost"] }
  /// The case-insensitive discount codes that the customer added at checkout.
  public var discountCodes: [DiscountCode] { __data["discountCodes"] }
  /// The URL of the checkout for the cart.
  public var checkoutUrl: ShopifyAPI.URL { __data["checkoutUrl"] }

  /// Lines
  ///
  /// Parent Type: `BaseCartLineConnection`
  public struct Lines: ShopifyAPI.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.BaseCartLineConnection }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("edges", [Edge].self),
    ] }

    /// A list of edges.
    public var edges: [Edge] { __data["edges"] }

    /// Lines.Edge
    ///
    /// Parent Type: `BaseCartLineEdge`
    public struct Edge: ShopifyAPI.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.BaseCartLineEdge }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("node", Node.self),
      ] }

      /// The item at the end of BaseCartLineEdge.
      public var node: Node { __data["node"] }

      /// Lines.Edge.Node
      ///
      /// Parent Type: `BaseCartLine`
      public struct Node: ShopifyAPI.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Interfaces.BaseCartLine }
        public static var __selections: [ApolloAPI.Selection] { [
          .inlineFragment(AsCartLine.self),
        ] }

        public var asCartLine: AsCartLine? { _asInlineFragment() }

        /// Lines.Edge.Node.AsCartLine
        ///
        /// Parent Type: `CartLine`
        public struct AsCartLine: ShopifyAPI.InlineFragment {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CartLine }
          public static var __selections: [ApolloAPI.Selection] { [
            .fragment(CartLineFields.self),
          ] }

          /// A globally-unique ID.
          public var id: ShopifyAPI.ID { __data["id"] }
          /// The quantity of the merchandise that the customer intends to purchase.
          public var quantity: Int { __data["quantity"] }
          /// The merchandise that the buyer intends to purchase.
          public var merchandise: Merchandise { __data["merchandise"] }
          /// The cost of the merchandise that the buyer will pay for at checkout. The costs are subject to change and changes will be reflected at checkout.
          public var cost: CartLineFields.Cost { __data["cost"] }

          public struct Fragments: FragmentContainer {
            public let __data: DataDict
            public init(data: DataDict) { __data = data }

            public var cartLineFields: CartLineFields { _toFragment() }
          }

          /// Lines.Edge.Node.AsCartLine.Merchandise
          ///
          /// Parent Type: `Merchandise`
          public struct Merchandise: ShopifyAPI.SelectionSet {
            public let __data: DataDict
            public init(data: DataDict) { __data = data }

            public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Unions.Merchandise }

            public var asProductVariant: AsProductVariant? { _asInlineFragment() }

            /// Lines.Edge.Node.AsCartLine.Merchandise.AsProductVariant
            ///
            /// Parent Type: `ProductVariant`
            public struct AsProductVariant: ShopifyAPI.InlineFragment {
              public let __data: DataDict
              public init(data: DataDict) { __data = data }

              public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.ProductVariant }

              /// A globally-unique ID.
              public var id: ShopifyAPI.ID { __data["id"] }
              /// The product variant’s title.
              public var title: String { __data["title"] }
              /// The product variant’s price.
              public var price: Price { __data["price"] }
              /// The compare at price of the variant. This can be used to mark a variant as on sale, when `compareAtPrice` is higher than `price`.
              public var compareAtPrice: CompareAtPrice? { __data["compareAtPrice"] }
              /// The product object that the product variant belongs to.
              public var product: CartLineFields.Merchandise.AsProductVariant.Product { __data["product"] }

              /// Lines.Edge.Node.AsCartLine.Merchandise.AsProductVariant.Price
              ///
              /// Parent Type: `MoneyV2`
              public struct Price: ShopifyAPI.SelectionSet {
                public let __data: DataDict
                public init(data: DataDict) { __data = data }

                public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.MoneyV2 }

                /// Decimal money amount.
                public var amount: ShopifyAPI.Decimal { __data["amount"] }
                /// Currency of the money.
                public var currencyCode: GraphQLEnum<ShopifyAPI.CurrencyCode> { __data["currencyCode"] }

                public struct Fragments: FragmentContainer {
                  public let __data: DataDict
                  public init(data: DataDict) { __data = data }

                  public var moneyFields: MoneyFields { _toFragment() }
                }
              }

              /// Lines.Edge.Node.AsCartLine.Merchandise.AsProductVariant.CompareAtPrice
              ///
              /// Parent Type: `MoneyV2`
              public struct CompareAtPrice: ShopifyAPI.SelectionSet {
                public let __data: DataDict
                public init(data: DataDict) { __data = data }

                public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.MoneyV2 }

                /// Decimal money amount.
                public var amount: ShopifyAPI.Decimal { __data["amount"] }
                /// Currency of the money.
                public var currencyCode: GraphQLEnum<ShopifyAPI.CurrencyCode> { __data["currencyCode"] }

                public struct Fragments: FragmentContainer {
                  public let __data: DataDict
                  public init(data: DataDict) { __data = data }

                  public var moneyFields: MoneyFields { _toFragment() }
                }
              }
            }
          }
        }
      }
    }
  }

  /// Cost
  ///
  /// Parent Type: `CartCost`
  public struct Cost: ShopifyAPI.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CartCost }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("subtotalAmount", SubtotalAmount.self),
      .field("totalAmount", TotalAmount.self),
      .field("totalTaxAmount", TotalTaxAmount?.self),
    ] }

    /// The amount, before taxes and cart-level discounts, for the customer to pay.
    public var subtotalAmount: SubtotalAmount { __data["subtotalAmount"] }
    /// The total amount for the customer to pay.
    public var totalAmount: TotalAmount { __data["totalAmount"] }
    /// The tax amount for the customer to pay at checkout.
    @available(*, deprecated, message: """
      Tax and duty amounts are no longer available and will be removed in a future version.
      Please see [the changelog](https://shopify.dev/changelog/tax-and-duties-are-deprecated-in-storefront-cart-api)
      for more information.

      """)
    public var totalTaxAmount: TotalTaxAmount? { __data["totalTaxAmount"] }

    /// Cost.SubtotalAmount
    ///
    /// Parent Type: `MoneyV2`
    public struct SubtotalAmount: ShopifyAPI.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.MoneyV2 }
      public static var __selections: [ApolloAPI.Selection] { [
        .fragment(MoneyFields.self),
      ] }

      /// Decimal money amount.
      public var amount: ShopifyAPI.Decimal { __data["amount"] }
      /// Currency of the money.
      public var currencyCode: GraphQLEnum<ShopifyAPI.CurrencyCode> { __data["currencyCode"] }

      public struct Fragments: FragmentContainer {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public var moneyFields: MoneyFields { _toFragment() }
      }
    }

    /// Cost.TotalAmount
    ///
    /// Parent Type: `MoneyV2`
    public struct TotalAmount: ShopifyAPI.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.MoneyV2 }
      public static var __selections: [ApolloAPI.Selection] { [
        .fragment(MoneyFields.self),
      ] }

      /// Decimal money amount.
      public var amount: ShopifyAPI.Decimal { __data["amount"] }
      /// Currency of the money.
      public var currencyCode: GraphQLEnum<ShopifyAPI.CurrencyCode> { __data["currencyCode"] }

      public struct Fragments: FragmentContainer {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public var moneyFields: MoneyFields { _toFragment() }
      }
    }

    /// Cost.TotalTaxAmount
    ///
    /// Parent Type: `MoneyV2`
    public struct TotalTaxAmount: ShopifyAPI.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.MoneyV2 }
      public static var __selections: [ApolloAPI.Selection] { [
        .fragment(MoneyFields.self),
      ] }

      /// Decimal money amount.
      public var amount: ShopifyAPI.Decimal { __data["amount"] }
      /// Currency of the money.
      public var currencyCode: GraphQLEnum<ShopifyAPI.CurrencyCode> { __data["currencyCode"] }

      public struct Fragments: FragmentContainer {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public var moneyFields: MoneyFields { _toFragment() }
      }
    }
  }

  /// DiscountCode
  ///
  /// Parent Type: `CartDiscountCode`
  public struct DiscountCode: ShopifyAPI.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CartDiscountCode }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("code", String.self),
      .field("applicable", Bool.self),
    ] }

    /// The code for the discount.
    public var code: String { __data["code"] }
    /// Whether the discount code is applicable to the cart's current contents.
    public var applicable: Bool { __data["applicable"] }
  }
}
