//
//  SumView.h
//  Summer
//
//  Created by Chris Shreve on 11/20/15.
//  Copyright © 2015 C. Shreve. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SumView : NSView

@property (nonatomic, strong) NSArray *permutations;

@property BOOL showGrid;
@property BOOL showPermutations;
@property BOOL showSorted;
@property BOOL showCDF;

@end
