import Foundation
@testable import Utils

class GitSync{
    /**
     * Handles the process of making a commit for a single repository
     */
    static func initCommit(_ repoList:[RepoItem],_ idx:Int, _ onComplete:@escaping (_ idx:Int,_ hasCommited:Bool)->Void){
        let repoItem = repoList[idx]
        //Swift.print("initCommit: title: " + "\(repoItem.title)")
        //log "GitSync's handle_commit_interval() a repo with doCommit " & (remote_path of repo_item) & " local path: " & (local_path of repo_item)
        bg.async {/*All these git processes needs to happen one after the other*/
            let hasUnMergedpaths = GitAsserter.hasUnMergedPaths(repoItem.local)//🌵Asserts if there are unmerged paths that needs resolvment
            //Swift.print("hasUnMergedpaths: " + "\(hasUnMergedpaths)")
            if(hasUnMergedpaths){
                //Swift.print("has unmerged paths to resolve")
                let unMergedFiles = GitParser.unMergedFiles(repoItem.local)// 🌵 Asserts if there are unmerged paths that needs resolvment
                MergeUtils.resolveMergeConflicts(repoItem.local, repoItem.branch, unMergedFiles)
            }
            let hasCommited = commit(repoItem.local)//🌵 if there were no commits false will be returned
            //Swift.print("hasCommited: " + "\(hasCommited)")
            main.async {/*jump back on the main thread again*/
                onComplete(idx,hasCommited)//🚪➡️️ -> Exit here
            }
        }
    }
    /**
     * Handles the process of making a push for a single repository
     * NOTE: We must always merge the remote branch into the local branch before we push our changes.
     * NOTE: this method performs a "manual pull" on every interval
     * TODO: ⚠️️ Contemplate implimenting a fetch call after the pull call, to update the status, whats the diff between git fetch and git remote update again?
     */
    static func initPush(_ repoList:[RepoItem],_ idx:Int,/*_ onComplete:@escaping (_ hasPushed:Bool)->Void,*/ _ group:DispatchGroup){
        Swift.print("initPush")
        bg.async {/*The git calls needs to happen one after the other on bg thread*/
            group.enter()
            let repoItem = repoList[idx]
            var remotePath:String = repoItem.remote
            if(remotePath.test("^https://.+$")){remotePath = remotePath.subString(8, remotePath.count)}/*support for partial and full url,strip away the https://, since this will be added later*/
            let repo:GitRepo = (repoItem.local, remotePath, repoItem.branch)
            MergeUtils.manualMerge(repo)//🌵🌵🌵 commits, merges with promts, (this method also test if a merge is needed or not, and skips it if needed)
            let hasLocalCommits = GitAsserter.hasLocalCommits(repo.localPath, repoItem.branch)/*🌵🌵 TODO: maybe use GitAsserter's is_local_branch_ahead instead of this line*/
            //Swift.print("hasLocalCommits: " + "\(hasLocalCommits)")
            var hasPushed:Bool = false
            if hasLocalCommits { //only push if there are commits to be pushed, hence the has_commited flag, we check if there are commits to be pushed, so we dont uneccacerly push if there are no local commits to be pushed, we may set the commit interval and push interval differently so commits may stack up until its ready to be pushed, read more about this in the projects own FAQ
                guard let keychainPassword:String = KeyChainParser.password("GitSyncApp") else{ fatalError("password not found")}
                //Swift.print("keychainPassword: 🔑" + "\(keychainPassword)")
                //Swift.print("repo.keyChainItemName: " + "\(repoItem.keyChainItemName)")
                let key:GitKey = (PrefsView.prefs.login, keychainPassword)
                if PrefsView.prefs.login.isEmpty || keychainPassword.isEmpty {fatalError("need login and pass")}
                let pushCallBack = GitModifier.push(repo,key)/*🌵*/
                _ = pushCallBack
                Swift.print("pushCallBack: " + "\(pushCallBack)")
                hasPushed = true
            }
            Swift.print("hasPushed: " + "\(hasPushed)")
            group.leave()
        }
    }
    /**
     * This method generates a git status list,and asserts if a commit is due, and if so, compiles a commit message and then tries to commit
     * Returns true if a commit was made, false if no commit was made or an error occured
     * NOTE: checks git staus, then adds changes to the index, then compiles a commit message, then commits the changes, and is now ready for a push
     * NOTE: only commits if there is something to commit
     * TODO: add branch parameter to this call
     * NOTE: this a purly local method, does not need to communicate with remote servers etc..
     */
    static func commit(_ localRepoPath:String)->Bool{
        //Swift.print("commit()")
        let statusList = StatusUtils.generateStatusList(localRepoPath)//get current status
        //Swift.print("statusList.count: " + "\(statusList.count)")
        if (statusList.count > 0) {
            //Swift.print("doCommit().there is something to add or commit")
            StatusUtils.processStatusList(localRepoPath, statusList) //process current status by adding files, now the status has changed, some files may have disapared, some files now have status as renamed that prev was set for adding and del
            let title = CommitUtils.sequenceCommitMsgTitle(statusList) //sequence commit msg title for the commit
            //Swift.print("commitMsgTitle: " + "\(title)")
            let desc = DescUtils.sequenceDescription(statusList)//sequence commit msg description for the commit
            //Swift.print("commitMsgDesc: >" + "\(desc)" + "<")
            let commitResult = GitModifier.commit(localRepoPath, (title,desc))//🌵 commit
            _ = commitResult
            //Swift.print("commitResult: " + "\(commitResult)")
            return true/*return true to indicate that the commit completed*/
        }else{
            //Swift.print("nothing to add or commit")
            return false/*break the flow since there is nothing to commit or process*/
        }
    }
}
