//
//  ImageHelper.swift
//  AppStoreClone
//
//  Created by JosephNK on 2018. 10. 25..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

extension UIImage {
    
    /**
     색상을 이미지로 변환
     - parameters:
     - color: 색상
     - returns: 이미지
     */
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
    
    /**
     이미지 리사이즈 함수
     - parameters:
     - image: 이미지
     - targetSize: 원하는 사이즈
     - returns: 리사이즈 이미지
     */
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
    
    /**
     이미지뷰에 URL로 부터 Cache 이미지 설정하는 Extention 함수
     - parameters:
     - url: URL
     */
    func setCacheImageURL(_ url: URL?) {
        self.setCacheImageURL(url, nil)
    }
    
    /**
     이미지뷰에 URL로 부터 Cache 이미지 설정하는 Extention 함수
     - parameters:
     - url: URL
     - success: 성공 block
     */
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
    
    /**
     버튼에 URL로 부터 Cache 이미지 설정하는 Extention 함수
     - parameters:
     - url: URL
     */
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
