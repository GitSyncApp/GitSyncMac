import Foundation
@testable import Utils
/**
 * NOTE: It seems its dificult to add Dispatch group to this, as all commits are fired of at once and depending on its result a subsequent push is called
 */
class AutoSync {
    typealias AutoSyncComplete = ()->Void
    static let shared = AutoSync()
    var repoList:[RepoItem]?
    var repoListThatRequireManualMSG:[RepoItem]?
    var msgCount:Int = 0
    var autoSyncGroup:DispatchGroup?
    /**
     * The GitSync automation algo (Basically Commits and pushes)
     * TODO: ⚠️️ Try to use dispathgroups instead
     */
    func initSync(_ onComplete:@escaping AutoSyncComplete){
        //Swift.print("🔁 AutoSync.initSync() 🔁")
        autoSyncGroup = DispatchGroup()
        autoSyncGroup?.notify(queue: main){
            Swift.print("🏁🏁🏁 AutoSync.swift All repos are now AutoSync'ed")//now go and read commits to list
            onComplete()/*All commits and pushes was completed*/
        }
        repoList = RepoUtils.repoListFlattenedOverridden/*re-new the repo list*/
        repoListThatRequireManualMSG = repoList?.filter{!$0.message}
        iterateMessageCount()
    }
    /**
     * New
     */
    func iterateMessageCount(){
        if let messageList = repoListThatRequireManualMSG, msgCount < messageList.count {
            let repo = messageList[msgCount]
            msgCount += 1
            if let commitMessage = CommitMessageUtils.generateCommitMessage(repo.local) {//if no commit msg is generated, then no commit is needed
                Nav.setView(.dialog(.commit(repo,commitMessage)))/*⬅️️🚪*/
            }else {
                iterateMessageCount()//nothing to commit, iterate
            }
        }else {
            syncRepoItemsWithAutoMessage()
        }
    }
    /**
     *
     */
    private func syncRepoItemsWithAutoMessage(){
        repoList?.filter{$0.message}.forEach { repoItem in/*all the initCommit calls are non-waiting. */
            autoSyncGroup?.enter()
            GitSync.initCommit(repoItem,onPushComplete)//🚪⬅️️ Enter the AutoSync process here
        }
    }
    /**
     * When a singular push is compelete this method is called
     */
    func onPushComplete(_ hasPushed:Bool){
        Swift.print("onPushComplete")
        autoSyncGroup?.leave()
    }
}
