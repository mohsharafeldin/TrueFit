// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetCustomerOrderDetailsQuery: GraphQLQuery {
  public static let operationName: String = "GetCustomerOrderDetails"
  public static let document: ApolloAPI.DocumentType = .notPersisted(
    definition: .init(
      #"""
      query GetCustomerOrderDetails($customerAccessToken: String!, $orderQuery: String!) {
        customer(customerAccessToken: $customerAccessToken) {
          __typename
          orders(first: 1, query: $orderQuery) {
            __typename
            edges {
              __typename
              node {
                __typename
                ...OrderDetailsFields
              }
            }
          }
        }
      }
      """#,
      fragments: [OrderDetailsFields.self, MoneyFields.self]
    ))

  public var customerAccessToken: String
  public var orderQuery: String

  public init(
    customerAccessToken: String,
    orderQuery: String
  ) {
    self.customerAccessToken = customerAccessToken
    self.orderQuery = orderQuery
  }

  public var __variables: Variables? { [
    "customerAccessToken": customerAccessToken,
    "orderQuery": orderQuery
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
          "first": 1,
          "query": .variable("orderQuery")
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
              .fragment(OrderDetailsFields.self),
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
            /// The reason for the order's cancellation. Returns `null` if the order wasn't canceled.
            public var cancelReason: GraphQLEnum<ShopifyAPI.OrderCancelReason>? { __data["cancelReason"] }
            /// The date and time when the order was canceled. Returns null if the order wasn't canceled.
            public var canceledAt: ShopifyAPI.DateTime? { __data["canceledAt"] }
            /// The financial status of the order.
            public var financialStatus: GraphQLEnum<ShopifyAPI.OrderFinancialStatus>? { __data["financialStatus"] }
            /// The fulfillment status for the order.
            public var fulfillmentStatus: GraphQLEnum<ShopifyAPI.OrderFulfillmentStatus> { __data["fulfillmentStatus"] }
            /// The total amount of the order, including duties, taxes and discounts, minus amounts for line items that have been removed.
            public var currentTotalPrice: CurrentTotalPrice { __data["currentTotalPrice"] }
            /// The subtotal of line items and their discounts, excluding line items that have been removed. Does not contain order-level discounts, duties, shipping costs, or shipping discounts. Taxes aren't included unless the order is a taxes-included order.
            public var currentSubtotalPrice: CurrentSubtotalPrice { __data["currentSubtotalPrice"] }
            /// The total cost of shipping.
            public var totalShippingPrice: TotalShippingPrice { __data["totalShippingPrice"] }
            /// The total cost of taxes.
            public var totalTax: TotalTax? { __data["totalTax"] }
            /// The total amount that has been refunded.
            public var totalRefunded: TotalRefunded { __data["totalRefunded"] }
            /// The address to where the order will be shipped.
            public var shippingAddress: OrderDetailsFields.ShippingAddress? { __data["shippingAddress"] }
            /// List of the order’s line items.
            public var lineItems: OrderDetailsFields.LineItems { __data["lineItems"] }
            /// List of the order’s successful fulfillments.
            public var successfulFulfillments: [OrderDetailsFields.SuccessfulFulfillment]? { __data["successfulFulfillments"] }

            public struct Fragments: FragmentContainer {
              public let __data: DataDict
              public init(data: DataDict) { __data = data }

              public var orderDetailsFields: OrderDetailsFields { _toFragment() }
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

            /// Customer.Orders.Edge.Node.CurrentSubtotalPrice
            ///
            /// Parent Type: `MoneyV2`
            public struct CurrentSubtotalPrice: ShopifyAPI.SelectionSet {
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

            /// Customer.Orders.Edge.Node.TotalShippingPrice
            ///
            /// Parent Type: `MoneyV2`
            public struct TotalShippingPrice: ShopifyAPI.SelectionSet {
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

            /// Customer.Orders.Edge.Node.TotalTax
            ///
            /// Parent Type: `MoneyV2`
            public struct TotalTax: ShopifyAPI.SelectionSet {
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

            /// Customer.Orders.Edge.Node.TotalRefunded
            ///
            /// Parent Type: `MoneyV2`
            public struct TotalRefunded: ShopifyAPI.SelectionSet {
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
