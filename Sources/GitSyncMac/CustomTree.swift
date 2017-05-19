import Cocoa
@testable import Utils
@testable import Element

class CustomTree{
    lazy var lineGraphic:LineGraphic = {
        let lineGraphic = LineGraphic(CGPoint(50,50),CGPoint(50,-150),LineStyle(1,.blue))
        lineGraphic.draw()
        return lineGraphic
    }()
    lazy var view:NSView = {
        /*RoundRect*/
        //let roundRect = RoundRectGraphic(0,0,50,50,Fillet(10),FillStyle(.blue),nil)
        //addSubview(roundRect.graphic)
        //roundRect.draw()
        
        //let rect = RectGraphic(0,0,50,50,FillStyle(.blue),nil)
        //rect.draw()
        //return roundRect.graphic
        //let view = Element(0,0,100,100)
        /*Line*/
        let textButton:TextButton = TextButton.init(100, 50, self.title, nil)
        return textButton
    }()
    var parent:CustomTree?
    var children:[CustomTree] = []
    var title:String
    var pt:CGPoint = CGPoint()
    lazy var deepest:Int = {CustomTree.deepest(self)}()
    
    init(_ title:String){
        self.title = title
    }
}
extension CustomTree{
    var width:CGFloat {return view.frame.size.width}
    var height:CGFloat {return view.frame.size.height}
}
extension CustomTree{
    /*Return siblings on same level*/
    static func siblings(_ tree:CustomTree,_ level:Int, _ curLevel:Int = 0) -> [CustomTree] {//4
        //Swift.print("tree title: \(tree.title) curLevel: \(curLevel)" )
        if curLevel == level {//correct level
            return [tree]
        }else{
            return tree.children.reduce([]) { result,child in
                return result + siblings(child,level,curLevel + 1)/*not correct level, keep diving*/
            }
        }
    }
    static func deepest(_ tree:CustomTree, _ depth:Int = 0) -> Int{/*num of levels on the deepest node from root*/
        return tree.children.reduce(depth) { deepestDepth, child in
            let curDeepest = deepest(child, depth + 1)
            return curDeepest > deepestDepth ? curDeepest : deepestDepth
        }
    }
    /**
     * So the idea is to evenly position from the center of parent position (inverted tree (aka hierarchy))
     */
    static func distribute(_ tree:CustomTree, _ level:Int, _ prevBound:CGRect){/*recursive*/
        let padding:CGFloat = 10
        Swift.print("distribute tree title: \(tree.title) prevBound: \(prevBound)")
        /*align things here*/
        let siblings = CustomTree.siblings(tree,level)/*siblings are the items that are on the same level*/
        //let count = siblings.count
        Swift.print("siblings.count: " + "\(siblings.count)")
        //figure out how much horizontal space all items take up
        let totW:CGFloat = siblings.reduce(0){
            return $0 + $1.width + padding
        } - padding
        Swift.print("totW: " + "\(totW)")
        Swift.print("prevBound.center.x: " + "\(prevBound.center.x)")
        var x = prevBound.center.x - (totW/2)//center of prev bound - halfTot
        let y = prevBound.bottom.y + padding
        let maxH = siblings.map{$0.height}.reduce(0){$0 > $1 ? $0 : $1}
        let curBound = CGRect(x,y,totW,maxH)
        
        siblings.forEach{ child in
            child.pt = CGPoint(x,y)
            x = (x + child.width + padding)
        }
        
        if level < tree.deepest {
            distribute(tree,level+1,curBound)//go to next level
        }
    }
    /**
     * Recusivly flattens the the treeStructure into a column structure array of tree items
     * TODO: ⚠️️ Use reduce!
     */
    static func flattened(_ tree:CustomTree) -> [CustomTree] {
        var results:[CustomTree] = [tree]
        tree.children.forEach { child in
            if(child.children.count > 0) {/*Array*/
                results += CustomTree.flattened(child)
            }else{/*Item*/
                results.append(child)
            }
        }
        return results
    }
}
