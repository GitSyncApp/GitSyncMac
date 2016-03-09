import Cocoa

class CustomView:WindowView{
    var section:Section?
    var closeButton:Button?
    var minimizeButton:Button?
    var maximizeButton:Button?
    /**
     * Add content here
     */
    override func resolveSkin() {
        super.resolveSkin()
        createTitleBar()
    }
    /**
     * Adds close button, min, max
     */
    func createTitleBar(){
        //Swift.print("CustomView.createTitleBar()")
        StyleManager.addStylesByURL("~/Desktop/css/titleBar.css")
        section = self.addSubView(Section(frame.width,16,self,"titleBar")) as? Section
        closeButton = section!.addSubView(Button(0,0,section!,"close")) as? Button/*<--TODO: the w and h should be NaN, test if it supports this*/
        minimizeButton = section!.addSubView(Button(0,0,section!,"minimize")) as? Button
        maximizeButton = section!.addSubView(Button(0,0,section!,"maximize")) as? Button
    }
    /**
     *
     */
    override func setSize(width:CGFloat,_ height:CGFloat){
        //Swift.print("CustomView.setSize() size: " + "\(size)")
        //self.skin!.setSize(size.width, size.height)
        super.setSize(width, height)
        section!.setSize(width, section!.height)
    }
    /**
     *
     */
    func onCloseButtonReleaseInside() {
        Swift.print("onCloseButtonReleaseInside")
        //Close window here
        //self.window?.close()//this closes the window
        NSApp.terminate(self)//quits the app
    }
    /**
     *
     */
    func onMinimizeButtonReleaseInside(){
        Swift.print("onMinimizeButtonReleaseInside")
        //minimize the window here
        
        //NSApp.miniaturizeAll(self)//minimizes all windows in the app
        self.window?.miniaturize(self)
    }
    /**
     * TODO: Add support for fullscreen mode aswell: window.setFrame(NSScreen.mainScreen()!.visibleFrame, display: true, animate: true)
     * TODO: add support for zooming back to normal size
     */
    func onMaximizeButtonReleaseInside(){
        Swift.print("onMaximizeButtonReleaseInside")
        //maximize the window here
        self.window?.zoom(self)
    }
    /**
     *
     */
    func onTestButtonDown(){
        Swift.print("onTestButtonDown")
    }
    /**
     *
     */
    override func onEvent(event: Event) {
        //Swift.print( "CustomView.onEvent() event:" + "\(event)")
        //Swift.print("CustomView.onEvent: " + "\(event)" + " event.origin: " + "\(event.origin)")
        if(event.origin === closeButton && event.type == ButtonEvent.upInside){onCloseButtonReleaseInside()}
        else if(event.origin === minimizeButton && event.type == ButtonEvent.upInside){onMinimizeButtonReleaseInside()}
        else if(event.origin === maximizeButton && event.type == ButtonEvent.upInside){onMaximizeButtonReleaseInside()}
    }
}
