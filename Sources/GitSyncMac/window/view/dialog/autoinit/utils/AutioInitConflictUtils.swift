import Foundation
@testable import Utils

class AutoInitConflictUtils {
    typealias State = (pathExists:Bool,hasPathContent:Bool,isGitRepo:Bool,areRemotesEqual:Bool)
    typealias TextData = (issue:String,proposal:String)
    /**
     * Creates the text for the AutoInitPrompt
     */
    static func text(_ conflict:AutoInitConflict)->TextData{//TODO: ⚠️️ Move to AutoInitUtils
        Swift.print("AutoInitConflict.text")
        let repoItem = conflict.repoItem
        var issue:String = ""
        var proposal:String = ""
        let state:State = (conflict.pathExists,conflict.hasPathContent,conflict.isGitRepo,conflict.areRemotesEqual)
        Swift.print("state: " + "\(state)")
        switch state {
        case (true,true,true,false):
            issue = "There is already a git project in the folder: \(repoItem.local) with a different remote URL"
            proposal = "Do you want delete the current files, download the git repo from remote?"
        case (true,true,false,_):
            issue = "The folder \(repoItem.localPath) is not a git repo but there are pre-exisiting files"
            proposal = "Do you want to keep the files, download the git repo from remote and start a merge wizard?"
        case (true,false,_,_):
            issue = "The folder in path: " + "\(repoItem.localPath) is empty"
            proposal = "Do you want to download the remote git repository into this path?"
        case (false,_,_,_):
            issue = "The path \(repoItem.localPath) doesn't exist"
            proposal = "Do you want to create it and download files from remote "//\(repoItem.remotePath)
        default:
            fatalError("Has no strategy for this scenario \(state)")
        }
        return (issue,proposal)
    }
    /**
     * NOTE: after this you often want to : MergeUtils.manualMerge(repoItem,{})
     */
    static func process(_ conflict:AutoInitConflict){//TODO: ⚠️️ Move to AutoInitUtils
        let state:State = (conflict.pathExists,conflict.hasPathContent,conflict.isGitRepo,conflict.areRemotesEqual)
        let repoItem = conflict.repoItem
        Swift.print("AutoInitConflic.process() state: \(state)")
        switch state {
        case (true,true,true,false):
            Swift.print("a")
            
        case (true,true,false,_):
            Swift.print("")
            _ = GitModifier.initialize(repoItem.localPath)
            _ = GitModifier.attachRemoteRepo(repoItem.localPath,repoItem.branch)//--add new remote origin
        case (true,false,_,_):
            Swift.print("c")
            GitUtils.manualClone(repoItem.localPath.tildePath, repoItem.remotePath, repoItem.branch)
            //            let status = GitModifier.clone(repoItem.remotePath,repoItem.localPath.tildePath)
        //            Swift.print("status: " + "\(status)")
        case (false,_,_,_):
            Swift.print("d")
            _ = GitModifier.clone(repoItem.remotePath,repoItem.localPath.tildePath)//--this will create the folders if they dont exist, even nested
        default:
            fatalError("Has no strategy for this scenario: \(state) ")
        }
    }
}