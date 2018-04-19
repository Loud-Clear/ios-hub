////////////////////////////////////////////////////////////////////////////////
//
//  LOUDCLEAR
//  Copyright 2017 LoudClear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by Loud & Clear on behalf of LoudClear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import "CCEnvironment+PresentingName.h"


@implementation CCEnvironment (PresentingName)

- (NSString *)cc_presentingName
{
    if ([self respondsToSelector:@selector(name)]) {
        id name = [self valueForKey:@"name"];
        if ([name isKindOfClass:[NSString class]]) {
            return name;
        }
    }
    return self.filename;
}

- (NSArray *)cc_titleNames
{
    NSMutableArray *titles = [[NSMutableArray alloc] initWithObjects:@"filename", nil];
    if ([self respondsToSelector:@selector(name)]) {
        [titles addObject:@"name"];
    }
    return titles;
}

@end
