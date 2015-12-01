//
//  SumView.m
//  Summer
//
//  Created by Chris Shreve on 11/20/15.
//  Copyright © 2015 C. Shreve. All rights reserved.
//

#import "SumView.h"

@interface SumView ()
@property double gridCellWidth;
@property double gridCellHeight;
@end

@implementation SumView


-(void)drawRect:(NSRect)dirtyRect {
    [[NSColor whiteColor] set];
    NSRectFill(dirtyRect);
    
    [self drawBorder];
    
    if (self.permutations) {
        self.gridCellWidth = self.frame.size.width/self.permutations.count;
        
        NSString *hiValStr = [self.permutations lastObject];
        double hiVal = [hiValStr doubleValue];
        self.gridCellHeight = self.frame.size.height/hiVal;
        
        if (self.showGrid) {
            [self drawGrid];
        }

        
        NSBezierPath *line;
                
        // show permutations
        if (self.showPermutations) {
            line = [NSBezierPath bezierPath];
            [line setLineWidth:1.0];
            [[NSColor blackColor] set];
            [self drawArray:self.permutations withLine:line];
        }
        
        // show sorted
        if (self.showSorted) {
            line = [NSBezierPath bezierPath];
            [line setLineWidth:1.5];
            [[NSColor blueColor] set];
            NSArray *sorted = [self sortPermutations];
            [self drawArray:sorted withLine:line];
        }
        
        
        // show cdf
        if (self.showCDF) {
            double n = log2([self.permutations count]);
            double nSquared = n * n;
            double increment = ([self.permutations count]/2)/nSquared;
            
            double meanX = 3.3;
            double meanY = 0.3;
            
            for (int i=1; i<=nSquared; i++) {
                double x = meanX + i*increment;
                double y = meanY + cdf(x, meanX, 0.3);
            }
            NSLog(@"n = %f", n);
        }
    }
}

-(void) drawBorder {
    NSBezierPath *line = [NSBezierPath bezierPath];
    [line setLineWidth:1];
    [[NSColor blackColor] set];
    
    [line moveToPoint:NSMakePoint(NSMinX([self bounds]), NSMinY([self bounds]))];
    [line lineToPoint:NSMakePoint(NSMinX([self bounds]), NSMaxY([self bounds]))];
    [line lineToPoint:NSMakePoint(NSMaxX([self bounds]), NSMaxY([self bounds]))];
    [line lineToPoint:NSMakePoint(NSMaxX([self bounds]), NSMinY([self bounds]))];
    [line lineToPoint:NSMakePoint(NSMinX([self bounds]), NSMinY([self bounds]))];
    [line stroke];
}

-(void) drawGrid {

    NSBezierPath *line = [NSBezierPath bezierPath];
    [line setLineWidth:0.25];
    [[NSColor lightGrayColor] set];
    
    
    // draw vertical lines
    for (int i = 1; i < self.permutations.count; i++) {
        float x = i * self.gridCellWidth;
        [line moveToPoint:NSMakePoint(x, NSMinY([self bounds]))];
        [line lineToPoint:NSMakePoint(x, NSMaxY([self bounds]))];
        [line stroke];
    }
    
    
    // draw horizontal lines
    NSString *maxString = [self.permutations lastObject];
    NSInteger max = [maxString integerValue];
    for (int i = 1; i <= max; i++) {
        float y = i * self.gridCellHeight;
        [line moveToPoint:NSMakePoint(NSMinX([self bounds]), y)];
        [line lineToPoint:NSMakePoint(NSMaxX([self bounds]), y)];
        [line stroke];
    }
    
}


//-(void) drawPermutations {
//    NSBezierPath *line = [NSBezierPath bezierPath];
//    [line setLineWidth:1.5];
//    [[NSColor blackColor] set];
//
//    [line moveToPoint:NSMakePoint(NSMinX([self bounds]), NSMinY([self bounds]))];
//     
//    for (int i = 0; i < self.permutations.count; i++) {
//        float x = i * self.gridCellWidth;
//
//        NSString *pStr = self.permutations[i];
//        float p = [pStr floatValue];
//        float y = p * self.gridCellHeight;
//        
//        
//        [line lineToPoint:NSMakePoint(x, y)];
//        [line lineToPoint:NSMakePoint(x + self.gridCellWidth, y)];        
//        [line stroke];
//    }
//}

-(void) drawArray:(NSArray *)data withLine:(NSBezierPath *)line{
//    NSBezierPath *line = [NSBezierPath bezierPath];
//    [line setLineWidth:1.5];
//    [[NSColor blackColor] set];
    
    [line moveToPoint:NSMakePoint(NSMinX([self bounds]), NSMinY([self bounds]))];
    
    for (int i = 0; i < data.count; i++) {
        float x = i * self.gridCellWidth;
        
        NSString *pStr = data[i];
        float p = [pStr floatValue];
        float y = p * self.gridCellHeight;
        
        
        [line lineToPoint:NSMakePoint(x, y)];
        [line lineToPoint:NSMakePoint(x + self.gridCellWidth, y)];
        [line stroke];
    }
}


-(NSArray *) sortPermutations {
    NSMutableArray *blah = [[NSMutableArray alloc] init];
    
    for (NSString *pStr in self.permutations) {
        NSInteger p = [pStr integerValue];
        NSNumber *n = [NSNumber numberWithInteger:p];
        [blah addObject:n];
    }
    
    NSArray *sorted = [blah sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if (obj1 < obj2) return NSOrderedAscending;
        else if (obj1 > obj2) return NSOrderedDescending;
        return NSOrderedSame;
    }];

    NSLog(@"sorted = %@", sorted);
    return sorted;
}
//
//double cdf(double x, double mean, double stdDev) {
//    return (1/2)*(1 + erfc( (x - mean)/(stdDev * M_SQRT2) ));
//}

@end
