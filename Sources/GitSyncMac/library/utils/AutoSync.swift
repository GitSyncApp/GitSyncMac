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
    var countForRepoWithMSG:Int = 0
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
        incrementCountForRepoWithMSG()
    }
    /**
     * New
     */
    func incrementCountForRepoWithMSG(){
        if countForRepoWithMSG < repoListThatRequireManualMSG!.count {
            let repo = repoListThatRequireManualMSG![countForRepoWithMSG]
            countForRepoWithMSG += 1
            if let commitMessage = CommitMessageUtils.generateCommitMessage(repo.local) {//if no commit msg is generated, then no commit is needed
                Nav.setView(.dialog(.commit(repo,commitMessage)))/*⬅️️🚪*/
            }else {
                onRepoWithMSGSyncComplete(false)//fire of an anonmouse onCOmplete call
                incrementCountForRepoWithMSG()//nothing to commit, iterate
            }
        }
    }
    /**
     *
     */
    func onRepoWithMSGSyncComplete(_ hasPushed:Bool){
        if countForRepoWithMSG == repoListThatRequireManualMSG!.count{
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
