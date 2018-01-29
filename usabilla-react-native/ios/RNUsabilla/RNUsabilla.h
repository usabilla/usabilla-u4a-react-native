//
//  RNUsabilla.h
//  RNUsabilla
//
//  Created by Adil Bougamza on 23/01/2018.
//  Copyright © 2018 Usabilla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import "RNUsabilla-Swift.h"

@interface RNUsabilla : NSObject <RCTBridgeModule>

@property UsabillaBridge* usabillaBrigde;

@end
