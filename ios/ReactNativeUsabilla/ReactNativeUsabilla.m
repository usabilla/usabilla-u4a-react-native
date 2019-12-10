//
//  ReactNativeUsabilla.m
//  ReactNativeUsabilla
//
//  Created by Adil Bougamza on 01/02/2018.
//  Copyright © 2018 Usabilla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(UsabillaBridge, NSObject)

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

RCT_EXTERN_METHOD(dismiss)
RCT_EXTERN_METHOD(initialize:(NSString * _Nullable)appID)
RCT_EXTERN_METHOD(loadFeedbackForm:(NSString * _Nullable)formID)
RCT_EXTERN_METHOD(setDataMasking:(NSArray<NSString *>*)masks : (NSString *)maskChar)
RCT_EXTERN_METHOD(setCustomVariables:(NSDictionary * _Nonnull)variables)
RCT_EXTERN_METHOD(loadFeedbackFormWithCurrentViewScreenshot:(NSString * _Nonnull)formID)
RCT_EXTERN_METHOD(sendEvent:(NSString *)event)
RCT_EXTERN_METHOD(removeCachedForms)
RCT_EXTERN_METHOD(resetCampaignData:(RCTResponseSenderBlock)callback)

@end
