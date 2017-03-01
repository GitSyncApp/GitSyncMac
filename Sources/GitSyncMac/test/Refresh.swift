import Foundation
@testable import Utils

typealias CommitDPRefresher = Refresh//temp
/**
 * Basically creates/updates a list of the latest commits
 */
class Refresh{//TODO:rename to refresh
    //var commitDB:CommitDB/* = CommitDB()*/
    var commitDP:CommitDP?
    //var startTime:NSDate?//debugging
    //var isRefreshing:Bool = false/*avoids refreshing when the refresh has already started*/
    var onComplete:()->Void = {print("⚠️️⚠️️⚠️️ Refresh.onComplete() completed but no onComplete is currently attached")}
    init(_ commitDP:CommitDP){
        self.commitDP = commitDP
    }
    /**
     * Inits the refresh process
     */
    func initRefresh(){
        //isRefreshing = true/*avoid calling refresh when this is true, it is set to false on completion*/
        //let freshness = Freshness()
        //freshness.onFreshnessSortComplete = refreshRepos//👈
        //startTime = NSDate()/*Measure the time of the refresh*/
        //freshness.initFreshnessSort()//begin process on a background thread
        refreshRepos()
    }
    var repoCount:Int?
    var idx:Int = 0
    /**
     *
     */
    func onRefreshRepoComplete(){
        idx += 1
        if(idx == repoCount){
            self.onRefreshReposComplete()/*All repo items are now refreshed, the entire refresh process is finished*/
        }
    }
    /**
     * Adds commits to CommitDB
     * NOTE: This method is called from the freshness onComplete
     */
    func refreshRepos(/*_ sortableRepoList:[FreshnessItem]*/){
        //Swift.print("💛 Freshness.onFreshnessSortComplete() Time:-> " + "\(abs(self.startTime!.timeIntervalSinceNow))")/*How long it took*/
        let repos = RepoUtils.repoList
        repoCount = repos.count
        for i in repos.indices{
            bgQueue.async{/*run the task on a background thread*/
                RefreshUtils.refreshRepo(self.commitDP!,repos[i])//👈 0~1000's of git calls
                mainQueue.async{/*jump back on the main thread*/
                    self.onRefreshRepoComplete()
                }
            }
        }
    }
    /**
     * The final complete call
     */
    func onRefreshReposComplete(){
        Swift.print("commitDB.sortedArr.count: " + "\(commitDP!.items.count)")
        Swift.print("Printing sortedArr after refresh: ")
        commitDP!.items.forEach{
            Swift.print("hash: \($0["hash"]!) date: \(GitDateUtils.gitTime($0["sortableDate"]!)) repo: \($0["repo-name"]!) ")
        }
        //Swift.print("💚 onRefreshReposComplete() Time: " + "\(abs(startTime!.timeIntervalSinceNow))")/*How long did the gathering of git commit logs take?*/
        CommitDPCache.write(commitDP!)//write data to disk, we could also do this on app exit
        //isRefreshing = false
        onComplete()//calls a dynamic onComplete method, other classes can override this variable to get callback
        Swift.print("Written to disk")
    }
}
class RefreshUtils{
    /**
     * Adds commit items to CommitDB if they are newer than the oldest commit in CommitDB
     * Retrieve the commit log items for this repo with the range specified
     */
    static func refreshRepo(_ dp:CommitDP,_ repo:RepoItem){
        //once these completes then do result, you do not want to wait until calling refreshRepo
        let commitCount:Int = 0//self.commitCount(dp,repo)//👈2 git calls
        Swift.print("💙\(repo.title): rangeCount: " + "\(commitCount)")
        let results:[String] = Utils.commitItems(repo.localPath, commitCount,{})//👈0~100 Git calls/*creates an array raw commit item logs, from repo*/
        results.forEach{
            if($0.count > 0){/*resulting string must have characters*/
                let commitData:CommitData = GitLogParser.commitData($0)/*Compartmentalizes the result into a Tuple*/
                //let commit:Commit = CommitViewUtils.processCommitData(repoTitle,commitData,0)/*Format the data*/
                let commitDict:[String:String] = CommitViewUtils.processCommitData(repo.title, commitData, 0)//<---TODO:add repo idx here
                mainQueue.async{/*jump back on the main thread*/
                    dp.add(commitDict)/*add the commit log items to the CommitDB*/
                }
            }else{
                Swift.print("-----ERROR: repo: \(repo.title) at index: \(index) didn't work")
            }
        }//if results.count == 0 then -> no commitItems to append (because they where to old or non existed)
    }
    /**
     * Find the range of commits to add to CommitDB for this repo
     */
    private static func commitCount(_ dp:CommitDP,_ repo:RepoItem, _ onComplete:@escaping (_ commitCount:Int)->Void) {
        //var commitCount:Int
        func onRangeCommitCountComplete(_ count:Int){
            bg.async {
                var totCommitCount:Int = GitUtils.commitCount(repo.localPath).int - 1//👈1 Git call/*Get the total commitCount of this repo*/
                totCommitCount = Swift.min(totCommitCount,count)
                main.async{
                    onComplete(totCommitCount)//🚪
                }
            }
        }
        if(dp.items.count > 0){
            let lastDate:Int = dp.items.last!["sortableDate"]!.int/*the last date is always the furthest distant date 19:59,19:15,19:00 etc*/
            //Swift.print("lastDate: " + "\(lastDate)")
            let gitTime = GitDateUtils.gitTime(lastDate.string)/*converts descending date to git time*/
            bg.async {
                let rangeCount:Int = GitUtils.commitCount(repo.localPath, after: gitTime).int//👈1 Git call /*Finds the num of commits from now until */
                Swift.print("rangeCount now..last: " + "\(rangeCount)")
                main.async{
                    let commitCount = min(rangeCount,100)/*force the value to be no more than max allowed*/
                    onRangeCommitCountComplete(commitCount)
                }
            }
        }else {//< 100
            onRangeCommitCountComplete(100)//you need to top up dp with 100 if dp.count = 0, ⚠️️ this works because later this value is cliped to max of repo.commits.count
        }
    }
}
private class Utils{
    /**
     * Basically creates an array of commit data from the latest commit until limit (limit:3 returns the 3 last commits)
     * Returns an array of commitItems at PARAM: localPath and limited with PARAM: max
     * PARAM: limit = max Items Allowed per repo
     */
    static func commitItems(_ localPath:String,_ limit:Int, _ onComplete:()->Void)->[String]{
        //Swift.print("limit: \(limit)")
        var results:[String] = []
        let formating:String = "--pretty=format:Hash:%h%nAuthor:%an%nDate:%ci%nSubject:%s%nBody:%b".encode()!//"-3 --oneline"//
        for i in 0..<limit{
            let cmd:String = "head~" + "\(i) " + formating + " --no-patch"
            bg.async{/*inner*/
                let result:String = GitParser.show(localPath, cmd)//👈 git call//--no-patch suppresses the diff output of git show
                main.async {
                    results.append(result)
                }
            }
        }
        return results.reversed()//reversed is a temp fix
    }
}
