// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class DeleteAddressMutation: GraphQLMutation {
  public static let operationName: String = "DeleteAddress"
  public static let document: ApolloAPI.DocumentType = .notPersisted(
    definition: .init(
      #"""
      mutation DeleteAddress($customerAccessToken: String!, $id: ID!) {
        customerAddressDelete(customerAccessToken: $customerAccessToken, id: $id) {
          __typename
          deletedCustomerAddressId
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

  public init(
    customerAccessToken: String,
    id: ID
  ) {
    self.customerAccessToken = customerAccessToken
    self.id = id
  }

  public var __variables: Variables? { [
    "customerAccessToken": customerAccessToken,
    "id": id
  ] }

  public struct Data: ShopifyAPI.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("customerAddressDelete", CustomerAddressDelete?.self, arguments: [
        "customerAccessToken": .variable("customerAccessToken"),
        "id": .variable("id")
      ]),
    ] }

    /// Permanently deletes a specific [`MailingAddress`](https://shopify.dev/docs/api/storefront/current/objects/MailingAddress) for a [`Customer`](https://shopify.dev/docs/api/storefront/current/objects/Customer). Requires a valid [customer access token](https://shopify.dev/docs/api/storefront/current/mutations/customerAddressDelete#arguments-customerAccessToken) to authenticate the request.
    ///
    /// > Caution:
    /// > This action is irreversible. You can't recover the deleted address.
    ///
    public var customerAddressDelete: CustomerAddressDelete? { __data["customerAddressDelete"] }

    /// CustomerAddressDelete
    ///
    /// Parent Type: `CustomerAddressDeletePayload`
    public struct CustomerAddressDelete: ShopifyAPI.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CustomerAddressDeletePayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("deletedCustomerAddressId", String?.self),
        .field("customerUserErrors", [CustomerUserError].self),
      ] }

      /// ID of the deleted customer address.
      public var deletedCustomerAddressId: String? { __data["deletedCustomerAddressId"] }
      /// The list of errors that occurred from executing the mutation.
      public var customerUserErrors: [CustomerUserError] { __data["customerUserErrors"] }

      /// CustomerAddressDelete.CustomerUserError
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
