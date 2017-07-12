#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

/**
 * For non-retina devices, will round to points (1.0).
 *
 * For retina devices (with screen scale = 2x) will round to half-points (0.5).
 *
 * For retina devices with screen scale > 2 (like iPhone 6+) will not round at all
 * as wich such high PPI rounding is no longer needed.
 */
CGFloat CCUIRound(double value);
CGFloat CCUICeil(double value);
