//
//  Utilities.swift
//  MachineLearning
//
//  Created by Britto Thomas on 03/07/19.
//  Copyright © 2019 Britto Thomas. All rights reserved.
//

import Foundation

extension NSObject {
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
