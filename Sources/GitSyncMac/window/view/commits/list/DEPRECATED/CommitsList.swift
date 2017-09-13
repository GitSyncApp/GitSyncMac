import Cocoa
@testable import Utils
@testable import Element
/**
 * ⚠️️⚠️️⚠️️ Since This uses POP, a lot of the logic is in  CommitListable
 */
class CommitsList:ElasticSlideScrollFastList3,CommitListable{/*⬅️️ The bulk of the logic is in COmmitListable because POP*/
    var _state:CommitListState = .init()
    lazy var progressIndicator:ProgressIndicator = self.createProgressIndicator()
    var performance:PerformanceTester = PerformanceTester()/*Debug*/

    override func resolveSkin() {
        super.resolveSkin()
        _ = progressIndicator
    }
    /**
     * Create ListItem
     */
    override func createItem(_ index:Int) -> Element {
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
        let item:CommitsListItem = listItem.item as! CommitsListItem
        let idx:Int = listItem.idx/*the index of the data in dataProvider*/
        let selected:Bool = idx == selectedIdx//dpItem["selected"]!.bool
        item.setData(dp.items[idx])
        if(item.selected != selected){item.setSelected(selected)}//only set this if the selected state is different from the current selected state in the ISelectable
        disableAnim {item.layer?.position[dir] = idx * itemSize.height/*position the item*/}
    }
    override func onEvent(_ event:Event) {
        //Swift.print("CommitsList.onEvent() event.type: " + "\(event.type)")
        if(event.assert(AnimEvent.completed, progressIndicator.animator)){
            //self.onRefreshComplete()//<-strange that this is here, lets remove it
        }else if(event.assert(AnimEvent.stopped, moverGroup?.yMover)){
            scrollAnimStopped()
        }
        super.onEvent(event)
    }
    /**
     * When the the user scrolls
     * NOTE: this method overides the Native NSView scrollWheel method
     * //TODO: ⚠️️you need to make an scroolWheel method that you can override down hirarcy.
     */
    override func scrollWheel(with event:NSEvent) {//you can probably remove this method and do it in base?"!?
        //Swift.print("CommitsList.scrollWheel()")
        (self as CommitListable).scroll(event)
        super.scrollWheel(with:event)/*⚠️️, 👈 not good, forward the event other delegates higher up in the stack*/
    }
    /**
     * TODO: ⚠️️ You could add this through setting the callback
     */
    override var moverGrp:MoverGroup {
        var group = MoverGroup(self.setProgressValue,self.maskSize,self.contentSize)
        group.event = self.onEvent/*Add an eventHandler for the mover object, , this has no functionality in this class, but may have in classes that extends this class, like hide progress-indicator when all animation has stopped*/
        return group
    }
}
extension CommitsList{
    func createProgressIndicator() -> ProgressIndicator{
        let piContainer = addSubView(Container(self.getWidth(), self.getHeight(),self,"progressIndicatorContainer"))
        let progressIndicator = piContainer.addSubView(ProgressIndicator(30,30,piContainer))
        progressIndicator.frame.y = -45/*hide at init*/
        progressIndicator.animator.event = onEvent
        return progressIndicator
    }
}

/*self.addSubView(Container(self.width,self.height,self,"lable"))*/
