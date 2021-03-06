import Foundation
/**
 * Const
 */
extension Button {
   //Default closure
   public static let defaultUpInside: UpInsideCallBack = {}
   public static let defaultUpOutside: UpOutsideCallBack = {}
   public static let defaultUp: UpCallBack = {}
   public static let defaultDown: DownCallBack = {}
   #if os(macOS)
   public static let defaultOver: OverCallBack = {}
   public static let defaultOut: OutCallBack = {}
   #endif
   /*Style*/
   public static let defaultStyle: Style = (.white, .black, 1, false)
   public static let alternateStyle: Style = (.black, .white, 1, false)
}
