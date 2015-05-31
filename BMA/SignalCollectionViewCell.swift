
import UIKit
import Foundation

class SignalCollectionViewCell: UICollectionViewCell, UITextFieldDelegate{
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    var textField: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textField = UITextField(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        textField.textAlignment = .Center
        textField.font = UIFont(name: "HelveticaNeue-Thin", size: CGFloat(frame.height*5/6))
        
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderColor = AquaCG
        self.layer.cornerRadius = 13
        self.layer.borderWidth = 1
        textField.textColor = Aqua
        textField.layer.borderColor = SeaFoamCG
        textField.layer.cornerRadius = 13
        textField.layer.borderWidth = 2
        
        self.textField.delegate = self
        textField.keyboardType = UIKeyboardType.NumbersAndPunctuation
        textField.returnKeyType = UIReturnKeyType.Next
        
        contentView.addSubview(textField)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField.tag < n*h-1) {
            (self.superview?.viewWithTag(textField.tag+1) as! SignalCollectionViewCell).textField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        textField.endEditing(true)
        if (textField.tag < n*h-1) {
            (self.superview?.viewWithTag(textField.tag+1) as! SignalCollectionViewCell).textField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
    }
    
    func cellResignFirstResponder () -> () {
        textField.resignFirstResponder()
    }
}

class SubView : UIScrollView {
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        (self.viewWithTag(100)!.viewWithTag(n*h-1) as! SignalCollectionViewCell).textField.becomeFirstResponder()
        (self.viewWithTag(100)!.viewWithTag(n*h-1) as! SignalCollectionViewCell).textField.resignFirstResponder();
        var io = UITextField()
        io.becomeFirstResponder()
        io.resignFirstResponder()
        self.backgroundColor = Gray // view.endEditing(true)
    }
}
