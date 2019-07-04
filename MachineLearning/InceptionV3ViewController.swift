//
//  InceptionV3ViewController.swift
//  MachineLearning
//
//  Created by Britto Thomas on 03/07/19.
//  Copyright © 2019 Britto Thomas. All rights reserved.
//

import UIKit
import Vision

class InceptionV3ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapGestureAction(_ sender: Any) {
        let imagePicker = UIImagePickerController.init()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }
    
    /*
    func vncoreMLRequestCompletionHandler(request:VNRequest,error: Error?) {
        guard let results = request.results as? [VNClassificationObservation] else {
            fatalError("Could not get result from ML Vision Request.")
        }
        
        var bestPrediction = ""
        var bestConfidence:VNConfidence = 0
        for classification in results  {
            
            if classification.confidence > bestConfidence {
                bestPrediction = classification.identifier
                bestConfidence = classification.confidence
            }
        }
        
        self.label.text = bestPrediction
    }
     */
}

extension InceptionV3ViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL,
            let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            
            self.imageView.image = image
            let model = Inceptionv3()
            try? model.prediction(image: CVPixelBuffer)
            
            /*(
            let modelFile = Inceptionv3()
            if let model = try? VNCoreMLModel(for: modelFile.model) {
                let handler = VNImageRequestHandler.init(url: imageURL)
                let request = VNCoreMLRequest(model: model, completionHandler: vncoreMLRequestCompletionHandler)
                try! handler.perform([request])
            }
            */
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
