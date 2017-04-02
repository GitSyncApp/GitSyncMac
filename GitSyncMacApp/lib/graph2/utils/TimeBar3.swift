import Cocoa
@testable import Element
@testable import Utils

class TimeBar3:ElasticScrollFastList{
    override func createMover(){
        /*RubberBand*/
        let frame:RubberBand.Frame = (min:0,len:maskSize[dir])//CGRect(0,0,width,height)/*represents the visible part of the content *///TODO: could be ranmed to maskRect
        let itemsRect:RubberBand.Frame = (min:0,len:contentSize[dir])/*represents the total size of the content *///TODO: could be ranmed to contentRect
        mover = SnappyRubberBand(Animation.sharedInstance,setProgress/*👈important*/,frame,itemsRect)
        mover!.event = onEvent/*Add an eventHandler for the mover object, , this has no functionality in this class, but may have in classes that extends this class, like hide progress-indicator when all animation has stopped*/
    }
    override func scrollWheel(with event: NSEvent) {
        super.scrollWheel(with: event)
        /*⚠️️ temp fix for SnappyRubberBand support, move this into a new protocol extension*/
        if(event.phase == .changed || event.phase == NSEventPhase(rawValue:0)){
            let prevDir = (mover! as! SnappyRubberBand).prevDir
            var tempDir:CGFloat = 0
            let curDir:CGFloat = event.scrollingDelta[dir]
            if(curDir == 0){tempDir = prevDir}//use old value
            else if(curDir.isNegative){tempDir = -1}
            else if(curDir.isPositive){tempDir = 1}
            //Swift.print("tempDir: " + "\(tempDir)")
            (mover! as! SnappyRubberBand).prevDir = tempDir
        }
    }
}
