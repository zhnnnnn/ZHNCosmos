//
//  RSColorPickerView.m
//  RSColorPicker
//
//  Created by Ryan Sullivan on 8/12/11.
//


#import "ANImageBitmapRep.h"

#import "BGRSLoupeLayer.h"
#import "RSColorFunctions.h"
#import "RSColorPickerState.h"
#import "RSColorPickerView.h"
#import "RSGenerateOperation.h"
#import "RSSelectionLayer.h"

#define kSelectionViewSize 22

@interface RSColorPickerView () {
    struct {
        unsigned int bitmapNeedsUpdate:1;
    } _colorPickerViewFlags;
    RSColorPickerState * state;
}

@property (nonatomic) ANImageBitmapRep *rep;

/**
 * A path which represents the shape of the color picker palette,
 * padded by 1/2 the selectionViews's size.
 */
@property (nonatomic) UIBezierPath *activeAreaShape;


/**
 * The layer which contains just the currently selected color 
 * within the -selectionLayer.
 */
@property (nonatomic) CALayer *selectionColorLayer;
/**
 * Layer which shows the circular selection "target".
 */
@property (nonatomic) RSSelectionLayer *selectionLayer;

/**
 * The layer which will ultimately contain the generated
 * palette image.
 */
@property (nonatomic) CALayer *gradientLayer;

/**
 * A black layer. As the brightness is lowered, the opacity
 * of brightnessLayer is increased and thus this view becomes more
 * visible.
 */
@property (nonatomic) CALayer *brightnessLayer;

/**
 * A checkerboard pattern indicating opacity.
 * As opacity is lowered, the alpha of this view becomes
 * closer to 1.
 */
@property (nonatomic) CALayer *opacityLayer;

/**
 * Layer that will contain the gradientLayer, brightnessLayer,
 * opacityLayer.
 */
@property (nonatomic) CALayer *contentsLayer;


@property (nonatomic) BGRSLoupeLayer *loupeLayer;

/**
 * Gets updated to the scale of the current UIWindow.
 */
@property (nonatomic) CGFloat scale;

- (void)initRoutine;
- (void)resizeOrRescale;

// Called to generate the _rep ivar and set it.
- (void)genBitmap;

// Called to generate the bezier paths
- (void)generateBezierPaths;

// Called to update the UI for the current state.
- (void)handleStateChanged;

// Called to handle a state change (optionally disabling CA Actions for loupe).
- (void)handleStateChangedDisableActions:(BOOL)disable;

// touch handling
- (CGPoint)validPointForTouch:(CGPoint)touchPoint;
- (RSColorPickerState *)stateForPoint:(CGPoint)point;
- (void)updateStateForTouchPoint:(CGPoint)point;

// metrics
- (CGFloat)paletteDiameter;

@end


@implementation RSColorPickerView

#pragma mark - Object Lifecycle -

- (id)initWithFrame:(CGRect)frame {
    CGFloat square = fmin(frame.size.height, frame.size.width);
    frame.size = CGSizeMake(square, square);

    self = [super initWithFrame:frame];
    if (self) {
        [self initRoutine];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initRoutine];
    }
    return self;
}

- (void)initRoutine {

    // Show or hide the loupe. Default: show.
    self.showLoupe = YES;
    self.opaque = YES;
    self.backgroundColor = [UIColor clearColor];

    _colorPickerViewFlags.bitmapNeedsUpdate = NO;

    // the view used to select the colour
    self.selectionLayer = [RSSelectionLayer layer];
    self.selectionLayer.frame = CGRectMake(0.0, 0.0, kSelectionViewSize, kSelectionViewSize);
    [self.selectionLayer setNeedsDisplay];

    self.selectionColorLayer = [CALayer layer];
    self.selectionColorLayer.cornerRadius = kSelectionViewSize / 2;
    self.selectionColorLayer.frame = CGRectMake(0.0, 0.0, kSelectionViewSize, kSelectionViewSize);

    self.brightnessLayer = [CALayer layer];
    self.brightnessLayer.frame = self.bounds;
    self.brightnessLayer.backgroundColor = [UIColor blackColor].CGColor;

    self.gradientLayer = [CALayer layer];
    self.gradientLayer.frame = self.bounds;

    self.opacityLayer = [CALayer layer];

    self.contentsLayer = [CALayer layer];
    self.contentsLayer.frame = self.bounds;

    [self.contentsLayer addSublayer:self.gradientLayer];
    [self.contentsLayer addSublayer:self.brightnessLayer];
//    [self.contentsLayer addSublayer:self.selectionColorLayer];
    [self.contentsLayer addSublayer:self.opacityLayer];
//    [self.contentsLayer addSublayer:self.selectionLayer];

    [self.layer addSublayer:self.contentsLayer];

    [self handleStateChangedDisableActions:NO];

    self.contentsLayer.masksToBounds = YES;
    self.cropToCircle = NO;
    self.selectionColor = [UIColor whiteColor];
}

- (void)resizeOrRescale {
    if (!self.window || self.frame.size.width == 0 || self.frame.size.height == 0) {
        self.scale = 0;
        [self.loupeLayer disappearAnimated:NO];
        return;
    }

    self.scale = self.window.screen.scale;

    [CATransaction begin];
    [CATransaction setDisableActions:YES];

    self.layer.contentsScale = self.scale;
    self.selectionLayer.contentsScale = self.scale;
    self.selectionColorLayer.contentsScale = self.scale;
    self.brightnessLayer.contentsScale = self.scale;
    self.gradientLayer.contentsScale = self.scale;
    self.opacityLayer.contentsScale = 1.0;//self.scale;
    self.loupeLayer.contentsScale = self.scale;
    self.contentsLayer.contentsScale = self.scale;

    _colorPickerViewFlags.bitmapNeedsUpdate = YES;
    self.contentsLayer.frame    = self.bounds;
    self.gradientLayer.frame    = self.bounds;
    self.brightnessLayer.frame  = self.bounds;
    self.opacityLayer.frame     = self.bounds;

    self.opacityLayer.backgroundColor = [[UIColor colorWithPatternImage:RSOpacityBackgroundImage(20, self.scale, [UIColor colorWithWhite:0.5 alpha:1.0])] CGColor];

    [self genBitmap];
    [self generateBezierPaths];
    [self handleStateChanged];

    [CATransaction commit];
}

- (void)didMoveToWindow {
    [self resizeOrRescale];
}

- (void)setFrame:(CGRect)frame {
    NSAssert(frame.size.width == frame.size.height, @"RSColorPickerView must be square.");
    [super setFrame:frame];
    [self resizeOrRescale];
}

#pragma mark - Business -

- (void)genBitmap {
    if (!_colorPickerViewFlags.bitmapNeedsUpdate) return;

    self.rep = [self.class bitmapForDiameter:self.gradientLayer.bounds.size.width scale:self.scale padding:self.paddingDistance shouldCache:YES];
    _colorPickerViewFlags.bitmapNeedsUpdate = NO;
    self.gradientLayer.contents = (id)[RSUIImageWithScale(self.rep.image, self.scale) CGImage];
}

- (void)generateBezierPaths {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];

    CGRect activeAreaFrame = CGRectInset(self.bounds, self.paddingDistance, self.paddingDistance);
    if (self.cropToCircle) {
        self.contentsLayer.cornerRadius = self.paletteDiameter / 2.0;
        self.activeAreaShape = [UIBezierPath bezierPathWithOvalInRect:activeAreaFrame];
    } else {
        self.contentsLayer.cornerRadius = 0.0;
        self.activeAreaShape = [UIBezierPath bezierPathWithRect:activeAreaFrame];
    }

    [CATransaction commit];
}

#pragma mark - Getters -

- (UIColor *)colorAtPoint:(CGPoint)point {
    return [self stateForPoint:point].color;
}

- (CGFloat)brightness {
    return state.brightness;
}

- (CGFloat)opacity {
    return state.alpha;
}

- (UIColor *)selectionColor {
    return state.color;
}

- (CGPoint)selection {
    return [state selectionLocationWithSize:self.paletteDiameter padding:self.paddingDistance];
}

#pragma mark - Setters -

- (void)setSelection:(CGPoint)selection {
    [self updateStateForTouchPoint:selection];
}

- (void)setBrightness:(CGFloat)bright {
    state = [state stateBySettingBrightness:bright];
    [self handleStateChanged];
}

- (void)setOpacity:(CGFloat)opacity {
    state = [state stateBySettingAlpha:opacity];
    [self handleStateChanged];
}

- (void)setCropToCircle:(BOOL)circle {
    _cropToCircle = circle;

    [self generateBezierPaths];
    if (circle) {
        // there's a chance the selection was outside the bounds
        CGPoint point = [self validPointForTouch:[state selectionLocationWithSize:self.paletteDiameter
                                                                          padding:self.paddingDistance]];
        [self updateStateForTouchPoint:point];
    } else {
        [self handleStateChanged];
    }
}

- (void)setSelectionColor:(UIColor *)selectionColor {
    state = [[RSColorPickerState alloc] initWithColor:selectionColor];
    [self handleStateChanged];
}

#pragma mark - Selection Updates -

- (void)handleStateChanged {
    [self handleStateChangedDisableActions:YES];
}

- (void)handleStateChangedDisableActions:(BOOL)disable {
    [CATransaction begin];
    [CATransaction setDisableActions: disable];

    // update positions
    CGPoint selectionLocation = [state selectionLocationWithSize:self.paletteDiameter padding:self.paddingDistance];
    self.selectionLayer.position      = selectionLocation;
    self.selectionColorLayer.position = selectionLocation;
    self.loupeLayer.position          = selectionLocation;

    // Make loupeLayer sharp on screen
    CGRect loupeFrame     = self.loupeLayer.frame;
    loupeFrame.origin     = CGPointMake(round(loupeFrame.origin.x), round(loupeFrame.origin.y));
    self.loupeLayer.frame = loupeFrame;
    [self.loupeLayer setNeedsDisplay];

    // set colors and opacities
    self.selectionColorLayer.backgroundColor = [[self selectionColor] CGColor];
    self.opacityLayer.opacity    = 1 - self.opacity;
    self.brightnessLayer.opacity = 1 - self.brightness;
    [CATransaction commit];

    // notify delegate
    if ([self.delegate respondsToSelector:@selector(colorPickerDidChangeSelection:)]) {
        [self.delegate colorPickerDidChangeSelection:self];
    }
}

- (void)updateStateForTouchPoint:(CGPoint)point {
    state = [self stateForPoint:[self validPointForTouch:point]];
    [self handleStateChanged];
}

#pragma mark - Metrics -

- (CGFloat)paddingDistance {
    return kSelectionViewSize / 2.0;
}

- (CGFloat)paletteDiameter {
    return self.bounds.size.width;
}

#pragma mark - Touch Events -

- (CGPoint)validPointForTouch:(CGPoint)touchPoint {
    if ([self.activeAreaShape containsPoint:touchPoint]) {
        return touchPoint;
    }

    if (self.cropToCircle) {
        // We compute the right point on the gradient border
        CGPoint returnedPoint;

        // TouchCircle is the circle which pass by the point 'touchPoint', of radius 'r'
        // 'X' is the x coordinate of the touch in TouchCircle
        CGFloat X = touchPoint.x - CGRectGetMidX(self.bounds);
        // 'Y' is the y coordinate of the touch in TouchCircle
        CGFloat Y = touchPoint.y - CGRectGetMidY(self.bounds);
        CGFloat r = sqrt(pow(X, 2) + pow(Y, 2));

        // alpha is the angle in radian of the touch on the unit circle
        CGFloat alpha = acos( X / r );
        if (touchPoint.y > CGRectGetMidX(self.bounds)) alpha = (2 * M_PI) - alpha;

        // 'actual radius' is the distance between the center and the border of the gradient
        CGFloat actualRadius = (self.paletteDiameter / 2.0) - self.paddingDistance;

        returnedPoint.x = fabs(actualRadius) * cos(alpha);
        returnedPoint.y = fabs(actualRadius) * sin(alpha);

        // we offset the center of the circle, to get the coordinate from the right top left origin
        returnedPoint.x = returnedPoint.x + CGRectGetMidX(self.bounds);
        returnedPoint.y = CGRectGetMidY(self.bounds) - returnedPoint.y;
        return returnedPoint;
    } else {
        CGPoint point = touchPoint;
        if (point.x < self.paddingDistance) point.x = self.paddingDistance;
        if (point.x > self.paletteDiameter - self.paddingDistance) {
            point.x = self.paletteDiameter - self.paddingDistance;
        }
        if (point.y < self.paddingDistance) point.y = self.paddingDistance;
        if (point.y > self.paletteDiameter - self.paddingDistance) {
            point.y = self.paletteDiameter - self.paddingDistance;
        }
        return point;
    }
}

- (RSColorPickerState *)stateForPoint:(CGPoint)point {
    RSColorPickerState * newState = [RSColorPickerState stateForPoint:point
                                                                 size:self.paletteDiameter
                                                              padding:self.paddingDistance];
    newState = [[newState stateBySettingAlpha:self.opacity] stateBySettingBrightness:self.brightness];
    return newState;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    if (self.showLoupe) {
        // Lazily load loupeLayer, if user wants to display it.
		if (!self.loupeLayer) {
			self.loupeLayer = [BGRSLoupeLayer layer];
            self.loupeLayer.contentsScale = self.scale;
		}
		[self.loupeLayer appearInColorPicker:self];
	} else {
        // Otherwise, byebye
        [self.loupeLayer disappear];
	}

    CGPoint point = [touches.anyObject locationInView:self];
    [self updateStateForTouchPoint:point];

    if ([self.delegate respondsToSelector:@selector(colorPicker:touchesBegan:withEvent:)]) {
        [self.delegate colorPicker:self touchesBegan:touches withEvent:event];
    }

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    [self updateStateForTouchPoint:point];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    [self updateStateForTouchPoint:point];

    [self.loupeLayer disappear];

    if ([self.delegate respondsToSelector:@selector(colorPicker:touchesEnded:withEvent:)]) {
        [self.delegate colorPicker:self touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.loupeLayer disappear];
}

#pragma mark - Class Methods -

static NSCache *generatedBitmaps;
static NSOperationQueue *generateQueue;
static dispatch_queue_t backgroundQueue;

+ (void)initialize {
    generatedBitmaps = [NSCache new];
    generateQueue = [NSOperationQueue new];
    generateQueue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
    backgroundQueue = dispatch_queue_create("com.github.rsully.rscolorpicker.background", DISPATCH_QUEUE_SERIAL);
}

#pragma mark Background Methods

+ (void)prepareForDiameter:(CGFloat)diameter {
    [self prepareForDiameter:diameter padding:kSelectionViewSize/2.0];
}

+ (void)prepareForDiameter:(CGFloat)diameter padding:(CGFloat)padding {
    [self prepareForDiameter:diameter scale:1.0 padding:padding];
}

+ (void)prepareForDiameter:(CGFloat)diameter scale:(CGFloat)scale {
    [self prepareForDiameter:diameter scale:scale padding:kSelectionViewSize / 2.0];
}

+ (void)prepareForDiameter:(CGFloat)diameter scale:(CGFloat)scale padding:(CGFloat)padding {
    [self prepareForDiameter:diameter scale:scale padding:padding inBackground:YES];
}

#pragma mark Prep Method

+ (void)prepareForDiameter:(CGFloat)diameter scale:(CGFloat)scale padding:(CGFloat)padding inBackground:(BOOL)bg {
    void (*function)(dispatch_queue_t, dispatch_block_t) = bg ? dispatch_async : dispatch_sync;
    function(backgroundQueue, ^{
        [self bitmapForDiameter:diameter scale:scale padding:padding shouldCache:YES];
    });
}

#pragma mark Generate Helper Method

+ (ANImageBitmapRep *)bitmapForDiameter:(CGFloat)diameter scale:(CGFloat)scale padding:(CGFloat)paddingDistance shouldCache:(BOOL)cache {
    RSGenerateOperation *repOp = nil;

    // Handle the scale here so the operation can just work with pixels directly
    paddingDistance *= scale;
    diameter *= scale;

    if (diameter <= 0) return nil;

    // Unique key for this size combo
    NSString *dictionaryCacheKey = [NSString stringWithFormat:@"%.1f-%.1f", diameter, paddingDistance];
    // Check cache
    repOp = [generatedBitmaps objectForKey:dictionaryCacheKey];

    if (repOp) {
        if (!repOp.isFinished) {
            [repOp waitUntilFinished];
        }
        return repOp.bitmap;
    }

    repOp = [[RSGenerateOperation alloc] initWithDiameter:diameter andPadding:paddingDistance];

    if (cache) {
        [generatedBitmaps setObject:repOp forKey:dictionaryCacheKey cost:diameter];
    }

    [generateQueue addOperation:repOp];
    [repOp waitUntilFinished];

    return repOp.bitmap;
}

@end
