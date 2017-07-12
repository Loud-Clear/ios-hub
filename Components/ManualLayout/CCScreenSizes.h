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

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

static CGFloat const kCCScreenWidth4Inch = 320;
static CGFloat const kCCScreenWidth47Inch = 375;
static CGFloat const kCCScreenWidth55Inch = 414;

static CGFloat const kCCScreenHeight35Inch = 480;
static CGFloat const kCCScreenHeight4Inch = 568;
static CGFloat const kCCScreenHeight47Inch = 667;
static CGFloat const kCCScreenHeight55Inch = 736;

static CGFloat const kCCScreenWidthIphone4 = kCCScreenHeight4Inch;
static CGFloat const kCCScreenWidthIphone5 = kCCScreenWidth4Inch;
static CGFloat const kCCScreenWidthIphone6 = kCCScreenWidth47Inch;
static CGFloat const kCCScreenWidthIphone6Plus = kCCScreenWidth55Inch;
static CGFloat const kCCScreenWidthIphone7 = kCCScreenWidthIphone6;
static CGFloat const kCCScreenWidthIphone7Plus = kCCScreenWidthIphone6Plus;

static CGFloat const kCCScreenHeightIphone4 = kCCScreenHeight35Inch;
static CGFloat const kCCScreenHeightIphone5 = kCCScreenHeight4Inch;
static CGFloat const kCCScreenHeightIphone6 = kCCScreenHeight47Inch;
static CGFloat const kCCScreenHeightIphone6Plus = kCCScreenHeight55Inch;
static CGFloat const kCCScreenHeightIphone7 = kCCScreenHeightIphone6;
static CGFloat const kCCScreenHeightIphone7Plus = kCCScreenHeightIphone6Plus;

CGFloat CCScreenWidth();
CGFloat CCScreenHeight();

CGFloat CCScreenDependentValue(CGFloat valueFor35, CGFloat valueFor4, CGFloat valueFor47, CGFloat valueFor55);
CGFloat CCScreenDependentValue6(CGFloat valueForPre6, CGFloat valueFor6AndPost);
CGFloat CCScreenWidthDependentValue(CGFloat valueFor5AndPre, CGFloat valueFor6AndPost, CGFloat valueForPlus);
