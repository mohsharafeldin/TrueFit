// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

/// The input fields for the cart's delivery properties.
public struct CartDeliveryInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    addresses: GraphQLNullable<[CartSelectableAddressInput]> = nil
  ) {
    __data = InputDict([
      "addresses": addresses
    ])
  }

  /// Selectable addresses to present to the buyer on the cart.
  ///
  /// The input must not contain more than `250` values.
  public var addresses: GraphQLNullable<[CartSelectableAddressInput]> {
    get { __data["addresses"] }
    set { __data["addresses"] = newValue }
  }
}
