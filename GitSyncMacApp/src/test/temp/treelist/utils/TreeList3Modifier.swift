import Foundation

class TreeList3Modifier {
    /**
     * Sets a selectable in PARAM: treeList at PARAM: index (array index)
     * NOTE: this does not unselect previously selected items.
     */
    static func select(_ treeList:TreeListable3, _ idx3d:[Int],_ isSelected:Bool = true) {
        if let idx2d:Int = TreeList3Parser.idx2d(treeList, idx3d){//get idx2d
            FastList3Modifier.select(treeList, idx2d, isSelected)
        }
    }
    /**
     *
     */
    static func open(_ treeList:TreeList3, _ idx3d:[Int]){
        if let idx2d:Int = treeList.treeDP[idx3d]{
            TreeDP2Modifier.open(treeList.treeDP, idx2d)
        }
    }
    /**
     *
     */
    static func close(_ treeList:TreeList3, _ idx3d:[Int]){
        if let idx2d:Int = treeList.treeDP[idx3d]{
            TreeDP2Modifier.close(treeList.treeDP, idx2d)
        }
    }
    /**
     * NOTE: To explode the entire treeList pass an empty array as PARAM: index
     */
    static func explodeAt(_ treeList:TreeListable3,_ idx3d:[Int]) {
        if let isOpen = treeList.treeDP.tree.props?["isOpen"]  {/*if has isOpen param and its set to false*/
            if isOpen == "true" {//already open
                //remove descendants
            }
            //Continue here: 🏀
                //make a method that traverses down hierarchy
            //traverse all items and set to open
            //add all descedants to 2d list
            //use the count to update DP and UI
            //tree.props?["isOpen"] = "true"/*Set it to true*/
        }
        let apply:TreeModifier.ApplyMethod = {tree in
            
        }
        TreeModifier.apply(&treeList.treeDP.tree, idx3d, apply)
    }
    typealias KeyValue = (key:String,val:String)
    typealias Apply = (_ tree:inout Tree, _ prop:KeyValue) -> Void
    
    static var setValue:Apply = {tree,prop in
        tree.props?[prop.key] = prop.val
    }
    /**
     *
     */
    static func recursiveApply(_ tree:Tree, _ apply:Apply, _ prop:KeyValue){
        if let child:Tree = tree[idx3d]{
            apply(child)
            child.children.forEach {
                recursiveApply($0,idx3d,apply,prop)
            }
        }
    }
    static func recursiveApply(_ tree:Tree,_ idx3d:[Int], _ apply:Apply, _ prop:KeyValue){
        if let child:Tree = tree[idx3d]{
            apply(child)
            child.children.forEach {
                recursiveApply($0,idx3d,apply,prop)
            }
        }
    }
    /**
     * NOTE: To collapse the entire treeList pass an empty array as PARAM: index
     * NOTE: This method collapses all nodes from the PARAM: index
     */
    static func collapseAt(_ treeList:TreeListable3,_ idx3d:[Int]) {
        
    }
}
