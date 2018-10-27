//
//  ImageHelper.swift
//  AppStoreClone
//
//  Created by JosephNK on 2018. 10. 25..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

extension UIImage {
    
    static func imagePattern(withColor color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}

extension UIImageView {
    
    func setCacheImageURL(_ url: URL?) {
        self.setCacheImageURL(url, nil)
    }
    
    func setCacheImageURL(_ url: URL?, _ success: ((_ image: UIImage) -> Void)? = nil) {
        let urlString = url?.absoluteString ?? ""
        if urlString.isEmpty {
            self.image = nil
            return
        }
        
        self.image = nil
        
        ImageDownLoadManager.shared.requestImageURL(url, { [weak self] (image) in
            self?.image = image
            if let success = success {
                success(image)
            }
        }) { (error) in
            DDLogDebug("download error: \(error)")
        }
    }
}

extension UIButton {
    
    func setCacheImageURL(_ url: URL?) {
        let urlString = url?.absoluteString ?? ""
        if urlString.isEmpty {
            self.setImage(nil, for: UIControl.State.normal)
            return
        }
        
        ImageDownLoadManager.shared.requestImageURL(url, { [weak self] (image) in
            self?.setImage(image, for: UIControl.State.normal)
        }) { (error) in
            DDLogDebug("download error: \(error)")
        }
    }
    
}
