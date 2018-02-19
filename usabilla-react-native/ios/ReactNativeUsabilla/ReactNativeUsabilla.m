//
//  ReactNativeUsabilla.m
//  ReactNativeUsabilla
//
//  Created by Adil Bougamza on 01/02/2018.
//  Copyright © 2018 Usabilla. All rights reserved.
//

#import "ReactNativeUsabilla.h"

@implementation ReactNativeUsabilla {
    UINavigationController *loadedViewController;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _usabillaInterface = [[UsabillaInterface alloc] init];
        _usabillaInterface.delegate = self;
    }
    return self;
}

RCT_EXPORT_MODULE(UsabillaBridge);

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"UBFormLoadingSucceeded",
             @"UBFormLoadingFailed",
             @"UBFormDidClose"];
}

RCT_EXPORT_METHOD(initialize:(NSString *)appID)
{
    [self.usabillaInterface initialize:appID];
}

RCT_EXPORT_METHOD(loadFeedbackForm:(NSString * _Nonnull)formID)
{
    [self.usabillaInterface loadFeedbackForm:formID];
}

RCT_EXPORT_METHOD(loadFeedbackFormWithCurrentViewScreenshot:(NSString * _Nonnull)formID)
{
    UIViewController *rootController = (UIViewController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    UIImage* screenshot = [self.usabillaInterface takeScreenshot:rootController.view];

    [self.usabillaInterface loadFeedbackForm:formID screenshot:screenshot];
}

RCT_EXPORT_METHOD(setCustomVariables:(NSDictionary * _Nonnull)variables)
{
    [self.usabillaInterface setCustomVariables:variables];
}

RCT_EXPORT_METHOD(sendEvent:(NSString *)event)
{
    [self.usabillaInterface sendEvent:event];
}

RCT_EXPORT_METHOD(resetCampaignData:(RCTResponseSenderBlock)callback)
{
    [self.usabillaInterface resetCampaignData:^{
        NSDictionary* resultsDict = @{@"success" : @YES};
        callback(@[[NSNull null], resultsDict]);
    }];
}

RCT_EXPORT_METHOD(showLoadedFrom)
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIViewController *rootController = (UIViewController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
        [rootController presentViewController:self->loadedViewController animated:true completion:nil];
    });
}

#pragma mark UsabillaInterfaceDelegate Methods

-(void)formLoadedSucessfullyWithForm:(UINavigationController *)form {
    self->loadedViewController = form;
    [self sendEventWithName:@"UBFormLoadingSucceeded" body:@{@"success": @YES}];
}

-(void)formFailedLoadingWithError:(NSError *)error {
    self->loadedViewController = nil;
    [self sendEventWithName:@"UBFormLoadingFailed" body:@{@"error": error.description}];
}

-(void)formDidCloseWithFormID:(NSString *)formID withFeedbackResults:(NSArray<RNUsabillaFeedbackResult *> *)results isRedirectToAppStoreEnabled:(BOOL)isRedirectToAppStoreEnabled {
    self->loadedViewController = nil;
    [self sendEventWithName:@"UBFormDidClose" body:@{@"formId": formID, @"results": results, @"isRedirectToAppStoreEnabled": @(isRedirectToAppStoreEnabled)}];
}

@end
