// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension Objects {
  /// A shipment of one or more items in an order. Accessed through the [`Order`](https://shopify.dev/docs/api/storefront/current/objects/Order) object's [`successfulFulfillments`](https://shopify.dev/docs/api/storefront/current/objects/Order#field-Order.fields.successfulFulfillments) field.
  ///
  /// Each fulfillment includes the line items that shipped, the tracking company name, and tracking details like numbers and URLs. An order can have multiple fulfillments when items ship separately or from different locations.
  ///
  static let Fulfillment = Object(
    typename: "Fulfillment",
    implementedInterfaces: []
  )
}