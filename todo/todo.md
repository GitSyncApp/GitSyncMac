### Continue here:🔨
    //Maybe use a simpler list while debugging and a non-fancy refresh button (to test out ideas and the GitSync algorithm) 👈
    //then create a custom merge method that efficiently merges sortedByDates onto ListView.dp
    //Take a look at how the GitSync apple-script is organized. and copy the workflow to swift 
    //Improve the compact-date parser (see twitter app and also other apps) ✨
    //Translucent overlay for the menu ✨
    //Fix the CompactBody problem (occurs with Element MacOS repo) (soon)
### Completed:🏁
    //Figure out a workflow to store commit logs in xml (maybe use reflection) because querying git is cpu intensive ✅            
    //CommitListRefresh algo ✅
    //Figure out how to derive previous commit messages from repo's. You need from 0 to 10 latest commits.
        //Research custom "git log" commands ✅
        //Store each commit in an array with data capsules (date:"",author:"",subject:"",body:"") ✅
            //figure out the body bug by printing all the body strings and testing each one ✅
                //also cap the subject? or maybe not? maybe there is a max subject length already? google it (done 50/72 rule)
            //store all subjects and body strings in a txt file for debugging (done, used GitHub Desktop)
        //Format the date into an NSDate instance, see old notes ✅
        //Then figure out how to sort these based on the date within them ✅
            //make an array with Tuples then sort on date as num: 20161203 aka YYYYMMDDHHMMSS ✅
        //Then make a list of all commits from all repos. Cap the list at 200 divide by repos.count to find how many to get from each repo
            //Use NSNotification with NSTask when extracting data from the repos ✅
                //try to add the task to a Background thread
        //then add this list to CommitsView ✅
    //Write a post about Gitsync app demo ✅
    //Brush up on your Git Skills. ✅
    //Publish 4 articles about Git on gitsync.io ✅
    //setup init test for the GitSync Algo with a few test projects (see old test files) ✅
    //make the textBg in the darkmode more subtle, its too bright at the moment ✅
    //create the 10 sec video demo of the Current GUI interactions ✅
    //add the Date Text UI Element to StatsView and hock up the interactivity logic (next)
        //move the DateText into the CommitGraph, because touch interactivity is located there
    //RepoDetailView should have a CheckBoxButton: Auto-sync ✅
    //PrefsView should have the Auto-sync-interval: (as its too complicated to have individual timers, too much can go wrong) ✅
    //move sync interval to prefs-view ✅
    //create auto-sync checkbox in repo-detail-view ✅
    //rename subscribe and broadcast to download and upload ✅
    //darkmode checkbox should be true ✅
    //design CommitDetailView in illustrator ✅
    //adjust the dialog designs ✅
    //add CommitDetailView to the app (take cues from GitHub) ✅
    //Create the Conflict resolution prompt w/ darkmode ✅
    //Create the commit message prompt w/ darkmode ✅
    //center-align repo-detail and add broader text input fields ✅
    //center-align the prefs ✅
### Later🖖
    //Figure out how you can update the FastList with new Items and not lose track of selected idx etc
        //Start testing this with the regular List
        //I think you can just append the DataProvider and refresh the visible items, then you just increment the selected idx for every append
    //path picker for localPath in repodetailview (folder icon)
    //add a eye-icon for find in finder feature in repodetailview
    //write about the mc2/bump idea (create logo idea ?!?)
    //prepare 3 blog posts about FastList,ProgressIndicator,LineGraph for stylekit
    //attempt to add the switch skin functionality in a small isolated test (w/ styles from generic.css, just switching a few params)
    //Use the san-fran font (if you can find it)
    
### Future🔮
    //Animate the Menu Icons to wobble in and out on click (similar to twitter for iOS)
        //Make animated gif of this animation in double retina resolution
    //cmd click on repo items will reveal edit icon in top bar for multi edit feature
    //Add support for tabbing the textfields
    //Add focus state support to the TextInput components
    
    
### Ideas:💡
    //Conversational search: (or via type-blocks similar to macOS search)
        //{range:"all commits"} {author:"made by eonist"} {where:"in the element repo"} {time-period:"this summer"}
    //Auto-message: if the alteration is removing empty whitespace or empty lines. Create a case for this: Removed 3 empty lines, or Removed whitespace