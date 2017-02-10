////////////////////////////////////////////////////////////////////////////////
//
//  FANHUB
//  Copyright 2016 FanHub Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of FanHub. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import "CCValueTransformer.h"

@interface CCPersistentModelValueTransformer : CCValueTransformer <TRCValueTransformer>

- (instancetype)initWithModelClass:(Class)modelClass;

+ (instancetype)transformerWithClass:(Class)modelClass;

//-------------------------------------------------------------------------------------------
#pragma mark - Methods to override
//-------------------------------------------------------------------------------------------

+ (NSDictionary *)tagsForModelClasses;

@end
