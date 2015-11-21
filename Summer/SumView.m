//
//  SumView.m
//  Summer
//
//  Created by Chris Shreve on 11/20/15.
//  Copyright © 2015 C. Shreve. All rights reserved.
//

#import "SumView.h"

@interface SumView ()

@end

@implementation SumView


-(void)drawRect:(NSRect)dirtyRect {
    [[NSColor whiteColor] set];
    NSRectFill(dirtyRect);
    
    
    float gridCellWidth = self.frame.size.width/self.permutations.count;
    float gridCellHeight = self.frame.size.height/self.permutations.count;
    
    NSBezierPath *line = [NSBezierPath bezierPath];
    [line moveToPoint:NSMakePoint(NSMinX([self bounds]), NSMinY([self bounds]))];
    [line lineToPoint:NSMakePoint(NSMaxX([self bounds]), NSMaxY([self bounds]))];
    [line setLineWidth:0.5];
    [[NSColor grayColor] set];
    [line stroke];
    
}
@end
