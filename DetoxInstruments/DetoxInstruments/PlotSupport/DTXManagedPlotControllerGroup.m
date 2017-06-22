//
//  DTXManagedPlotControllerGroup.m
//  DetoxInstruments
//
//  Created by Leo Natan (Wix) on 02/06/2017.
//  Copyright © 2017 Wix. All rights reserved.
//

#import "DTXManagedPlotControllerGroup.h"
#import "DTXTimelineIndicatorView.h"

@interface DTXManagedPlotControllerGroup () <DTXPlotControllerDelegate>
{
	BOOL _ignoringPlotRangeNotifications;
	DTXTimelineIndicatorView* _timelineView;
	CPTPlotRange* _savedPlotRange;
}

@end

@implementation DTXManagedPlotControllerGroup
{
	NSMutableArray<id<DTXPlotController>>* _managedPlotControllers;
}

- (instancetype)init
{
	return [self initWithHostingView:nil];
}

- (instancetype)initWithHostingView:(NSView*)view
{
	self = [super init];
	
	if(self)
	{
		_managedPlotControllers = [NSMutableArray new];
		_hostingView = view;
		
		_timelineView = [DTXTimelineIndicatorView new];
		_timelineView.translatesAutoresizingMaskIntoConstraints = NO;
		
		NSTrackingArea* tracker = [[NSTrackingArea alloc] initWithRect:_timelineView.bounds options:NSTrackingActiveAlways | NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved owner:self userInfo:nil];
		[_timelineView addTrackingArea:tracker];
		
		[_hostingView addSubview:_timelineView positioned:NSWindowAbove relativeTo:_hostingView.superview];
		
		[NSLayoutConstraint activateConstraints:@[[view.topAnchor constraintEqualToAnchor:_timelineView.topAnchor],
												  [view.leadingAnchor constraintEqualToAnchor:_timelineView.leadingAnchor],
												  [view.trailingAnchor constraintEqualToAnchor:_timelineView.trailingAnchor],
												  [view.bottomAnchor constraintEqualToAnchor:_timelineView.bottomAnchor]]];
	}
	
	return self;
}

- (NSArray<id<DTXPlotController>> *)plotControllers
{
	return _managedPlotControllers;
}

- (void)addHeaderPlotController:(id<DTXPlotController>)headerPlotController
{
	_headerPlotController = headerPlotController;
	_headerPlotController.delegate = self;
}

- (void)addPlotController:(id<DTXPlotController>)plotController
{
	[_managedPlotControllers addObject:plotController];
	plotController.delegate = self;
	if(_savedPlotRange)
	{
		[plotController setPlotRange:_savedPlotRange];
	}
}

- (void)removePlotController:(id<DTXPlotController>)plotController
{
	plotController.delegate = nil;
	[_managedPlotControllers removeObject:plotController];
}

- (void)insertPlotController:(id<DTXPlotController>)plotController afterPlotController:(id<DTXPlotController>)afterPlotController
{
	NSUInteger idx = [_managedPlotControllers indexOfObject:afterPlotController];
	
	if(idx == NSNotFound)
	{
		return;
	}
	
	[_managedPlotControllers insertObject:plotController atIndex:idx + 1];
	plotController.delegate = self;
	if(_savedPlotRange)
	{
		[plotController setPlotRange:_savedPlotRange];
	}
}

- (void)plotController:(id<DTXPlotController>)pc didChangeToPlotRange:(CPTPlotRange *)plotRange
{
	if(_ignoringPlotRangeNotifications)
	{
		return;
	}
	
	_ignoringPlotRangeNotifications = YES;
	_savedPlotRange = plotRange;
	
	if(pc != _headerPlotController)
	{
		[_headerPlotController setPlotRange:plotRange];
	}
	
	[_managedPlotControllers enumerateObjectsUsingBlock:^(id<DTXPlotController>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if(obj == pc)
		{
			return;
		}
		
		[obj setPlotRange:plotRange];
	}];
	
	_ignoringPlotRangeNotifications = NO;
}

- (void)plotControllerUserDidClickInPlotBounds:(id<DTXPlotController>)pc
{
	[self.delegate managedPlotControllerGroup:self requestPlotControllerSelection:pc];
}

- (void)mouseEntered:(NSEvent *)event
{
	[self mouseMoved:event];
}

- (void)mouseExited:(NSEvent *)event
{
	_timelineView.displaysIndicator = NO;
}

- (void)mouseMoved:(NSEvent *)event
{
	CGPoint pointInView = [_hostingView convertPoint:[event locationInWindow] fromView:nil];
	
	_timelineView.displaysIndicator = pointInView.x >= 210;
	_timelineView.indicatorOffset = pointInView.x;
}

@end