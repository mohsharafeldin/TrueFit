// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension Objects {
  /// An image hosted on Shopify's content delivery network (CDN). Used for product images, brand logos, and other visual content across the storefront.
  ///
  /// The [`image`](https://shopify.dev/docs/api/storefront/current/objects/MediaImage#field-MediaImage.fields.image) field provides the actual image data with transformation options. Implements the [`Media`](https://shopify.dev/docs/api/storefront/current/interfaces/Media) interface alongside other media types like [`Video`](https://shopify.dev/docs/api/storefront/current/objects/Video) and [`Model3d`](https://shopify.dev/docs/api/storefront/current/objects/Model3d).
  ///
  static let MediaImage = Object(
    typename: "MediaImage",
    implementedInterfaces: [
      Interfaces.Media.self,
      Interfaces.Node.self
    ]
  )
}