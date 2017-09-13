import Cocoa
@testable import Utils
@testable import Element

class CommitList2:ElasticSliderScrollerFastList5,CommitListable2 {
    private var commitListHandler:CommitListHandler {return handler as! CommitListHandler}//move this to extension somewhere
    override lazy var handler:ProgressHandler = CommitListHandler(progressable:self)
    //
    var _state:CommitListState = .init()
    lazy var progressIndicator:ProgressIndicator = self.createProgressIndicator()
    var performance:PerformanceTester = PerformanceTester()/*Debug*/
    //
    override lazy var moverGroup:MoverGroup = createMoverGroup
    override func resolveSkin() {
        super.resolveSkin()
        _ = progressIndicator
    }
    /**
     * Create ListItem
     */
    override func createItem(_ index:Int) -> Element {
        Swift.print("CommitList2.createItem")
        let dpItem = dp.items[index]
        let config:CommitsListItem.Config = (dpItem["repo-name"]!, dpItem["contributor"]!,dpItem["title"]!,dpItem["description"]!,dpItem["date"]!, false)
        let item:CommitsListItem = CommitsListItem.init(config: config, size: CGSize(0,itemSize.height))
        
        contentContainer.addSubview(item)
        return item
    }
    /**
     * Apply data to ListItem
     */
    override func reUse(_ listItem:FastListItem) {
        let item:CommitsListItem = listItem.item as! CommitsListItem//use guard here
        let idx:Int = listItem.idx/*the index of the data in dataProvider*/
        let selected:Bool = idx == selectedIdx//dpItem["selected"]!.bool
        item.setData(dp.items[idx])
        if item.selected != selected {item.setSelected(selected)}//only set this if the selected state is different from the current selected state in the ISelectable
//        disableAnim {} no need for this anymore
        item.layer?.position[dir] = idx * itemSize.height/*position the item*/
    }
    override func onEvent(_ event:Event) {
        //Swift.print("CommitsList.onEvent() event.type: " + "\(event.type)")
        if event.assert(AnimEvent.completed, progressIndicator.animator) {
            //self.onRefreshComplete()//<-strange that this is here, lets remove it
        }else if event.assert(AnimEvent.stopped, moverGroup.yMover) {
            commitListHandler.scrollAnimStopped()
        }
        super.onEvent(event)
    }
    /**
     * When the the user scrolls
     * NOTE: this method overides the Native NSView scrollWheel method
     * //TODO: ⚠️️you need to make an scroolWheel method that you can override down hirarcy.
     */
//    override func scrollWheel(with event:NSEvent) {//you can probably remove this method and do it in base?"!?
//        //Swift.print("CommitsList.scrollWheel()")
//        (self as CommitListable2).scroll(event)
//        super.scrollWheel(with:event)/*⚠️️, 👈 not good, forward the event other delegates higher up in the stack*/
//    }
    /**
     * TODO: ⚠️️ You could add this through setting the callback
     */
    var createMoverGroup:MoverGroup {
        var group = MoverGroup(self.commitListHandler.setProgressValue,self.maskSize,self.contentSize)
        group.event = self.onEvent/*Add an eventHandler for the mover object, , this has no functionality in this class, but may have in classes that extends this class, like hide progress-indicator when all animation has stopped*/
        return group
    }
//    override func getClassType() -> String {
//        return "\(CommitsList.self)"
//    }
}
extension CommitList2{//move into extension class
    func createProgressIndicator() -> ProgressIndicator{
        let piContainer = addSubView(Container(self.getWidth(), self.getHeight(),self,"progressIndicatorContainer"))
        let progressIndicator = piContainer.addSubView(ProgressIndicator(30,30,piContainer))
        progressIndicator.frame.y = -45/*hide at init*/
        progressIndicator.animator.event = onEvent
        return progressIndicator
    }
}
