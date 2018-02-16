//
//  UsabillaInterface.swift
//  ReactNativeUsabilla
//
//  Created by Adil Bougamza on 01/02/2018.
//  Copyright © 2018 Usabilla. All rights reserved.
//

import Foundation
import Usabilla

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
    @objc func formDidClose(formID: String, withFeedbackResults results: [RNUsabillaFeedbackResult], isRedirectToAppStoreEnabled: Bool)
}

@objc(UsabillaInterface)
class UsabillaInterface: NSObject {

    @objc weak var delegate: UsabillaInterfaceDelegate?

    override init() {
        super.init()
        Usabilla.delegate = self
    }

    @objc(initialize:)
    func initialize(appID: String) {
        Usabilla.initialize(appID: appID)
        Usabilla.debugEnabled = true
    }

    @objc(loadFeedbackForm:)
    func loadFeedbackForm(formID: String) {
        Usabilla.loadFeedbackForm(formID)
    }
    
    @objc(setCustomVariables:)
    func setCustomVariables(_ variables: [String: Any]) {
        Usabilla.customVariables = variables

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
}

extension UsabillaInterface: UsabillaDelegate {

    func formDidLoad(form: UINavigationController) {
        delegate?.formLoadedSucessfully(form: form)
    }

    func formDidFailLoading(error: UBError) {
        delegate?.formFailedLoading(error: NSError(domain: "Usabilla-PassiveForm", code: 500, userInfo: ["error": error.description]))
    }

    func formDidClose(formID: String, withFeedbackResults results: [FeedbackResult], isRedirectToAppStoreEnabled: Bool) {
        var rnResults = [RNUsabillaFeedbackResult]()
        for result in results {
            rnResults.append(RNUsabillaFeedbackResult(rating: result.rating, abandonedPageIndex: result.abandonedPageIndex, sent: result.sent))
        }

        delegate?.formDidClose(formID: formID, withFeedbackResults: rnResults, isRedirectToAppStoreEnabled: isRedirectToAppStoreEnabled)
    }
}

