import Cocoa
@testable import Utils
@testable import Element
@testable import GitSyncMac

//Continue here:
    //remove things from the css files
    //add repoDetailView👈
        //add items that scale with windowresize


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
        
        initApp()
    }
    func initApp(){
        NSApp.windows[0].close()/*<--Close the initial non-optional default window*/
        StyleManager.addStylesByURL("~/Desktop/ElCapitan/styletest.css")//<--toggle this bool for live refresh
        win = StyleTestWin(300,350)
        //StyleWatcher.watch("~/Desktop/ElCapitan/","~/Desktop/ElCapitan/gitsync.css", self.win!.contentView!)
        menu = Menu()/*This creates the App menu*/
    }
    /**
     *
     */
    func jsonTest(){
        
        /*JSONParser.dictArr("[{\"title\":\"doctor\"}]".json)?.forEach{
         Swift.print("\(JSONParser.dict($0)?["title"])")//doctor
         }*/
        //let content = "~/Desktop/gitsync.json".content
        //Swift.print("content: " + "\(content)")
        //let json = "~/Desktop/gitsync.json".content!.json
        //Swift.print("json: " + "\(json)")
        //let dict = JSONParser.dict("~/Desktop/gitsync.json".content?.json)
        //Swift.print("dict: " + "\(dict)")
        
        JSONParser.dictArr(JSONParser.dict("~/Desktop/gitsync.json".content?.json)?["repoDetailView"])?.forEach{
            //Swift.print("$0: " + "\($0)")
            if let dict:[String:Any] = JSONParser.dict($0){
                let type:Any? = dict["type"]
                Swift.print("type: " + "\(type)")
                let id:Any? = dict["id"]
                Swift.print("id: " + "\(id)")
                let text:Any? = dict["text"]
                Swift.print("text: " + "\(text)")
            }
        }
        
        //Continue here: 🏀
            //research How you use reflection and how it can create items via xml 👈
        
        //1. provide json and key
        //2. provide parent and every UI item is created and added to
        //3. Returns dict with id and ref to item
        
        
    }
    func applicationWillTerminate(_ aNotification:Notification) {
        /*Stores the app prefs*/
        if(PrefsView.keychainUserName != nil){//make sure the data has been read and written to first
            _ = FileModifier.write("~/Desktop/gitsyncprefs.xml".tildePath, PrefsView.xml.xmlString)
            Swift.print("💾 Write PrefsView to: prefs.xml")
        }
        Swift.print("💾 Write RepoList to: repo.xml")
        _ = FileModifier.write(RepoView.repoListFilePath.tildePath, RepoView.treeDP.tree.xml.xmlString)/*store the repo xml*/
        print("Good-bye")
    }
}

class UnFoldUtils{
    static func unFold(_ dict:[String:Any]) -> IElement?{
        guard let type:String = dict["type"] as? String else {fatalError("type must be string")}
        switch true{
            case type == "\(TextInput.self)":
                return TextInput.unFold(dict)
            case type == "\(CheckBoxButton.self)":
                return nil
            default:
                return nil
        }
    }
    /**
     * String
     */
    static func string(_ dict:[String:Any],_ key:String) -> String?{
        if let value:Any = dict[key] {
            if let str = value as? String {return str}
            else {fatalError("type not supported: \(value)")}
        };return nil
    }
    /**
     * cgFloat
     */
    static func cgFloat(_ dict:[String:Any],_ key:String) -> CGFloat{
        if let value:Any = dict[key] {
            if let str = value as? String {return str.cgFloat}
            else if let int = value as? Int {return int.cgFloat}
            else {fatalError("type not supported: \(value)")}
        };return NaN
    }
}
extension TextInput{
    /**
     * New
     */
    static func unFold(_ dict:[String:Any]) -> TextInput{
        //element tuple _ width:CGFloat, _ height:CGFloat, parent, id
        //config tuple
        return TextInput(NaN,NaN,"","",nil)
    }
    typealias TextInputConfig = (text:String, inputText:String)
    convenience init(element:ElementConfig, config:TextInputConfig) {
        self.init(element.width, element.height, config.text, config.inputText, element.parent, element.id)
    }
}
extension Element{
    typealias ElementConfig = (width:CGFloat, height:CGFloat, parent:IElement?, id:String?)
    /**
     * New
     */
    static func element(_ dict:[String:Any], _ parent:IElement? = nil){
        let width:CGFloat = UnFoldUtils.cgFloat(dict, "width")
        let height:CGFloat = UnFoldUtils.cgFloat(dict, "width")
        let id:String
    }
}
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
