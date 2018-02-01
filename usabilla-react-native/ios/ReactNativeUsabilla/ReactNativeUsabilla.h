//
//  ReactNativeUsabilla.h
//  ReactNativeUsabilla
//
//  Created by Adil Bougamza on 01/02/2018.
//  Copyright © 2018 Usabilla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import "ReactNativeUsabilla-Swift.h"

@interface ReactNativeUsabilla : NSObject <RCTBridgeModule>

@property UsabillaInterface* usabillaInterface;

@end
