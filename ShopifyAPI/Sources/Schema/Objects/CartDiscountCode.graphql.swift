// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension Objects {
  /// A discount code applied to a [`Cart`](https://shopify.dev/docs/api/storefront/current/objects/Cart). Discount codes are case-insensitive and can be added using the [`cartDiscountCodesUpdate`](https://shopify.dev/docs/api/storefront/current/mutations/cartDiscountCodesUpdate) mutation.
  ///
  /// The [`applicable`](https://shopify.dev/docs/api/storefront/current/objects/CartDiscountCode#field-CartDiscountCode.fields.applicable) field indicates whether the code applies to the cart's current contents, which might change as items are added or removed.
  ///
  static let CartDiscountCode = Object(
    typename: "CartDiscountCode",
    implementedInterfaces: []
  )
}