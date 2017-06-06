import Foundation
@testable import Utils
@testable import Element

class LeftSideBar:Element{
    
    override func resolveSkin() {
        var css:String = ""
        css += "#leftBar{fill:orange;fill-alpha:0;width:80px;height:100%;float:left;padding-top:26px;}"
        
        StyleManager.addStyle(css)
        super.resolveSkin()
        let menuContainer = MenuContainer(NaN,NaN,self)
        self.addSubview(menuContainer)
    }
    
}