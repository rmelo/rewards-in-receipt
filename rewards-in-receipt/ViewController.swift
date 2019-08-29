//
//  ViewController.swift
//  rewards-in-receipt
//
//  Created by Rodrigo Melo on 05/08/19.
//  Copyright © 2019 Rodrigo Melo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var cameraController = CameraController()

    @IBOutlet weak var cameraPreview: UIView!
    @IBOutlet weak var cameraCaptureButton: CameraCaptureButton!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var currentPhotoView: UIImageView!
    @IBOutlet weak var topPhotoView: UIImageView!
    @IBOutlet weak var removePhotoButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var overPreviewView: UIImageView!
    var photos: [UIImage] = []
    var currentPhoto: UIImage! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCamera(preview: cameraPreview)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        createCropArea()
        toggleComponents()
    }
    
    func createCropArea() {
        
        let rect = CGRect(x: topPhotoView.frame.minX,
                          y: topPhotoView.frame.maxY,
                          width: cameraPreview.bounds.width,
                          height:cameraPreview.bounds.height - topPhotoView.frame.maxY)
        
        overPreviewView = UIImageView(frame: rect)

        overPreviewView.layer.borderWidth = 1
        overPreviewView.layer.borderColor = UIColor.yellow.cgColor
        
        cameraPreview.addSubview(overPreviewView)
    }
    
    func cropImage(image: UIImage) -> UIImage?
    {
        
        let imageToBeCropped = image.fixedOrientation()
        
        let deltaW = (cameraPreview.bounds.height - topPhotoView.frame.maxY) / cameraPreview.bounds.height
        
        let deltaY = 1 - deltaW
        
        let cropRect = CGRect(x: 0,
                              y: imageToBeCropped.size.height * deltaY,
                              width: imageToBeCropped.size.width,
                              height: imageToBeCropped.size.height * deltaW)
        
        let imageCrop = imageToBeCropped.cgImage?.cropping(to: cropRect)
        let croppedImage = UIImage(cgImage: imageCrop!)
        
        return croppedImage
    }
    
    func configureCamera(preview: UIView){
        
        cameraController.prepare { (error) in
            if let error = error {
                print(error)
            }

            try? self.cameraController.displayPreview(on: preview)
        }
    }
    
    func toggleComponents(){
        toggleSaveButton()
        toggleRemoveButton()
        toggleAddButton()
        toggleCaptureButton()
        toggleCurrentPhoto()
    }
    
    func toggleRemoveButton(){
            removePhotoButton.isHidden = photos.count == 0
    }
    
    func toggleCurrentPhoto(){
        
        currentPhotoView.image = nil
        overPreviewView.image = nil
        
        if(currentPhoto != nil){
            
            if(photos.count == 1){
                currentPhotoView.image = currentPhoto
            }
            
            if(photos.count > 1){
                overPreviewView.image = currentPhoto
            }
        }
    }
    
    func showTopViewPhoto(){
        topPhotoView.image = photos.last
    }
    
    func showLastTopViewPhoto(){
        hiddenTopView()
        if(photos.count > 1){
            showTopViewPhoto()
        }
    }
    
    func hiddenTopView(){
        topPhotoView.image = nil
    }
    
    func toggleCaptureButton(){
        cameraCaptureButton.alpha = currentPhoto == nil ? 1 : 0.2
        cameraCaptureButton.isEnabled = currentPhoto == nil
    }
    
    func toggleAddButton(){
        addPhotoButton.isHidden = currentPhoto == nil || photos.count == 0
    }
    
    func toggleSaveButton(){
        saveButton.isHidden = photos.count == 0
    }
    
    func resetComponents(){
        overPreviewView.image = nil
        currentPhotoView.image = nil
        topPhotoView.image = nil
    }
    
    @IBAction func capturePhoto(_ sender: CameraCaptureButton) {
        
        cameraController.captureImage{(image, error) in
            guard var image = image else {
                print(error ?? "Image capture error")
                return
            }
            
            if(self.photos.count >= 1){
                image = self.cropImage(image: image)!
            }
                
            self.currentPhoto = image
            
            self.photos.append(image)
            
            self.toggleComponents()
        }
        
    }
    
    @IBAction func addPhoto(_ sender: UIButton) {
        
        showTopViewPhoto()
        
        currentPhoto = nil
        
        toggleComponents()
    }
    
    @IBAction func removePhoto(_ sender: Any) {
        
        if(currentPhoto == nil){
            showLastTopViewPhoto()
        }
        
        currentPhoto = nil
        
        photos.removeLast()
        
        toggleComponents()
    }
    
    func saveMultiple(){
        for photo in photos {
            UIImageWriteToSavedPhotosAlbum(photo, nil, nil, nil)
        }
    }
    
    func saveSingle(){
        let image = stitchImages(images: photos,
                                 isVertical: true)
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    func resetAfterSave(){
        
        currentPhoto = nil
        
        photos.removeAll()
        
        resetComponents()
        toggleComponents()
        
        let alert = UIAlertController(title: "Salvo",
                                      message: "Fotos salvas em sua biblioteca.",
                                      preferredStyle: .alert)
        
        self.present(alert, animated: true, completion: nil)
        
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.dismiss(animated: true, completion: nil);
        }
    }
    
    @IBAction func savePhotos(_ sender: Any) {

        let confirm = UIAlertController(title: "Salvando fotos",
                                    message: "Escolha como deseja salvar as fotos",
                                    preferredStyle: .actionSheet)
        
        confirm.addAction(UIAlertAction(title: "Foto única", style: .default, handler: { (_) in
            self.saveSingle()
            self.resetAfterSave()
        }))
        
        confirm.addAction(UIAlertAction(title: "Múltiplas fotos", style: .default, handler: { (_) in
            self.saveMultiple()
            self.resetAfterSave()
        }))
        
        self.present(confirm, animated: true, completion: nil)
    }
}


