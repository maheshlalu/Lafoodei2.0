//
//  CXCameraView.swift
//  Lefoodie
//
//  Created by Manishi on 1/2/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import AVFoundation

public protocol CXCameraViewDelegate: class{
    
    func cameraShotFinished(_ image: UIImage)
    
}
class CXCameraView: UIView, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var previewViewContainer: UIView!
    @IBOutlet weak var shotButton: UIButton!
    let flashButton: UIButton = UIButton()
     let flipButton: UIButton = UIButton()
    @IBOutlet weak var fullAspectRatioConstraint: NSLayoutConstraint!
    var croppedAspectRatioConstraint: NSLayoutConstraint?
    
    weak var delegate: CXCameraViewDelegate? = nil
    
    var session: AVCaptureSession?
    var device: AVCaptureDevice?
    var videoInput: AVCaptureDeviceInput?
    var imageOutput: AVCaptureStillImageOutput?
    var focusView: UIView?
    
    var flashOffImage: UIImage?
    var flashOnImage: UIImage?
    
    static func instance() -> CXCameraView {
        
        return UINib(nibName: "CXCameraView", bundle: Bundle(for: self.classForCoder())).instantiate(withOwner: self, options: nil)[0] as! CXCameraView
    }
    
    func initialize() {
        
        if session != nil {
            return
        }
        
        self.backgroundColor = CXBackgroundColor
        
        let bundle = Bundle(for: self.classForCoder)
        
        flashOnImage = CXFlashOnImage != nil ? CXFlashOnImage : UIImage(named: "ic_flash_on", in: bundle, compatibleWith: nil)
        flashOffImage = CXFlashOffImage != nil ? CXFlashOffImage : UIImage(named: "ic_flash_off", in: bundle, compatibleWith: nil)
        let flipImage = CXFlipImage != nil ? CXFlipImage : UIImage(named: "ic_loop", in: bundle, compatibleWith: nil)
        let shotImage = CXShotImage != nil ? CXShotImage : UIImage(named: "ic_radio_button_checked", in: bundle, compatibleWith: nil)
        
        flashButton.frame = CGRect(x:self.previewViewContainer.frame.size.width - 45 , y: self.previewViewContainer.frame.size.height - 50, width: 30, height: 30)
        flashButton.addTarget(self, action: #selector(flashButtonPressed(sender:)), for: .touchUpInside)
        self.addSubview(flashButton)
        
        flipButton.frame = CGRect(x: 8, y: self.previewViewContainer.frame.size.height - 50, width: 30, height: 30)
        flipButton.addTarget(self, action: #selector(flipButtonPressed(sender:)), for: .touchUpInside)
        self.addSubview(flipButton)
        
        if(CXTintIcons) {
            
            flipButton.tintColor  = UIColor.white
            shotButton.tintColor  = CXBaseTintColor
            
            flashButton.setImage(flashOffImage?.withRenderingMode(.alwaysTemplate), for: UIControlState())
            flipButton.setImage(flipImage?.withRenderingMode(.alwaysTemplate), for: UIControlState())
            shotButton.setImage(shotImage?.withRenderingMode(.alwaysTemplate), for: UIControlState())
        } else {
            flashButton.setImage(flashOffImage, for: UIControlState())
            flipButton.setImage(flipImage, for: UIControlState())
            shotButton.setImage(shotImage, for: UIControlState())
        }
        
        
        self.isHidden = false
        
        // AVCapture
        session = AVCaptureSession()
        
        for device in AVCaptureDevice.devices() {
            
            if let device = device as? AVCaptureDevice , device.position == AVCaptureDevicePosition.back {
                
                self.device = device
                
                if !device.hasFlash {
                    
                    flashButton.isHidden = true
                }
            }
        }
        
        do {
            
            if let session = session {
                
                videoInput = try AVCaptureDeviceInput(device: device)
                
                session.addInput(videoInput)
                
                imageOutput = AVCaptureStillImageOutput()
                
                session.addOutput(imageOutput)
                
                let videoLayer = AVCaptureVideoPreviewLayer(session: session)
                //videoLayer?.backgroundColor = UIColor.red.cgColor
                videoLayer?.frame = self.previewViewContainer.bounds
                videoLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
                
                self.previewViewContainer.layer.addSublayer(videoLayer!)
                
                session.sessionPreset = AVCaptureSessionPresetMedium
                
                session.startRunning()
                
            }
            
            // Focus View
            self.focusView         = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
            let tapRecognizer      = UITapGestureRecognizer(target: self, action:#selector(CXCameraView.focus(_:)))
            tapRecognizer.delegate = self
            self.previewViewContainer.addGestureRecognizer(tapRecognizer)
            
        } catch {
            
        }
        flashConfiguration()
        
        self.startCamera()
        self.flipButton.bringSubview(toFront: self.previewViewContainer)
        self.flashButton.bringSubview(toFront: self.previewViewContainer)
        NotificationCenter.default.addObserver(self, selector: #selector(CXCameraView.willEnterForegroundNotification(_:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    func willEnterForegroundNotification(_ notification: Notification) {
        
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        if status == AVAuthorizationStatus.authorized {
            
            session?.startRunning()
            
        } else if status == AVAuthorizationStatus.denied || status == AVAuthorizationStatus.restricted {
            
            session?.stopRunning()
        }
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func startCamera() {
        
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        if status == AVAuthorizationStatus.authorized {
            
            session?.startRunning()
            
        } else if status == AVAuthorizationStatus.denied || status == AVAuthorizationStatus.restricted {
            
            session?.stopRunning()
        }
    }
    
    func stopCamera() {
        session?.stopRunning()
    }
    
    @IBAction func shotButtonPressed(_ sender: UIButton) {
        
        guard let imageOutput = imageOutput else {
            
            return
        }
        
        DispatchQueue.global(qos: .default).async(execute: { () -> Void in
            
            let videoConnection = imageOutput.connection(withMediaType: AVMediaTypeVideo)
            
            let orientation: UIDeviceOrientation = UIDevice.current.orientation
            switch (orientation) {
            case .portrait:
                videoConnection?.videoOrientation = .portrait
            case .portraitUpsideDown:
                videoConnection?.videoOrientation = .portraitUpsideDown
            case .landscapeRight:
                videoConnection?.videoOrientation = .landscapeLeft
            case .landscapeLeft:
                videoConnection?.videoOrientation = .landscapeRight
            default:
                videoConnection?.videoOrientation = .portrait
            }
            
            imageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (buffer, error) -> Void in
                
                self.session?.stopRunning()
                
                //let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
                
                let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)

                if let image = UIImage(data: data!), let delegate = self.delegate {
                    
                    // Image size
                    var iw: CGFloat
                    var ih: CGFloat
                    
                    switch (orientation) {
                    case .landscapeLeft, .landscapeRight:
                        // Swap width and height if orientation is landscape
                        iw = image.size.height
                        ih = image.size.width
                    default:
                        iw = image.size.width
                        ih = image.size.height
                    }
                    

                    // Frame size

                    let sw = self.previewViewContainer.frame.width
                    print(sw)
                    // The center coordinate along Y axis
                    let rcy = ih * 0.5
                    
                    let imageRef = image.cgImage?.cropping(to: CGRect(x: rcy-iw*0.5, y: 0 , width: iw, height: iw))
                    
                    //let imageViewImg = UIImage(cgImage: image as! CGImage, scale: 1.0, orientation: UIImageOrientation.right)//sw/iw
                    DispatchQueue.main.async(execute: { () -> Void in
                        if CXCropImage {
                           let resizedImage = UIImage(cgImage: imageRef!, scale: sw/iw, orientation: image.imageOrientation)
                            delegate.cameraShotFinished(resizedImage)
                          //  delegate.cameraShotFinished(image.resizedImage(withMaximumSize: CGSize(width: UIScreen.main.bounds.width*2, height: UIScreen.main.bounds.width*2)))

                           // UIImageWriteToSavedPhotosAlbum(resizedImage, nil, nil, nil)

                        } else {
                            delegate.cameraShotFinished(image)
                        }
                        
                        self.session     = nil
                        self.device      = nil
                        self.imageOutput = nil
                        
                    })
                }
                
            })
            
        })
    }
    
    
    
    func resizeImage(image:UIImage) -> UIImage
    {
        var actualHeight:Float = Float(image.size.height)
        var actualWidth:Float = Float(image.size.width)
        
        let maxHeight:Float = Float(UIScreen.main.bounds.height*0.75) //your choose height
        let maxWidth:Float = Float(UIScreen.main.bounds.width)  //your choose width
        
        var imgRatio:Float = actualWidth/actualHeight
        let maxRatio:Float = maxWidth/maxHeight
        
        if (actualHeight > maxHeight) || (actualWidth > maxWidth)
        {
            if(imgRatio < maxRatio)
            {
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            }
            else if(imgRatio > maxRatio)
            {
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            }
            else
            {
                actualHeight = maxHeight;
                actualWidth = maxWidth;
            }
        }
        
        
        
        let rect:CGRect = CGRect(x: 0, y: 0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData:NSData = UIImageJPEGRepresentation(img, 1.0)! as NSData
        UIGraphicsEndImageContext()
        
        return UIImage(data: imageData as Data)!
    }
    
     func flipButtonPressed(sender: UIButton) {
        
        if !cameraIsAvailable() {
            
            return
        }
        
        session?.stopRunning()
        
        do {
            
            session?.beginConfiguration()
            
            if let session = session {
                
                for input in session.inputs {
                    
                    session.removeInput(input as! AVCaptureInput)
                }
                
                let position = (videoInput?.device.position == AVCaptureDevicePosition.front) ? AVCaptureDevicePosition.back : AVCaptureDevicePosition.front
                
                for device in AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) {
                    
                    if let device = device as? AVCaptureDevice , device.position == position {
                        
                        videoInput = try AVCaptureDeviceInput(device: device)
                        session.addInput(videoInput)
                        
                    }
                }
                
            }
            
            session?.commitConfiguration()
            
            
        } catch {
            
        }
        
        session?.startRunning()
    }
    
    func flashButtonPressed(sender: UIButton) {
        
        if !cameraIsAvailable() {
            
            return
        }
        
        do {
            
            if let device = device {
                
                guard device.hasFlash else { return }
                
                try device.lockForConfiguration()
                
                let mode = device.flashMode
                
                if mode == AVCaptureFlashMode.off {
                    
                    device.flashMode = AVCaptureFlashMode.on
                    flashButton.setImage(flashOnImage, for: UIControlState())
                    
                } else if mode == AVCaptureFlashMode.on {
                    
                    device.flashMode = AVCaptureFlashMode.off
                    flashButton.setImage(flashOffImage, for: UIControlState())
                }
                
                device.unlockForConfiguration()
                
            }
            
        } catch _ {
            
            flashButton.setImage(flashOffImage, for: UIControlState())
            return
        }
        
    }
}

extension CXCameraView {
    
    @objc func focus(_ recognizer: UITapGestureRecognizer) {
        
        let point = recognizer.location(in: self)
        let viewsize = self.bounds.size
        let newPoint = CGPoint(x: point.y/viewsize.height, y: 1.0-point.x/viewsize.width)
        
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            
            try device?.lockForConfiguration()
            
        } catch _ {
            
            return
        }
        
        if device?.isFocusModeSupported(AVCaptureFocusMode.autoFocus) == true {
            
            device?.focusMode = AVCaptureFocusMode.autoFocus
            device?.focusPointOfInterest = newPoint
        }
        
        if device?.isExposureModeSupported(AVCaptureExposureMode.continuousAutoExposure) == true {
            
            device?.exposureMode = AVCaptureExposureMode.continuousAutoExposure
            device?.exposurePointOfInterest = newPoint
        }
        
        device?.unlockForConfiguration()
        
        self.focusView?.alpha = 0.0
        self.focusView?.center = point
        self.focusView?.backgroundColor = UIColor.clear
        self.focusView?.layer.borderColor = CXBaseTintColor.cgColor
        self.focusView?.layer.borderWidth = 1.0
        self.focusView!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        self.addSubview(self.focusView!)
        
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 3.0, options: UIViewAnimationOptions.curveEaseIn, // UIViewAnimationOptions.BeginFromCurrentState
            animations: {
                self.focusView!.alpha = 1.0
                self.focusView!.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }, completion: {(finished) in
            self.focusView!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.focusView!.removeFromSuperview()
        })
    }
    
    func flashConfiguration() {
        
        do {
            
            if let device = device {
                
                guard device.hasFlash else { return }
                
                try device.lockForConfiguration()
                
                device.flashMode = AVCaptureFlashMode.off
                flashButton.setImage(flashOffImage, for: UIControlState())
                
                device.unlockForConfiguration()
                
            }
            
        } catch _ {
            
            return
        }
    }
    
    func cameraIsAvailable() -> Bool {
        
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        if status == AVAuthorizationStatus.authorized {
            
            return true
        }
        
        return false
    }
}

