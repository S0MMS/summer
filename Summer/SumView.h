//
//  SumView.h
//  Summer
//
//  Created by Chris Shreve on 11/20/15.
//  Copyright © 2015 C. Shreve. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SumView : NSView

@property (nonatomic, strong) NSArray *components;
@property (nonatomic, strong) NSArray *permutations;
@property (nonatomic, strong) NSArray *hLines;
@property (nonatomic, strong) NSArray *vLines;
@property (nonatomic, strong) NSArray *approximationPoints;
@property BOOL scaleY;
@property BOOL showGrid;
@property BOOL showPermutations;
@property BOOL showSorted;
@property BOOL showCDF;

@property double mean;
@property double variance;

@end
