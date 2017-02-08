//
//  CXCameraSourceViewController.swift
//  Lefoodie
//
//  Created by Manishi on 1/2/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import Photos

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

public protocol CXCameraSourceDelegate:class {
    
    // MARK: Required
    func CXImageSelected(_ image: UIImage, source: CXMode)
    func CXCameraRollUnauthorized()
    
    // MARK: Optional
    func CXDismissedWithImage(_ image: UIImage, source: CXMode)
    func CXClosed()
    
}

extension CXCameraSourceDelegate {
    func CXDismissedWithImage(_ image: UIImage, source: CXMode) {}
    func CXClosed() {}
}

public var CXBaseTintColor   = UIColor.appTheamColor()
public var CXTintColor       = UIColor.appTheamColor()
public var CXBackgroundColor = UIColor.hex("#3B3D45", alpha: 1.0)

public var CXAlbumImage : UIImage? = nil
public var CXCameraImage : UIImage? = nil
public var CXVideoImage : UIImage? = nil
public var CXCheckImage : UIImage? = nil
public var CXCloseImage : UIImage? = nil
public var CXFlashOnImage : UIImage? = nil
public var CXFlashOffImage : UIImage? = nil
public var CXFlipImage : UIImage? = nil
public var CXShotImage : UIImage? = nil

public var CXVideoStartImage : UIImage? = nil
public var CXVideoStopImage : UIImage? = nil

public var CXCropImage: Bool = true

public var CXCameraRollTitle = "CAMERA ROLL"
public var CXCameraTitle = "PHOTO"
public var CXVideoTitle = "VIDEO"
public var CXTitleFont = UIFont(name: "AvenirNext-DemiBold", size: 15)

public var CXTintIcons : Bool = true

public enum CXModeOrder {
    case cameraFirst
    case libraryFirst
}

public enum CXMode {
    case camera
    case library
    case video
}

class CXCameraSourceViewController: UIViewController {
    
    public var hasVideo = false
    public var cropHeightRatio: CGFloat = 1
    
    var mode: CXMode = .camera
    public var modeOrder: CXModeOrder = .libraryFirst
    var willFilter = true
    
    @IBOutlet weak var photoLibraryViewerContainer: UIView!
    @IBOutlet weak var cameraShotContainer: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    lazy var albumView  = CXAlbumView.instance()
    lazy var cameraView = CXCameraView.instance()
    
    fileprivate var hasGalleryPermission: Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized
    }
    
    public weak var delegate: CXCameraSourceDelegate? = nil
    
    override public func loadView() {
        
        if let view = UINib(nibName: "CXCameraSourceViewController", bundle: Bundle(for: self.classForCoder)).instantiate(withOwner: self, options: nil).first as? UIView {
            
            self.view = view
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = CXBackgroundColor
        
        cameraView.delegate = self
        albumView.delegate  = self
        
        menuView.backgroundColor = CXBackgroundColor
        menuView.addBottomBorder(UIColor.black, width: 1.0)
        
        let bundle = Bundle(for: self.classForCoder)
        let closeImage = CXCloseImage != nil ? CXCloseImage : UIImage(named: "ic_close", in: bundle, compatibleWith: nil)
        
        if CXTintIcons {

            libraryButton.tintColor = CXTintColor
            cameraButton.tintColor  = CXTintColor
            closeButton.tintColor = CXBaseTintColor
            doneButton.tintColor = CXBaseTintColor
            
        } else {

            libraryButton.tintColor = nil
            cameraButton.tintColor = nil
            closeButton.setImage(closeImage, for: UIControlState())
        }
        
        cameraButton.clipsToBounds  = true
        libraryButton.clipsToBounds = true
        
        changeMode(CXMode.library)
        
        photoLibraryViewerContainer.addSubview(albumView)
        cameraShotContainer.addSubview(cameraView)
        //videoShotContainer.addSubview(videoView)
        
        titleLabel.textColor = CXBaseTintColor
        titleLabel.font = CXTitleFont

        if CXCropImage {
            let heightRatio = getCropHeightRatio()
            cameraView.croppedAspectRatioConstraint = NSLayoutConstraint(item: cameraView.previewViewContainer, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: cameraView.previewViewContainer, attribute: NSLayoutAttribute.width, multiplier: heightRatio, constant: 0)
            
            //cameraView.fullAspectRatioConstraint.isActive = false
            //cameraView.croppedAspectRatioConstraint?.isActive = true
        } else {
            cameraView.fullAspectRatioConstraint.isActive = true
            cameraView.croppedAspectRatioConstraint?.isActive = false
        }
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        albumView.frame  = CGRect(origin: CGPoint.zero, size: photoLibraryViewerContainer.frame.size)
        albumView.layoutIfNeeded()
        cameraView.frame = CGRect(origin: CGPoint.zero, size: cameraShotContainer.frame.size)
        cameraView.layoutIfNeeded()
        
        
        albumView.initialize()
        cameraView.initialize()
        
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopAll()
    }
    
    override public var prefersStatusBarHidden : Bool {
        
        return true
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            
            self.delegate?.CXClosed()
        })
    }
    
    @IBAction func libraryButtonPressed(_ sender: UIButton) {
        
        changeMode(CXMode.library)
    }
    
    @IBAction func photoButtonPressed(_ sender: UIButton) {
        
        changeMode(CXMode.camera)
    }
    
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        self.doneImage()
    }
    
}

extension CXCameraSourceViewController: CXAlbumViewDelegate, CXCameraViewDelegate {
    public func getCropHeightRatio() -> CGFloat {
        return cropHeightRatio
    }
    
    // MARK: FSCameraViewDelegate
    func cameraShotFinished(_ image: UIImage) {
        
        delegate?.CXImageSelected(image, source: mode)
        self.dismiss(animated: true, completion: {
            self.doneImage()
        })
    }
    
    func doneImage(){
        let view = albumView.imageCropView
        
        if CXCropImage {
            let normalizedX = (view?.contentOffset.x)! / (view?.contentSize.width)!
            let normalizedY = (view?.contentOffset.y)! / (view?.contentSize.height)!
            
            let normalizedWidth = (view?.frame.width)! / (view?.contentSize.width)!
            let normalizedHeight = (view?.frame.height)! / (view?.contentSize.height)!
            
            let cropRect = CGRect(x: normalizedX, y: normalizedY, width: normalizedWidth, height: normalizedHeight)
            
            DispatchQueue.global(qos: .default).async(execute: {
                
                let options = PHImageRequestOptions()
                options.deliveryMode = .highQualityFormat
                options.isNetworkAccessAllowed = true
                options.normalizedCropRect = cropRect
                options.resizeMode = .exact
                
                let targetWidth = floor(CGFloat(self.albumView.phAsset.pixelWidth) * cropRect.width)
                let targetHeight = floor(CGFloat(self.albumView.phAsset.pixelHeight) * cropRect.height)
                let dimensionW = max(min(targetHeight, targetWidth), 1024 * UIScreen.main.scale)
                let dimensionH = dimensionW * self.getCropHeightRatio()
                
                let targetSize = CGSize(width: dimensionW, height: dimensionH)
                
                PHImageManager.default().requestImage(for: self.albumView.phAsset, targetSize: targetSize,
                                                      contentMode: .aspectFill, options: options) {
                                                        result, info in
                                                        
                                                        DispatchQueue.main.async(execute: {
                                                            self.delegate?.CXImageSelected(result!, source: self.mode)
                                                            
                                                        })
                }
            })
        } else {
            print("no image crop ")
            delegate?.CXImageSelected((view?.image)!, source: mode)
            
            self.dismiss(animated: true, completion: {
                self.delegate?.CXDismissedWithImage((view?.image)!, source: self.mode)
            })
        }
    }
    
    
    public func albumViewCameraRollAuthorized() {
        // in the case that we're just coming back from granting photo gallery permissions
        // ensure the done button is visible if it should be
        self.updateDoneButtonVisibility()
    }
    
    // MARK: FSAlbumViewDelegate
    public func albumViewCameraRollUnauthorized() {
        delegate?.CXCameraRollUnauthorized()
    }
    
}

private extension CXCameraSourceViewController {
    
    func stopAll() {
        
        if hasVideo {
            
            //self.videoView.stopCamera()
        }
        
        self.cameraView.stopCamera()
    }
    
    func changeMode(_ mode: CXMode) {
        
        if self.mode == mode {
            return
        }
        
        //operate this switch before changing mode to stop cameras
        switch self.mode {
        case .library:
            break
        case .camera:
            self.cameraView.stopCamera()
        default: break
        }
        
        self.mode = mode
        
        dishighlightButtons()
        updateDoneButtonVisibility()
        
        switch mode {
        case .library:
            titleLabel.text = NSLocalizedString(CXCameraRollTitle, comment: CXCameraRollTitle)
            
            highlightButton(libraryButton)
            self.view.bringSubview(toFront: photoLibraryViewerContainer)
        case .camera:
            titleLabel.text = NSLocalizedString(CXCameraTitle, comment: CXCameraTitle)
            
            highlightButton(cameraButton)
            self.view.bringSubview(toFront: cameraShotContainer)
            cameraView.startCamera()
            default: break
        }
        
        doneButton.isHidden = !hasGalleryPermission
        self.view.bringSubview(toFront: menuView)
    }
    
    
    func updateDoneButtonVisibility() {
        // don't show the done button without gallery permission
        if !hasGalleryPermission {
            self.doneButton.isHidden = true
            return
        }
        
        switch self.mode {
        case .library:
            self.doneButton.isHidden = false
        default:
            self.doneButton.isHidden = true
        }
    }
    
    func dishighlightButtons() {
        
        cameraButton.tintColor  = CXBaseTintColor
        libraryButton.tintColor = CXBaseTintColor
        
        if cameraButton.layer.sublayers?.count > 1 {
            
            for layer in cameraButton.layer.sublayers! {
                
                if let borderColor = layer.borderColor , UIColor(cgColor: borderColor) == CXTintColor {
                    
                    layer.removeFromSuperlayer()
                }
            }
        }
        
        if libraryButton.layer.sublayers?.count > 1 {
            
            for layer in libraryButton.layer.sublayers! {
                
                if let borderColor = layer.borderColor , UIColor(cgColor: borderColor) == CXTintColor {
                    
                    layer.removeFromSuperlayer()
                }
            }
        }

    }
    
    func highlightButton(_ button: UIButton) {
        
        button.tintColor = CXTintColor
        
        button.addBottomBorder(CXTintColor, width: 3)
    }
}


