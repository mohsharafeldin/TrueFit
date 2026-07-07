// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class FetchCustomerAddressesQuery: GraphQLQuery {
  public static let operationName: String = "FetchCustomerAddresses"
  public static let document: ApolloAPI.DocumentType = .notPersisted(
    definition: .init(
      #"""
      query FetchCustomerAddresses($customerAccessToken: String!) {
        customer(customerAccessToken: $customerAccessToken) {
          __typename
          id
          defaultAddress {
            __typename
            id
          }
          addresses(first: 100) {
            __typename
            edges {
              __typename
              node {
                __typename
                id
                address1
                city
                country
                province
                zip
              }
            }
          }
        }
      }
      """#
    ))

  public var customerAccessToken: String

  public init(customerAccessToken: String) {
    self.customerAccessToken = customerAccessToken
  }

  public var __variables: Variables? { ["customerAccessToken": customerAccessToken] }

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
        .field("id", ShopifyAPI.ID.self),
        .field("defaultAddress", DefaultAddress?.self),
        .field("addresses", Addresses.self, arguments: ["first": 100]),
      ] }

      /// A unique ID for the customer.
      public var id: ShopifyAPI.ID { __data["id"] }
      /// The customer’s default address.
      public var defaultAddress: DefaultAddress? { __data["defaultAddress"] }
      /// A list of addresses for the customer.
      public var addresses: Addresses { __data["addresses"] }

      /// Customer.DefaultAddress
      ///
      /// Parent Type: `MailingAddress`
      public struct DefaultAddress: ShopifyAPI.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.MailingAddress }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("id", ShopifyAPI.ID.self),
        ] }

        /// A globally-unique ID.
        public var id: ShopifyAPI.ID { __data["id"] }
      }

      /// Customer.Addresses
      ///
      /// Parent Type: `MailingAddressConnection`
      public struct Addresses: ShopifyAPI.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.MailingAddressConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("edges", [Edge].self),
        ] }

        /// A list of edges.
        public var edges: [Edge] { __data["edges"] }

        /// Customer.Addresses.Edge
        ///
        /// Parent Type: `MailingAddressEdge`
        public struct Edge: ShopifyAPI.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.MailingAddressEdge }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("node", Node.self),
          ] }

          /// The item at the end of MailingAddressEdge.
          public var node: Node { __data["node"] }

          /// Customer.Addresses.Edge.Node
          ///
          /// Parent Type: `MailingAddress`
          public struct Node: ShopifyAPI.SelectionSet {
            public let __data: DataDict
            public init(data: DataDict) { __data = data }

            public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.MailingAddress }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("id", ShopifyAPI.ID.self),
              .field("address1", String?.self),
              .field("city", String?.self),
              .field("country", String?.self),
              .field("province", String?.self),
              .field("zip", String?.self),
            ] }

            /// A globally-unique ID.
            public var id: ShopifyAPI.ID { __data["id"] }
            /// The first line of the address. Typically the street address or PO Box number.
            public var address1: String? { __data["address1"] }
            /// The name of the city, district, village, or town.
            public var city: String? { __data["city"] }
            /// The name of the country.
            public var country: String? { __data["country"] }
            /// The region of the address, such as the province, state, or district.
            public var province: String? { __data["province"] }
            /// The zip or postal code of the address.
            public var zip: String? { __data["zip"] }
          }
        }
      }
    }
  }
}
