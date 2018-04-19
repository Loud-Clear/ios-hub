////////////////////////////////////////////////////////////////////////////////
//
//  LOUD & CLEAR
//  Copyright 2016 Loud & Clear Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by Loud & Clear on behalf of Loud & Clear. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import "CCTableViewManager.h"

@interface CCTableViewManager (Internal)

- (void)sectionDidChangeItemsSet:(CCTableViewSection *)section;
- (void)section:(CCTableViewSection *)section gotNewItems:(NSArray *)items;

- (void)sectionsSetChanged;
- (void)gotNewSections:(NSArray *)sections;

/// Calls when new item appears inside CCTableViewManager (after adding section or additing items to section)
- (void)gotNewItems:(NSArray *)items;
/// Calls when items set changed (something added or removed)
- (void)didChangeItemsSet;


- (void)willAppearCell:(CCTableViewCell *)cell;
- (void)didLoadCell:(CCTableViewCell *)cell;

@end
