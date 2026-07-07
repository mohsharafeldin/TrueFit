// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetCustomerOrdersListQuery: GraphQLQuery {
  public static let operationName: String = "GetCustomerOrdersList"
  public static let document: ApolloAPI.DocumentType = .notPersisted(
    definition: .init(
      #"""
      query GetCustomerOrdersList($customerAccessToken: String!, $first: Int!) {
        customer(customerAccessToken: $customerAccessToken) {
          __typename
          orders(first: $first, sortKey: PROCESSED_AT, reverse: true) {
            __typename
            edges {
              __typename
              node {
                __typename
                ...OrderListFields
              }
            }
          }
        }
      }
      """#,
      fragments: [OrderListFields.self, MoneyFields.self]
    ))

  public var customerAccessToken: String
  public var first: Int

  public init(
    customerAccessToken: String,
    first: Int
  ) {
    self.customerAccessToken = customerAccessToken
    self.first = first
  }

  public var __variables: Variables? { [
    "customerAccessToken": customerAccessToken,
    "first": first
  ] }

  public struct Data: ShopifyAPI.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.QueryRoot }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("customer", Customer?.self, arguments: ["customerAccessToken": .variable("customerAccessToken")]),
    ] }

    /// Retrieves the [`Customer`](https://shopify.dev/docs/api/storefront/current/objects/Customer) associated with the provided access token. Use the [`customerAccessTokenCreate`](https://shopify.dev/docs/api/storefront/current/mutations/customerAccessTokenCreate) mutation to obtain an access token using legacy customer account authentication (email and password).
    ///
    /// The returned customer includes data such as contact information, [addresses](https://shopify.dev/docs/api/storefront/current/objects/MailingAddress), [orders](https://shopify.dev/docs/api/storefront/current/objects/Order), and [custom data](https://shopify.dev/docs/apps/build/custom-data) associated with the customer.
    ///
    public var customer: Customer? { __data["customer"] }

    /// Customer
    ///
    /// Parent Type: `Customer`
    public struct Customer: ShopifyAPI.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Customer }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("orders", Orders.self, arguments: [
          "first": .variable("first"),
          "sortKey": "PROCESSED_AT",
          "reverse": true
        ]),
      ] }

      /// The orders associated with the customer.
      public var orders: Orders { __data["orders"] }

      /// Customer.Orders
      ///
      /// Parent Type: `OrderConnection`
      public struct Orders: ShopifyAPI.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.OrderConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("edges", [Edge].self),
        ] }

        /// A list of edges.
        public var edges: [Edge] { __data["edges"] }

        /// Customer.Orders.Edge
        ///
        /// Parent Type: `OrderEdge`
        public struct Edge: ShopifyAPI.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.OrderEdge }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("node", Node.self),
          ] }

          /// The item at the end of OrderEdge.
          public var node: Node { __data["node"] }

          /// Customer.Orders.Edge.Node
          ///
          /// Parent Type: `Order`
          public struct Node: ShopifyAPI.SelectionSet {
            public let __data: DataDict
            public init(data: DataDict) { __data = data }

            public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Order }
            public static var __selections: [ApolloAPI.Selection] { [
              .fragment(OrderListFields.self),
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
            public var lineItems: OrderListFields.LineItems { __data["lineItems"] }

            public struct Fragments: FragmentContainer {
              public let __data: DataDict
              public init(data: DataDict) { __data = data }

              public var orderListFields: OrderListFields { _toFragment() }
            }

            /// Customer.Orders.Edge.Node.CurrentTotalPrice
            ///
            /// Parent Type: `MoneyV2`
            public struct CurrentTotalPrice: ShopifyAPI.SelectionSet {
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
