import Foundation

class Selector {// :TODO: impliment a ISelector interface
    var element:String
    var classIds:Array<String>
    var id:String
    var states:Array<String>
    init(_ element:String = "",_ classIds:Array<String> = [],_ id:String = "",_ states:Array<String> = []) {
        self.element = element;
        self.classIds = classIds;
        self.id = id;
        self.states = states;
    }
}