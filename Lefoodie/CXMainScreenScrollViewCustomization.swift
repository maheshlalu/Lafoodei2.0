//
//  CXMainScreenScrollViewCustomization.swift
//  Lefoodie
//
//  Created by Manishi on 1/2/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import Foundation
import UIKit

final class CXMainScreenScrollViewCustomization: UIScrollView, UIScrollViewDelegate {
    
    var imageView = UIImageView()
    let btnRotations = UIButton()
    
    var imageSize: CGSize?
    
    var image: UIImage! = nil {
        
        didSet {
            
            if image != nil {
                
                if !imageView.isDescendant(of: self) {
                    self.imageView.alpha = 1.0
                    self.addSubview(imageView)
                }
                
            } else {
                
                imageView.image = nil
                return
            }
            
            if !CXCropImage {
                // Disable scroll view and set image to fit in view
                imageView.frame = self.frame
                imageView.contentMode = .scaleAspectFit
                self.isUserInteractionEnabled = false
                
                imageView.image = image
                return
            }
            
            let imageSize = self.imageSize ?? image.size
            
            let ratioW = frame.width / imageSize.width // 400 / 1000 => 0.4
            let ratioH = frame.height / imageSize.height // 300 / 500 => 0.6
            
            if ratioH > ratioW {
                imageView.frame = CGRect(
                    origin: CGPoint.zero,
                    size: CGSize(width: imageSize.width  * ratioH, height: frame.height)
                )
            } else {
                imageView.frame = CGRect(
                    origin: CGPoint.zero,
                    size: CGSize(width: frame.width, height: imageSize.height  * ratioW)
                )
            }
            
            self.contentOffset = CGPoint(
                x: imageView.center.x - self.center.x,
                y: imageView.center.y - self.center.y
            )
            
            self.contentSize = CGSize(width: imageView.frame.width + 1, height: imageView.frame.height + 1)
            
            imageView.image = image
            let frame1 = CGRect(x: 8, y: 200, width: 30, height: 30)
            btnRotations.frame = frame1
            let imgve = UIImage(named: "RotateImage")
            btnRotations.setBackgroundImage(imgve, for: UIControlState.normal)
            imageView.addSubview(btnRotations)
            btnRotations.addTarget(self, action:#selector(pressButton(button:)), for: .touchUpInside)
            
            imageView.isUserInteractionEnabled = true
            btnRotations.isUserInteractionEnabled = true
            btnRotations.isHidden = false
            
            self.zoomScale = 1.0
            
        }
        
    }
    func pressButton(button:UIButton){
        print("imaggge")

        if btnRotations.isSelected {
            self.zoomScale = 1.0
            
        }else{
            self.zoomScale = 1.3
            
        }
        btnRotations.isHidden = false
    
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)!
        self.backgroundColor = CXBackgroundColor
        self.frame.size      = CGSize.zero
        self.clipsToBounds   = true
        self.imageView.alpha = 0.0
        
        imageView.frame = CGRect(origin: CGPoint.zero, size: CGSize.zero)
        
        self.maximumZoomScale = 2.0
        self.minimumZoomScale = 0.8
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator   = false
        self.bouncesZoom = true
        self.bounces = true
        
        self.delegate = self
    }
    
    
    func changeScrollable(_ isScrollable: Bool) {
        
        self.isScrollEnabled = isScrollable
    }
    
    // MARK: UIScrollViewDelegate Protocol
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return imageView
        
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
            
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            
            contentsFrame.origin.y = 0.0
        }
        
        imageView.frame = contentsFrame
        
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
        self.contentSize = CGSize(width: imageView.frame.width + 1, height: imageView.frame.height + 1)
    }
    
}
