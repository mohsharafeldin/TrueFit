// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class UpdateAddressMutation: GraphQLMutation {
  public static let operationName: String = "UpdateAddress"
  public static let document: ApolloAPI.DocumentType = .notPersisted(
    definition: .init(
      #"""
      mutation UpdateAddress($customerAccessToken: String!, $id: ID!, $address: MailingAddressInput!) {
        customerAddressUpdate(
          customerAccessToken: $customerAccessToken
          id: $id
          address: $address
        ) {
          __typename
          customerAddress {
            __typename
            id
          }
          customerUserErrors {
            __typename
            code
            field
            message
          }
        }
      }
      """#
    ))

  public var customerAccessToken: String
  public var id: ID
  public var address: MailingAddressInput

  public init(
    customerAccessToken: String,
    id: ID,
    address: MailingAddressInput
  ) {
    self.customerAccessToken = customerAccessToken
    self.id = id
    self.address = address
  }

  public var __variables: Variables? { [
    "customerAccessToken": customerAccessToken,
    "id": id,
    "address": address
  ] }

  public struct Data: ShopifyAPI.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("customerAddressUpdate", CustomerAddressUpdate?.self, arguments: [
        "customerAccessToken": .variable("customerAccessToken"),
        "id": .variable("id"),
        "address": .variable("address")
      ]),
    ] }

    /// Updates an existing [`MailingAddress`](https://shopify.dev/docs/api/storefront/current/objects/MailingAddress) for a [`Customer`](https://shopify.dev/docs/api/storefront/current/objects/Customer). Requires a [customer access token](https://shopify.dev/docs/api/storefront/current/mutations/customerAddressUpdate#arguments-customerAccessToken) to identify the customer, an ID to specify which address to modify, and an [`address`](https://shopify.dev/docs/api/storefront/current/input-objects/MailingAddressInput) with the updated fields.
    ///
    /// Successful update returns the updated [`MailingAddress`](https://shopify.dev/docs/api/storefront/current/objects/MailingAddress).
    ///
    public var customerAddressUpdate: CustomerAddressUpdate? { __data["customerAddressUpdate"] }

    /// CustomerAddressUpdate
    ///
    /// Parent Type: `CustomerAddressUpdatePayload`
    public struct CustomerAddressUpdate: ShopifyAPI.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CustomerAddressUpdatePayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("customerAddress", CustomerAddress?.self),
        .field("customerUserErrors", [CustomerUserError].self),
      ] }

      /// The customer’s updated mailing address.
      public var customerAddress: CustomerAddress? { __data["customerAddress"] }
      /// The list of errors that occurred from executing the mutation.
      public var customerUserErrors: [CustomerUserError] { __data["customerUserErrors"] }

      /// CustomerAddressUpdate.CustomerAddress
      ///
      /// Parent Type: `MailingAddress`
      public struct CustomerAddress: ShopifyAPI.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.MailingAddress }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("id", ShopifyAPI.ID.self),
        ] }

        /// A globally-unique ID.
        public var id: ShopifyAPI.ID { __data["id"] }
      }

      /// CustomerAddressUpdate.CustomerUserError
      ///
      /// Parent Type: `CustomerUserError`
      public struct CustomerUserError: ShopifyAPI.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CustomerUserError }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("code", GraphQLEnum<ShopifyAPI.CustomerErrorCode>?.self),
          .field("field", [String]?.self),
          .field("message", String.self),
        ] }

        /// The error code.
        public var code: GraphQLEnum<ShopifyAPI.CustomerErrorCode>? { __data["code"] }
        /// The path to the input field that caused the error.
        public var field: [String]? { __data["field"] }
        /// The error message.
        public var message: String { __data["message"] }
      }
    }
  }
}
