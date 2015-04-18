//
//  FirstViewController.swift
//  BMA
//
//  Created by Roman Spirichkin on Feb/28/15.
//  Copyright (c) 2015 RomanSpirichkinOrganization. All rights reserved.
//
import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
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
        constraintFromViewToButton.constant = constH.constant/3
        constraintFromButtonToView.constant = constH.constant/3
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
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height/2)
        self.subView.layer.insertSublayer(gradient, atIndex: 0)
        let gradient2: CAGradientLayer = CAGradientLayer()
        gradient2.colors = [SeaFoamCG, GrayCG]
        gradient2.locations = [0.0, 0.5]
        gradient2.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient2.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient2.frame = CGRect(x: 0.0, y: self.view.frame.size.height/2, width: self.view.frame.size.width, height: self.view.frame.size.height/2)
        self.subView.layer.insertSublayer(gradient2, atIndex: 0)
    }
    
    private let sectionInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSize(width: (signalCollectionView.bounds.width - CGFloat(sectionInsets.left*CGFloat(n*2)))/CGFloat(n), height: (signalCollectionView.bounds.height - CGFloat(sectionInsets.left*CGFloat(h*2)))/CGFloat(h))
    }
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
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
        newCell.textField.text = (indexPath.section * n + indexPath.row).description
        if newCell.textField.tag == n*h-1 {
            newCell.textField.returnKeyType = UIReturnKeyType.Done
        }
        return newCell
    }
    
    @IBAction func actionSearch(sender: AnyObject) {
        signalCollectionView.backgroundColor = UIColor.redColor()
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
}




