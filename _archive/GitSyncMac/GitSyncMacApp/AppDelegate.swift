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
        Swift.print("GitSync - A futuristic Git client")

        initApp()
//        quickTest()
//      horizontalListTest()
//      viewTests()
//        quickTest()//repo
//        quickTest2()//year
//        quickTest3()//month
//        quickTest4()//day
//        quickTest6()
//        quickTest7()
//        quickTest8()
//        quickTest9()
//        graphZTest()//🚫
//        testGraphXTest()//✅
//        quickTest12()

    }
    func quickTest12(){
        window.size = CGSize(700,400)
        window.title = ""
        window.contentView = InteractiveView()
        _ = window.contentView?.addSubView(TestView())
    }
    /**
     * Testing the zoomable and bouncing graph
     */
    func testGraphXTest(){
        Swift.print("Hello GraphZ")
        //
        window.size = CGSize(700,400)
        window.title = ""
        window.contentView = InteractiveView()
        StyleManager.addStyle(url:Config.Bundle.styles + "styles/styletest/stats/graphz/graphztest.css", liveEdit: false)

        let winSize:CGSize = WinParser.size(window)
//      let db = CommitCountDB()
        let db:CommitCountDB = CommitCountDB.FileIO.open()//reads the cached CommitCount data
        Swift.print("🍏 db.repos.count: " + "\(db.repos.count)")
        //
        let repoList:[RepoItem] = RepoUtils.repoListFlattenedOverridden
        guard let first = repoList.first else {fatalError("err")}
        let subset = repoList//[first]//test with 1 first
        //
        let commitCounter = CommitCounter2()

        func onComplete(){
//          CommitCountDPUtils.describeMonth(commitDb:commitDb)
//          CommitCountDPUtils.describeDay(commitDb:commitDb)
            let graph = GraphZ(db:db,size:winSize,id:nil)
            window.contentView!.addSubview(graph)//➡️️
            CommitCountDB.FileIO.save(db:db)//this should be called on app exit and statsWin.close
        }
        commitCounter.update(commitDB:db, repoList:subset, onComplete: onComplete)//⬅️️
    }
    var monthDB:CommitCountDB {
        let commitDb = CommitCountDB()
        commitDb.addRepo(repoId: "RepoB", date: .init(year:2014,month:11,day:7), commitCount: 32)
        commitDb.addRepo(repoId: "RepoA", date: .init(year:2015,month:3,day:3), commitCount: 20)
        commitDb.addRepo(repoId: "RepoA", date: .init(year:2015,month:6,day:13), commitCount: 30)
        commitDb.addRepo(repoId: "RepoA", date: .init(year:2014,month:7,day:17), commitCount: 5)
        commitDb.addRepo(repoId: "RepoB", date: .init(year:2014,month:7,day:20), commitCount: 16)
        commitDb.addRepo(repoId: "RepoA", date: .init(year:2014,month:1,day:4), commitCount: 3)
        return commitDb
    }
    var dayDB:CommitCountDB {
        //        let commitDb = CommitCountDB.FileIO.open()

        let commitDb = CommitCountDB()
        commitDb.addRepo(repoId: "RepoB", date: .init(year:2014,month:1,day:7), commitCount: 13)
        commitDb.addRepo(repoId: "RepoA", date: .init(year:2014,month:1,day:3), commitCount: 20)
        commitDb.addRepo(repoId: "RepoA", date: .init(year:2014,month:1,day:13), commitCount: 30)
        commitDb.addRepo(repoId: "RepoA", date: .init(year:2014,month:1,day:17), commitCount: 5)
        commitDb.addRepo(repoId: "RepoB", date: .init(year:2014,month:1,day:29), commitCount: 16)
        commitDb.addRepo(repoId: "RepoB", date: .init(year:2014,month:1,day:1), commitCount: 4)
        commitDb.addRepo(repoId: "RepoB", date: .init(year:2014,month:1,day:2), commitCount: 13)
        commitDb.addRepo(repoId: "RepoA", date: .init(year:2014,month:1,day:4), commitCount: 5)
        commitDb.addRepo(repoId: "RepoA", date: .init(year:2014,month:1,day:28), commitCount: 15)
        commitDb.addRepo(repoId: "RepoB", date: .init(year:2014,month:1,day:30), commitCount: 11)
        commitDb.addRepo(repoId: "RepoB", date: .init(year:2014,month:2,day:4), commitCount: 6)
        commitDb.addRepo(repoId: "RepoA", date: .init(year:2014,month:2,day:6), commitCount: 3)
        commitDb.addRepo(repoId: "RepoB", date: .init(year:2014,month:2,day:8), commitCount: 14)
        commitDb.addRepo(repoId: "RepoB", date: .init(year:2014,month:2,day:12), commitCount: 4)
        commitDb.addRepo(repoId: "RepoB", date: .init(year:2014,month:2,day:16), commitCount: 9)
        commitDb.addRepo(repoId: "RepoB", date: .init(year:2014,month:3,day:2), commitCount: 16)
        commitDb.addRepo(repoId: "RepoA", date: .init(year:2014,month:3,day:9), commitCount: 6)
        commitDb.addRepo(repoId: "RepoA", date: .init(year:2014,month:3,day:12), commitCount: 4)

        return commitDb
    }
    /**
     * New
     */
    func graphZTest(){
        window.size = CGSize(700,400)
        window.title = ""
        window.contentView = InteractiveView()
        StyleManager.addStyle(url:"~/Desktop/ElCapitan/graphz/graphztest.css", liveEdit: true)
        //
        let winSize:CGSize = WinParser.size(window)
        let graph = window.contentView!.addSubView(GraphZ(db:dayDB, size:winSize,id:nil))
        _ = graph
    }
    /**
     * Tests File IO for CommitCountDB
     */
    func quickTest9(){
        let commitDb = CommitCountDB()//CommitCountDB.FileIO.open()
        Swift.print("commitDb.repos.count: " + "\(commitDb.repos.count)")
        commitDb.addRepo(repoId: "RepoB", date: .init(year:2014,month:11,day:7), commitCount: 32)
        commitDb.addRepo(repoId: "RepoA", date: .init(year:2015,month:3,day:3), commitCount: 20)
        commitDb.addRepo(repoId: "RepoA", date: .init(year:2015,month:6,day:13), commitCount: 30)
//        CommitCountDPUtils.describeMonth(commitDb:commitDb)
//        CommitCountDPUtils.describeDay(commitDb:commitDb)
        CommitCountDB.FileIO.save(db: commitDb)
        let newCommitDb = CommitCountDB.FileIO.open()
//        Swift.print("newCommitDb.repos.count: " + "\(newCommitDb.repos.count)")
        CommitCountDPUtils.describeMonth(commitDb:newCommitDb)
    }
    /**
     * Store the commitDB locally in .json
     * NOTE: make a utility method  to convert the dict to str
     * NOTE: you might need to make custom Json method for wrapping and unwrapping because of int
     */
    func quickTest8(){
        let commitDb = CommitCountDB()
        commitDb.addRepo(repoId: "RepoB", date: .init(year:2014,month:11,day:7), commitCount: 32)
        commitDb.addRepo(repoId: "RepoA", date: .init(year:2015,month:3,day:3), commitCount: 20)
        commitDb.addRepo(repoId: "RepoA", date: .init(year:2015,month:6,day:13), commitCount: 30)
        //convert to jsonFirndly dict
        let jsonFriendlyDict = commitDb.jsonFriendlyDict
//        Swift.print("jsonFriendlyDict: " + "\(jsonFriendlyDict)")
        //convert to json string
        guard let str = JSONParser.str(dict:jsonFriendlyDict) else {return}
        Swift.print("str: " + "\(str)")


        //convert to dictionary
        guard let dict:[String:Any] = str.json as? [String:Any] else {return}
        dict.forEach{
            Swift.print("$0.key: " + "\($0.key)")
        }
        //convert to commitdb friendly dict
        let commitCountDb = CommitCountDB.commitCountDb(jsonDict: dict)
        Swift.print("commitCountDb.repos.count: " + "\(commitCountDb.repos.count)")

//        let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
//        if let dictFromJSON = decoded as? [String:String] {
//
//        }
    }
    /**
     * Test CommitCounter2
     * NOTE: Try to populate the DataBase with real Git commit data. And try to store it and append to it when new comits get in.
     */
    func quickTest7(){
        let db:CommitCountDB = CommitCountDB.FileIO.open()//reads the cached CommitCount data
        Swift.print("🍏 db.repos.count: " + "\(db.repos.count)")
        //
        let repoList:[RepoItem] = RepoUtils.repoListFlattenedOverridden
        guard let first = repoList.first else {fatalError("err")}
        let subset = [first]//test with 1 first
        let commitCounter = CommitCounter2()

        func onComplete(){
//            CommitCountDPUtils.describeYear(commitDb:db)
            CommitCountDB.FileIO.save(db: db)//this should be called on app exit and statsWin.close
        }
        commitCounter.update(commitDB:db, repoList:subset, onComplete: onComplete)//⬅️️

    }
    /**
     * hash key test
     */
    func quickTest6(){
        let ymd:YMD = YMD.init(year: 2015, month: 12, day: 14)
        Swift.print("ymd.hashValue: " + "\(ymd.int)")
    }

    /**
     * Day
     */
    func quickTest4(){
        Swift.print("quickTest4")
        let commitDb = CommitCountDB()
        commitDb.addRepo(repoId: "RepoB", date: .init(year:2014,month:3,day:7), commitCount: 32)
        commitDb.addRepo(repoId: "RepoA", date: .init(year:2015,month:3,day:3), commitCount: 20)
        commitDb.addRepo(repoId: "RepoA", date: .init(year:2015,month:6,day:13), commitCount: 30)
        commitDb.addRepo(repoId: "RepoA", date: .init(year:2014,month:2,day:17), commitCount: 5)
        commitDb.addRepo(repoId: "RepoB", date: .init(year:2014,month:1,day:20), commitCount: 16)
        commitDb.addRepo(repoId: "RepoA", date: YMD(year:2014,month:1,day:4), commitCount: 3)
        commitDb.addRepo(repoId: "RepoA", date: YMD(year:2014,month:1,day:9), commitCount: 5)
        Swift.print("commitDb.count: " + "\(commitDb.count)")
//        let count:Int? = commitDb.dayCount(repoId: "RepoA", date: YMD(year:2014,month:1,day:4))
//        Swift.print("Appdel.count: " + "\(count)")
//        CommitCountDPUtils.describeDay(commitDb:commitDb)
    }
    /**
     * Month
     */
    func quickTest3(){
        let commitDb = CommitCountDB()
        commitDb.addRepo(repoId: "RepoB", date: .init(year:2014,month:11,day:7), commitCount: 32)
        commitDb.addRepo(repoId: "RepoA", date: .init(year:2015,month:3,day:3), commitCount: 20)
        commitDb.addRepo(repoId: "RepoA", date: .init(year:2015,month:6,day:13), commitCount: 30)
        commitDb.addRepo(repoId: "RepoA", date: .init(year:2014,month:7,day:17), commitCount: 5)
        commitDb.addRepo(repoId: "RepoB", date: .init(year:2014,month:7,day:20), commitCount: 16)
        commitDb.addRepo(repoId: "RepoA", date: .init(year:2014,month:1,day:4), commitCount: 3)
////
//        let monthCounts:[Int:Int] = commitDb.monthCounts
//        Swift.print("monthCounts: " + "\(monthCounts)")
//        let commitCountDP = MonthCommitDP(commitCount:monthCounts)
//        Swift.print("commitCountDP.count: " + "\(commitCountDP.count)")
//        let result = commitCountDP.item(at:0)
//        Swift.print("result: " + "\(result)")

//        Swift.print("commitCountDP.minMonth: " + "\(commitCountDP.minMonth)")
//        Swift.print("commitCountDP.minYear: " + "\(commitCountDP.minYear)")
//        Swift.print("commitCountDP.maxMonth: " + "\(commitCountDP.maxMonth)")
//        Swift.print("commitCountDP.maxYear: " + "\(commitCountDP.maxYear)")
//        Swift.print("commitCountDP.max: " + "\(commitCountDP.max)")
//        Swift.print("commitCountDP.min: " + "\(commitCountDP.min)")
//        Swift.print("commitCountDP.count: " + "\(commitCountDP.count)")
//        for i in 0...commitCountDP.count{
//            let commitCount:Int = commitCountDP.item(at: i) ?? 0
//            let yearAndMonth = TimeParser.offset(year: commitCountDP.minYear, month: commitCountDP.minMonth, offset: i)
//            Swift.print("Year:\(yearAndMonth.year) Month:\(yearAndMonth.month) commitCount: \(commitCount)")
//        }
    }
    /**
     * Year
     */
    func quickTest2(){
        let commitDb = CommitCountDB()
        commitDb.addRepo(repoId: "RepoB", date: .init(year:2014,month:11,day:2), commitCount: 32)
        commitDb.addRepo(repoId: "RepoA", date: .init(year:2015,month:3,day:6), commitCount: 20)
//        commitDb.addRepo(repoId: "RepoA", date: CommitCountDB.DBDate.init(year:2015,month:6), commitCount: 30)
//        commitDb.addRepo(repoId: "RepoA", date: CommitCountDB.DBDate.init(year:2017,month:7), commitCount: 5)
//        commitDb.addRepo(repoId: "RepoB", date: CommitCountDB.DBDate.init(year:2017,month:1), commitCount: 16)
//        commitDb.addRepo(repoId: "RepoA", date: CommitCountDB.DBDate.init(year:2011,month:1), commitCount: 3)

        let yearCounts:[Int:Int] = commitDb.yearCounts
        let commitCountDP = CommitCountDP(commitCount:yearCounts)
        for i in 0..<commitCountDP.count{
            let yearCount:Int = commitCountDP.item(at: i) ?? 0
            let year:Int = commitCountDP.min + i
            Swift.print("year:\(year) yearCount: \(yearCount)")
        }
        Swift.print("commitCountDP.count: " + "\(commitCountDP.count)")
    }
    /**
     * //Figure out a sceheme to store the repo commit stats in database where its also removable if repos are removed etc. Also filtering repos 👈👈👈
     */
    func quickTest(){
        let commitDb = CommitCountDB()

        let id:String = "RepoA"/*repoID*/
        let year:Int = 2015
        let month:Int = 3
        let day:Int = 7
        let commitCount:Int = 20
//        let monthVal:CommitCountDB2.Month = [month:commitCount]
//        let yearVal:CommitCountDB2.Year = [year:monthVal]
//        let repoVal:CommitCountDB2.Repo = (repoId:id,year:yearVal)
//        commitDb.repos[repoVal.repoId] = repoVal.year

        commitDb.addRepo(repoId: id, date: .init(year:year,month:month,day:day), commitCount: commitCount)

//        Swift.print("commitCountValue: " + "\(commitDb.repos[id]?[year]?[month]?[day])")

        commitDb.addRepo(repoId: id, date: .init(year:year,month:month,day:day), commitCount: 12)


//        Swift.print("commitCountValue: " + "\(commitDb.repos[id]?[year]?[month]?[day])")

        //DataBase for git commit count
//        let tempA = TempA()
//        tempA.arr["a"] = (id:"blue",value:["a","b"])
//        tempA.arr["a"]?.value[0] = "x"
//        Swift.print(tempA.arr["a"]?.value[0])
    }
    /**
     *
     */
    func viewTests(){
        setup()
        let view = ViewTest.init(size: CGSize(300,300))
        _ = window.contentView?.addSubView(view)
    }
    /**
     *
     */
    func horizontalListTest(){
//        setup()
        window.contentView = InteractiveView()
        StyleManager.addStyle("CustomList{fill:black;fill-alpha:1;}")

        let dp:DP = DP.init(Array.init(repeating: ["":""], count: 32))
        let listConfig = List5.Config.init(itemSize: CGSize(80,80), dp: dp, dir: .hor)
        let list = CustomList.init(config: listConfig, size: CGSize(350,180))
        window.contentView?.addSubview(list)
    }
    func setup(){
        window.contentView = InteractiveView()
        let styleFilePath:String = Config.Bundle.styles + "styles/styletest/" + "light.css"//"dark.css"
        StyleManager.addStyle(url:styleFilePath,liveEdit: false)
    }
    /**
     * Initializes the app
     */
    func initApp(){
        NSApp.windows[0].close()/*<--Close the initial non-optional default window*/
        NSUserNotificationCenter.default.delegate = self//Enables notifications even when app is in focus
        let themeStr:String = PrefsView.prefs.darkMode ? "dark.css" : "light.css"
        let styleFilePath:String = Config.Bundle.styles + "styles/styletest/" + themeStr
        StyleManager.addStyle(url:styleFilePath,liveEdit: false)
        //StyleWatcher.watch("~/Desktop/ElCapitan/","~/Desktop/ElCapitan/gitsync.css", self.win!.contentView!)
        win = StyleTestWin(PrefsView.prefs.rect.w, PrefsView.prefs.rect.h)
        menu = Menu()/*This creates the App menu*/
    }
    func applicationWillTerminate(_ aNotification:Notification) {
        _ = FileModifier.write(Config.Bundle.prefsURL.tildePath, PrefsData.xml.xmlString)/*Stores the app prefs*/
        Swift.print("💾 Write PrefsView to: prefs.xml")
        _ = FileModifier.write(Config.Bundle.repo.tildePath, RepoView.treeDP.tree.xml.xmlString)/*store the repo xml*/
        Swift.print("💾 Write RepoList to: repo.xml")
        print("Good-bye")
    }
}
extension AppDelegate:NSUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
}

class ViewTest:ElasticScrollerView5{//ScrollerView5,ElasticSliderScrollerView5,ScrollerView5,SliderScrollerView5
    override var contentSize: CGSize {return CGSize(super.width*2,super.height*2)}
    override func resolveSkin() {
        StyleManager.addStyle("ContainerView{fill:blue;fill-alpha:0.0;}")
        super.resolveSkin()
        createEllipse()
    }
}
/**
 * Testing multiple views performance 👷🚧
 */
extension ContainerView5{
    /**
     * Creates debug ellipse
     */
    func createEllipse(){
        /*Styles*/
        let gradient = LinearGradient(Gradients.blue(),[],π/2)
        let lineGradient = LinearGradient(Gradients.deepPurple(0.5),[],π/2)
        let fill:GradientFillStyle = GradientFillStyle(gradient);
        let lineStyle = LineStyle(20,NSColorParser.nsColor(Colors.green()).alpha(0.5),CGLineCap.round)
        let line = GradientLineStyle(lineGradient,lineStyle)
        /*size*/
        let objSize:CGSize = CGSize(200,200)
        Swift.print("objSize: " + "\(objSize)")
        let viewSize:CGSize = CGSize(width,height)
        Swift.print("viewSize: " + "\(viewSize)")
        let p = Align.alignmentPoint(objSize, viewSize, Alignment.centerCenter, Alignment.centerCenter,CGPoint())
        Swift.print("p: " + "\(p)")
        /*Graphics*/
        let ellipse = EllipseGraphic(0,0,200,200,fill.mix(Gradients.green()),line.mix(Gradients.lightGreen(0.5)))
        contentContainer.addSubview(ellipse.graphic)
        ellipse.graphic.layer?.position = p
        ellipse.draw()
    }
    /**
     * creates many shapes for performance testing
     * //TODO: ⚠️️ Try to draw the same amount of rects but as Shapes not NSViews, maybe via svg or manually
     */
    func createmanyShapes(){
        /*Styles*/
        let colorFill = FillStyle(.green)
        /*size*/
        let objSize:CGSize = CGSize(200,200)
        let viewSize:CGSize = CGSize(width,height)
        let p = Align.alignmentPoint(objSize, viewSize, Alignment.centerCenter, Alignment.centerCenter,CGPoint())
        let rectContainer:NSView = contentContainer.addSubView(Container(200,200))
        rectContainer.frame.origin = p

        let hCount:Int = 10
        let vCount:Int = 10
        (0..<hCount).indices.forEach{ i in
            (0..<vCount).indices.forEach{ e in
                let x:CGFloat = /*p.x + */(20 * i)
                let y:CGFloat = /*p.y + */(20 * e)
                let rect = RectGraphic(x,y,10,10,colorFill,nil)
                rectContainer.addSubview(rect.graphic)
                rect.draw()
            }
        }
    }
}
class CustomList:ElasticScrollerFastList5{
    override lazy var contentContainer: Element = {
        let container = createContentContainer()
        let ellipse = EllipseGraphic(0,0,200,200,FillStyle(.red),nil)
        container.addSubview(ellipse.graphic)
        //        ellipse.graphic.layer?.position = p
        ellipse.draw()
        return container
    }()
    override func createItem(_ index:Int) -> Element {
        let customListItem = CustomListItem.init(size: itemSize)
        contentContainer.addSubview(customListItem)
//        customListItem.setPosition(CGPoint(itemSize.w*index,0))
        return customListItem
    }
    override func reUse(_ listItem:FastListItem) {
        let randCol:NSColor = NSColorParser.randomColor()
        (listItem.item as! CustomListItem).rect?.graphic.fillStyle = FillStyle.init(randCol)
        (listItem.item as! CustomListItem).rect?.graphic.draw()
        listItem.item.layer?.position[dir] = listItem.idx * itemSize[dir]/*position the item*/
    }
    override func getClassType() -> String {
        return "\(CustomList.self)"
    }
}
class CustomListItem:Element{
    var rect:RectGraphic?
    override func resolveSkin() {
        let randCol:NSColor = NSColorParser.randomColor()
//        let x = index * skinSize.w
//        Swift.print("x: " + "\(x)")
        rect = RectGraphic(0,0,skinSize.w,skinSize.h,FillStyle(randCol))
        rect!.draw()
        addSubview(rect!.graphic)
    }
}
class TestView:InteractiveView{
    lazy var gestureHUD:GestureHUD = GestureHUD(self)
    init(){
        super.init(frame: NSRect.init(0, 0, 400, 400))
        self.acceptsTouchEvents = true/*Enables gestures*/
        self.wantsRestingTouches = true/*Makes sure all touches are registered. Doesn't register when used in playground*/
        let rect = RectGraphic(0,0,400,400,FillStyle(.blue),nil)
        self.addSubview(rect.graphic)
        rect.draw()
        _ = gestureHUD

    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func magnify(with event: NSEvent) {
        Swift.print("magnify")
    }
}
extension TestView{
    override func touchesBegan(with event:NSEvent) {
        gestureHUD.touchesBegan(event)
    }
    override func touchesMoved(with event:NSEvent) {
        gestureHUD.touchesMoved(event)
    }
    override func touchesEnded(with event:NSEvent) {
        gestureHUD.touchesEnded(event)
    }
}
