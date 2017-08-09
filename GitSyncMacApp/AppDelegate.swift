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
        Swift.print("GitSync - Automates git")
        initApp()
        
//        AutoInit.autoInit("~/dev/welcome/".tildePath, remotePath: "github.com/gitsync/welcome.git", branch: "master")
        
        //Continue here: 🏀
        
            //Hock up the dialog prompts to manualMerge etc ✅
                //start hocking up MergeConflicView logic ✅
                    //check legacy code ✅
                    //test merge then commit dialog
        
        
            //THere is a problem where repos are not pulled. Fetch is never being called on each autoSync. test this again 👈
        
            //The autosync on interval
                //stop on pull gesture init 🚫
                //start after pull gesture completes etc
        
            //Fix the problem where the text gets reset if you change focus ✅
        
            //Add Auto init
                //auto fill local path
                //design UX for stashing / remove preexisting files / merge into
        
            //add filepicker prompt
                //needs filepicker UI

    }
    
    /**
     * Initializes the app
     */
    func initApp(){
        NSApp.windows[0].close()/*<--Close the initial non-optional default window*/
        
        let themeStr:String = PrefsView.prefs.darkMode ? "dark.css" : "light.css"
        let styleFilePath:String = Config.Bundle.styles + "styles/styletest/" + themeStr
        Swift.print("styleFilePath: " + "\(styleFilePath)")
        StyleManager.addStyle(url:styleFilePath,liveEdit: false)
        //StyleWatcher.watch("~/Desktop/ElCapitan/","~/Desktop/ElCapitan/gitsync.css", self.win!.contentView!)
        win = StyleTestWin(PrefsView.prefs.rect.w, PrefsView.prefs.rect.h)
        
        menu = Menu()/*This creates the App menu*/
    }
    func applicationWillTerminate(_ aNotification:Notification) {
        _ = FileModifier.write(Config.Bundle.prefs.tildePath, PrefsView.xml.xmlString)/*Stores the app prefs*/
        Swift.print("💾 Write PrefsView to: prefs.xml")
        _ = FileModifier.write(Config.Bundle.repo.tildePath, RepoView.treeDP.tree.xml.xmlString)/*store the repo xml*/
        Swift.print("💾 Write RepoList to: repo.xml")
        print("Good-bye")
    }
}
