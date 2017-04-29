import Foundation
@testable import Element
@testable import Utils

class MinimalView:WindowView{
    override func resolveSkin(){
        //let css:String = "Window{fill-alpha:1;fill:white;corner-radius:4px;}"//
        //StyleManager.addStyle(css)
        super.resolveSkin()
        //rotationUITest()
        //checkBoxTest()
        treeList()
    }
   
    func rotationUITest(){
        var css = "Button{"
        css += "fill:blue,~/Desktop/ElCapitan/svg/arrow_right.svg grey6;"
        css += "transform:rotate(0deg),rotate(0deg);"
        css += "}"
        css += "Button:over{"
        css += "transform:rotate(0deg),rotate(90deg);"
        css += "}"
        StyleManager.addStyle(css)
        let btn = addSubView(Button(100,100,self))
        _ = btn
    }
    
    func treeList(){
        let url = "~/Desktop/repo2.xml"
        //let url = "~/Desktop/assets/xml/treelist.xml"
        let dp:TreeDP2 = TreeDP2(url.tildePath)
        _ = self.addSubView(TreeList3(140, 145, CGSize(24,24), dp, self))
    }
    /**
     *
     */
    func checkBoxTest(){
        var css = "CheckBox{"
        css += "float:left;clear:none;"
        css += "fill:blue,~/Desktop/ElCapitan/svg/arrow_right.svg grey6;"
        css += "transform:rotate(0deg),rotate(0deg);"
        css += "margin-left:0px,0px;"
        css += "}"
        css += "CheckBox:checked{"
        css += "transform:rotate(0deg),rotate(90deg);"
        css += "}"
        css += "Button{"
        css += "float:left;clear:none;"
        css += "fill:red;"
        css += "}"
        StyleManager.addStyle(css)
        let checkBox1 = addSubView(CheckBox(100,100,false,self))
        _ = checkBox1
        /**/
        let btn = addSubView(Button(100,100,self))
        btn.event = { event in
            if(event.type == ButtonEvent.upInside){
                Swift.print("click")
                var style:IStyle = StyleModifier.clone(checkBox1.skin!.style!)//We need to clone the style so not to change the style on other UI elements
                
                var marginLeft0:IStyleProperty = style.getStyleProperty("margin-left",0)!
                marginLeft0.value = 20
                StyleModifier.overrideStyleProperty(&style, marginLeft0)
                var marginLeft1:IStyleProperty = style.getStyleProperty("margin-left",1)!
                marginLeft1.value = 20
                StyleModifier.overrideStyleProperty(&style, marginLeft1)
                style.describe()
                
                checkBox1.skin?.setStyle(style)
            }
        }
    }
}
