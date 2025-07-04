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

RCT_EXTERN_METHOD(dismiss)
RCT_EXTERN_METHOD(initialize:(NSString * _Nullable)appID)
RCT_EXTERN_METHOD(setDebugEnabled:(BOOL * _Nonnull)debugEnabled)
RCT_EXTERN_METHOD(loadLocalizedStringFile:(NSString * _Nullable)localizedStringFile)
RCT_EXTERN_METHOD(loadFeedbackForm:(NSString * _Nonnull)formID
  selectedEmoticonImages:(NSArray * _Nullable)selectedEmoticonImages
  unselectedEmoticonImages:(NSArray * _Nullable)unselectedEmoticonImages
  )
RCT_EXTERN_METHOD(setDataMasking:(NSArray<NSString *>* _Nullable)masks : (NSString * _Nullable)maskChar)
RCT_EXTERN_METHOD(setCustomVariables:(NSDictionary * _Nonnull)variables)
RCT_EXTERN_METHOD(loadFeedbackFormWithCurrentViewScreenshot:(NSString * _Nonnull)formID
  selectedEmoticonImages:(NSArray * _Nullable)selectedEmoticonImages
  unselectedEmoticonImages:(NSArray * _Nullable)unselectedEmoticonImages
)
RCT_EXTERN_METHOD(preloadFeedbackForms:(NSArray<NSString *>*)formIDs)
RCT_EXTERN_METHOD(removeCachedForms)
RCT_EXTERN_METHOD(sendEvent:(NSString *)event)
RCT_EXTERN_METHOD(resetCampaignData:(RCTResponseSenderBlock)callback)

@end
