import Cocoa
import With_mac
/**
 * - Abstract: PrefsList is a ScrollView with a tableView set to the contentView
 */
class PrefsList: NSScrollView {
   lazy var rowData: [CellDataKind] = self.createRows()
   //lazy var scrollView : NSScrollView = createScrollView()
   lazy var table: NSTableView = createTable()
   /**
    * ## Example:
    * .init()
    */
   override init(frame: CGRect = .zero){
//      self.rowData = crate
      Swift.print("prefslist.init()")
      super.init(frame: frame)
      
      self.autohidesScrollers = true
      self.borderType = .noBorder
      self.hasHorizontalScroller = false
      self.hasVerticalScroller = true
      table.reloadData() // might be not needed?
      table.selectionHighlightStyle = .none
   }
   /**
    * Boilerplate
    */
   required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
//$0.translatesAutoresizingMaskIntoConstraints = false
