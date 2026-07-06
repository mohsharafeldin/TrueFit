// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct OrderDetailsFields: ShopifyAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString { """
    fragment OrderDetailsFields on Order {
      __typename
      id
      name
      orderNumber
      processedAt
      cancelReason
      canceledAt
      financialStatus
      fulfillmentStatus
      currentTotalPrice {
        __typename
        ...MoneyFields
      }
      currentSubtotalPrice {
        __typename
        ...MoneyFields
      }
      totalShippingPrice {
        __typename
        ...MoneyFields
      }
      totalTax {
        __typename
        ...MoneyFields
      }
      totalRefunded {
        __typename
        ...MoneyFields
      }
      shippingAddress {
        __typename
        address1
        address2
        city
        province
        zip
        country
      }
      lineItems(first: 50) {
        __typename
        edges {
          __typename
          node {
            __typename
            title
            quantity
            originalTotalPrice {
              __typename
              ...MoneyFields
            }
            discountedTotalPrice {
              __typename
              ...MoneyFields
            }
            variant {
              __typename
              id
              title
              price {
                __typename
                ...MoneyFields
              }
              image {
                __typename
                url
                altText
              }
            }
          }
        }
      }
      successfulFulfillments(first: 5) {
        __typename
        trackingCompany
        trackingInfo {
          __typename
          number
          url
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
    .field("cancelReason", GraphQLEnum<ShopifyAPI.OrderCancelReason>?.self),
    .field("canceledAt", ShopifyAPI.DateTime?.self),
    .field("financialStatus", GraphQLEnum<ShopifyAPI.OrderFinancialStatus>?.self),
    .field("fulfillmentStatus", GraphQLEnum<ShopifyAPI.OrderFulfillmentStatus>.self),
    .field("currentTotalPrice", CurrentTotalPrice.self),
    .field("currentSubtotalPrice", CurrentSubtotalPrice.self),
    .field("totalShippingPrice", TotalShippingPrice.self),
    .field("totalTax", TotalTax?.self),
    .field("totalRefunded", TotalRefunded.self),
    .field("shippingAddress", ShippingAddress?.self),
    .field("lineItems", LineItems.self, arguments: ["first": 50]),
    .field("successfulFulfillments", [SuccessfulFulfillment]?.self, arguments: ["first": 5]),
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
  public var shippingAddress: ShippingAddress? { __data["shippingAddress"] }
  /// List of the order’s line items.
  public var lineItems: LineItems { __data["lineItems"] }
  /// List of the order’s successful fulfillments.
  public var successfulFulfillments: [SuccessfulFulfillment]? { __data["successfulFulfillments"] }

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

  /// CurrentSubtotalPrice
  ///
  /// Parent Type: `MoneyV2`
  public struct CurrentSubtotalPrice: ShopifyAPI.SelectionSet {
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

  /// TotalShippingPrice
  ///
  /// Parent Type: `MoneyV2`
  public struct TotalShippingPrice: ShopifyAPI.SelectionSet {
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

  /// TotalTax
  ///
  /// Parent Type: `MoneyV2`
  public struct TotalTax: ShopifyAPI.SelectionSet {
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

  /// TotalRefunded
  ///
  /// Parent Type: `MoneyV2`
  public struct TotalRefunded: ShopifyAPI.SelectionSet {
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

  /// ShippingAddress
  ///
  /// Parent Type: `MailingAddress`
  public struct ShippingAddress: ShopifyAPI.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.MailingAddress }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("address1", String?.self),
      .field("address2", String?.self),
      .field("city", String?.self),
      .field("province", String?.self),
      .field("zip", String?.self),
      .field("country", String?.self),
    ] }

    /// The first line of the address. Typically the street address or PO Box number.
    public var address1: String? { __data["address1"] }
    /// The second line of the address. Typically the number of the apartment, suite, or unit.
    ///
    public var address2: String? { __data["address2"] }
    /// The name of the city, district, village, or town.
    public var city: String? { __data["city"] }
    /// The region of the address, such as the province, state, or district.
    public var province: String? { __data["province"] }
    /// The zip or postal code of the address.
    public var zip: String? { __data["zip"] }
    /// The name of the country.
    public var country: String? { __data["country"] }
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
          .field("title", String.self),
          .field("quantity", Int.self),
          .field("originalTotalPrice", OriginalTotalPrice.self),
          .field("discountedTotalPrice", DiscountedTotalPrice.self),
          .field("variant", Variant?.self),
        ] }

        /// The title of the product combined with title of the variant.
        public var title: String { __data["title"] }
        /// The number of products variants associated to the line item.
        public var quantity: Int { __data["quantity"] }
        /// The total price of the line item, not including any discounts. The total price is calculated using the original unit price multiplied by the quantity, and it's displayed in the presentment currency.
        public var originalTotalPrice: OriginalTotalPrice { __data["originalTotalPrice"] }
        /// The total price of the line item, including discounts, and displayed in the presentment currency.
        public var discountedTotalPrice: DiscountedTotalPrice { __data["discountedTotalPrice"] }
        /// The product variant object associated to the line item.
        public var variant: Variant? { __data["variant"] }

        /// LineItems.Edge.Node.OriginalTotalPrice
        ///
        /// Parent Type: `MoneyV2`
        public struct OriginalTotalPrice: ShopifyAPI.SelectionSet {
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

        /// LineItems.Edge.Node.DiscountedTotalPrice
        ///
        /// Parent Type: `MoneyV2`
        public struct DiscountedTotalPrice: ShopifyAPI.SelectionSet {
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

        /// LineItems.Edge.Node.Variant
        ///
        /// Parent Type: `ProductVariant`
        public struct Variant: ShopifyAPI.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.ProductVariant }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("id", ShopifyAPI.ID.self),
            .field("title", String.self),
            .field("price", Price.self),
            .field("image", Image?.self),
          ] }

          /// A globally-unique ID.
          public var id: ShopifyAPI.ID { __data["id"] }
          /// The product variant’s title.
          public var title: String { __data["title"] }
          /// The product variant’s price.
          public var price: Price { __data["price"] }
          /// Image associated with the product variant. This field falls back to the product image if no image is available.
          public var image: Image? { __data["image"] }

          /// LineItems.Edge.Node.Variant.Price
          ///
          /// Parent Type: `MoneyV2`
          public struct Price: ShopifyAPI.SelectionSet {
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

          /// LineItems.Edge.Node.Variant.Image
          ///
          /// Parent Type: `Image`
          public struct Image: ShopifyAPI.SelectionSet {
            public let __data: DataDict
            public init(data: DataDict) { __data = data }

            public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Image }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("url", ShopifyAPI.URL.self),
              .field("altText", String?.self),
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
            /// A word or phrase to share the nature or contents of an image.
            public var altText: String? { __data["altText"] }
          }
        }
      }
    }
  }

  /// SuccessfulFulfillment
  ///
  /// Parent Type: `Fulfillment`
  public struct SuccessfulFulfillment: ShopifyAPI.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Fulfillment }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("trackingCompany", String?.self),
      .field("trackingInfo", [TrackingInfo].self),
    ] }

    /// The name of the tracking company.
    public var trackingCompany: String? { __data["trackingCompany"] }
    /// Tracking information associated with the fulfillment,
    /// such as the tracking number and tracking URL.
    ///
    public var trackingInfo: [TrackingInfo] { __data["trackingInfo"] }

    /// SuccessfulFulfillment.TrackingInfo
    ///
    /// Parent Type: `FulfillmentTrackingInfo`
    public struct TrackingInfo: ShopifyAPI.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.FulfillmentTrackingInfo }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("number", String?.self),
        .field("url", ShopifyAPI.URL?.self),
      ] }

      /// The tracking number of the fulfillment.
      public var number: String? { __data["number"] }
      /// The URL to track the fulfillment.
      public var url: ShopifyAPI.URL? { __data["url"] }
    }
  }
}
