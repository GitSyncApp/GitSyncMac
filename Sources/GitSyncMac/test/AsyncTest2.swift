import Foundation
@testable import Utils

class AsyncTest2 {
    let outerArr = [0,1,2]
    let innerArr = ["a","b"]
    /*Indecies*/
    var outerIdx = 0
    init(){
        func onOuterComplete(_ i_idx:Int, _ e_idx:Int){
            Swift.print("🍏 onOuterComplete \(i_idx), \(innerArr[e_idx]) 🍏")
            outerIdx += 1
            if(outerIdx == outerArr.count){
                allOuterCompleted()
            }
        }
        func allOuterCompleted(){
            Swift.print("🏁 allOuterTasksCompleted: 🏁")
        }
        func doInner(_ i:Int, _ onComplete:@escaping (_ a:Int, _ b:Int)->Void){
            var innerIdx = 0//Array(repeating: 0, count: outerArr.count)//basically just creates this [0,0,0]
            /*Completion handlers resides on the main thread*/
            func onInnerComplete(_ i_idx:Int, _ e_idx:Int){
                Swift.print("🍌 onInnerComplete \(i_idx), \(innerArr[e_idx]) 🍌")
                innerIdx += 1/*increment counter*/
                if(innerIdx == innerArr.count){
                    onComplete(i_idx,e_idx)
                }
            }
            for e in innerArr.indices{
                bg.async{/*do 2 things at the same time*/
                    Swift.print("===🚗 inner async started \(e)===")
                    sleep(IntParser.random(1, 6).uint32)/*simulates task that takes between 1 and 6 secs*/
                    main.async{/*we must jump back on main thread, because we want to manipulate a variable that resids on the main thread*/
                        onInnerComplete(i,e)/*we only itereate on the main thread via this method*/
                    }
                }
            }
        }
        /*The goal here is to fire of all sleep tasks in one swoop on a bg thread, 6 sleep tasks at once. not one after the other*/
        for i in outerArr.indices{
            bg.async {/*do 3 things at the same time*/
                Swift.print("🚄 ---outer async started \(i)---")
                doInner(i,onOuterComplete)
            }
        }
    }
}
