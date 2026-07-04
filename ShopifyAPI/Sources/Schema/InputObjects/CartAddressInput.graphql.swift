// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

/// Specifies a delivery address for a cart. Provide either a [`deliveryAddress`](https://shopify.dev/docs/api/storefront/current/input-objects/CartAddressInput#fields-deliveryAddress) with full address details, or a [`copyFromCustomerAddressId`](https://shopify.dev/docs/api/storefront/current/input-objects/CartAddressInput#fields-copyFromCustomerAddressId) to copy from an existing customer address. Used by [`CartSelectableAddressInput`](https://shopify.dev/docs/api/storefront/current/input-objects/CartSelectableAddressInput) and [`CartSelectableAddressUpdateInput`](https://shopify.dev/docs/api/storefront/current/input-objects/CartSelectableAddressUpdateInput).
///
public struct CartAddressInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    deliveryAddress: GraphQLNullable<CartDeliveryAddressInput> = nil,
    copyFromCustomerAddressId: GraphQLNullable<ID> = nil
  ) {
    __data = InputDict([
      "deliveryAddress": deliveryAddress,
      "copyFromCustomerAddressId": copyFromCustomerAddressId
    ])
  }

  /// A delivery address stored on this cart.
  public var deliveryAddress: GraphQLNullable<CartDeliveryAddressInput> {
    get { __data["deliveryAddress"] }
    set { __data["deliveryAddress"] = newValue }
  }

  /// Copies details from the customer address to an address on this cart.
  public var copyFromCustomerAddressId: GraphQLNullable<ID> {
    get { __data["copyFromCustomerAddressId"] }
    set { __data["copyFromCustomerAddressId"] = newValue }
  }
}
