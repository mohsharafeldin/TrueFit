// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension Objects {
  /// A blog container for [`Article`](https://shopify.dev/docs/api/storefront/current/objects/Article) objects. Stores can have multiple blogs, for example to organize content by topic or purpose.
  ///
  /// Each blog provides access to its articles, contributing [`ArticleAuthor`](https://shopify.dev/docs/api/storefront/current/objects/ArticleAuthor) objects, and [`SEO`](https://shopify.dev/docs/api/storefront/current/objects/SEO) information. You can retrieve articles individually [by handle](https://shopify.dev/docs/api/storefront/current/objects/Blog#field-Blog.fields.articleByHandle) or as a [paginated list](https://shopify.dev/docs/api/storefront/current/objects/Blog#field-Blog.fields.articles).
  ///
  static let Blog = Object(
    typename: "Blog",
    implementedInterfaces: [
      Interfaces.HasMetafields.self,
      Interfaces.Node.self,
      Interfaces.OnlineStorePublishable.self
    ]
  )
}