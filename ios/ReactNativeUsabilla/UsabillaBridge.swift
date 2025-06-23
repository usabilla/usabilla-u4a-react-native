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

    override var methodQueue: DispatchQueue {
        return .main
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
    }

    @objc(setDebugEnabled:)
    func setDebugEnabled(debugEnabled: Bool) {
        Usabilla.debugEnabled = debugEnabled
    }

    @objc(loadLocalizedStringFile:)
    func loadLocalizedStringFile(localizedStringFile: String) {
        Usabilla.localizedStringFile = localizedStringFile
    }

    @objc(loadFeedbackForm:selectedEmoticonImages:unselectedEmoticonImages:)
    func loadFeedbackForm(formID: String,
        selectedEmoticonImages: [String]?,
        unselectedEmoticonImages: [String]?) {

        let usabillaTheme = createTheme(selectedEmoticonImages: selectedEmoticonImages,
                                                     unselectedEmoticonImages: unselectedEmoticonImages)
        if let theme = usabillaTheme {
            Usabilla.loadFeedbackForm(formID,
                                  screenshot: nil,
                                  theme: theme)
        } else {
            Usabilla.loadFeedbackForm(formID,
                                  screenshot: nil)
        }
    }

    @objc(loadFeedbackFormWithCurrentViewScreenshot:selectedEmoticonImages:unselectedEmoticonImages:)
    func loadFeedbackFormWithCurrentViewScreenshot(formID: String,
        selectedEmoticonImages: [String]?,
        unselectedEmoticonImages: [String]?) {
        if let rootVC = UIApplication.shared.windows.first?.rootViewController {
            let screenshot = self.takeScreenshot(view: rootVC.view)

            let usabillaTheme = createTheme(selectedEmoticonImages: selectedEmoticonImages,
                                                     unselectedEmoticonImages: unselectedEmoticonImages)
            if let theme = usabillaTheme {
                Usabilla.loadFeedbackForm(formID,
                                    screenshot: screenshot,
                                    theme: theme)
            } else {
                Usabilla.loadFeedbackForm(formID,
                                    screenshot: screenshot)
            }

        }
    }

    /**
     * Creates a UsabillaTheme with custom selected and unselected emoticon images.
     * @param selectedEmoticonImages Array of enabled emoticon image names (optional, nullable).
     * @param unselectedEmoticonImages Array of disabled emoticon image names (optional, nullable).
     * @return UsabillaTheme instance with custom emoticons.
     */

    func createTheme(selectedEmoticonImages: [String]?, unselectedEmoticonImages: [String]?) -> UsabillaTheme? {

        // Convert image names to UIImage
        let enabledImages = selectedEmoticonImages?.compactMap { UIImage(named: $0) }
        let disabledImages = unselectedEmoticonImages?.compactMap { UIImage(named: $0) }

        if (enabledImages?.isEmpty ?? true) && (disabledImages?.isEmpty ?? true) {
            return nil
            }
        var theme = UsabillaTheme()
        theme.images.enabledEmoticons = enabledImages!
        theme.images.disabledEmoticons = disabledImages
        return theme  

     }

    func takeScreenshot(view: UIView) -> UIImage {
        return Usabilla.takeScreenshot(view)!
    }

    @objc(setCustomVariables:)
    func setCustomVariables(_ variables: [String: Any]) {
        guard let variable = variables as? [String: String] else {
            print("ERROR : Expected customVariables as Dictionary of String [String : String]")
            return
        }
        Usabilla.customVariables = variable
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

    @objc(preloadFeedbackForms:)
    func preloadFeedbackForms(_ formIDs: [String]) {
        Usabilla.preloadFeedbackForms(withFormIDs: formIDs)
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
    func setDataMasking(_ masks: [String]?, _ maskChar: String?) {
        let mask = masks ?? Usabilla.defaultDataMasks
        let maskCharacter = maskChar?.first ?? "X"
        Usabilla.setDataMasking(masks: mask, maskCharacter: maskCharacter)
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



