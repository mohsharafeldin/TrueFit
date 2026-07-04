// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension Objects {
  /// A [custom content page](https://help.shopify.com/manual/online-store/add-edit-pages) on a merchant's store. Pages display HTML-formatted content, such as "About Us", contact details, or store policies.
  ///
  /// Each page has a unique [`handle`](https://shopify.dev/docs/api/storefront/current/objects/Page#field-Page.fields.handle) for URL routing and includes [`SEO`](https://shopify.dev/docs/api/storefront/current/objects/SEO) information for search engine optimization. Pages support [`Metafield`](https://shopify.dev/docs/api/storefront/current/objects/Metafield) attachments for storing additional custom data.
  ///
  static let Page = Object(
    typename: "Page",
    implementedInterfaces: [
      Interfaces.HasMetafields.self,
      Interfaces.Node.self,
      Interfaces.OnlineStorePublishable.self,
      Interfaces.Trackable.self
    ]
  )
}