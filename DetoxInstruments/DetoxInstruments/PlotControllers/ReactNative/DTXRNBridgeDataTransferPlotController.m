//
//  DTXRNBridgeDataTransferPlotController.m
//  DetoxInstruments
//
//  Created by Leo Natan (Wix) on 31/07/2017.
//  Copyright © 2017-2021 Wix. All rights reserved.
//

#import "DTXRNBridgeDataTransferPlotController.h"
#if ! PROFILER_PREVIEW_EXTENSION
#import "DTXRNBridgeDataDataProvider.h"
#import "DTXRNBridgeDataDataDataProvider.h"
#import "DTXDetailController.h"
#endif
#import "DTXRecording+Additions.h"
#import "NSFormatter+PlotFormatters.h"

@implementation DTXRNBridgeDataTransferPlotController

#if ! PROFILER_PREVIEW_EXTENSION
- (NSArray<DTXDetailController *> *)dataProviderControllers
{
	DTXDetailController* detailController1 = [self.scene instantiateControllerWithIdentifier:@"DTXOutlineDetailController"];
	detailController1.detailDataProvider = [[self.class.UIDataProviderClass alloc] initWithDocument:self.document plotController:self];
	
	NSMutableArray* rv = [NSMutableArray new];
	
	[rv addObject:detailController1];
	
	if(self.document.firstRecording.dtx_profilingConfiguration.recordReactNativeBridgeData)
	{
		DTXDetailController* detailController2 = [self.scene instantiateControllerWithIdentifier:@"DTXOutlineDetailController"];
		detailController2.detailDataProvider = [[DTXRNBridgeDataDataDataProvider alloc] initWithDocument:self.document plotController:self];
		
		[rv addObject:detailController2];
	}
	
	return rv;
}

+ (Class)UIDataProviderClass
{
	return [DTXRNBridgeDataDataProvider class];
}
#endif

+ (Class)classForPerformanceSamples
{
	return [DTXReactNativePerformanceSample class];
}

- (NSString *)displayName
{
	return NSLocalizedString(@"Bridge Data", @"");
}

- (NSString *)toolTip
{
	return NSLocalizedString(@"The Bridge Data instrument captures information about React Native bridge data passed in the profiled app.", @"");
}

- (NSString *)helpTopicName
{
	return @"BridgeData";
}

- (NSImage*)displayIcon
{
	return [NSImage imageNamed:@"RNBridgeData"];
}

- (NSImage *)secondaryIcon
{
	return [NSImage imageNamed:@"react"];
}

- (NSArray<NSString*>*)sampleKeys
{
	return @[@"bridgeNToJSDataSizeDelta", @"bridgeJSToNDataSizeDelta"];
}

- (NSArray<NSColor*>*)plotColors
{
	return @[[NSColor.systemPurpleColor colorWithAlphaComponent:1.0], [NSColor.systemOrangeColor colorWithAlphaComponent:1.0]];
}

- (NSArray<NSString*>*)plotTitles
{
	return @[NSLocalizedString(@"Native to JavaScript", @""), NSLocalizedString(@"JavaScript to Native", @"")];
}

- (NSArray<NSString*>*)legendTitles
{
	return @[NSLocalizedString(@"N → JS", @""), NSLocalizedString(@"JS → N", @"")];
}

- (BOOL)isStepped
{
	return YES;
}

+ (NSFormatter*)formatterForDataPresentation
{
	return [NSFormatter dtx_memoryFormatter];
}

- (BOOL)includeSeparatorsInStackView
{
	return self.isForTouchBar;
}

@end
