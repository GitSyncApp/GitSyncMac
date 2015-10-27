import Foundation
class Section:Element {//Unlike Container, section can have a style applied
    /*
    *  This class exists because one shouldnt use the Element class as a holder of content
    */
    override init(_ width: Int, _ height: Int, _ style: IStyle) {
        super.init(width, height, style)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}