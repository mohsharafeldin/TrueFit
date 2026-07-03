// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

/// Delivery preferences can be used to prefill the delivery section at checkout.
public struct CartDeliveryPreferenceInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    deliveryMethod: GraphQLNullable<[GraphQLEnum<PreferenceDeliveryMethodType>]> = nil,
    pickupHandle: GraphQLNullable<[String]> = nil,
    coordinates: GraphQLNullable<CartDeliveryCoordinatesPreferenceInput> = nil
  ) {
    __data = InputDict([
      "deliveryMethod": deliveryMethod,
      "pickupHandle": pickupHandle,
      "coordinates": coordinates
    ])
  }

  /// The preferred delivery methods such as shipping, local pickup or through pickup points.
  ///
  /// The input must not contain more than `250` values.
  public var deliveryMethod: GraphQLNullable<[GraphQLEnum<PreferenceDeliveryMethodType>]> {
    get { __data["deliveryMethod"] }
    set { __data["deliveryMethod"] = newValue }
  }

  /// The pickup handle prefills checkout fields with the location for either local pickup or pickup points delivery methods.
  /// It accepts both location ID for local pickup and external IDs for pickup points.
  ///
  /// The input must not contain more than `250` values.
  public var pickupHandle: GraphQLNullable<[String]> {
    get { __data["pickupHandle"] }
    set { __data["pickupHandle"] = newValue }
  }

  /// The coordinates of a delivery location in order of preference.
  public var coordinates: GraphQLNullable<CartDeliveryCoordinatesPreferenceInput> {
    get { __data["coordinates"] }
    set { __data["coordinates"] = newValue }
  }
}
