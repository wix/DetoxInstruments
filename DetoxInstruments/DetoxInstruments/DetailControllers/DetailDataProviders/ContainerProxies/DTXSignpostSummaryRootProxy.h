//
//  DTXSignpostSummaryRootProxy.h
//  DetoxInstruments
//
//  Created by Leo Natan (Wix) on 7/1/18.
//  Copyright © 2017-2021 Wix. All rights reserved.
//

#import "DTXSampleAggregatorProxy.h"

@interface DTXSignpostSummaryRootProxy : DTXSampleAggregatorProxy

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext outlineView:(NSOutlineView*)outlineView;

@end
