import Foundation
@testable import Element
@testable import Utils

class FindPointOnGraphTest:Element{
    typealias P = CGPoint
    var points:[CGPoint] = []
    override func resolveSkin() {
        super.resolveSkin()
        addGraphLine()
        addGraphPoint()
    }
    //add point to interactive graph
    //you just offset the x when the graph moves
    //you add asserts if the x is beyond start or end, then default to first and last seg
    //add dots for start and end
    //remember the x will give you virtual y values you get from the data set. then you ue these to add to your max value calculation 👉 that you use to
    //scale back to scrool only for test
}
extension FindPointOnGraphTest{
    func addGraphLine(){
        addGraphLineStyle()
        
        points = (0..<6).map{
            let x:CGFloat = 100*$0
            let y:CGFloat = (0..<(height.int-32)).random.cgFloat
            return P(x,y)
        }
        
        let path:IPath = PolyLineGraphicUtils.path(points)
        let graphLine = self.addSubView(GraphLine(width,height,path))
        _ = graphLine
    }
    /**
     *
     */
    func addGraphPoint(){
        
        let x:CGFloat = 150
        
        var seg:(p1:P,p2:P)?
        for i in 0..<points.count-1{
            let cur = points[i]
            let next = points[i+1]
            if(x >= cur.x && x <= next.x){//within
                seg = (cur,next)
                break
            }
        }
        Swift.print("seg: " + "\(seg)")
        let slope:CGFloat = CGPointParser.slope(seg!.p1, seg!.p2)
        Swift.print("slope: " + "\(slope)")
        let y:CGFloat = CGPointParser.y(seg!.p1, x, slope)/*seg!.p2.x*/
        let p:P = P(x,y)
        Swift.print("-p-: " + "\(p)")
        
        addGraphPointStyle()
        let graphPoint:Element = self.addSubView(Element(NaN,NaN,self,"graphPoint"))
        graphPoint.setPosition(p)
    }
    /**
     *
     */
    func addGraphLineStyle(){
        var css:String = "GraphLine{"
        css +=    "float:none;"
        css +=    "clear:none;"
        css +=    "line:#2AA3EF;"
        css +=    "line-alpha:1;"
        css +=    "line-thickness:0.5px;"
        css += "}"
        StyleManager.addStyle(css)
    }
    /**
     *
     */
    func addGraphPointStyle(){
        
        /*GraphPoint*/
        var css:String = ""
        css += "Element#graphPoint{"
        css +=     "float:none;"
        css +=     "clear:none;"
        css +=     "fill:#128BF2,#192633;"
        css +=     "width:12px,11px;"
        css +=     "height:12px,11px;"
        css +=     "margin-left:-6px,-5.5px;"
        css +=     "margin-right:6px,5.5px;"
        css +=     "margin-top:-6px,-5.5px;"
        css +=     "margin-bottom:6px,5.5px;"
        css +=     "drop-shadow:drop-shadow(1px 90 #000000 0.3 0.5 0.5 0 0 false);"
        css +=     "corner-radius:6px,5.5px;"
        css += "}"
        StyleManager.addStyle(css)
    }
}
