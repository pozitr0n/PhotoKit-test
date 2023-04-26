//
//  ViewController.swift
//  GetThePhotoFromOS
//
//  Created by Raman Kozar on 27/04/2023.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    @IBOutlet weak var imageViewMain: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        photoAuthorization()
        imageViewMain.image = self.loadImage()
        
    }
    
    private func loadImage() -> UIImage? {
        
        let manager = PHImageManager.default()
        
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions())
        
        var resultImage: UIImage? = nil
        
        manager.requestImage(for: fetchResult.object(at: 0), targetSize: CGSize(width: 647, height: 375), contentMode: .aspectFill, options: requestOption()) { (image, error) in
            
            guard let image = image else {
                return
            }
            
            resultImage = image
            
        }
        
        return resultImage
        
    }
    
    private func fetchOptions() -> PHFetchOptions {
        
        let fetchOptions = PHFetchOptions()
        
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        return fetchOptions
        
    }
    
    private func requestOption() -> PHImageRequestOptions {
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        return requestOptions
        
    }
    
    private func photoAuthorization() {
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                
                switch status {
                case .authorized:
                    DispatchQueue.main.async {
                        self.imageViewMain.image = self.loadImage()
                    }
                case .notDetermined, .restricted, .denied, .limited: break
                @unknown default: break
                }
                
            }
            
        case .restricted:
            print("You haven't access to photos - go to settings")
        case .denied: break
            print("Not access: reason - settings block through the Settings app")
        case .limited: break
            @unknown default: break
        }
        
    }

}

