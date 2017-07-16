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
        //jsonTest()
        
        //initApp()
        //stateTest()
        //themeSwitchTest()
        //testGraphXTest()
        //testGraphView2()
        
        targetAnimationTest()
       
    }
    /**
     *
     */
    func targetAnimationTest(){
        //animate to to target
        //then we change the target and the ball should gravitate towards this new target
        
        //Setup a window
        window.size = CGSize(664,400)
        window.contentView = InteractiveView2()
        
        StyleManager.addStyle("#bg{fill:green;}")
        let bg = window.contentView?.addSubView(Button(window.size.w,window.size.h,nil,"bg"))
        
        
        /*Ellipse*/
        let ellipse = EllipseGraphic(-50,-50,100,100,FillStyle(.blue),nil)
        window.contentView?.addSubview(ellipse.graphic)
        ellipse.draw()
        
        
        
        //setup Mover animator
        
        var spring:CGFloat = 0.02
        var targetX:CGFloat = 0
        var vx:CGFloat = 0
        var friction:CGFloat = 0.95
        
        func progress(value:CGFloat){
            let dx:CGFloat = targetX - (ellipse.graphic.point.x)
            let ax:CGFloat = dx * spring
            vx += ax
            vx *= friction
            ellipse.graphic.point.x += vx
        }
        
        let animator = FrameTicker(Animation.sharedInstance,progress)
        //setup click on window event handler
        func onViewEvent(_ event:Event) {
            //Swift.print("onViewEvent: " + "\(event)")
            if let buttonEvent = event as? ButtonEvent, buttonEvent.type == ButtonEvent.upInside {
                //Swift.print("bg upInside")
                //Swift.print("buttonEvent.loc: " + "\(buttonEvent.loc)")
                //Swift.print("bg.localPos(): " + "\(bg?.localPos())")
                vx = 0
                targetX = (bg?.localPos().x)!
                animator.stop()
                animator.start()
            }
        }
        bg?.event = onViewEvent
  
        //update mover target on window event mouseUpEvent

    }
    /**
     * Testing the zoomable and bouncing graph
     */
    func testGraphXTest(){
        Swift.print("Hello GraphX")
        
        window.size = CGSize(664,400)
        window.contentView = InteractiveView2()
        StyleManager.addStylesByURL("~/Desktop/ElCapitan/graphx/graphxtest.css",true)
        
        let winSize:CGSize = WinParser.size(window)
        let graph = window.contentView!.addSubView(GraphX(winSize.w,winSize.h))
        _ = graph
    }
    /**
     * Earlier test that modulates the graph while you scroll
     */
    func testGraphView2(){
        window.size = CGSize(664,400)
        window.contentView = InteractiveView2()
        let winSize:CGSize = WinParser.size(window)
        let test = window.contentView!.addSubView(GraphView2(winSize.w,winSize.h))
        _ = test
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
/*
func themeSwitchTest(){
    
    //Continue here: 🏀
    //deprecated the last of gitsync old css files ✅
    //setup the themes for styleTest 👈
    //You then store the colors in light and dark theme ✅
    //then hook up the switch to the css switcher code ✅
    //COntinue here:
    
    window.contentView = InteractiveView2()
    
    StyleManager.addStylesByURL("~/Desktop/theme/lighttheme.css")
    
    let section = window.contentView!.addSubView(Section(200,300))
    let btn = section.addSubView(Button(NaN,NaN,section,"btn"))
    _ = section.addSubView(Element(100,100,section,"one"))
    
    btn.event = { event in
        if event.type == ButtonEvent.upInside {
            Swift.print("value: " + "\(StyleManager.getStylePropVal("Theme", "fill"))")//white
            StyleManager.reset()
            StyleManager.addStylesByURL("~/Desktop/theme/darktheme.css")
            ElementModifier.refreshSkin(section)
            Swift.print("newVal: " + "\(StyleManager.getStylePropVal("Theme", "fill")))")//black
        }
    }
}
func stateTest(){
    window.contentView = InteractiveView2()
    var css:String = "#btn{fill:blue;width:100px;height:24px;float:left;clear:left;}"
    css += "#green{fill:green;clear:left;float:left;display:block;}"
    css += "#green:hidden{fill:orange;display:none;}"
    StyleManager.addStyle(css)
    
    let section = window.contentView!.addSubView(Section(200,300))
    let btn = section.addSubView(Button(NaN,NaN,section,"btn"))
    
    let one = section.addSubView(Element(100,100,section,"green"))
    btn.event = { event in
        if event.type == ButtonEvent.upInside {
            Swift.print("test")
            one.setSkinState("hidden")
        }
    }
}
*/
/*
func jsonTest(){
    Swift.print("jsonTest")
    /*JSONParser.dictArr("[{\"title\":\"doctor\"}]".json)?.forEach{
     Swift.print("\(JSONParser.dict($0)?["title"])")//doctor
     }*/
    //let content = "~/Desktop/gitsync.json".content
    //Swift.print("content: " + "\(content)")
    //let json = "~/Desktop/gitsync.json".content!.json
    //Swift.print("json: " + "\(json)")
    //let dict = JSONParser.dict("~/Desktop/gitsync.json".content?.json)
    //Swift.print("dict: " + "\(dict)")
    
    StyleManager.addStylesByURL("~/Desktop/ElCapitan/styletest.css")
    JSONParser.dictArr(JSONParser.dict("~/Desktop/gitsync.json".content?.json)?["repoDetailView"])?.forEach{
        if let element:IElement = UnFoldUtils.unFold($0) {
            Swift.print("created an element")
            _ = element
        }else{
            Swift.print("did not create an element")
        }
    }
}*/
//paddingTest()
//calcTest()
/*
 func initTestWin(){
 //StyleManager.addStylesByURL("~/Desktop/ElCapitan/explorer.css",false)
 StyleManager.addStylesByURL("~/Desktop/ElCapitan/test.css",false)
 win = TestWin(500,400)/*Debugging Different List components*/
 
 /*fileWatcher =*/
 //StyleWatcher.watch("~/Desktop/ElCapitan/","~/Desktop/ElCapitan/gitsync.css", self.win!.contentView!)
 }
 
 
 func initMinimalWin(){
 NSApp.windows[0].close()
 StyleManager.addStylesByURL("~/Desktop/ElCapitan/minimal.css",true)
 //Swift.print("StyleManager.styles.count: " + "\(StyleManager.styles.count)")
 //Swift.print("StyleManager.styles: " + "\(StyleManager.styles)")
 win = MinimalWin(500,400)
 }
 
 */
/*class Label:Flexible{
    //graphic bg
    //text that is centeres
    //implement Flexible
    // that also repos the text etc
    lazy var txtBtn:NSView = {
        let textButton:TextButton = TextButton.init(self.w, self.h, self.title, nil)
        return textButton
    }()
    init(_ rect:CGRect){
        
    }
}*/

/*
/**
 *
 */
func calcTest(){
    window.contentView = InteractiveView2()
    var css:String = "#btn{fill:blue;width:calc(100% -20px);height:50;float:left;clear:left;}"
    css += "Section{fill:silver;padding:12px;}"
    StyleManager.addStyle(css)
    
    let section = window.contentView!.addSubView(Section(200,200))
    let btn = section.addSubView(Element(NaN,NaN,section,"btn"))
    
    section.addSubview(btn)
}
func paddingTest(){
    window.contentView = InteractiveView2()
    var css:String = "#btn{fill:blue;width:100%;height:100%;float:left;clear:left;}"
    css += "Section{fill:silver;padding:12px;}"
    StyleManager.addStyle(css)
    
    let section = window.contentView!.addSubView(Section(200,300))
    let btn = section.addSubView(Element(NaN,NaN,section,"btn"))
    
    section.addSubview(btn)
}
 */
/**
 *
 */
/*
func hitTesting(){
    window.contentView = InteractiveView2()
    StyleManager.addStyle("Button{fill:blue;}")
    
    let btn = Button(50,50)
    let container = window.contentView!.addSubView(Container(0,0,nil))
    
    container.addSubview(btn)
    /*container.layer?.position.x = 100
     container.layer?.position.y = 100*/
    container.layer?.position = CGPoint(40,20)
    //container.frame.origin = CGPoint(100,100)
    Swift.print("container.layer?.position: " + "\(container.layer?.position)")
    Swift.print("container.frame.origin: " + "\(container.frame.origin)")
    
    btn.layer?.position = CGPoint(40,20)
    //btn.frame
    Swift.print("btn.layer?.position: " + "\(btn.layer?.position)")
    Swift.print("btn.frame.origin: " + "\(btn.frame.origin)")
    btn.event = { event in
        if(event.type == ButtonEvent.upInside){Swift.print("hello world")}
    }
}
 */
