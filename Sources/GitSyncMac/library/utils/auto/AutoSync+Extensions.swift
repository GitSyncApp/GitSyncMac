import Foundation
@testable import Utils
/**
 * Methods
 */
extension AutoSync{
    /**
     * Syncs auto-message repos
     */
    private func syncOtherRepos(){
        let group = DispatchGroup()
        otherRepos.forEach { repoItem in/*all the initCommit calls are non-waiting. */
            group.enter()
            bg.async {
                GitSync.initCommit(repoItem,nil,{group.leave()})/*🚪⬅️️ Enter the AutoSync process here, it's wrapped in a bg thread because hwne oush complets it jumps back on the main thread*/
            }
        }
        group.notify(queue: main){//It also fires when nothing left or entered
            self.autoSyncComplete()/*All commits and pushes was completed*/
        }
    }
}
/**
 * Event handlers
 */
extension AutoSync{
    /**
     * This is called when all repos are verified that they exist locally and remotly
     */
    func onAllReposVerified(){
        if !messageRepoIterator.isEmpty {
            messageRepoIterator.iterate()/*Iterate over repos with manual commit message*/
        }else if !otherRepos.isEmpty {
            Swift.print("otherRepos: " + "\(otherRepos)")
            syncOtherRepos()
        }else {/*Nothing to sync*/
            autoSyncComplete()
        }
    }
}
/**
 * Generators
 */
extension AutoSync{
    /**
     * Generates the repoList
     */
    func createRepoList() -> [RepoItem]{
        let repoList = RepoUtils.repoListFlattenedOverridden/*Get the latest repo list*/
        Swift.print("repoList.count: " + "\(repoList.count)")
        return isUserInitiated ? repoList : repoList.filter{$0.auto}/*if interval initiated then only target repos that have interval set to true*/
    }
    /**
     * Generates the MessageRepoIterator
     */
    func createMessageRepoIterator() -> MessageRepoIterator{
        let messageRepos:[RepoItem] = repoList.filter{$0.message}/*repos that have manual commit message*/
        Swift.print("messageRepos.count: " + "\(messageRepos.count)")
        return .init(array:messageRepos,onComplete:syncOtherRepos)
    }
}
