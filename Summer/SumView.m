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
        
        [self drawGrid];
        [self drawPermutations];
        
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
//    float gridCellWidth = self.frame.size.width/self.permutations.count;
//    float gridCellHeight = self.frame.size.height/self.permutations.count;
    
    NSBezierPath *line = [NSBezierPath bezierPath];
    [line setLineWidth:0.5];
    [[NSColor grayColor] set];
    
    
    // draw vertical lines
    for (int i = 1; i < self.permutations.count; i++) {
        float x = i * self.gridCellWidth;
        [line moveToPoint:NSMakePoint(x, NSMinY([self bounds]))];
        [line lineToPoint:NSMakePoint(x, NSMaxY([self bounds]))];
        [line stroke];
    }
    
    
    // draw horizontal lines
    for (int i = 1; i <= self.permutations.count; i++) {
        float y = i * self.gridCellHeight;
        [line moveToPoint:NSMakePoint(NSMinX([self bounds]), y)];
        [line lineToPoint:NSMakePoint(NSMaxX([self bounds]), y)];
        [line stroke];
    }
    
}


-(void) drawPermutations {
    NSBezierPath *line = [NSBezierPath bezierPath];
    [line setLineWidth:2];
    [[NSColor blueColor] set];

    [line moveToPoint:NSMakePoint(NSMinX([self bounds]), NSMinY([self bounds]))];
     
    for (int i = 0; i < self.permutations.count; i++) {
        float x = i * self.gridCellWidth;

        NSString *pStr = self.permutations[i];
        float p = [pStr floatValue];
        float y = p * self.gridCellHeight;
        
        
        [line lineToPoint:NSMakePoint(x, y)];
        [line lineToPoint:NSMakePoint(x + self.gridCellWidth, y)];        
        [line stroke];

    }
}

@end
