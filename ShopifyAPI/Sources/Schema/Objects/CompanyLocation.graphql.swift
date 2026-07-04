// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension Objects {
  /// A branch or office of a [`Company`](https://shopify.dev/docs/api/storefront/current/objects/Company) where B2B customers can place orders. When a B2B customer selects a location after logging in, the Storefront API contextualizes product queries to return location-specific pricing and quantity rules.
  ///
  /// Access through the [`PurchasingCompany`](https://shopify.dev/docs/api/storefront/current/objects/PurchasingCompany) object, which associates the location with the buyer's [`Cart`](https://shopify.dev/docs/api/storefront/current/objects/Cart).
  ///
  static let CompanyLocation = Object(
    typename: "CompanyLocation",
    implementedInterfaces: [
      Interfaces.HasMetafields.self,
      Interfaces.Node.self
    ]
  )
}