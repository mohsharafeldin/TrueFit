// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

/// Represents the reason for the order's cancellation.
public enum OrderCancelReason: String, EnumType {
  /// The customer wanted to cancel the order.
  case customer = "CUSTOMER"
  /// Payment was declined.
  case declined = "DECLINED"
  /// The order was fraudulent.
  case fraud = "FRAUD"
  /// There was insufficient inventory.
  case inventory = "INVENTORY"
  /// Staff made an error.
  case staff = "STAFF"
  /// The order was canceled for an unlisted reason.
  case other = "OTHER"
}
