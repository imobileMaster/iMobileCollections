//
//  MADrawRect.m
//  instaoverlay
//
//  Created by Maximilian Mackh on 11/6/12.
//  Copyright (c) 2012 mackh ag. All rights reserved.
//
// CGPoints Illustraition
//
//            cd
//  d   -------------   c
//     |             |
//     |             |
//  da |             |  bc
//     |             |
//     |             |
//     |             |
//  a   -------------   b
//            ab
//
// a = 1, b = 2, c = 3, d = 4

#import "MADrawRect.h"
#import "BKZoomView.h"

@implementation MADrawRect

@synthesize pointD = _pointD;
@synthesize pointC = _pointC;
@synthesize pointB = _pointB;
@synthesize pointA = _pointA;

@synthesize zoomView = _zoomView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setZoomViewer];
        
        [self setPoints];
        [self setClipsToBounds:NO];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        [self setContentMode:UIViewContentModeRedraw];
        
        _pointD = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pointD setTag:4];
        [_pointD setShowsTouchWhenHighlighted:YES];
        [_pointD addTarget:self action:@selector(pointMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
        [_pointD addTarget:self action:@selector(pointMoveEnter:withEvent:) forControlEvents:UIControlEventTouchDown];
        [_pointD addTarget:self action:@selector(pointMoveExit:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        [_pointD setImage:[self squareButtonWithWidth:100] forState:UIControlStateNormal];
        [_pointD setAccessibilityLabel:@"Draggable Crop Button Upper Left hand Corner. Double tap & hold to drag and adjust image frame."];
        [self addSubview:_pointD];
        
        _pointC = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pointC setTag:3];
        [_pointC setShowsTouchWhenHighlighted:YES];
        [_pointC addTarget:self action:@selector(pointMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
        [_pointC addTarget:self action:@selector(pointMoveEnter:withEvent:) forControlEvents:UIControlEventTouchDown];
        [_pointC addTarget:self action:@selector(pointMoveExit:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_pointC setImage:[self squareButtonWithWidth:100] forState:UIControlStateNormal];
        [_pointC setAccessibilityLabel:@"Draggable Crop Button Upper Right hand Corner."];
        [self addSubview:_pointC];
        
        _pointB = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pointB setTag:2];
        [_pointB setShowsTouchWhenHighlighted:YES];
        [_pointB addTarget:self action:@selector(pointMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
        [_pointB addTarget:self action:@selector(pointMoveEnter:withEvent:) forControlEvents:UIControlEventTouchDown];
        [_pointB addTarget:self action:@selector(pointMoveExit:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_pointB setImage:[self squareButtonWithWidth:100] forState:UIControlStateNormal];
        [_pointB setAccessibilityLabel:@"Draggable Crop Button Bottom Right hand Corner."];
        [self addSubview:_pointB];
        
        _pointA = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pointA setTag:1];
        [_pointA setShowsTouchWhenHighlighted:YES];
        [_pointA addTarget:self action:@selector(pointMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
        [_pointA addTarget:self action:@selector(pointMoveEnter:withEvent:) forControlEvents:UIControlEventTouchDown];
        [_pointA addTarget:self action:@selector(pointMoveExit:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_pointA setImage:[self squareButtonWithWidth:100] forState:UIControlStateNormal];
        [_pointA setAccessibilityLabel:@"Draggable Crop Button Bottom Left hand Corner."];
        [self addSubview:_pointA];
        
        [_pointA setShowsTouchWhenHighlighted:NO];
        [_pointB setShowsTouchWhenHighlighted:NO];
        [_pointC setShowsTouchWhenHighlighted:NO];
        [_pointD setShowsTouchWhenHighlighted:NO];
        
        [self setButtons];
        
       
        
    }
    
    _zoomView.hidden = YES;
    
    return self;
}

- (void) setZoomViewHidden
{
    _zoomView.hidden = YES;
}

- (void) setZoomViewer
{
    _zoomView = [[BKZoomView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    [_zoomView setZoomScale:2.0];
    [_zoomView setDragingEnabled:NO];
    [_zoomView.layer setBorderColor:[UIColor blackColor].CGColor];
    [_zoomView.layer setBorderWidth:1.0];
    [_zoomView.layer setCornerRadius:75];
    
    _zoomView.hidden = YES;
    
    [self addSubview:_zoomView];
}

- (UIImage *)squareButtonWithWidth:(int)width
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, width), NO, 0.0);
    UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return blank;
}

- (void)setPoints
{
    a = CGPointMake(0 + 10, self.bounds.size.height - 10);
    b = CGPointMake(self.bounds.size.width - 10, self.bounds.size.height - 10);
    c = CGPointMake(self.bounds.size.width - 10, 0 + 10);
    d = CGPointMake(0 + 10, 0 + 10);
}

- (void)setButtons
{
    [_pointD setFrame:CGRectMake(d.x - kCropButtonSize / 2, d.y - kCropButtonSize / 2, kCropButtonSize, kCropButtonSize)];
    [_pointC setFrame:CGRectMake(c.x - kCropButtonSize / 2,c.y - kCropButtonSize / 2, kCropButtonSize, kCropButtonSize)];
    [_pointB setFrame:CGRectMake(b.x - kCropButtonSize / 2, b.y - kCropButtonSize / 2, kCropButtonSize, kCropButtonSize)];
    [_pointA setFrame:CGRectMake(a.x - kCropButtonSize / 2, a.y - kCropButtonSize / 2, kCropButtonSize, kCropButtonSize)];
}

- (void)bottomLeftCornerToCGPoint: (CGPoint)point
{
    a = point;
    [self needsRedraw];
}

- (void)bottomRightCornerToCGPoint: (CGPoint)point
{
    b = point;
    [self needsRedraw];
}

- (void)topRightCornerToCGPoint: (CGPoint)point
{
    c = point;
    [self needsRedraw];
}

- (void)topLeftCornerToCGPoint: (CGPoint)point
{
    d = point;
    [self needsRedraw];
}

- (void)needsRedraw
{
    frameMoved = YES;
    [self setNeedsDisplay];
    [self setButtons];
    [self drawRect:self.bounds];
}

- (void)drawRect:(CGRect)rect;
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context)
    {
        
        // [UIColor colorWithRed:0.52f green:0.65f blue:0.80f alpha:1.00f];
        
        CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, 0.7f);
        CGContextSetRGBStrokeColor(context, 1.00f, 0.43f, 0.08f, 1.0f);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextSetLineWidth(context, 4.0f);
        
        CGRect boundingRect = CGContextGetClipBoundingBox(context);
        CGContextAddRect(context, boundingRect);
        CGContextFillRect(context, boundingRect);
        
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGPathMoveToPoint(pathRef, NULL, a.x, a.y);
        CGPathAddLineToPoint(pathRef, NULL, b.x, b.y);
        CGPathAddLineToPoint(pathRef, NULL, c.x, c.y);
        CGPathAddLineToPoint(pathRef, NULL, d.x, d.y);
        
       
//        // Draw 4 circles
//        CGPathAddArc(pathRef, NULL, a.x+5, a.y-5, 10.0, 6.28, 0, YES);
//        CGPathAddArc(pathRef, NULL, b.x+5, b.y-5, 10.0, 6.28, 0, YES);
//        CGPathAddArc(pathRef, NULL, c.x+5, c.y-5, 10.0, 6.28, 0, YES);
//        CGPathAddArc(pathRef, NULL, d.x+5, d.y+5, 10.0, 6.28, 0, YES);
    
        CGPathCloseSubpath(pathRef);

        CGContextAddPath(context, pathRef);
        CGContextStrokePath(context);
        
        CGContextSetBlendMode(context, kCGBlendModeClear);
        
        CGContextAddPath(context, pathRef);
        CGContextFillPath(context);
        
        
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        
        CGFloat dashArray[2];
        dashArray[0] = 5;
        dashArray[1] = 2;
        
        float lineWith = 1.0f;
        
        UIBezierPath *dash1V = [UIBezierPath bezierPath];
        [dash1V setLineWidth:lineWith];
        [dash1V setLineDash:dashArray count:2 phase:0];
        UIBezierPath *dash2V = [UIBezierPath bezierPath];
        [dash2V setLineWidth:lineWith];
        [dash2V setLineDash:dashArray count:2 phase:0];
        UIBezierPath *dash3V = [UIBezierPath bezierPath];
        [dash3V setLineWidth:lineWith];
        [dash3V setLineDash:dashArray count:2 phase:0];
        
        UIBezierPath *dash1H = [UIBezierPath bezierPath];
        [dash1H setLineWidth:lineWith];
        [dash1H setLineDash:dashArray count:2 phase:0];
        UIBezierPath *dash2H = [UIBezierPath bezierPath];
        [dash2H setLineWidth:lineWith];
        [dash2H setLineDash:dashArray count:2 phase:0];
        UIBezierPath *dash3H = [UIBezierPath bezierPath];
        [dash3H setLineWidth:lineWith];
        [dash3H setLineDash:dashArray count:2 phase:0];
        
        
        CGPathRelease(pathRef);
    }
    
    _zoomView.hidden = YES;
}

- (IBAction) pointMoveEnter:(id) sender withEvent:(UIEvent *) event
{
    UIControl *control = sender;
    CGPoint raw = [[[event allTouches] anyObject] locationInView:self];
    touchOffset = CGPointMake( raw.x - control.center.x, raw.y - control.center.y);
    
   CGPoint point = CGPointMake(raw.x - touchOffset.x, raw.y - touchOffset.y);
    
    if (CGRectContainsPoint(self.bounds, point))
    {
        UIControl *control = sender;
        control.center = point;
        
        switch (control.tag) {
            case 1:
                _zoomView.center = CGPointMake(point.x, point.y-80);
                break;
            case 2:
                _zoomView.center = CGPointMake(point.x, point.y-80);
                break;
            case 3:
                 _zoomView.center = CGPointMake(point.x, point.y-80);
                break;
            case 4:
                 _zoomView.center = CGPointMake(point.x, point.y-80);
                break;
        }
    }
    
    _zoomView.hidden = NO;
    
    [_zoomView setZoomPoint:point];
    [_zoomView setNeedsDisplay];
}

- (IBAction) pointMoved:(id) sender withEvent:(UIEvent *) event
{
    CGPoint point = [[[event allTouches] anyObject] locationInView:self];
   
     point = CGPointMake(point.x - touchOffset.x, point.y - touchOffset.y);
    
    if (CGRectContainsPoint(self.bounds, point))
    {
        frameMoved = YES;
        UIControl *control = sender;
        control.center = point;
        
        switch (control.tag) {
            case 1:
                a = point;
                 _zoomView.center = CGPointMake(point.x, point.y-80);
                break;
            case 2:
                b = point;
                 _zoomView.center = CGPointMake(point.x, point.y-80);
                break;
            case 3:
                c = point;
                 _zoomView.center = CGPointMake(point.x, point.y-80);
                break;
            case 4:
                d = point;
                 _zoomView.center = CGPointMake(point.x, point.y-80);
                break;
        }
        
        [self setNeedsDisplay];
        [self drawRect:self.bounds];
        
        [_zoomView setZoomPoint:point];
        [_zoomView setNeedsDisplay];

    }
    else
    {
        float kLineOffsetWidth = 2.0f;
        
        if (point.x < kLineOffsetWidth || point.x > self.bounds.size.width - kLineOffsetWidth)
        {
            if (point.x < kLineOffsetWidth)
            {
                point.x = kLineOffsetWidth;
            }
            else if (point.x > self.bounds.size.width - kLineOffsetWidth)
            {
                point.x = self.bounds.size.width - kLineOffsetWidth;
            }
        }
        
        if (point.y < kLineOffsetWidth || point.y > self.bounds.size.height - kLineOffsetWidth)
        {
            if (point.y < kLineOffsetWidth)
            {
                point.y = kLineOffsetWidth;
            }
            else if (point.y > self.bounds.size.height)
            {
                point.y = self.bounds.size.height - kLineOffsetWidth;
            }
        }
        
        frameMoved = YES;
        UIControl *control = sender;
        control.center = point;
        
        
        switch (control.tag) {
            case 1:
                a = point;
                break;
            case 2:
                b = point;
                break;
            case 3:
                c = point;
                break;
            case 4:
                d = point;
                break;
        }
        
        [self setNeedsDisplay];
        [self drawRect:self.bounds];
    }
}

- (IBAction) pointMoveExit:(id) sender withEvent:(UIEvent *) event
{
    touchOffset = CGPointZero;
    
    _zoomView.hidden = YES;
}

- (void) resetFrame
{
    [self setPoints];
    [self setNeedsDisplay];
    [self drawRect:self.bounds];
    frameMoved = NO;
    [self setButtons];
}

- (BOOL) frameEdited
{
    return frameMoved;
}

- (CGPoint)coordinatesForPoint: (int)point withScaleFactor: (CGFloat)scaleFactor
{
    CGPoint tmp = CGPointMake(0, 0);
    
    switch (point) {
        case 1:
            tmp = CGPointMake(a.x / scaleFactor, a.y / scaleFactor);
            break;
        case 2:
            tmp = CGPointMake(b.x / scaleFactor, b.y / scaleFactor);
            break;
        case 3:
            tmp = CGPointMake(c.x / scaleFactor, c.y / scaleFactor);
            break;
        case 4:
            tmp =  CGPointMake(d.x / scaleFactor, d.y / scaleFactor);
            break;
    }
    
    //NSLog(@"%@", NSStringFromCGPoint(tmp));
    
    return tmp;
}

@end

