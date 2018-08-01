//
//  ViewController.swift
//  GzipSwift Demo
//
//  Created by Prashant G on 7/31/18.
//  Copyright © 2018 MyOrg. All rights reserved.
//

import UIKit
import Gzip

class ViewController: UIViewController {
    
    let image = UIImage(named:"imageToTest.jpg")!
    
    var zippedData:Data?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // GZip to zip the image
        zipMyImage()
        
        // GUnzip to unzip the image
        unZipMyImage()
        
        
        // Image extension used to change the image size from 3.* MB to 300KB - 400KB
        if let imageData = image.jpeg(.medium) {
            print(imageData.count/1024)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Zip logic
    func zipMyImage()  {
        let imageData = UIImagePNGRepresentation(image)
        print((imageData?.count)!/1024)
        // gzip
        let compressedData: Data = try! imageData!.gzipped()
        let optimizedData: Data = try! imageData!.gzipped(level: .bestCompression)
        print(compressedData.count/1024)
        print(optimizedData.count/1024)
        
        zippedData = optimizedData
        print((zippedData?.count)!/1024)
    }
    
    // Unzip logic
    func unZipMyImage()  {
        // gunzip
        let decompressedData: Data
        if (zippedData?.isGzipped)! {
            decompressedData = try! zippedData!.gunzipped()
        } else {
            decompressedData = zippedData!
        }
        print(decompressedData.count/1024)
    }
    
}

// UIImage extension for changing image Quality
extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
}

