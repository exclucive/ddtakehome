//
//  DDError.swift
//  DDSample
//
//  Created by Igor Novik on 6/3/18.
//  Copyright © 2018 NAppsLab. All rights reserved.
//

import UIKit

protocol DDErrorType {
    var code: Int {get}
    var title: String? {get}
    var description: String {get}
}

struct DDError: LocalizedError {
    var title: String?
    var code: Int
    var errorDescription: String? { return internalDescription }
    var failureReason: String? { return internalDescription }
    
    private var internalDescription: String
    
    init(title: String?, description: String, code: Int) {
        self.title = title ?? "Error"
        self.internalDescription = description
        self.code = code
    }
    
    init(errorType: DDErrorType) {
        self.title = errorType.title
        self.internalDescription = errorType.description
        self.code = errorType.code
    }
    
    var printableDescription: String {
        get {
            return "\(title ?? ""): \(code)\n\(errorDescription ?? "")"
        }
    }
}
