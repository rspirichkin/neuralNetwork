//
//  SecondViewController.swift
//  BMA
//
//  Created by Roman Spirichkin on Feb/28/15.
//  Copyright (c) 2015 RomanSpirichkinOrganization. All rights reserved.
//
import UIKit

class LearnViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var subView: SubView!
    @IBOutlet weak var collectionViewM1: UICollectionView!
    @IBOutlet weak var collectionViewM2: UICollectionView!
    @IBOutlet weak var buttonDetermination: UIButton!
    @IBOutlet weak var constraintFromTopToView: NSLayoutConstraint!
    @IBOutlet weak var constraintFromViewToButton: NSLayoutConstraint!
    @IBOutlet weak var constraintFromButtonToView: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subView.backgroundColor = Gray
        
        var constH = NSLayoutConstraint(item: collectionViewM1, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: (UIScreen.mainScreen().bounds.height - 34 - 49) / 4)
        var constW = NSLayoutConstraint(item: collectionViewM1, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: UIScreen.mainScreen().bounds.width - 20)
        collectionViewM1.addConstraint(constH)
        collectionViewM1.addConstraint(constW)
        collectionViewM1.dataSource = self
        collectionViewM1.delegate = self
        collectionViewM1.registerClass(SignalCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionViewM1.backgroundColor = SeaFoam
        collectionViewM1.layer.borderColor = AquaCG
        collectionViewM1.layer.cornerRadius = 13
        collectionViewM1.layer.borderWidth = 2
        
        constraintFromTopToView.constant = constH.constant/3
        constraintFromViewToButton.constant = constH.constant*5/3
        constraintFromButtonToView.constant = -constH.constant*7/3
        buttonDetermination.titleLabel?.font = UIFont(name: "HelveticaNeue-UltraLight", size: CGFloat(constH.constant*3/4))
        buttonDetermination.backgroundColor = SeaFoam
        buttonDetermination.layer.borderColor = AquaCG
        buttonDetermination.layer.cornerRadius = 13
        buttonDetermination.layer.borderWidth = 2
        
        collectionViewM2.dataSource = self
        collectionViewM2.delegate = self
        collectionViewM2.registerClass(SignalCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionViewM2.backgroundColor = SeaFoam
        collectionViewM2.layer.borderColor = AquaCG
        collectionViewM2.layer.cornerRadius = 13
        collectionViewM2.layer.borderWidth = 2
        
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
                var S1r : Double = Double(i+1)
                arrayS1.append(Node(Uin: S1r, Uout: S1r))
            }
        }
        var arrayS2 = [Node]()
        for j in 0..<h {
            for i in 0..<k {
                var S2r : Double = Double((i+1)%2)
                arrayS2.append(Node(Uin: S2r, Uout: S2r))
            }
        }
        //pairs.append(Pair(arrayS1: arrayS1, arrayS2: arrayS2))
    }
    
    private let sectionInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return h }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 100 { return n }
        if collectionView.tag == 101 { return k }
        return k
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if collectionView.tag == 100 {
            return CGSize(width: (collectionViewM1.bounds.width - CGFloat(sectionInsets.left*CGFloat(n*2)))/CGFloat(n), height: (collectionViewM1.bounds.height - CGFloat(sectionInsets.left*CGFloat(h*2)))/CGFloat(h)) }
        if collectionView.tag == 101 {
            return CGSize(width: (collectionViewM1.bounds.width - CGFloat(sectionInsets.left*CGFloat(k*2)))/CGFloat(k), height: (collectionViewM1.bounds.height - CGFloat(sectionInsets.left*CGFloat(k*2)))/CGFloat(h)) }
        return CGSize(width: (collectionViewM1.bounds.width - CGFloat(sectionInsets.left*CGFloat(n*2)))/CGFloat(n), height: (collectionViewM1.bounds.height - CGFloat(sectionInsets.left*CGFloat(h*2)))/CGFloat(h))
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let newCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! SignalCollectionViewCell
        if collectionView.tag == 100 {
            newCell.tag = indexPath.section * n + indexPath.row
            newCell.textField.tag = indexPath.section * n + indexPath.row
            newCell.textField.text = "4"
            if newCell.textField.tag == n*h-1 {
                newCell.textField.returnKeyType = UIReturnKeyType.Done
            }
        }
        if collectionView.tag == 101 {
            newCell.tag = indexPath.section * k + indexPath.row
            newCell.textField.tag = indexPath.section * k + indexPath.row
            newCell.textField.text = "0"
            if newCell.textField.tag == k*h-1 {
                newCell.textField.returnKeyType = UIReturnKeyType.Done
            }
        }
        return newCell
    }
    
    // Add New Pair
    @IBAction func actionNewPair(sender: AnyObject) {
        var arrayS1 = [Node]()
        for j in 0..<h {
            for i in 0..<n {
                var S1r = (collectionViewM1.cellForItemAtIndexPath(NSIndexPath(forRow: i, inSection: j)) as! SignalCollectionViewCell).textField.text.toDouble()!
                arrayS1.append(Node(Uin: S1r, Uout: S1r))
            }
        }
        var arrayS2 = [Node]()
        for j in 0..<h {
            for i in 0..<k {
                var S2r = (collectionViewM2.cellForItemAtIndexPath(NSIndexPath(forRow: i, inSection: j)) as! SignalCollectionViewCell).textField.text.toDouble()!
                arrayS2.append(Node(Uin: S2r, Uout: S2r))
            }
        }
        pairs.append(Pair(arrayS1: arrayS1, arrayS2: arrayS2))
    }
    // Learn
    @IBAction func actionLearn(sender: AnyObject) {
        actionNewPair(sender)
        machineLearning(model: &model, pairs: pairs)
        pairs.removeAll(keepCapacity: false)
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
        (collectionViewM1.viewWithTag(n*h-1) as! SignalCollectionViewCell).textField.becomeFirstResponder()
        (collectionViewM1.viewWithTag(n*h-1) as! SignalCollectionViewCell).textField.resignFirstResponder()
        collectionViewM1.backgroundColor = UIColor.grayColor()
    }
}

