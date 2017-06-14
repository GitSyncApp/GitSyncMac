import Cocoa
@testable import Utils
@testable import Element
/**
 * NOTE: repo-name,contributor,title,description,date
 */
class CommitsListItem:Button,ISelectable{
    var repoName:String
    var contributor:String
    var title:String
    var desc:String/*Description*/
    var date:String
    var isSelected:Bool
    var titleText:Text?//TODO: ⚠️️ make lazy
    var repoNameText:Text?//TODO: ⚠️️ make lazy
    var contributorText:Text?//TODO: ⚠️️ make lazy
    var descText:Text?//TODO: ⚠️️ make lazy
    var dateText:Text?//TODO: ⚠️️ make lazy
    init(_ width:CGFloat, _ height:CGFloat, _ repoName:String,_ contributor:String,_ title:String,_ desc:String,_ date:String,_ isSelected : Bool = false, _ parent:IElement? = nil, _ id:String? = nil){
        self.repoName = repoName
        self.contributor = contributor
        self.title = title
        self.desc = desc
        self.date = date
        self.isSelected = isSelected
        super.init(width, height, parent, id)
    }
    override func resolveSkin() {
        super.resolveSkin()
        let container = addSubView(Section(NaN,100,self,"textContainer"))
        
        repoNameText = container.addSubView(Text(NaN,NaN,repoName,container,"repoName"))
        repoNameText!.isInteractive = false
        contributorText = container.addSubView(Text(NaN,NaN,contributor,container,"contributor"))
        contributorText!.isInteractive = false
        
        titleText = container.addSubView(Text(360,24,title,container,"title"))
        titleText!.isInteractive = false
        descText = container.addSubView(Text(NaN,50,desc,container,"description"))
        descText!.isInteractive = false
        
        dateText = container.addSubView(Text(180,24,date,container,"date"))
        dateText!.isInteractive = false
    }
    override func mouseUpInside(_ event: MouseEvent) {
        isSelected = true
        super.mouseUpInside(event)
        self.event!(SelectEvent(SelectEvent.select,self/*,self*/))
    }
    /**
     * Sets data to the UI elements
     */
    func setData(_ data:[String:String]){
        titleText!.setText(data["title"]!)
        repoNameText!.setText(data["repo-name"]!)
        contributorText!.setText(data["contributor"]!)
        descText!.setText(data["description"]!)
        /**/
        let date:Date = GitDateUtils.date(data["gitDate"]!)
        //Swift.print("date.shortDate: " + "\(date.shortDate)")
        let relativeTime:(value:Int,type:String) = DateParser.relativeTime(Date(),date)[0]
        let relativeDate:String = relativeTime.value.string + relativeTime.type/*create date like 3s,4m,5h,6w,2y*/
        dateText!.setText(relativeDate)
    }
    /**
     * NOTE: do not add a dispatch event here, that is the responsibilyy of the caller
     */
    func setSelected(_ isSelected:Bool){
        Swift.print("setSelected(): " + "\(isSelected)")
        self.isSelected = isSelected
        setSkinState(getSkinState())
    }
    func getSelected() -> Bool {
        return self.isSelected
    }
    override func setSkinState(_ skinState:String) {
        //Swift.print("\(self.dynamicType)" + " setSkinState() skinState: " + "\(skinState)")
        super.setSkinState(skinState)
        titleText!.setSkinState(skinState)
    }
    override func getSkinState() -> String {
        return isSelected ? SkinStates.selected + " " + super.getSkinState() : super.getSkinState();
    }
    override func getClassType() -> String {
        return "\(CommitsListItem.self)"
    }
    override func setSize(_ width: CGFloat, _ height: CGFloat) {
        Swift.print("CommitsListItem.width: " + "\(width)")
        Swift.print("getWidth(): " + "\(getWidth())")
        super.setSize(width,height)
    }
    /*override func hitTest(_ aPoint: NSPoint) -> NSView? {
        Swift.print("layer!.position: " + "\(layer!.position)")
        let aPoint = aPoint + CGPoint(layer!.position.x,layer!.position.y)
        return super.hitTest(aPoint)
     }*/
    required init(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}

//<commit repo-name="Element" contributor="Eonist" title="Comment update" description="Updated a comment in the file: View.swift" date="2016-01-22"/>

enum CommitItem:String{
    case repoName = "repo-name"
    case contributor = "contributor"
    case title = "title"
    case description = "description"
    case date = "date"
}
