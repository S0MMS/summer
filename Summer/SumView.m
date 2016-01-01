//
//  SumView.m
//  Summer
//
//  Created by Chris Shreve on 11/20/15.
//  Copyright © 2015 C. Shreve. All rights reserved.
//

#import "SumView.h"
#import "MyPoint.h"

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
        
        if (self.scaleY) {
            self.gridCellHeight = self.frame.size.height/hiVal;
        } else {
            self.gridCellHeight = self.gridCellWidth;
        }
        
        if (self.showGrid) {
            [self drawGrid];
        }

        
        NSBezierPath *line;
                
        // show permutations
        if (self.showPermutations) {
            line = [NSBezierPath bezierPath];
            [line setLineWidth:1.25];
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
        
        
        if ([self.hLines count] > 0) {
            line = [NSBezierPath bezierPath];
            [line setLineWidth:1.5];
            [[NSColor blackColor] set];
            
            for (NSNumber *hLine in self.hLines) {
                [line moveToPoint:NSMakePoint(NSMinX([self bounds]), [hLine floatValue]*self.gridCellHeight)];
                [line lineToPoint:NSMakePoint(NSMaxX([self bounds]), [hLine floatValue]*self.gridCellHeight)];
                [line stroke];
            }            
        }
        
        if ([self.vLines count] > 0) {
            line = [NSBezierPath bezierPath];
            [line setLineWidth:1.5];
            [[NSColor blackColor] set];
            
            for (NSNumber *vLine in self.vLines) {
                [line moveToPoint:NSMakePoint([vLine floatValue]*self.gridCellWidth, NSMinY([self bounds]))];
                [line lineToPoint:NSMakePoint([vLine floatValue]*self.gridCellWidth, NSMaxY([self bounds]))];
                [line stroke];
            }
        }
        
        if (self.showCDF) {
            
            NSMutableArray *approximationPoints = [[NSMutableArray alloc] init];
            NSMutableArray *complementPoints = [[NSMutableArray alloc] init];
            NSInteger n = [self.components count];
            
            double upperBound = self.mean;
            NSNumber *number = [self.permutations objectAtIndex:2];
            double lowerBound = [number doubleValue];
            double range = (upperBound - lowerBound);
            double step = range/n;
            double xScale = pow(2, n);
            
            double cdfX  = 0;
            for (int i = 1; i<n; i++) {
                cdfX = lowerBound + (i * step);
                double cdfY = [self CDFWithMean:self.mean variance:self.variance x:cdfX];
                MyPoint *p = [[MyPoint alloc] init];
                p.point =  CGPointMake(cdfY*xScale, cdfX);
                [approximationPoints addObject:p];
                
                if (i != n) {
                    double comCDFX = pow(2,n-1) + (pow(2, n-1) - cdfY*xScale);
                    double comCDFY = self.mean + (self.mean - cdfX);
                    MyPoint *comp = [[MyPoint alloc] init];
                    comp.point = CGPointMake(comCDFX, comCDFY);
                    [complementPoints insertObject:comp atIndex:0];
                }
            }
            
            // add complement
            [approximationPoints addObjectsFromArray:complementPoints];
            
            
            // draw
            MyPoint *previousPoint = [[MyPoint alloc] init];
            previousPoint.point = CGPointMake(3, lowerBound);
            for (int i=0; i<[approximationPoints count]; i++) {
                MyPoint *p = [approximationPoints objectAtIndex:i];
                
                line = [NSBezierPath bezierPath];
                if (i % 2) {
                    [line setLineWidth:1.5];
                    [[NSColor redColor] set];
                } else {
                    [line setLineWidth:2.0];
                    [[NSColor colorWithCalibratedRed:0.1 green:0.70 blue:0.1 alpha:1.0f] set];
                }
                [line moveToPoint:NSMakePoint(previousPoint.point.x * self.gridCellWidth, previousPoint.point.y * self.gridCellHeight)];
                [line lineToPoint:NSMakePoint(p.point.x * self.gridCellWidth, p.point.y * self.gridCellHeight)];
                [line stroke];
                previousPoint = p;
            }
            
            // draw last point
            line = [NSBezierPath bezierPath];
            if ([approximationPoints count] % 2) {
                [line setLineWidth:1.5];
                [[NSColor redColor] set];
            } else {
                [line setLineWidth:2.0];
                [[NSColor colorWithCalibratedRed:0.0 green:0.75 blue:0.0 alpha:1.0f] set];
            }

            MyPoint *lastPoint = [[MyPoint alloc] init];
            lastPoint.point = CGPointMake(pow(2, n)-3, self.mean + (self.mean - lowerBound));
            
            [line moveToPoint:NSMakePoint(previousPoint.point.x * self.gridCellWidth, previousPoint.point.y * self.gridCellHeight)];
            [line lineToPoint:NSMakePoint(lastPoint.point.x * self.gridCellWidth, lastPoint.point.y * self.gridCellHeight)];
            [line stroke];            
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
    [line setLineWidth:0.20];
    [[NSColor lightGrayColor] set];
    
    
    // draw vertical lines
    for (int i = 1; i < self.permutations.count; i++) {
        float x = i * self.gridCellWidth;
        [line moveToPoint:NSMakePoint(x, NSMinY([self bounds]))];
        [line lineToPoint:NSMakePoint(x, NSMaxY([self bounds]))];
        [line stroke];
    }
    
    
    // draw horizontal lines
    NSNumber *maxNum = [NSNumber numberWithInt:0];
    if (self.scaleY) {
//        NSString *maxString = [self.permutations lastObject];
        maxNum = [self.permutations lastObject];
    } else {
        maxNum = [NSNumber numberWithInt:(self.frame.size.height/self.gridCellHeight)];
    }
    int max = [maxNum intValue];
//    NSInteger max = [maxString integerValue];
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

//    NSLog(@"sorted = %@", sorted);
    return sorted;
}

//double cdf(double x, double mean, double stdDev) {
//    return (1/2)*(1 + erfc( (x - mean)/(stdDev * M_SQRT2) ));
//}

-(double) cumulativeNormal:(double )x
{
    return 0.5 * erfc(-x * M_SQRT1_2);
}


-(double) CDFWithMean:(double)mean variance:(double)variance x:(double)x
{
    return 0.5 * erfc(((mean - x)/sqrt(variance)) * M_SQRT1_2);
}


@end
