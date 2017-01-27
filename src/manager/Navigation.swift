import Cocoa
@testable import Utils

/**
 * TODO: Migrate to its own .swift file when appropriate
 */
class Navigation {
    static var activeView:String = MenuView.commits//<--default
    static var currentView:NSView? {return MainWin.mainView?.currentView}
    /**
     * Navigate between views
     */
    static func setView(_ viewName:String){
        Navigation.activeView = viewName
        Swift.print("Navigation.setView() viewName: " + "\(viewName)")
        let mainView:MainView = MainWin.mainView!
        if(mainView.currentView != nil) {mainView.currentView!.removeFromSuperview()}
        
        let width:CGFloat = MainView.w
        let height:CGFloat = MainView.h
        /**
         * TODO: Use class name instead of static let strings
         */
        switch viewName{
            case MenuView.commits:
                Swift.print("set commits win")
                mainView.currentView = mainView.addSubView(CommitsView(width,height,mainView))
            case MenuView.repos:
                mainView.currentView = mainView.addSubView(RepoView(width,height,mainView))
            case MenuView.stats:
                mainView.currentView = mainView.addSubView(StatsView(width,height,mainView))
            case MenuView.prefs:
                Swift.print("set prefs win")
                mainView.currentView = mainView.addSubView(PrefsView(width,height,mainView))
            case "\(RepoDetailView.self)":
                mainView.currentView = mainView.addSubView(RepoDetailView(width,height,mainView))
            case "\(ConflictDialogView.self)":
                mainView.currentView = mainView.addSubView(ConflictDialogView(width,height,mainView))
            case "\(DebugView.self)":
                mainView.currentView = mainView.addSubView(DebugView(width,height,mainView))
            case "\(TestView.self)":
                mainView.currentView = mainView.addSubView(TestView(width,height,mainView))
            case "\(CommitDetailView.self)":
                Swift.print("set CommitDetailView win")
                mainView.currentView = mainView.addSubView(CommitDetailView(width,height,mainView))
            default:
                break;
        }
    }
}
