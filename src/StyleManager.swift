import Foundation
class StyleManager{
    static var styles:Array<IStyle> = []
    /**
    * Adds a style to the styleManager class
    * @param style: IStyle
    */
    class func addStyle(style:IStyle){
        styles.append(style);
    }
    /**
    * Adds every style in a styleCollection to the stylemanager
    */
    class func addStyle(styles:Array<IStyle>){
        self.styles += styles;
    }
    
    /**
    * Locates and returns a Style by the @param name.
    * @return a Style
    */
    class func getStyle(name:String)->IStyle?{
        let numOfStyles:Int = styles.count;
        for(var i:Int = 0;i < numOfStyles;i++) {
            if((styles[i] as IStyle).name == name) {
                return styles[i];
            }
        }
        return nil;
    }
   
}