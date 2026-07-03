// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

/// A custom key-value pair that stores additional information on a [cart](https://shopify.dev/docs/api/storefront/current/objects/Cart) or [cart line](https://shopify.dev/docs/api/storefront/current/objects/CartLine). Attributes capture additional information like gift messages, special instructions, or custom order details. Learn more about [managing carts with the Storefront API](https://shopify.dev/docs/storefronts/headless/building-with-the-storefront-api/cart/manage).
///
public struct AttributeInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    key: String,
    value: String
  ) {
    __data = InputDict([
      "key": key,
      "value": value
    ])
  }

  /// Key or name of the attribute.
  public var key: String {
    get { __data["key"] }
    set { __data["key"] = newValue }
  }

  /// Value of the attribute.
  public var value: String {
    get { __data["value"] }
    set { __data["value"] = newValue }
  }
}
