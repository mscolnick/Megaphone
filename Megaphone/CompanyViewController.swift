//
//  CompanyViewController.swift
//  Megaphone
//
//  Created by Myles Scolnick on 4/2/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

import Foundation


import UIKit

private let reuseIdentifier = "CompanyCell"

class CompanyViewController : UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    var companyList: NSArray?

    override func viewDidLoad() {
        println("Company Screen Loaded");
        
        super.viewDidLoad()
        if let path = NSBundle.mainBundle().pathForResource("CompanyList", ofType: "plist") {
            println("CompanyList imported");
            companyList = NSArray(contentsOfFile: path)
        }
        
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return companyList!.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as CompanyCell
        // Configure the cell
        let company = companyList![indexPath.row] as NSDictionary
        let companyName = company["Name"] as NSString
        let companyLogo = UIImage(named: companyName)!
        cell.imageView.image = companyLogo
        
        cell.imageView.contentMode = UIViewContentMode.Center;
        cell.imageView.contentMode = UIViewContentMode.ScaleAspectFit;

        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let company = companyList![indexPath.row] as NSDictionary
        let companyName = company["Name"] as NSString
        println("Clicked \(companyName)!")
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
            return CGSize(width: 100, height: 100)
    }
    
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 10.0, bottom: 50.0, right: 10.0)
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
    
}