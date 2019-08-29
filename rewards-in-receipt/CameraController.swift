//
//  CameraController.swift
//  rewards-in-receipt
//
//  Created by Rodrigo Melo on 12/08/19.
//  Copyright © 2019 Rodrigo Melo. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIView {
    
    var captureSession: AVCaptureSession?
    var rearCamera: AVCaptureDevice?
    var rearCameraInput: AVCaptureDeviceInput?
    var photoOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?

    func prepare(completionHandler: @escaping (Error?) -> Void){
        
        #if targetEnvironment(simulator)
        
        completionHandler(nil)
        
        #else
        
        func createCaptureSession() {
            self.captureSession = AVCaptureSession()
        }
        func configureCaptureDevices() throws {
            self.rearCamera = AVCaptureDevice.default(for: .video)!
        }
        
        func configureDeviceInputs() throws {
            
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
            
            if let captureCamera = self.rearCamera {
                self.rearCameraInput = try AVCaptureDeviceInput(device: captureCamera)
                
                if captureSession.canAddInput(self.rearCameraInput!) { captureSession.addInput(self.rearCameraInput!) }
            }else
            { throw  CameraControllerError.noCamerasAvailable }

        }
        
        func configurePhotoOutput() throws {
            
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
            
            self.photoOutput = AVCapturePhotoOutput()
            self.photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            
            if captureSession.canAddOutput(self.photoOutput!) { captureSession.addOutput(self.photoOutput!) }
            
            captureSession.startRunning()
        }
        
        DispatchQueue(label: "prepare").async {
            do {
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
                try configurePhotoOutput()
            }
                
            catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
        
        #endif
    }
    
    
    func displayPreview(on view: UIView) throws {
        
        #if targetEnvironment(simulator)
        
        let image  = UIImage(named: "intotheforest.jpg")
        let preview = UIImageView(frame: view.bounds)
        
        preview.contentMode = .scaleAspectFill
        preview.image = image
        
        view.addSubview(preview)
        
        #else
        
        guard let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        self.previewLayer?.videoGravity = .resize
        
        self.previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        
        self.previewLayer?.frame = view.bounds
        
        #endif
    }
    
    func captureImage(completion: @escaping (UIImage?, Error?)->Void){
        
        guard let captureSession = captureSession, captureSession.isRunning else { completion(nil, CameraControllerError.captureSessionIsMissing); return }
        
        let settings = AVCapturePhotoSettings()
        
        self.photoOutput?.capturePhoto(with: settings, delegate: self)
        
        self.photoCaptureCompletionBlock = completion
        
    }

}

extension CameraController : AVCapturePhotoCaptureDelegate {
    
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
                if let error = error { self.photoCaptureCompletionBlock?(nil, error) }
        
                else if let imageData = photo.fileDataRepresentation() {
                    let image = UIImage(data: imageData)
                    self.photoCaptureCompletionBlock?(image, nil)
                }
    
                else {
                    self.photoCaptureCompletionBlock?(nil, CameraControllerError.unknown)
                }
    
    }
    
}

enum CameraControllerError: Swift.Error {
    case captureSessionAlreadyRunning
    case captureSessionIsMissing
    case inputsAreInvalid
    case invalidOperation
    case noCamerasAvailable
    case unknown
}
