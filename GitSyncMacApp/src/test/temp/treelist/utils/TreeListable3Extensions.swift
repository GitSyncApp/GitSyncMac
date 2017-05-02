import Foundation
@testable import Utils

extension TreeListable3 {
    //add convenience methods here
    var selected:Tree? {return TreeList3Parser.selected(self)}
    func open(_ idx3d:[Int]){/*Convenience*/
        TreeList3Modifier.open(self, idx3d)
    }
    func close(_ idx3d:[Int]){/*Convenience*/
        TreeList3Modifier.close(self, idx3d)
    }
    func select(_ idx3d:[Int],_ isSelected:Bool = true) {
        TreeList3Modifier.select(self, idx3d, isSelected)
    }
    func explode(_ idx3d:[Int]) {
        TreeList3AdvanceModifier.explode(self, idx3d)
    }
    func collapse(_ idx3d:[Int]){
        TreeList3AdvanceModifier.collapse(self, idx3d)
    }
    func unSelectAll(){
        TreeList3Modifier.unSelectAll(self)
    }
    func insert(_ idx3d:[Int],_ tree:Tree){
        TreeList3Modifier.insert(self,idx3d,tree)
    }
    func remove(_ idx3d:[Int]){
        TreeDP2Modifier.remove(self.treeDP, idx3d)
    }
    func append(_ idx3d:[Int],_ child:Tree){
        TreeDP2Modifier.append(self.treeDP, idx3d, child)
    }
    var selectedIdx3d:[Int]? {return TreeList3Parser.selected(self)}
    var xml:XML {return self.treeDP.tree.xml}
}
