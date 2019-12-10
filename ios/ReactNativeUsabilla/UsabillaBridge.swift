//
//  UsabillaBridge.swift
//  ReactNativeUsabilla
//
//  Created by Adil Bougamza on 01/02/2018.
//  Copyright © 2018 Usabilla. All rights reserved.
//

import Foundation
import Usabilla
import UIKit

@objc(UsabillaBridge)
class UsabillaBridge: RCTEventEmitter {

    @objc weak var formNavigationController: UINavigationController?

    override static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    func constantsToExport() -> [String: Any]! {
        return ["DEFAULT_DATA_MASKS": getDefaultDataMasks()]
    }
    
    override func supportedEvents() -> [String]! {
        return ["UBFormLoadingSucceeded","UBFormLoadingFailed","UBFormDidClose","UBCampaignDidClose"]
    }

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
    
    @objc(loadFeedbackFormWithCurrentViewScreenshot:)
    func loadFeedbackFormWithCurrentViewScreenshot(formID: String) {
        DispatchQueue.main.sync {
            if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
              let screenshot = self.takeScreenshot(view: rootVC.view)
                Usabilla.loadFeedbackForm(formID, screenshot: screenshot)
          }
        }
    }

    func takeScreenshot(view: UIView) -> UIImage {
        return Usabilla.takeScreenshot(view)!
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
    func resetCampaignData(_ callback: RCTResponseSenderBlock) {
        let resultsDict: Dictionary = ["success": true]
        callback([NSNull(), resultsDict])
        
        Usabilla.resetCampaignData {
        }
    }

    @objc(removeCachedForms)
    func removeCachedForms() {
        Usabilla.removeCachedForms()
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

extension UsabillaBridge: UsabillaDelegate {

    func formDidLoad(form: UINavigationController) {
        formNavigationController = form
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            rootVC.present(formNavigationController!, animated: true, completion: nil)
        }
        sendEvent(withName: "UBFormLoadingSucceeded", body: ["success": true])
    }

    func formDidFailLoading(error: UBError) {
        formNavigationController = nil
        sendEvent(withName: "UBFormLoadingFailed", body: ["error": error.description])
    }

    func formDidClose(formID: String, withFeedbackResults results: [FeedbackResult], isRedirectToAppStoreEnabled: Bool) {
        var rnResults: [[String : Any]] = []
        for result in results {
            let dictionary: Dictionary = ["rating": result.rating ?? 0, "abandonedPageIndex": result.abandonedPageIndex ?? 0, "sent": result.sent] as [String : Any]
            rnResults.append(dictionary)
        }
        formNavigationController = nil
        sendEvent(withName: "UBFormDidClose", body: ["formId": formID, "results": rnResults, "isRedirectToAppStoreEnabled": isRedirectToAppStoreEnabled])
    }
    
    func campaignDidClose(withFeedbackResult result: FeedbackResult, isRedirectToAppStoreEnabled: Bool) {
        let rnResult: [String : Any] = ["rating": result.rating ?? 0, "abandonedPageIndex": result.abandonedPageIndex ?? 0, "sent": result.sent] as [String : Any]
        formNavigationController = nil
        sendEvent(withName: "UBCampaignDidClose", body: ["result": rnResult, "isRedirectToAppStoreEnabled": isRedirectToAppStoreEnabled])
    }
}

