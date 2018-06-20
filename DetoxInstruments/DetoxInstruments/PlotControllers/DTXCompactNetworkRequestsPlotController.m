//
//  DTXCompactNetworkRequestsPlotController.m
//  DetoxInstruments
//
//  Created by Leo Natan (Wix) on 08/06/2017.
//  Copyright © 2017 Wix. All rights reserved.
//

#import "DTXCompactNetworkRequestsPlotController.h"
#import "DTXNetworkSample+CoreDataClass.h"
#import "DTXNetworkDataProvider.h"
#import "DTXRecording+UIExtensions.h"

@implementation DTXCompactNetworkRequestsPlotController

+ (Class)UIDataProviderClass
{
	return [DTXNetworkDataProvider class];
}

+ (Class)classForIntervalSamples
{
	return [DTXNetworkSample class];
}

- (NSDate*)endTimestampForSample:(DTXNetworkSample*)sample
{
	return sample.responseTimestamp ?: self.document.recording.endTimestamp;
}

- (NSColor*)colorForSample:(DTXNetworkSample*)sample
{
	NSColor* lineColor = self.plotColors.firstObject;
	
	if(sample.responseStatusCode == 0)
	{
		lineColor = NSColor.warningColor;
	}
	else if(sample.responseStatusCode < 200 || sample.responseStatusCode >= 400)
	{
		lineColor = NSColor.warning2Color;
	}
	
	if(sample.responseError)
	{
		lineColor = NSColor.warning3Color;
	}
	
	return lineColor;
}

@end

