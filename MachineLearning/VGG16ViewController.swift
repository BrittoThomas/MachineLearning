//
//  VGG16ViewController.swift
//  MachineLearning
//
//  Created by Britto Thomas on 03/07/19.
//  Copyright © 2019 Britto Thomas. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class VGG16ViewController: UIViewController,AVCapturePhotoCaptureDelegate {
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var predictionTextView: UITextView!
    
    var captureSession:AVCaptureSession!
    var captureOutput:AVCapturePhotoOutput!
    var capturePreviewLayer:AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpCamera()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.launchAI()
    }
    
    func setUpCamera() {
        self.captureSession = AVCaptureSession()
        self.captureSession.sessionPreset = AVCaptureSession.Preset.photo
        self.captureOutput = AVCapturePhotoOutput()
        
        
        if let device = AVCaptureDevice.default(for: AVMediaType.video),
            let input = try? AVCaptureDeviceInput(device: device){
            
            if self.captureSession.canAddInput(input) {
                self.captureSession.addInput(input)
                if self.captureSession.canAddOutput(self.captureOutput) {
                    self.captureSession.addOutput(self.captureOutput)
                }else{
                    print("Failed to add output")
                }
                self.capturePreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                self.capturePreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                self.capturePreviewLayer.frame = self.previewView.bounds
                self.previewView.layer.addSublayer(self.capturePreviewLayer)
                self.captureSession.startRunning()
            }else{
                print("Failed to add input")
            }
        }else{
            print("Failed to get input device")
        }
    }
    
    @objc
    func launchAI() {
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [
            (kCVPixelBufferPixelFormatTypeKey as String): previewPixelType,
            (kCVPixelBufferWidthKey as String): 160,
            (kCVPixelBufferHeightKey as String): 160
        ]
        settings.previewPhotoFormat = previewFormat
        self.captureOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if let error = error {
            print("Error : \(error.localizedDescription)")
        }
        
        if let imageData = photo.fileDataRepresentation(),
            let image = UIImage.init(data: imageData)  {
            self.predict(image: image)
        }
    }
    
    func predict(image:UIImage)  {
        if let data = image.pngData() {
            let fileURL = self.getDocumentsDirectory().appendingPathComponent("image.png ")
            try? data.write(to: fileURL)
            let model = try! VNCoreMLModel(for: VGG16().model)
            let request = VNCoreMLRequest(model: model, completionHandler: predictionCompleted)
            let handler = VNImageRequestHandler.init(url: fileURL)
            try! handler.perform([request])
        }
    }
    
    func predictionCompleted(request: VNRequest,error: Error?) {
        guard let results = request.results as? [VNClassificationObservation] else {
            fatalError("Could not get a prediction output from ML model")
        }
        
        var bestPrediction = ""
        var confidence:VNConfidence = 0
        
        for classification in results {
            if classification.confidence > confidence {
                confidence = classification.confidence
                bestPrediction = classification.identifier
            }
        }
        self.predictionTextView.text = self.predictionTextView.text + bestPrediction + "\n"
        
        
        if self.tabBarController?.selectedViewController == self {
            self.perform(#selector(launchAI), with: nil, afterDelay: 1.0)
        }
    }
}


