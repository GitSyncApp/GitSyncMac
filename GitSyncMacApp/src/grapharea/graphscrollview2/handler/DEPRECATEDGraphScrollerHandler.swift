import Cocoa
@testable import Utils
@testable import Element

class GraphScrollerHandler:ElasticScrollerHandler5,GraphScrollerDecorator{
    /**
     * When the the user scrolls
     * NOTE: this method overides the Native NSView scrollWheel method
     * //TODO: ⚠️️ You need to make an scroolWheel method that you can override down hierarchy.
     * NOTE: Basically when you perform a scroll-gesture on the touch-pad
     */
    override func onScrollWheelChange(_ event:NSEvent){/*Direct and indirect scroll*/
        if event.phase == NSEvent.Phase.changed {/*this is only direct manipulation, not momentum*/
            //Swift.print("moverGroup!.result.x: " + "\(moverGroup!.result.x)")
            frameTick()
        }
        //Swift.print("👻📜 (ElasticScrollable3).onScrollWheelChange : \(event.type) ")
        moverGroup.value += event.scrollingDelta/*Directly manipulate the value 1 to 1 control*/
        moverGroup.updatePosition(true)/*the mover still governs the resulting value, in order to get the displacement friction working*/
        let p:CGPoint = moverGroup.result
        setProgress(p)
    }
    override func setProgress(_ point:CGPoint){
        
        //Swift.print("override setProgress")
//        disableAnim {}
        contentContainer.layer?.position = CGPoint(point.x,0)//moves the contentContainer (locks it into hor movement)
    }
}

