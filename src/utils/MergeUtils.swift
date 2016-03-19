import Foundation
/**
 * Utility methods for merging branches
 */
class MergeUtils{
    static var options:Array<String> = ["keep local version", "keep remote version", "keep mix of both versions", "open local version", "open remote version", "open mix of both versions", "keep all local versions", "keep all remote versions", "keep all local and remote versions", "open all local versions", "open all remote versions", "open all mixed versions"]
    /**
     * Manual merge
     * NOTE: tries to merge a remote branch into a local branch
     * NOTE: prompts the users if a merge conflicts occure
     * TODO: we should use two branch params here since its entirly possible to merge from a different remote branch
     */
    class func manualMerge(localPath:String, _ remotePath:String, _ branch:String){
        Swift.print("MergeUtils.manualMerge()")
        
    }
    //property options : {}
	/*
 	 * Promts the user with a list of options to aid in resolving merge conflicts
 	 * @param branch: the branch you tried to merge into
 	 */
	class func resolveMergeConflicts(localRepoPath:String, _ branch:String, _ unMergedFiles:Array<String>){
		//log "resolve_merge_conflicts()"
		//log ("MergeUtil's resolve_merge_conflicts()")
        for unMergedFile:String in unMergedFiles {
			let lastSelectedAction:String = options.first! //you may want to make this a "property" to store the last item more permenantly
			print(lastSelectedAction)
            print(unMergedFile)
            fatalError("not implemented yet")
            //let listWindow:ListWindow = ListWindow(options,headerTitle:"Resolve merge conflict in: ",title:unMergedFile + ":",selected:lastSelectedAction,cancelButtonName:"Exit")//promt user with list of options, title: Merge conflict in: unmerged_file
			//listWindow.addTarget(self, action: "Complete: ", forControlEvents: .complete)
		}
	}
    /*
    func complete(sender:ListWindow!) {
	   print("Complete: " + sender.tag)
	   if(sender.didComplete){
			handleMergeConflictDialog(sender.didComplete, sender.selected, unMergedFile, localRepoPath, branch, unMergedFiles)
	   }else{
	   	//TODO: do the git merge --abort here to revert to the state you were in before the merge attempt, you may also want to display a dialog to informnthe user in which state the files are now.
	   }
	}
    */
	/*
 	 * Handles the choice made in the merge conflict dialog
 	 * TODO: test the open file clauses
 	 */
	class func handleMergeConflictDialog(selected:String, _ unmergedFile:String, _ localRepoPath:String, _ branch:String, _ unmergedFiles:Array<String>){
		//log "handle_merge_conflict_dialog()"
		//print("MergeUtil's handle_merge_conflict_dialog(): " & (item 1 of the_action))
		//last_selected_action = selected
		
        switch selected{
            case options[0]://keep local version
				GitModifier.checkOut(localRepoPath, "--ours", unmergedFile)
			case options[1]://keep remote version
				GitModifier.checkOut(localRepoPath, "--theirs", unmergedFile)
			case options[2]://keep mix of both versions
				GitModifier.checkOut(localRepoPath, branch, unmergedFile)
			case options[3]://open local version
				GitModifier.checkOut(localRepoPath, "--ours", unmergedFile)
				FileUtils.openFile(localRepoPath + unmergedFile)
			case options[4]://open remote version
				GitModifier.checkOut(localRepoPath, "--theirs", unmergedFile)
				FileUtils.openFile(localRepoPath + unmergedFile)
			case options[5]://open mix of both versions
				GitModifier.checkOut(localRepoPath, branch, unmergedFile)
				FileUtils.openFile(localRepoPath + unmergedFile)
			case options[6]://keep all local versions
				GitModifier.checkOut(localRepoPath, "--ours", "*")
			case options[7]://keep all remote versions
				GitModifier.checkOut(localRepoPath, "--theirs", "*")
			case options[8]://keep all local and remote versions
				GitModifier.checkOut(localRepoPath, branch, "*")
			case options[9]://open all local versions
				GitModifier.checkOut(localRepoPath, "--ours", "*")
				FileUtils.openFiles([])//localRepoPath unmergedFiles
			case options[10]://open all remote versions
				GitModifier.checkOut(localRepoPath, "--theirs", "*")
				FileUtils.openFiles([])//localRepoPath,unmergedFiles
			case options[11]://open all mixed versions
				GitModifier.checkOut(localRepoPath, branch, "*")
				FileUtils.openFiles([])//localRepoPath,unmergedFiles
        default:
				break;
		}
	}
}