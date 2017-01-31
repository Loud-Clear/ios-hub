////////////////////////////////////////////////////////////////////////////////
//
//  LOUD & CLEAR
//  Copyright 2016 Loud & Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of Loud & Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

@interface NSObject (TyphoonDefaultFactory)

/**
 * Creates new instance of given class using default Typhoon factory
 * It uses registered TyphoonDefinition if exists and tries to register
 * new definition, if property auto-injection specified
 * */
+ (instancetype)newUsingTyphoon;

@end
