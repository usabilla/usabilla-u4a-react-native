//
//  ReactNativeUsabilla.m
//  ReactNativeUsabilla
//
//  Created by Adil Bougamza on 01/02/2018.
//  Copyright © 2018 Usabilla. All rights reserved.
//

#import "ReactNativeUsabilla.h"

@implementation ReactNativeUsabilla

- (instancetype)init
{
    self = [super init];
    if (self) {
        _usabillaInterface = [[UsabillaInterface alloc] init];
    }
    return self;
}

RCT_EXPORT_MODULE(UsabillaBridge);

RCT_EXPORT_METHOD(loadFeedbackForm:(NSString *)formID)
{
    NSLog(@"-loadFeedbackForm");
    [self.usabillaInterface loadFeedbackForm:formID];
}

RCT_EXPORT_METHOD(initialize:(NSString *)appID)
{
    NSLog(@"-initialize");
    [self.usabillaInterface initialize:appID];
}

@end
