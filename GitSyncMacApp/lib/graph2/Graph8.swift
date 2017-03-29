import Foundation
@testable import Element
@testable import Utils

//test snappy friction ✅
//test zoom to time-levels ✅
//test fastList with dates ✅
//Test animate graphPoint ✅

//between zoom levels you just do random graph
    //make some randomVals 👈
//you derive the time range based on the first and last visible items in fastList
//you make a rand value list for each time zoon on app init which is consistent across time level zooming

//hock up the timeRangeDescTextComponent

//after all these works, you then figure out how to jump in and out of time levels at the point you are at.
//create padding for values tht dont exist, you need to show 7 time points but may have only commits in 1 year for instance
//try to add valuebar
//try to add the git stuff and your done


class Graph8 {
    //Build the modell first rather than add it later?
    
    //year 2010 - 2017 -> create rand values
    //month (Gen from year range) -> create rand values
    //day (gen from year range) -> create rand values
        //you actually generate these on the fly. 
            //instead of pulling items from an array you pull from a method that calculates via progress and Date()
                //this is cool! you do this for month and year to, takes care of padding time values as well.
                    //try some tests around this concept first
                    //look at the FastList and see if it can support it! 👀 ✅
                        //All you need todo is SubClass DP and make it adhere to a dateRange of 7 years. or longer if the commit hist is longer, but 7 years for now
                        //you can even have 3 dp's that you switch between zoom levels
    let fromYear:Int = 2010
    let toYear:Int = 2017
    var range:Range<Int> {return fromYear..<toYear}
    init(){
        
        let dp = DayDP(range)
        Swift.print("dp.count: " + "\(dp.count)")
    }
}

class DayDP:DataProvider{
    static var numOfDaysInYear:Int = 365
    var yearRange:Range<Int>
    override var count:Int {return yearRange.count * DayDP.numOfDaysInYear }/*numOfDaysInYearRange*/
    override var items:[[String:String]] {get{fatalError("Not available")}set{fatalError("Not available")}}
    init(_ yearRange:Range<Int>) {
        self.yearRange = yearRange
    }
    override func item(_ at: Int) -> [String : String]? {
        return ["title":""]
    }
}
