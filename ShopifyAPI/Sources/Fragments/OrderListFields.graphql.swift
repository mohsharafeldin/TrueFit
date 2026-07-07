// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct OrderListFields: ShopifyAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString { """
    fragment OrderListFields on Order {
      __typename
      id
      name
      orderNumber
      processedAt
      financialStatus
      fulfillmentStatus
      currentTotalPrice {
        __typename
        ...MoneyFields
      }
      lineItems(first: 1) {
        __typename
        edges {
          __typename
          node {
            __typename
            variant {
              __typename
              image {
                __typename
                url
              }
            }
          }
        }
      }
    }
    """ }

  public let __data: DataDict
  public init(data: DataDict) { __data = data }

  public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Order }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("id", ShopifyAPI.ID.self),
    .field("name", String.self),
    .field("orderNumber", Int.self),
    .field("processedAt", ShopifyAPI.DateTime.self),
    .field("financialStatus", GraphQLEnum<ShopifyAPI.OrderFinancialStatus>?.self),
    .field("fulfillmentStatus", GraphQLEnum<ShopifyAPI.OrderFulfillmentStatus>.self),
    .field("currentTotalPrice", CurrentTotalPrice.self),
    .field("lineItems", LineItems.self, arguments: ["first": 1]),
  ] }

  /// A globally-unique ID.
  public var id: ShopifyAPI.ID { __data["id"] }
  /// Unique identifier for the order that appears on the order.
  /// For example, _#1000_ or _Store1001.
  ///
  public var name: String { __data["name"] }
  /// A unique numeric identifier for the order for use by shop owner and customer.
  public var orderNumber: Int { __data["orderNumber"] }
  /// The date and time when the order was imported.
  /// This value can be set to dates in the past when importing from other systems.
  /// If no value is provided, it will be auto-generated based on current date and time.
  ///
  public var processedAt: ShopifyAPI.DateTime { __data["processedAt"] }
  /// The financial status of the order.
  public var financialStatus: GraphQLEnum<ShopifyAPI.OrderFinancialStatus>? { __data["financialStatus"] }
  /// The fulfillment status for the order.
  public var fulfillmentStatus: GraphQLEnum<ShopifyAPI.OrderFulfillmentStatus> { __data["fulfillmentStatus"] }
  /// The total amount of the order, including duties, taxes and discounts, minus amounts for line items that have been removed.
  public var currentTotalPrice: CurrentTotalPrice { __data["currentTotalPrice"] }
  /// List of the order’s line items.
  public var lineItems: LineItems { __data["lineItems"] }

  /// CurrentTotalPrice
  ///
  /// Parent Type: `MoneyV2`
  public struct CurrentTotalPrice: ShopifyAPI.SelectionSet {
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

  /// LineItems
  ///
  /// Parent Type: `OrderLineItemConnection`
  public struct LineItems: ShopifyAPI.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.OrderLineItemConnection }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("edges", [Edge].self),
    ] }

    /// A list of edges.
    public var edges: [Edge] { __data["edges"] }

    /// LineItems.Edge
    ///
    /// Parent Type: `OrderLineItemEdge`
    public struct Edge: ShopifyAPI.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.OrderLineItemEdge }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("node", Node.self),
      ] }

      /// The item at the end of OrderLineItemEdge.
      public var node: Node { __data["node"] }

      /// LineItems.Edge.Node
      ///
      /// Parent Type: `OrderLineItem`
      public struct Node: ShopifyAPI.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.OrderLineItem }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("variant", Variant?.self),
        ] }

        /// The product variant object associated to the line item.
        public var variant: Variant? { __data["variant"] }

        /// LineItems.Edge.Node.Variant
        ///
        /// Parent Type: `ProductVariant`
        public struct Variant: ShopifyAPI.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.ProductVariant }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("image", Image?.self),
          ] }

          /// Image associated with the product variant. This field falls back to the product image if no image is available.
          public var image: Image? { __data["image"] }

          /// LineItems.Edge.Node.Variant.Image
          ///
          /// Parent Type: `Image`
          public struct Image: ShopifyAPI.SelectionSet {
            public let __data: DataDict
            public init(data: DataDict) { __data = data }

            public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Image }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("url", ShopifyAPI.URL.self),
            ] }

            /// The location of the image as a URL.
            ///
            /// If no transform options are specified, then the original image will be preserved including any pre-applied transforms.
            ///
            /// All transformation options are considered "best-effort". Any transformation that the original image type doesn't support will be ignored.
            ///
            /// If you need multiple variations of the same image, then you can use [GraphQL aliases](https://graphql.org/learn/queries/#aliases).
            ///
            public var url: ShopifyAPI.URL { __data["url"] }
          }
        }
      }
    }
  }
}
