////////////////////////////////////////////////////////////////////////////////
//
//  VAMPR
//  Copyright 2016 Vampr Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of Vampr. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////


#import "CCScreenSizes.h"


CGFloat CCScreenWidth()
{
    return [UIScreen mainScreen].bounds.size.width;
}

CGFloat CCScreenHeight()
{
    return [UIScreen mainScreen].bounds.size.height;
}

CGFloat CCScreenDependentValue(CGFloat valueFor35, CGFloat valueFor4, CGFloat valueFor47, CGFloat valueFor55)
{
    if (CCScreenHeight() <= kCCScreenHeight35Inch) {
        return valueFor35;
    } else if (CCScreenHeight() <= kCCScreenHeight4Inch) {
        return valueFor4;
    } else if (CCScreenHeight() <= kCCScreenHeight47Inch) {
        return valueFor47;
    } else {
        return valueFor55;
    }
}

CGFloat CCScreenDependentValue6(CGFloat valueForPre6, CGFloat valueFor6AndPost)
{
    if (CCScreenHeight() < kCCScreenHeightIphone6) {
        return valueForPre6;
    } else {
        return valueFor6AndPost;
    }
}

CGFloat CCScreenDependentValueX(CGFloat valueForPreX, CGFloat valueForXAndPost)
{
    if (CCScreenHeight() < kCCScreenHeightIphoneX) {
        return valueForPreX;
    } else {
        return valueForXAndPost;
    }
}

CGFloat CCScreenWidthDependentValue(CGFloat valueFor5AndPre, CGFloat valueFor6AndPost, CGFloat valueForPlus)
{
    if (CCScreenWidth() <= kCCScreenWidthIphone5) {
        return valueFor5AndPre;
    } else if (CCScreenWidth() < kCCScreenWidthIphone6Plus) {
        return valueFor6AndPost;
    } else {
        return valueForPlus;
    }
}

CGFloat CCScreenStatusBarHeight()
{
    return fminf(UIApplication.sharedApplication.statusBarFrame.size.height, UIApplication.sharedApplication.statusBarFrame.size.width);
}
