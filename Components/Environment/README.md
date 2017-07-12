
## Overview 

CCEnvironment component designed to configure the app. For example you can specify backend endpoint URL, choose app mode and so on.

## Usage

1. Create environment configs. Create plist file for each environment, for example `Config.production.plist` and `Config.development.plist`. 
Add them to project. 

2. Subclass `CCEnvironment` with your custom class. Make sure that property names matches keys in plists. For example:
```
@interface FSEnvironment : CCEnvironment

@property (nonatomic) NSString *apiBaseUrl;

@end
```
and return environment filenames in implementation:
```
@implementation FSEnvironment

+ (NSArray<NSString *> *)environmentFilenames
{
    return @[ @"Config.production.plist", @"Config.development.plist" ];
}

@end
```
3. That's all! From now you can use `[FSEnvironment currentEnvironment]` to access current environment config.


You can change current environment using `[FSEnvironment setCurrentEnvironment: <another environment instance>];`.
All changes to any environment object synced and autosaved. You can observe any property using KVO to get changes.
