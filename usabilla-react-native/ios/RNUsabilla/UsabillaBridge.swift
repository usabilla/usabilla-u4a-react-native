//
//  UsabillaBridge.swift
//  RNUsabilla
//
//  Created by Adil Bougamza on 23/01/2018.
//  Copyright © 2018 Usabilla. All rights reserved.
//

import Foundation
import Usabilla


@objc(UsabillaBridge)
class UsabillaBridge: NSObject {
    override init() {
        super.init()
        Usabilla.delegate = self
    }
    
    @objc(loadFeedbackForm:)
    func loadFeedbackForm(formID: String) {
        print("f: loadFeedbackForm")
        Usabilla.loadFeedbackForm(formID)
//        Usabilla.initialize(appID: nil)
//        Usabilla.debugEnabled = true
    }
    
    @objc(initialize:)
    func initialize(appID: String) {
        print("f: initialize")
        Usabilla.initialize(appID: nil)
        Usabilla.debugEnabled = true
    }
    
}

extension UsabillaBridge: UsabillaDelegate {
    func formDidLoad(form: UINavigationController) {
        guard let rootController = UIApplication.shared.delegate?.window??.rootViewController else {
            return
        }
        
        rootController.present(form, animated: true, completion: nil)
    }
    
    func formDidFailLoading(error: UBError) {
        assertionFailure(error.localizedDescription)
    }
}
