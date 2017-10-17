////////////////////////////////////////////////////////////////////////////////
//
//  iOS Hub
//  Created by ivan at 17.10.2017.
//
//  Copyright 2017 Loud & Clear Pty Ltd
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

#define _SUPPRESS_WARNING_HELPER_0(x) #x
#define _SUPPRESS_WARNING_HELPER_1(x) _SUPPRESS_WARNING_HELPER_0(clang diagnostic ignored x)
#define _SUPPRESS_WARNING_HELPER_2(x) _SUPPRESS_WARNING_HELPER_1("-W" #x)
#define _SUPPRESS_WARNING_HELPER_3(x) _Pragma(_SUPPRESS_WARNING_HELPER_2(x))

#define SUPPRESS_WARNING(x) \
    _Pragma("clang diagnostic push") \
    _SUPPRESS_WARNING_HELPER_3(x)

#define SUPPRESS_WARNING_END \
    _Pragma("clang diagnostic pop")

#define SUPPRESS_WARNING_ARC_RETAIN_CYCLES              SUPPRESS_WARNING(arc-retain-cycles)
#define SUPPRESS_WARNING_MISMATCHED_PARAMETER_TYPES     SUPPRESS_WARNING(mismatched-parameter-types)
#define SUPPRESS_WARNING_STRICT_PROTOTYPES              SUPPRESS_WARNING(strict-prototypes)
#define SUPPRESS_WARNING_PERFORM_SELECTOR_LEAKS         SUPPRESS_WARNING(arc-performSelector-leaks)
#define SUPPRESS_WARNING_INCOMPATIBLE_PROPERTY_TYPE     SUPPRESS_WARNING(incompatible-property-type)
#define SUPPRESS_WARNING_DEPRECATED_DECLARATIONS        SUPPRESS_WARNING(deprecated-declarations)
