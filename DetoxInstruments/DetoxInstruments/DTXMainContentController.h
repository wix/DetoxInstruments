//
//  DTXMainContentController.h
//  DetoxInstruments
//
//  Created by Leo Natan (Wix) on 01/06/2017.
//  Copyright © 2017 Wix. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DTXPlotController.h"
#import "DTXDetailDataProvider.h"

@class DTXMainContentController;

@protocol DTXMainContentControllerDelegate

- (void)contentController:(DTXMainContentController*)cc updatePlotController:(id<DTXPlotController>)plotController;

@end

@interface DTXMainContentController : NSViewController

- (void)zoomIn;
- (void)zoomOut;
- (void)fitAllData;

@property (nonatomic, strong) DTXDocument* document;
@property (nonatomic, weak) id<DTXMainContentControllerDelegate> delegate;

@end
