//
//  UsabillaInterface.swift
//  ReactNativeUsabilla
//
//  Created by Adil Bougamza on 01/02/2018.
//  Copyright © 2018 Usabilla. All rights reserved.
//

import Foundation
import Usabilla
import UIKit

@objc class RNUsabillaFeedbackResult: NSObject {
    public let rating: Int?
    public let abandonedPageIndex: Int?
    public var sent: Bool

    init(rating: Int?, abandonedPageIndex: Int?, sent: Bool) {
        self.rating = rating
        self.abandonedPageIndex = abandonedPageIndex
        self.sent = sent
    }
}

@objc(UsabillaInterfaceDelegate)
protocol UsabillaInterfaceDelegate {
    @objc func formLoadedSucessfully(form: UINavigationController)
    @objc func formFailedLoading(error: NSError)
    @objc func formDidClose(formID: String, withFeedbackResults results: [[String : Any]], isRedirectToAppStoreEnabled: Bool)
}

@objc(UsabillaInterface)
class UsabillaInterface: NSObject {

    @objc weak var delegate: UsabillaInterfaceDelegate?

    override init() {
        super.init()
        Usabilla.delegate = self
    }

    @objc(initialize:)
    func initialize(appID: String?) {
        Usabilla.initialize(appID: appID)
        Usabilla.debugEnabled = true
    }

    @objc(loadFeedbackForm:)
    func loadFeedbackForm(formID: String) {
        Usabilla.loadFeedbackForm(formID)
    }
    
    @objc(loadFeedbackForm:screenshot:)
    func loadFeedbackForm(formID: String, screenshot: UIImage) {
        Usabilla.loadFeedbackForm(formID, screenshot: screenshot)
    }
    
    @objc(setCustomVariables:)
    func setCustomVariables(_ variables: [String: Any]) {
        let newCustomVariables = variables.mapValues { String(describing: $0) }
        Usabilla.customVariables = newCustomVariables
    }

    @objc(sendEvent:)
    func sendEvent(eventName: String) {
        Usabilla.sendEvent(event: eventName)
    }
    
    @objc(resetCampaignData:)
    func resetCampaignData(completion: (() -> Swift.Void)?) {
        Usabilla.resetCampaignData {
            if let completion = completion {
                completion()
            }
        }
    }

    @objc(removeCachedForms)
    func removeCachedForms() {
        Usabilla.removeCachedForms()
    }

    @objc(takeScreenshot:)
    func takeScreenshot(view: UIView) -> UIImage {
        return Usabilla.takeScreenshot(view)!
    }
    
    @objc(dismiss)
    func dismiss() {
        let _ = Usabilla.dismiss()
    }
    
    @objc(getDefaultDataMasks)
    func getDefaultDataMasks() -> [String] {
        let str = Usabilla.defaultDataMasks
        return str
    }
    
    @objc(setDataMasking::)
    func setDataMasking(_ masks: [String], _ maskChar: String) {
        guard let maskCharacter = maskChar.first else {   Usabilla.setDataMasking(masks: Usabilla.defaultDataMasks, maskCharacter: "X")
            return
        }
        Usabilla.setDataMasking(masks: masks, maskCharacter: maskCharacter)
    }
}

extension UsabillaInterface: UsabillaDelegate {

    func formDidLoad(form: UINavigationController) {
        delegate?.formLoadedSucessfully(form: form)
    }

    func formDidFailLoading(error: UBError) {
        delegate?.formFailedLoading(error: NSError(domain: "Usabilla-PassiveForm", code: 500, userInfo: ["error": error.description]))
    }

    func formDidClose(formID: String, withFeedbackResults results: [FeedbackResult], isRedirectToAppStoreEnabled: Bool) {
        var rnResults: [[String : Any]] = []
        for result in results {
            var dictionary: Dictionary = ["rating": result.rating ?? 0, "abandonedPageIndex": result.abandonedPageIndex ?? 0, "sent": result.sent] as [String : Any]
            rnResults.append(dictionary)
        }

        delegate?.formDidClose(formID: formID, withFeedbackResults: rnResults, isRedirectToAppStoreEnabled: isRedirectToAppStoreEnabled)
    }
}

