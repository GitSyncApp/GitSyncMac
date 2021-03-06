import Cocoa
@testable import Utils
@testable import Element

/**
 * Right click context menu
 * TODO: ⚠️️ maybe create sub menus to appear more organized?
 */
class RepoContextMenu: NSMenu {
    var rightClickItemIdx: [Int]?
    var clipBoard: XML?
    var treeList: TreeListable3
    init(_ treeList: TreeListable3) {
        self.treeList = treeList//Element - mac
        super.init(title:"Contextual menu")
        let menuItems:[(title: RepoMenuItem, selector: Foundation.Selector)] = [
              (.newGroup, #selector(newGroup))
            , (.newRepo, #selector(newRepo))
            , (.duplicate, #selector(duplicate))
            , (.copy, #selector(doCopy))
            , (.cut, #selector(cut))
            , (.paste, #selector(paste))
            , (.delete, #selector(delete))
            , (.moveUp, #selector(moveUp))
            , (.moveDown, #selector(moveDown))
            , (.moveTop, #selector(moveToTop))
            , (.moveBottom, #selector(moveToBottom))
            , (.showInFinder, #selector(showInFinder))
            , (.openUrl, #selector(openURL))
        ]
        //continue here: add Open in github
        menuItems.forEach {
            let menuItem: NSMenuItem = .init(title: $0.title.rawValue, action: $0.selector, keyEquivalent: "")
            self.addItem(menuItem)
            menuItem.target = self
        }
        self.insertItem(NSMenuItem.separator(), at: 7)/*Separator*/
        self.insertItem(NSMenuItem.separator(), at: 12)/*Separator*/
    }
    required init(coder decoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
/**
 * Right click Context menu methods
 */
extension RepoContextMenu{
    /**
     * - TODO: ⚠️️ A bug is that when you add a folder and its the last item then the list isnt resized
     * - TODO: ⚠️️ There is a bug if you add items to closed groups, then there will be an error
     */
    @objc func newGroup(sender: AnyObject) {
        Swift.print("newFolder")
        let idx = rightClickItemIdx!
        let xmlStr:String = "<item title=\"New group\" \(RepoFolderType.isOpen.rawValue)=\"true\" \(RepoItem.Key.active)=\"true\"></item>"//hasChildren=\"true\"
        let tree = TreeConverter.tree(xmlStr.xml)//treeList.node.addAt(newIdx(idx), a.xml)//"<item title=\"New folder\"/>"
        let newIdx = Utils.newIdx(treeList,idx)
        treeList.insert(newIdx,tree)
        Swift.print("Promt folder name popup")
    }
    @objc func newRepo(sender: AnyObject) {
        Swift.print("newRepo")
        //treeList.insert([1],Tree("item",[],nil,["title":"Fish"]))/*Insert item at
        let idx = rightClickItemIdx!
        Swift.print("idx: " + "\(idx)")
        let props: [String: String] = [
            RepoItem.Key.title:"New repo",
            RepoItem.Key.local:"~/Desktop/test",
            RepoItem.Key.remote:"https://github.com/eonist/test.git",
            RepoItem.Key.branch:"master",
            RepoItem.Key.message:"true",
            RepoItem.Key.active:"true",
            RepoItem.Key.auto:"true"]
        let tree:Tree = .init("item", [], nil, props)
        let newIdx = Utils.newIdx(treeList,idx)
        treeList.insert(newIdx,tree)
        //Swift.print("Promt repo name popup")
    }
    @objc func duplicate(sender: AnyObject) {
        Swift.print("duplicate")
        let idx = rightClickItemIdx!
        Swift.print("idx: " + "\(idx)")
        if let tree: Tree = treeList[idx] {
            let newIdx = Utils.newIdx(treeList,idx)
            treeList.insert(newIdx, tree)
        }
    }
    @objc func doCopy(sender: AnyObject) {
        Swift.print("copy")
        let idx = rightClickItemIdx!
        Swift.print("idx: " + "\(idx)")
        if let tree: Tree = treeList[idx] {
            clipBoard = tree.xml
            Swift.print("clipBoard: " + "\(clipBoard!.string)")
        }
    }
    @objc func cut(sender: AnyObject) {
        Swift.print("cut")
        let idx = rightClickItemIdx!
        Swift.print("idx: " + "\(idx)")
        if let tree: Tree = treeList[idx] {
            treeList.remove(idx)
            clipBoard = tree.xml
            Swift.print("clipBoard: " + "\(clipBoard!.string)")
        }
    }
    @objc func paste(sender: AnyObject) {
        Swift.print("paste")
        if let idx3d = rightClickItemIdx, let clipBoard:XML = clipBoard{
            Swift.print("idx: " + "\(idx3d)")
            //Swift.print("clipBoard: " + "\(self.clipBoard)")


            let newIdx = Utils.newIdx(treeList,idx3d)
            let tree = TreeConverter.tree(clipBoard)
            treeList.insert(newIdx, tree)
        }
    }
    @objc func delete(sender: AnyObject) {
        Swift.print("delete")
        if let idx = rightClickItemIdx {
            treeList.remove(idx)
        }
        treeList.hashList.forEach {
            Swift.print("$0: " + "\($0)")
        }
    }
    /*move up down top bottom.*/
    @objc func moveUp(sender: AnyObject){
        Swift.print("moveUp")
        if let idx3d = rightClickItemIdx {
            TreeList3Modifier.moveUp(treeList, idx3d)
        }
    }
    @objc func moveDown(sender: AnyObject){
        Swift.print("moveDown")
        if let idx3d = rightClickItemIdx {
            TreeList3Modifier.moveDown(treeList, idx3d)
        }
    }
    @objc func moveToTop(sender: AnyObject){
        Swift.print("moveToTop")
        if let idx3d = rightClickItemIdx {
            TreeList3Modifier.moveTop(treeList, idx3d)
        }
    }
    @objc func moveToBottom(sender: AnyObject){
        Swift.print("moveToBottom")
        if let idx3d = rightClickItemIdx {
            TreeList3Modifier.moveBottom(treeList, idx3d)
        }
    }
    @objc func showInFinder(sender: AnyObject){
        Swift.print("showInFinder")
        if let idx = rightClickItemIdx, !TreeList3Asserter.hasChildren(treeList, idx) {
            /*Only repos can be opened in finder*/
            let repoItem = RepoUtils.repoItem(xml: treeList.xml, idx: idx)
            if FileAsserter.exists(repoItem.local.tildePath) {/*make sure local-path exists*/
                FileUtils.showFileInFinder(repoItem.local)
            }
        }
    }
    @objc func openURL(sender: AnyObject){
        Swift.print("openURL")
        if let idx = rightClickItemIdx {
            let hasChildren: Bool = treeList.hasChildren(idx)
            if !hasChildren {/*Only repos can be opened in finder*/
                let repoItem = RepoUtils.repoItem(xml: treeList.xml, idx: idx)
                NetworkUtils.openURLInDefaultBrowser(repoItem.remote)
            }
        }
    }
}
enum RepoMenuItem: String {
    case newGroup = "New group"
    case newRepo = "New repo"
    case duplicate = "Duplicate"
    case copy = "Copy"
    case cut = "Cut"
    case paste = "Paste"
    case delete = "Delete"
    case moveUp = "Move up"
    case moveDown = "Move down"
    case moveTop = "Move top"
    case moveBottom = "Move bottom"
    case showInFinder = "Show in finder"
    case openUrl = "Open URL"
}
private class Utils {
    /**
     * Returns a new idx
     * NOTE: isFolder -> add within, is not folder -> add bellow
     */
    static func newIdx(_ treeList: TreeListable3, _ idx3d: [Int]) -> [Int] {
        var idx3d = idx3d
        //let itemData:ItemData3 = TreeList3Utils.itemData(treeList, idx)
        let isGroup:Bool = TreeAsserter.hasAttribute(treeList.tree, idx3d, RepoFolderType.isOpen.rawValue)
        if treeList.hasChildren(idx3d) || isGroup{/*isFolder, add within*/
            idx3d += [0]
        }else{/*is not folder, add bellow*/
            idx3d[idx3d.count-1] = idx3d.last! + 1
        }
        return idx3d
    }
}
