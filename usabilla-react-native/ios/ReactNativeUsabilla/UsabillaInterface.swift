//
//  UsabillaInterface.swift
//  ReactNativeUsabilla
//
//  Created by Adil Bougamza on 01/02/2018.
//  Copyright © 2018 Usabilla. All rights reserved.
//

import Foundation
import Usabilla


@objc(UsabillaInterface)
class UsabillaInterface: NSObject {
    override init() {
        super.init()
        Usabilla.delegate = self
    }

    @objc(loadFeedbackForm:)
    func loadFeedbackForm(formID: String) {
        print("f: loadFeedbackForm")
        Usabilla.loadFeedbackForm(formID)
    }

    @objc(initialize:)
    func initialize(appID: String) {
        print("f: initialize")
        Usabilla.initialize(appID: nil)
        Usabilla.debugEnabled = true
    }
}

extension UsabillaInterface: UsabillaDelegate {
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

