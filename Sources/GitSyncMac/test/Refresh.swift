import Foundation
@testable import Utils

//try to make this class as static as possible
typealias CommitDPRefresher = Refresh//temp
class Refresh{//TODO:rename to refresh
    //var commitDB:CommitDB/* = CommitDB()*/
    static var commitDP:CommitDP?
    static var startTime:NSDate?//debugging
    static var isRefreshing:Bool = false/*avoids refreshing when the refresh has already started*/
    static var onComplete:()->Void = {print("⚠️️⚠️️⚠️️ Commit refresh completed but no onComplete is currently attached")}
    /**
     * Inits the refresh process
     */
    static func refresh(){
        isRefreshing = true/*avoid calling refresh when this is true, it is set to false on completion*/
        startTime = NSDate()//measure the time of the refresh
        FreshnessUtils.freshnessSort("~/Desktop/assets/xml/list.xml")//begin process on a background thread
    }
    /**
     * Adds commits to CommitDB
     */
    static func refreshRepos(_ sortableRepoList:[(repo:RepoItem,freshness:CGFloat)]){
        async(bgQueue, { () -> Void in/*run the task on a background thread*/
            sortableRepoList.forEach{/*the arr is already sorted from freshest to least fresh*/
                self.refreshRepo($0.repo)
            }
            async(mainQueue){/*jump back on the main thread*/
                self.onRefreshReposComplete()/*All repo items are now refreshed, the entire refresh process is finished*/
            }
        })
    }
    /**
     * Adds commit items to CommitDB if they are newer than the oldest commit in CommitDB
     * 1. Find the range of commits to add to CommitDB for this repo
     * 2. Retrieve the commit log items for this repo with the range specified
     */
    static func refreshRepo(_ repo:RepoItem){
        var commitCount:Int
        if(commitDP!.items.count > 0){
            let lastDate:Int = commitDP!.items.last!["sortableDate"]!.int/*the last date is always the furthest distant date 19:59,19:15,19:00 etc*/
            //Swift.print("lastDate: " + "\(lastDate)")
            let gitTime = GitDateUtils.gitTime(lastDate.string)/*converts descending date to git time*/
            let rangeCount:Int = GitUtils.commitCount(repo.localPath, after: gitTime).int/*Finds the num of commits from now until */
            Swift.print("rangeCount now..last: " + "\(rangeCount)")
            commitCount = min(rangeCount,100)/*force the value to be no more than max allowed*/
        }else {//< 100
            commitCount = 100
        }
        Swift.print("💙\(repo.title): rangeCount: " + "\(commitCount)")
        let results:[String] = Utils.commitItems(repo.localPath, commitCount)/*creates an array raw commit item logs, from repo*/
        results.forEach{
            if($0.count > 0){//resulting string must have characters
                let commitData:CommitData = GitLogParser.commitData($0)/*Compartmentalizes the result into a Tuple*/
                //let commit:Commit = CommitViewUtils.processCommitData(repoTitle,commitData,0)/*Format the data*/
                let commitDict:[String:String] = CommitViewUtils.processCommitData(repo.title, commitData, 0)//<---TODO:add repo idx here
                commitDP!.add(commitDict)/*add the commit log items to the CommitDB*/
            }else{
                Swift.print("-----ERROR: repo: \(repo.title) at index: \(index) didn't work")
            }
        }//if results.count == 0 then -> no commitItems to append (because they where to old or non existed)
    }
    
    /**
     * The final complete call
     */
    static func onRefreshReposComplete(){
        Swift.print("commitDB.sortedArr.count: " + "\(commitDP!.items.count)")
        Swift.print("Printing sortedArr after refresh: ")
        commitDP!.items.forEach{
            Swift.print("hash: \($0["hash"]!) date: \(GitDateUtils.gitTime($0["sortableDate"]!)) repo: \($0["repo-name"]!) ")
        }
        Swift.print("💚 onRefreshReposComplete() Time: " + "\(abs(startTime!.timeIntervalSinceNow))")/*How long did the gathering of git commit logs take?*/
        CommitDPCache.write(commitDP!)//write data to disk, we could also do this on app exit
        isRefreshing = false
        onComplete()//calls a dynamic onComplete method, other classes can override this variable to get callback
        Swift.print("Written to disk")
    }
}


private class Utils{
    /**
     * Basically creates an array of commit data from the latest commit until limit (limit:3 returns the 3 last commits)
     * Returns an array of commitItems at PARAM: localPath and limited with PARAM: max
     * PARAM: limit = max Items Allowed per repo
     */
    static func commitItems(_ localPath:String,_ limit:Int)->[String]{
        let commitCount:Int = GitUtils.commitCount(localPath).int - 1/*Get the total commitCount of this repo*/
        Swift.print("commitCount: " + ">\(commitCount)<")
        let len:Int = Swift.min(commitCount,limit)
        Swift.print("len: " + "\(len)")
        Swift.print("limit: \(limit)")
        var results:[String] = []
        let formating:String = "--pretty=format:Hash:%h%nAuthor:%an%nDate:%ci%nSubject:%s%nBody:%b".encode()!//"-3 --oneline"//
        for i in 0..<len{
            let cmd:String = "head~" + "\(i) " + formating + " --no-patch"
            let result:String = GitParser.show(localPath, cmd)//--no-patch suppresses the diff output of git show
            results.append(result)
        }
        return results.reversed()//reversed is a temp fix
    }
}
