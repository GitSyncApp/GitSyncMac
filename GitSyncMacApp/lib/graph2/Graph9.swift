import Cocoa
@testable import Element
@testable import Utils
import GitSyncMac

class Graph9:Element{
    lazy var gestureHUD:GestureHUD  =  GestureHUD(self)
    var dateText:TextArea?
    var timeBar:FastList?
    var valueBar:ValueBar?
    var contentContainer:Element?
    var graphPoints:[Element]?
    var graphLine:GraphLine?
    var graphPts:[CGPoint]?
    var prevGraphPts:[CGPoint]?
    var animator:Animator?
    /*Date vars*/
    let fromYear:Int = 2012
    let toYear:Int = 2017//TODO: swap this out with Date().year
    var range:Range<Int> {return fromYear..<toYear}
    /*Zooming vars*/
    var curZoom:Int = TimeType.year.rawValue
    let maxZoom:Int = 3
    var zoom:CGFloat = 0
    /*Interim*/
    var curTimeType:TimeType = .year
    var visibleRange:Range<Int>?
    override func resolveSkin() {
        StyleManager.addStyle("Graph9{float:left;clear:left;fill:green;fill-alpha:0.0;}")//Needed so that scrollWheel works
        StyleManager.addStylesByURL("~/Desktop/datetext.css")
        super.resolveSkin()
        dateText = addSubView(TextArea(NaN,NaN,"00/00/00 - 00/00/00",self,"date"))/*A TextField that displays the time range of the graph*/
        /**/
        contentContainer = addSubView(Container(width,height,self,"content"))
        createList()
        updateDateText()
        createGraphLine()
        createGraphPoints()
        createValueBar()
        /*Debug*/
        self.acceptsTouchEvents = true/*Enables gestures*/
        self.wantsRestingTouches = true/*Makes sure all touches are registered. Doesn't register when used in playground*/
    }
    override func onEvent(_ event:Event) {
        if(event === (AnimEvent.completed, (timeBar! as! TimeBar3).mover!)){
            Swift.print("Graph9.timeBar completed")
            //Swift.print("event.origin: " + "\(event.origin)")
            updateGraph()
        }
        super.onEvent(event)
    }
}
