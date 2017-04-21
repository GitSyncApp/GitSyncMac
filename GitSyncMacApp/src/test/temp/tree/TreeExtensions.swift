import Foundation
/**
 * TODO: Subscript?
 */
extension Tree{//maybe treekind isn't needed. Just use Tree?
    /**
     * The num of items in the entire tree
     * NOTE: This should be cached, only re-calc on alteration
     * IMPORTANT: ⚠️️ This is a exhaustive and naive implementation
     * TODO: You should make count a cached variable, only updated on additions and removals
     */
    var count:Int{
        var count:Int = self.children.count
        self.children.forEach{count += $0.count}
        return count
        //return TreeUtils.flattened(self).count + 1// +1 because it self is not added when recursiveFlattening. only self.children is flattened
    }
    /**
     * PARAM: assert: can assert things that a Tree instance must assert to true
     */
    func count(_ assert:TreeUtils.AssertMethod = TreeUtils.defaultAssert)->Int{
        var count:Int = 0
        let isOpen:Bool = assert(self)
        //Swift.print("isOpen: " + "\(isOpen)")
        if(isOpen){
            count = self.children.count
            //Swift.print("🍇 count: " + "\(count)")
            self.children.forEach{count += $0.count(assert)}
        }
        return count
    }
    /**
     * Adds a child to children
     */
    mutating func add(_ child:Tree){
        children.append(child)
    }
    func child(_ at:[Int])-> Tree?{
        return TreeParser.child(self, at)
    }
    func childFlattened(_ at:Int)->Tree?{
        return TreeParser.childFlattened(self, at)
    }
    subscript(at:Int) -> Tree? {
        get {return self.children[at]}
        set {self.children[at] = newValue!}
    }
    subscript(at:[Int]) -> Tree? {
        get {return self.child(at)}
    }
    /**
     * TODO: This could even be a subscript
     */
    mutating func setProp(_ at:[Int], _ prop:(key:String,val:String)) {
        TreeModifier.setProp(&self,at,prop)
    }
    func getProps(_ idx3d:[Int]) -> [String:String]? {
        return self[idx3d]?.props
    }
    func describe(_ tree:Tree,_ key:String, _ level:Int = 0){
        TreeUtils.describe(tree, key, level)
    }
}

/*protocol TreeKind {
 //associatedtype Element
 var children:[TreeKind] {get}
 var props:[String:String]? {get}
 var name:String? {get}
 var content:String? {get}//or use Any or T
 }*/
