//
//  SecondViewController.swift
//  BMA
//
//  Created by Roman Spirichkin on Feb/28/15.
//  Copyright (c) 2015 RomanSpirichkinOrganization. All rights reserved.
//
import UIKit

class InputViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var iTextField: UITextField!
    @IBOutlet weak var buttonSet: UIButton!
    @IBOutlet weak var hTextField: UITextField!
    @IBOutlet weak var kTextField: UITextField!
    @IBOutlet weak var nTextField: UITextField!
    @IBOutlet weak var subView: UIScrollView!
    @IBOutlet weak var buttonDetermination: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subView.backgroundColor = Gray
        
        buttonDetermination.titleLabel?.font = UIFont(name: "HelveticaNeue-UltraLight", size: CGFloat(50))
        buttonDetermination.backgroundColor = SeaFoam
        buttonDetermination.layer.borderColor = AquaCG
        buttonDetermination.layer.cornerRadius = 13
        buttonDetermination.layer.borderWidth = 2
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [GrayCG, SeaFoamCG]
        gradient.locations = [0.0, 1]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.frame = CGRect(x: 0.0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height/2)
        self.subView.layer.insertSublayer(gradient, atIndex: 0)
        let gradient2: CAGradientLayer = CAGradientLayer()
        gradient2.colors = [SeaFoamCG, GrayCG]
        gradient2.locations = [0.0, 1]
        gradient2.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient2.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradient2.frame = CGRect(x: 0.0, y: self.view.frame.size.height/2, width: self.view.frame.size.width, height: self.view.frame.size.height/2)
        self.subView.layer.insertSublayer(gradient2, atIndex: 1)
        
        if self.subView.tag == 100 {
        
        self.nTextField.text = n.description
        self.kTextField.text = k.description
        self.hTextField.text = h.description
        }
        else {
            
        }
        
    }
    
    @IBAction func actionSet(sender: AnyObject) {
        n = nTextField.text.toInt()!
        k = kTextField.text.toInt()!
        h = hTextField.text.toInt()!
        model = Model(n: n*h, k: k*h, m: (n+k)*h)
        pairs.removeAll(keepCapacity: true)
        
        if let vc = self.parentViewController {
            if let vc0 = vc.childViewControllers[0] as? LearnViewController {
                vc0.loadView()
                vc0.viewDidLoad()
            }
            if let vc1 = vc.childViewControllers[1] as? SearchViewController {
                vc1.loadView()
                vc1.viewDidLoad()
                vc1.view.backgroundColor = UIColor.redColor()
            }
        }
    }
    @IBAction func actionReset(sender: AnyObject) {
        model = Model(n: n*h, k: k*h, m: (n+k)*h)
    }
    @IBAction func actionAdvancedSet(sender: AnyObject) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning() }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField.tag < n*h-1) {
            (self.view.viewWithTag(textField.tag+1) as! UITextField).becomeFirstResponder()
        }
        else { textField.resignFirstResponder(); self.view.endEditing(true) }
        return true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
    }
}

