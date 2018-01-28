//
//  RSSelectionView.m
//  RSColorPicker
//
//  Created by Ryan Sullivan on 3/12/13.
//

#import "RSSelectionLayer.h"


@interface RSSelectionLayer ()

@property (nonatomic, strong) CGColorRef outerRingColor __attribute__((NSObject));
@property (nonatomic, strong) CGColorRef innerRingColor __attribute__((NSObject));

@end

@implementation RSSelectionLayer

- (void)drawInContext:(CGContextRef)ctx {
    if (!self.outerRingColor || !self.innerRingColor) {
        self.outerRingColor = [[UIColor colorWithWhite:1 alpha:0.4] CGColor];
        self.innerRingColor = [[UIColor colorWithWhite:0 alpha:1] CGColor];
    }
    CGRect rect = self.bounds;
    
    CGContextSetLineWidth(ctx, 3);
    CGContextSetStrokeColorWithColor(ctx, self.outerRingColor);
    CGContextStrokeEllipseInRect(ctx, CGRectInset(rect, 1.5, 1.5));
    
    CGContextSetLineWidth(ctx, 2);
    CGContextSetStrokeColorWithColor(ctx, self.innerRingColor);
    CGContextStrokeEllipseInRect(ctx, CGRectInset(rect, 3, 3));
}

@end

