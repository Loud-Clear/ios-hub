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



@interface CCNavigatorContext : NSObject

+ (instancetype)contextWithObjects:(NSArray *)objects;
+ (instancetype)contextWithObjectsDictionary:(NSDictionary *)objects;

- (void)addObject:(id)object;
- (void)setObject:(id)object forKey:(NSString *)key;

- (id)objectForKey:(NSString *)key;
- (id)objectForType:(id)classOrProtocol;

@end
