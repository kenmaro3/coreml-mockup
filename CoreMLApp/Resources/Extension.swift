import Foundation

import UIKit


extension UIView{
    var top: CGFloat{
        frame.origin.y
    }
    
    var right: CGFloat{
        frame.origin.x + width
    }
    
    var bottom: CGFloat{
        frame.origin.y + height
    }
    
    var left: CGFloat{
        frame.origin.x
    }
    
    var width: CGFloat{
        frame.size.width
    }
    
    var height: CGFloat{
        frame.size.height
    }
}
