//
//  RNUsabilla.m
//  RNUsabilla
//
//  Created by Adil Bougamza on 23/01/2018.
//  Copyright © 2018 Usabilla. All rights reserved.
//

#import "RNUsabilla.h"

@implementation RNUsabilla

- (instancetype)init
{
    self = [super init];
    if (self) {
        _usabillaBrigde = [[UsabillaBridge alloc] init];
    }
    return self;
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(loadFeedbackForm:(NSString *)formID)
{
    NSLog(@"-loadFeedbackForm");
    [self.usabillaBrigde loadFeedbackForm:formID];
}

RCT_EXPORT_METHOD(initialize:(NSString *)appID)
{
    NSLog(@"-initialize");
    [self.usabillaBrigde initialize:appID];
}

@end
