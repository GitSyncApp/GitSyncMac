import Cocoa
@testable import Utils
@testable import Element

class Nav {
    /**
     * Navigate between views
     * EXAMPLE: Nav.setView(.main(.prefs))
     * EXAMPLE: Nav.setView(.dialog(.commit))
     */
    static func setView(_ viewType:ViewType){
        StyleTestView.shared.leftBar.menuContainer?.selectButton(viewType)/*Selects the correct menu icon*/
        StyleTestView.shared.currentView = {
            if let curView = StyleTestView.shared.currentView {curView.removeFromSuperview()}/*Remove the old view*/
            let view = getView(viewType,StyleTestView.shared.content)
            return StyleTestView.shared.content.addSubView(view)
        }()
        
        if case Nav.ViewType.dialog( _) = viewType{
            Swift.print("🏀")
        }else if case Nav.ViewType.main( _ ) = viewType{
            Swift.print("🍏")
        }
        
//        switch viewType {
//        case .dialog(let dialog):
//            //
//        default:
//            //
//        }
        
        
    }
    private static func getView(_ view:ViewType,_ parentView:Element)->Element{
        switch view{
        case .main(let viewType):/*Main*/
            switch viewType {
            case .commit:
                return CommitView(NaN,NaN,parentView)
            case .repo:
                return RepoView(NaN,NaN,parentView)//RepoView2
            case .prefs:
                return PrefsView(NaN,NaN,parentView)
            }
        case .commitDetail(let commitData):/*CommitDetail*/
             let view:CommitDetailView = CommitDetailView(NaN,NaN,parentView)
             view.setCommitData(commitData)
             return view
            //fatalError("not implemented yet")
        case .repoDetail(let idx3d):/*RepoDetail*/
             let view:RepoDetailView = RepoDetailView(NaN,NaN,parentView)
             view.setRepoData(idx3d)
             return view
            //fatalError("not implemented yet")
        case .dialog(let dialog):/*Dialogs*/
            _ = dialog
            switch dialog{
            case .commit:
//                if !StyleTestView.shared.leftBar.isLeftBarHidden {//if leftSideBar is visible
//                    StyleTestView.shared.toggleSideBar(hide: true)
//                }
                let view:CommitDialogView = CommitDialogView(NaN,NaN,parentView)
                return view
                //fatalError("not implemented yet")
            case .conflict:
                //return ConflictDialogView(w,h,mainView)
                fatalError("not implemented yet")
            }
        }
    }
}
