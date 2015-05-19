//
//  SecondViewController.swift
//  BMA
//
//  Created by Roman Spirichkin on Feb/28/15.
//  Copyright (c) 2015 RomanSpirichkinOrganization. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var subView: SubView!
    @IBOutlet weak var signalCollectionView: UICollectionView!
    @IBOutlet weak var buttonDetermination: UIButton!
    @IBOutlet weak var constraintFromTopToView: NSLayoutConstraint!
    @IBOutlet weak var constraintFromViewToButton: NSLayoutConstraint!
    @IBOutlet weak var constraintFromButtonToView: NSLayoutConstraint!
    @IBOutlet weak var outputView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subView.backgroundColor = Gray
        
        var constH = NSLayoutConstraint(item: signalCollectionView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: (UIScreen.mainScreen().bounds.height - 34 - 49) / 4)
        var constW = NSLayoutConstraint(item: signalCollectionView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: UIScreen.mainScreen().bounds.width - 20)
        signalCollectionView.addConstraint(constH)
        signalCollectionView.addConstraint(constW)
        signalCollectionView.dataSource = self
        signalCollectionView.delegate = self
        signalCollectionView.registerClass(SignalCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        signalCollectionView.backgroundColor = SeaFoam
        signalCollectionView.layer.borderColor = AquaCG
        signalCollectionView.layer.cornerRadius = 13
        signalCollectionView.layer.borderWidth = 2
        
        constraintFromTopToView.constant = constH.constant/3
        constraintFromViewToButton.constant = constH.constant*5/3
        constraintFromButtonToView.constant = -constH.constant*7/3
        buttonDetermination.titleLabel?.font = UIFont(name: "HelveticaNeue-UltraLight", size: CGFloat(constH.constant*3/4))
        buttonDetermination.backgroundColor = SeaFoam
        buttonDetermination.layer.borderColor = AquaCG
        buttonDetermination.layer.cornerRadius = 13
        buttonDetermination.layer.borderWidth = 2
        
        outputView.dataSource = self
        outputView.delegate = self
        outputView.registerClass(SignalCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        outputView.backgroundColor = SeaFoam
        outputView.layer.borderColor = AquaCG
        outputView.layer.cornerRadius = 13
        outputView.layer.borderWidth = 2
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [GrayCG, SeaFoamCG]
        gradient.locations = [0.5, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: self.view.frame.size.height/4, width: self.view.frame.size.width, height: self.view.frame.size.height/2)
        self.subView.layer.insertSublayer(gradient, atIndex: 0)
        let gradient2: CAGradientLayer = CAGradientLayer()
        gradient2.colors = [SeaFoamCG, GrayCG]
        gradient2.locations = [0.0, 0.5]
        gradient2.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient2.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient2.frame = CGRect(x: 0.0, y: self.view.frame.size.height*3/4, width: self.view.frame.size.width, height: self.view.frame.size.height/2)
        self.subView.layer.insertSublayer(gradient2, atIndex: 0)
        
        // init
        
        var arrayS1 = [Node]()
        for j in 0..<h {
            for i in 0..<n {
                var S1r : Double = 10.0 * Double(i) + Double(i)
                arrayS1.append(Node(value: S1r, Uout: S1r))
            }
        }
        var arrayS2 = [Node]()
        for j in 0..<h {
            for i in 0..<n {
                var S2r : Double = 10.0 * Double(i) - Double(i)
                arrayS2.append(Node(value: S2r, Uout: S2r))
            }
        }
        pairs.append(Pair(arrayS1: arrayS1, arrayS2: arrayS2))
        
        machineLearning(model: &model, pairs: pairs)
       // var p2 = Pair(arrayS1: arrayS1, arrayS2: arrayS1)
        //var ar = p2.arrayS1
        //let signalsOut = machineDetermination(&model, ar)
        //var cl = FirstViewController()
        //actionSearch
        
    }
    
    private let sectionInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSize(width: (signalCollectionView.bounds.width - CGFloat(sectionInsets.left*CGFloat(n*2)))/CGFloat(n), height: (signalCollectionView.bounds.height - CGFloat(sectionInsets.left*CGFloat(h*2)))/CGFloat(h))
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return h }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return n }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let newCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! SignalCollectionViewCell
        newCell.tag = indexPath.section * n + indexPath.row
        newCell.textField.tag = indexPath.section * n + indexPath.row
        if collectionView.tag == 100 {
        newCell.textField.text = (indexPath.section * n + indexPath.row).description
        }
        else {
           newCell.textField.text = ((indexPath.section * n + indexPath.row)*2).description
        }
        if newCell.textField.tag == n*h-1 {
            newCell.textField.returnKeyType = UIReturnKeyType.Done
        }
        return newCell
    }
    
    // Add New Pair
    @IBAction func actionNewPair(sender: AnyObject) {
        var arrayS1 = [Node]()
        for j in 0..<h {
            for i in 0..<n {
                var S1r = (signalCollectionView.cellForItemAtIndexPath(NSIndexPath(forRow: i, inSection: j)) as! SignalCollectionViewCell).textField.text.toDouble()!
                arrayS1.append(Node(value: S1r, Uout: S1r))
            }
        }
        var arrayS2 = [Node]()
        for j in 0..<h {
            for i in 0..<n {
                var S2r = (outputView.cellForItemAtIndexPath(NSIndexPath(forRow: i, inSection: j)) as! SignalCollectionViewCell).textField.text.toDouble()!
                arrayS2.append(Node(value: S2r, Uout: S2r))
            }
        }
        var P = pairs
        pairs.append(Pair(arrayS1: arrayS1, arrayS2: arrayS2))
    }
    // Learn
    @IBAction func actionLearn(sender: AnyObject) {
        actionNewPair(sender)
        machineLearning(model: &model, pairs: pairs)
        //signalCollectionView.backgroundColor = UIColor.redColor()
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
        (signalCollectionView.viewWithTag(n*h-1) as! SignalCollectionViewCell).textField.becomeFirstResponder()
        (signalCollectionView.viewWithTag(n*h-1) as! SignalCollectionViewCell).textField.resignFirstResponder()
        signalCollectionView.backgroundColor = UIColor.grayColor()
    }
}

