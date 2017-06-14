import Cocoa
@testable import Utils
@testable import Element

/**
 * TODO: should remember previous selected item between transitions
 */
class RepoView:Element {
    static var repoListFilePath:String = "~/Desktop/repo2.xml"/*📝*///"~/Desktop/assets/xml/list.xml"
    static var selectedListItemIndex:[Int] = []
    static var _treeDP:TreeDP? = nil
    static var treeDP:TreeDP {
        guard let treeDP = _treeDP else{
            _treeDP = TreeDP(RepoView.repoListFilePath.tildePath)/*doesnt exists return new DP*/
            return _treeDP!
        };return treeDP/*already exist, return old dp*/
    }
    lazy var treeList:TreeList3 = {
        return  self.addSubView(TreeList3(self.getWidth(), self.getHeight(), CGSize(self.getWidth(),24), RepoView.treeDP, self))
    }()//if(RepoView.selectedListItemIndex.count > 0){TreeListModifier.selectAt(treeList!, RepoView.selectedListItemIndex)}
    lazy var contextMenu:RepoContextMenu = {return RepoContextMenu(self.treeList)}()
    override func resolveSkin() {
        self.skin = SkinResolver.skin(self)//super.resolveSkin()
        _ = treeList
        _ = contextMenu
    }
    override func onEvent(_ event:Event) {
        if(event.type == ListEvent.select && event.immediate === treeList){//if(event.type == SelectEvent.select && event.immediate === treeList){}
            //Swift.print("RepoView.onTreeListEvent() selectedIndex: " + "\(treeList.selectedIdx3d)")
            //print("_scrollTreeList.database.xml.toXMLString(): " + _scrollTreeList.database.xml.toXMLString());
            onTreeListSelect()
        }else if(event.type == ButtonEvent.rightMouseDown){
            contextMenu.rightClickItemIdx = TreeList3Parser.index(treeList, event.origin as! NSView)
            //Swift.print("RightMouseDown() rightClickItemIdx: " + "\(contextMenu.rightClickItemIdx)")
            NSMenu.popUpContextMenu(contextMenu, with: (event as! ButtonEvent).event!, for: self)
        }else if(event.type == TreeListEvent.change){
            
        }
    }
}
extension RepoView{
    func onTreeListSelect(){
        //Sounds.play?.play()
        let selectedIndex:[Int] = treeList.selectedIdx3d!
        Swift.print("selectedIndex: " + "\(selectedIndex)")
        Nav.setView(.repoDetail(selectedIndex))/*Updates the UI elements with the selected repo data*/
    }
}
