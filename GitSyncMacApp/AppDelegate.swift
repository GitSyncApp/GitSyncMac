import Cocoa
@testable import Utils
@testable import Element
@testable import GitSyncMac

/**
 * This is the main class for the application
 * Not one error in a million keystrokes
 */
@NSApplicationMain
class AppDelegate:NSObject, NSApplicationDelegate {
    weak var window:NSWindow!
    var win:NSWindow?/*<--The window must be a class variable, local variables doesn't work*/
    var menu:Menu?//TODO: ⚠️️ make lazy. does it need to be scoped globally?
    
    func applicationDidFinishLaunching(_ aNotification:Notification) {
        Swift.print("GitSync - Automates git")//Simple git automation for macOS, The autonomouse git client,The future is automated
        //initApp()
        
        
        //Continue here: 🏀
            //try with out disableAnim
            //Add more types to Easer/Springer
            //try to do a rotation test back and forth with elastic
            //Playground testing
        //add interuptabable animators to the fold
        peekAndPopTest()
    }
    /**
     * NOTE: Use ButtonEvent.down to listen for mouseDown events
     */
    class ForceTouchButtonEvent:Event{
        static var click:String = "forceTouchButtonClick"/*Stage 1 - forceTouch click*/
        static var deepClick:String = "forceTouchButtonDeepClick"/*Stage 2 - forceTouch click*/
        static var pressureChange:String = "forceTouchButtonPressureChangek"/*Stage 2 - forceTouch click*/
        //continue here:
            //pressure just return 0 - 2 and then use min max to get stage 1 and stage 2 pressures, you can add this via extensions 👌
            //stage 1 pressure 0-1
            //stage 2 pressure 0-1
        weak var event:NSEvent
        init(_ type:String = "", _ origin:AnyObject,_ event:NSEvent){
            self.event = event
            super.init(type, origin)
        }
        var pressure:CGFloat {
            return event.pressure.cgFloat
        }
    }
    class ForceTouchButton:Button{
        var prevState = 0
        override func pressureChange(with event: NSEvent) {
            let curState:Int = event.stage
            if event.pressureBehavior == NSPressureBehavior.primaryDeepClick {
                if prevState != curState {
                    if curState == 1 {
                        super.onEvent(ForceTouchButtonEvent(ForceTouchButtonEvent.click,self,event))
                    }else if curState == 2{
                        super.onEvent(ForceTouchButtonEvent(ForceTouchButtonEvent.deepClick,self,event))
                    }
                    prevState = curState
                }
                super.onEvent(ForceTouchButtonEvent(ForceTouchButtonEvent.pressureChange,self,event))
            }
            
        }
        override func getClassType() -> String {
            return "\(Button.self)"
        }
    }
    /**
     * It's all about making bespoke interactions 👌
     */
    func peekAndPopTest(){
        //1. circular button,centered
            //window
        let winRect = CGRect(0,0,200,300)
        window.size = winRect.size
        window.contentView = InteractiveView2()
        window.title = ""
        
        StyleManager.addStyle("#bg{fill:white;}")
        window.contentView?.addSubview(Section(window.size.w,window.size.h,nil,"bg"))
        
        let startRect:CGRect = {
            let size:CGSize = CGSize(70,70)
            let p:CGPoint = Align.alignmentPoint(size, winRect.size, Alignment.centerCenter, Alignment.centerCenter)
            return CGRect(p,size)
        }()
        
        
        let btn:Button = {//button
            StyleManager.addStyle("#btn{fill:blue,fillet:20px;;clear:none;float:none;}")
            let btn = window.contentView!.addSubView(ForceTouchButton(startRect.w,startRect.h,nil,"btn"))
            btn.point = startRect.origin//center button
            return btn
        }()
        
       
        func onViewEvent(_ event:Event) {/*This is the click on window event handler*/
            if event.type == ButtonEvent.upInside {
                Swift.print("upInside()")
            }
        }
        
        btn.event = onViewEvent
            //event handler for deep press
        
        //2. hardpress button to activate pop
        
        //3. spring circular button into bigger square modal, centered
        
        //4. spring modal in the .y axis to your mouse.position, offset by center
        
        //5. when modal.bottom moves beyond a threshold, spring in button bellow modal (you may need to dto the relational spring test first)
        
        //6. when button release in peek mode, transition modal to button
        
        //7. when button release in input mode, dont transition anything
        
        //8. when user clicks the button bellow modal, transition modal to circular button and spring inputButton bellow screen
    }
    func initApp(){
        NSApp.windows[0].close()/*<--Close the initial non-optional default window*/
        
        let themeStr:String = PrefsView.prefs.darkMode ? "dark.css" : "light.css"
        StyleManager.addStylesByURL("~/Desktop/ElCapitan/styletest/" + themeStr,true)
        
        //StyleWatcher.watch("~/Desktop/ElCapitan/","~/Desktop/ElCapitan/gitsync.css", self.win!.contentView!)
        let rect:CGRect = PrefsView.prefs.rect
        win = StyleTestWin(rect.w, rect.h)/*⬅️️🚪*/
        menu = Menu()/*This creates the App menu*/
    }
    func applicationWillTerminate(_ aNotification:Notification) {
        _ = FileModifier.write(Config.prefs.tildePath, PrefsView.xml.xmlString)/*Stores the app prefs*/
        Swift.print("💾 Write PrefsView to: prefs.xml")
        _ = FileModifier.write(Config.repoListFilePath.tildePath, RepoView.treeDP.tree.xml.xmlString)/*store the repo xml*/
        Swift.print("💾 Write RepoList to: repo.xml")
        print("Good-bye")
    }
}
