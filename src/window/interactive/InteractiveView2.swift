import Cocoa
/**
 * IMPORTANT: To understand the relatioship between NSEvent and hitTest: think of NSEvent as going upStream in an inverted pyramid hirarachy and hitTest going downStream in the same hirarachy
 * TODO: Make the isChildrenInteractive:Bool -> You may want to make a variable that also can set the isInteractive var of children of the view:
 * CAUTION: seems to not work as a container for i.e Adding a button to a View instance (for now use FlippedView when using it as a container)
 * NOTE: Remember to override the mouseDown method in subclasses if you want to add functionality to the mouseDown action
 * NOTE: Use mouseDragged method if you want to call a method while the mouse is dragged
 * NOTE: If you hi-jack the event handler variable then the parent will not recieve any events. Its better to override onEvent (one could us emany seletors but that would complicate the code. its simple enough to overide onEvent)
 * NOTE: its primary use-case is to wrap NSEvents into Event so that the view hierarchy can retrieve the view where the event came from which is not possible when using NSEvent. NSEvent cant be subclasses so this is the best solution I've found for this particular use-case.
 */
class InteractiveView2:FlippedView,IInteractiveView{
    var event: ((Event) -> ())?/*this holds any method assigned to it that has its type*/
    var eventCall:((Event) -> ())? {
        return {
                (event:Event) -> Void in if(self.superview is IEventSender){(self.superview as! IEventSender).onEvent(event.setImmediate(self))
            }
        }
    }//returns closure that will take care of propagating the event to the parent
    var isInteractive:Bool = true//why is this here? I guess so that you can toggle the interactive part on and of, Text uses this variable, remember that this effects all descendants as well
    var isMouseOver:Bool = false;/*you should hit test this on init*/
    var hasMouseEntered:Bool = false/*you should hit test this on init*/
    var hasHandCursor:Bool = false
    /*this can probably be removed--->*/override var wantsDefaultClipping:Bool{return false}//avoids clipping the view
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true/*if true then view is layer backed*/
        layer = CALayer()/*needs to be layer-hosted so that we dont get clipping of children*/
        layer!.masksToBounds = false//this is needed!!!
        //event = onEvent/*assign method to selector*/
        //event = eventCall
    }
    /**
     * EXAMPLE: override onEvent in a subClass then assert origin === thumb && event.type == ButtonEvent.down 
     */
    func onEvent(event:Event){
        //Swift.print("InteractiveView2.onEvent: " + "\(onEvent)")
        //if(self.superview is IEventSender){(self.superview as! IEventSender).event!(event.setImmediate(self))}
        self.event!(event)
    }
    /**
     * MouseMove (only fires when the mouse is actualy moving on the visible  part of the view)
     * NOTE: It could be possible to only call this method if a bool value was true. Optimization
     * TODO: when you implement propegation of the mouseMove method, mousemove needs a bool to turn it on or it will flood its parents with calls, isMouseMovable could be used
     * NOTE: if you override this method in subclasses, then also call the the super of this method to avoid loss of functionality
     */
    func mouseMoved(event:MouseEvent){
        //Swift.print("\(self.dynamicType)" + "mouseMoved() ")
        if(self.superview is IInteractiveView){(self.superview as! IInteractiveView).mouseMoved(event.setImmediate(self) as! MouseEvent)}/*informs the parent that an event occured*/
    }
    /**
     * Only fires if the mouse is over the visible part of this view 
     * NOTE: you have to implement a hitTest that aserts that the aPoint is within the path. (either in the CALayer or at the last hitTesable NSView in your stack)
     */
    func mouseOver(event:MouseEvent){
        //Swift.print("\(NSViewParser.parents(self))" + "\(self.dynamicType)" + ".mouseOver() ")
        if(self.superview is IInteractiveView){(self.superview as! IInteractiveView).mouseOver(event.setImmediate(self) as! MouseEvent)}/*informs the parent that an event occured*/
    }
    /**
     * Only fires if the mouse is "rolls" out of the visible part of this view
     */
    func mouseOut(event:MouseEvent){
        //Swift.print("\(self.dynamicType)" + ".mouseOut() ")
        if(self.superview is IInteractiveView){(self.superview as! IInteractiveView).mouseOut(event.setImmediate(self) as! MouseEvent)}/*informs the parent that an event occured*/
    }
    /**
     * Same as regular mouseDown event except this also includes the origin
     */
    func mouseDown(event:MouseEvent){
        //Swift.print("\(NSViewParser.parents(self))" + "mouseDown() ")
        if(self.superview is IInteractiveView){(self.superview as! IInteractiveView).mouseDown(event.setImmediate(self) as! MouseEvent)}/*informs the parent that an event occured*/
    }
    /**
     * Handles actions and drawing states for the release event.
     * @Note: bubbling= true was added to make Stepper class dragable
     */
    func mouseUpInside(event: MouseEvent){
        //Swift.print("\(self.dynamicType)" + "mouseUpInside() ")
        if(self.superview is IInteractiveView){(self.superview as! IInteractiveView).mouseUpInside(event.setImmediate(self) as! MouseEvent)}/*informs the parent that an event occured*/
    }
    /**
     * Handles actions and drawing states for the mouseUpOutside event.
     * @Note: bubbling = true was added to make Stepper class dragable
     */
    func mouseUpOutside(event: MouseEvent){
        //Swift.print("\(self.dynamicType)" + "mouseUpOutside() ")
        if(self.superview is IInteractiveView){(self.superview as! IInteractiveView).mouseUpOutside(event.setImmediate(self) as! MouseEvent)}/*informs the parent that an event occured*/
    }
    /**
     * this method exists for the sake of convenience
     */
    func mouseUp(event: MouseEvent){
        //Swift.print("\(self.dynamicType)" + "mouseUp() ")
        if(self.superview is IInteractiveView){(self.superview as! IInteractiveView).mouseUp(event.setImmediate(self) as! MouseEvent)}/*informs the parent that an event occured*/
    }
    /**
     * NOTE: if you override this method in subclasses, then also call the the super of this method to avoid loss of functionality
     */
     /*func mouseUp(event:MouseEvent){
     if(self.superview is InteractiveView2){(self.superview as! InteractiveView2).mouseDown(event)}/*informs the parent that an event occured*/
     }*/
    /**
     * MouseMoved
     * NOTE: there is also mouseDragged, you could forward it to a generic method, and do the same with mouseMoved. so that there wouldnt be duplicate code. since they have the same functionality. you could then use: if(NSEvent.pressedMouseButtons() == 1 << 0){"left is pressed"} to detect if mouse was dragged. or not. Maybe keeping these methods seperatly improves readbility, optimization etc
     * NOTE: mouseMoved doesnt work if the leftmouse button is pressed, then mouseDragged is used instead
     */
    override func mouseMoved(theEvent: NSEvent) {
        if(hasMouseEntered){/*Only run the following code when inside the actual TrackingArea*/
            if(viewUnderMouse === self){//mouse move on the "visible" part of the view
                if(!isMouseOver){mouseOver(MouseEvent(theEvent,self/*,self*/));isMouseOver = true;}
                mouseMoved(MouseEvent(theEvent,self/*,self*/))
            }
            else if(isMouseOver){mouseOut(MouseEvent(theEvent,self/*,self*/));isMouseOver = false;}//mouse move on the "invisible" parth of the view
        }
    }
    /**
     * Fires when the mouse enters the tracking area, regardless if it is overlapping with other trackingAreas of other views
     * NOTE: if you override this method in subclasses, then also call the the super of this method to avoid loss of functionality
     */
    override func mouseEntered( event: NSEvent){
        //Swift.print("\(self.dynamicType)" + ".mouseEntered(): event.locationInWindow" + "\(event.locationInWindow)")//+ "\(viewUnderMouse)" + " self: " + "\(self)"
        
        //im not sure if the bellow code is perfectly stable in all cases, more testing needed
        
        if(!hasMouseEntered && viewUnderMouse === self){
            hasMouseEntered = true;/*optimization*/
            isMouseOver = true;
            mouseOver(MouseEvent(event,self/*,self*/));
        }//mouse move on visible view
        //super.mouseEntered(event)/*passes on the event to the nextResponder, NSView parents etc*/
    }
    /**
     * Fires when the mouse exits the tracking area, regardless if it is overlapping with other trackingAreas of other views
     * NOTE: if you override this method in subclasses, then also call the the super of this method to avoid loss of functionality
     */
    override func mouseExited(event: NSEvent){
        //Swift.print("\(self.dynamicType)" + ".mouseExited: event.locationInWindow: " + "\(event.locationInWindow)")
        
        //im not sure if the bellow code is perfectly stable in all cases, more testing needed
        
        if(hasMouseEntered && isMouseOver){
            hasMouseEntered = false/*optimization*/;
            isMouseOver = false;
            mouseOut(MouseEvent(event,self/*,self*/));
        }
        //super.mouseExited(event)/*passes on the event to the nextResponder, NSView parents etc*/
    }
    override func mouseDown(theEvent: NSEvent) {mouseDown(MouseEvent(theEvent,self/*,self*/))}
    override func mouseUp(theEvent: NSEvent) {
        viewUnderMouse === self ? mouseUpInside(MouseEvent(theEvent,self/*,self*/)) : mouseUpOutside(MouseEvent(theEvent,self/*,self*/));/*if the event was on this button call triggerRelease, else triggerReleaseOutside*/
        mouseUp(MouseEvent(theEvent,self/*,self*/))
    }
    /**
     * NOTE: looping backwards is very important as its the only way to target the front-most views in the stack
     * NOTE: why is this needed? because normal hitTesting doesnt work if the frame size is zero. or if a subView is outside the frame.
     */
    override func hitTest(aPoint: NSPoint) -> NSView? {
        //Swift.print("hitTest: " + "\(self)" + " isInteractive: " + "\(isInteractive)")
        //super.hitTest(aPoint)
        if(isInteractive){
            for var i = self.subviews.count-1; i > -1; --i{//<--you could store the count outside the loop for optimization, i dont know if this is imp in swift
                let view = self.subviews[i]
                let hitView = view.hitTest(aPoint)/*if true then a point was found within its hittable area*/
                //Swift.print("view: " + "\(view)" + "hitView: " + "\(hitView)")
                if(hitView != nil){
                    //Swift.print("hitView: " + "\(hitView!.superview!.superview)")
                    return hitView
                }//<--if the view is a skin then return the self, so that the mouseEnter mouseExit methods work
            }
            return nil/*if no hitView is found return nil, the parent hitTest will then continue its search through its siblings etc*/
        }/*else (aka not interactive)*/
        return nil
    }
    /**
     * Enables the hand cursor on enter
     */
    override func resetCursorRects() {
        if(hasHandCursor){
            let cursor:NSCursor = NSCursor.pointingHandCursor()
            addCursorRect(frame, cursor: cursor)
            cursor.setOnMouseEntered(true)
        }else{super.resetCursorRects()}
    }
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}
/**
 * TODO: add to private utils class
 */
extension InteractiveView2{
    /**
     * Returns a correctly flipped coordinate of the mouse in window space 0,0
     * @NOTE: there may be a problem with this if the window has a titleBar, then the height of this may need to be included
     */
    var winMousePos:CGPoint {
        var pos = (window?.mouseLocationOutsideOfEventStream)!//convertPoint((window?.mouseLocationOutsideOfEventStream)!, fromView: nil)/*converts the p to local coordinates*/
        pos.y = WindowParser.height(window!) - pos.y/*flips the window coordinates*/
        return pos
    }
    var viewUnderMouse:NSView?{
        let theHitView = window!.contentView?.hitTest((window?.mouseLocationOutsideOfEventStream)!)
        return theHitView
    }
}
/**
 * Reasearch, these can be deprecated
 */
class InteractionUtils{
    /**
     * This method finds the immediate origin. Aka the first descendant of current
     */
    func immediate(current:NSView,_ origin:NSView)->NSView{//origin may be a CALayer, test this later
        var view:NSView = origin
        while(view.superview != current) {
            view = view.superview!
        }
        return view;
    }
    /**
     * origin equals target or origin descendes from target
     * @param origin: the result of hitTest()
     * @param target: i.e button1 or slider or some other UI component.
     */
    func withinScope(origin:NSView,_ target:NSView)->Bool{
        return origin === target || origin.isDescendantOf(target)
    }
}

