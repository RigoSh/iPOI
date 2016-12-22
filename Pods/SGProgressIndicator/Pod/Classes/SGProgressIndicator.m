//
//  SGProgressIndicator.m
//  Test
//
//  Created by Salvatore Graf on 29/02/16.
//  Copyright © 2016 Italwork S.r.l. All rights reserved.
//

#define degreesToRadians(x) ((x) * M_PI / 180.0)

#import "SGProgressIndicator.h"

static NSString *const kRotationAnimationKey = @"rotation";

@interface SGProgressIndicator()

@property CAShapeLayer *firstCircle;
@property CAShapeLayer *firstArc;

@property CAShapeLayer *secondCircle;
@property CAShapeLayer *secondArc;

@property CAShapeLayer *thirdCircle;
@property CAShapeLayer *thirdArc;

@property CAShapeLayer *fourthCircle;
@property CAShapeLayer *fourthArc;



@property (readwrite) BOOL animating;

@end

@implementation SGProgressIndicator

- (instancetype)initWithCoder:(NSCoder *)coder {
    if(self = [super initWithCoder:coder]) {
        [self _commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self _commonInit];
    }
    return self;
}

- (void)dealloc {
    [self _unregisterFromAppStateNotifications];
}

- (void)setTickness:(CGFloat)tickness {
    if(_tickness != tickness) {
        _tickness = tickness;
        
        self.firstArc.lineWidth     = tickness;
        self.firstCircle.lineWidth  = tickness;

        self.secondArc.lineWidth    = tickness;
        self.secondCircle.lineWidth = tickness;

        self.fourthArc.lineWidth    = tickness;
        self.fourthCircle.lineWidth = tickness;

        self.thirdArc.lineWidth     = tickness;
        self.thirdCircle.lineWidth  = tickness;
        
    }
}
- (void)setFirstArcColor:(UIColor *)firstArcColor {
    if(![_firstArcColor isEqual:firstArcColor]) {
        _firstArcColor                = firstArcColor;
        self.firstArc.strokeColor     = firstArcColor.CGColor;
    }
}

- (void)setSecondArcColor:(UIColor *)secondArcColor {
    if(![_secondArcColor isEqual:secondArcColor]) {
        _secondArcColor               = secondArcColor;
        self.secondArc.strokeColor    = secondArcColor.CGColor;
    }
}
- (void)setFourthArcColor:(UIColor *)fourthArcColor {
    if(![_fourthArcColor isEqual:fourthArcColor]) {
        _fourthArcColor               = fourthArcColor;
        self.fourthArc.strokeColor    = fourthArcColor.CGColor;
    }
}
- (void)setThirdArcColor:(UIColor *)thirdArcColor {
    if(![_thirdArcColor isEqual:thirdArcColor]) {
        _thirdArcColor                = thirdArcColor;
        self.thirdArc.strokeColor     = thirdArcColor.CGColor;
    }
}

- (void)setFirstCircleColor:(UIColor *)firstCircleColor {
    if(![_firstCircleColor isEqual:firstCircleColor]) {
        _firstCircleColor             = firstCircleColor;
        self.firstCircle.strokeColor  = firstCircleColor.CGColor;
    }
}
- (void)setSecondCircleColor:(UIColor *)secondCircleColor {
    if(![_secondCircleColor isEqual:secondCircleColor]) {
        _secondCircleColor            = secondCircleColor;
        self.secondCircle.strokeColor = secondCircleColor.CGColor;
    }
}
- (void)setFourthCircleColor:(UIColor *)fourthCircleColor {
    if(![_fourthCircleColor isEqual:fourthCircleColor]) {
        _fourthCircleColor          = fourthCircleColor;
        self.fourthCircle.strokeColor = fourthCircleColor.CGColor;
    }
}
- (void)setThirdCircleColor:(UIColor *)thirdCircleColor {
    if(![_thirdCircleColor isEqual:thirdCircleColor]) {
        _thirdCircleColor             = thirdCircleColor;
        self.thirdCircle.strokeColor  = thirdCircleColor.CGColor;
    }
}

- (void)setFirstVisible:(BOOL)firstVisible {
    if (_firstVisible != firstVisible) {
        _firstVisible = firstVisible;
    }
    self.firstCircle.hidden  = !firstVisible;
    self.firstArc.hidden     = !firstVisible;
    
}
- (void)setThirdVisible:(BOOL)thirdVisible {
    if (_thirdVisible != thirdVisible) {
    _thirdVisible            = thirdVisible;
    }
    self.thirdCircle.hidden  = !thirdVisible;
    self.thirdArc.hidden     = !thirdVisible;
}
- (void)setSecondVisible:(BOOL)secondVisible {
    if (_secondVisible != secondVisible) {
    _secondVisible           = secondVisible;
    }
    self.secondCircle.hidden = !secondVisible;
    self.secondArc.hidden    = !secondVisible;
}
- (void)setFourthVisible:(BOOL)fourthVisible{
    if (_fourthVisible != fourthVisible) {
    _fourthVisible           = fourthVisible;
    }
    self.fourthCircle.hidden = !fourthVisible;
    self.fourthArc.hidden    = !fourthVisible;
}

- (void)setFirstClockWise:(BOOL)firstClockWise {
    if (_firstClockWise != firstClockWise) {
        _firstClockWise  = firstClockWise;
    }
}
- (void)setThirdClockWise:(BOOL)thirdClockWise {
    if (_thirdClockWise != thirdClockWise) {
        _thirdClockWise  = thirdClockWise;
    }
}
- (void)setSecondClockWise:(BOOL)secondClockWise {
    if (_secondClockWise != secondClockWise) {
        _secondClockWise = secondClockWise;
    }
}
- (void)setFourthClockWise:(BOOL)fourthClockWise{
    if (_fourthClockWise != fourthClockWise) {
        _fourthClockWise = fourthClockWise;
    }
}

-(void)setFirstVelocity:(CGFloat)firstVelocity {
    if (_firstVelocity != firstVelocity) {
        _firstVelocity   = firstVelocity;
    }
}
-(void)setSecondVelocity:(CGFloat)secondVelocity {
    if (_secondVelocity != secondVelocity) {
        _secondVelocity  = secondVelocity;
    }
}
-(void)setThirdVelocity:(CGFloat)thirdVelocity {
    if (_thirdVelocity != thirdVelocity) {
        _thirdVelocity   = thirdVelocity;
    }
}

-(void)setFourthVelocity:(CGFloat)fourthVelocity {
    if (_fourthVelocity != fourthVelocity) {
        _fourthVelocity  = fourthVelocity;
    }
}

-(void)setPercentValue:(CGFloat)percentValue {
    if (_percentValue != percentValue) {
        _percentValue = percentValue;
    }
    
}

- (void)startAnimating {
    if(self.animating) {
        return;
    }
    
    self.animating = YES;
    self.hidden    = NO;
    [self _addAnimation];
}

- (void)stopAnimating {
    if(!self.animating) {
        return;
    }
    
    [self.firstArc removeAnimationForKey:@"rotation"];
    [self.firstCircle removeAnimationForKey:@"rotation"];
    [self.secondArc removeAnimationForKey:@"rotation"];
    [self.secondCircle removeAnimationForKey:@"rotation"];
    [self.thirdArc removeAnimationForKey:@"rotation"];
    [self.thirdCircle removeAnimationForKey:@"rotation"];
    [self.fourthArc removeAnimationForKey:@"rotation"];
    [self.fourthCircle removeAnimationForKey:@"rotation"];
    
    self.hidden    = YES;
    self.animating = NO;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [self _setupBezierPathsForCircle:1];
    [self _setupBezierPathsForCircle:2];
    [self _setupBezierPathsForCircle:3];
    [self _setupBezierPathsForCircle:4];
    
}

- (void)prepareForInterfaceBuilder {
    self.hidden = NO;
}

- (void)didMoveToWindow {
    [super didMoveToWindow];

    if(self.window) {
        [self _restartAnimationIfNeeded];
    }
}


#pragma mark - Private

- (void)_setupBezierPathsForCircle:(NSInteger) circleNumber {
    
    CGPoint center                   = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    CGFloat radius                   = self.bounds.size.width * 0.5 - self.tickness;

    UIBezierPath *firstCirclePath;
    UIBezierPath *firstArcPath;
    
    UIBezierPath *secondCirclePath;
    UIBezierPath *secondArcPath;
    
    UIBezierPath *thirdCirclePath;
    UIBezierPath *thirdArcPath;
    
    UIBezierPath *fourthCirclePath;
    UIBezierPath *fourthArcPath;
    
    switch (circleNumber) {
        case 1:
            // CERCHIO TOP
            firstCirclePath     = [UIBezierPath bezierPathWithArcCenter:center
                                                                               radius:radius - self.tickness *0
                                                                           startAngle:0
                                                                             endAngle:degreesToRadians(360)//   M_PI * 2
                                                                            clockwise:YES];
            
            firstArcPath        = [UIBezierPath bezierPathWithArcCenter:center
                                                                               radius:radius
                                                                           startAngle:degreesToRadians(-45) //-M_PI_4
                                                                             endAngle:degreesToRadians(225) //M_PI_2 - M_PI_4
                                                                            clockwise:YES];
            
            
            self.firstCircle.path = firstCirclePath.CGPath;
            self.firstArc.path    = firstArcPath.CGPath;
            
            
            [self.firstCircle setFrame:CGRectMake(self.bounds.origin.x,self.bounds.origin.y,self.bounds.size.width,self.bounds.size.height)];
            [self.firstArc setFrame:CGRectMake(self.bounds.origin.x,self.bounds.origin.y,self.bounds.size.width,self.bounds.size.height)];
            
            self.firstCircle.bounds    = CGPathGetBoundingBox(firstCirclePath.CGPath);
            self.firstArc.bounds    = CGPathGetBoundingBox(firstCirclePath.CGPath);

            
            break;
        
         case 2:
            //CERCHIO MIDDLE
            secondCirclePath  = [UIBezierPath bezierPathWithArcCenter:center
                                                                             radius:radius - self.tickness *1
                                                                         startAngle:0
                                                                           endAngle:degreesToRadians(360)   //M_PI * 2
                                                                          clockwise:NO];
            
            secondArcPath     = [UIBezierPath bezierPathWithArcCenter:center
                                                                             radius:radius - self.tickness *1
                                                                         startAngle:degreesToRadians(45) // -M_PI_4
                                                                           endAngle:degreesToRadians(-45)  // M_PI_2 - M_PI_4
                                                                          clockwise:YES];
            
            
            self.secondCircle.path   = secondCirclePath.CGPath;
            self.secondArc.path   = secondArcPath.CGPath;
            
            [self.secondCircle setFrame:CGRectMake(self.bounds.origin.x,self.bounds.origin.y,self.bounds.size.width,self.bounds.size.height)];
            [self.secondArc setFrame:CGRectMake(self.bounds.origin.x,self.bounds.origin.y,self.bounds.size.width,self.bounds.size.height)];
            
            self.secondCircle.bounds = CGPathGetBoundingBox(secondCirclePath.CGPath);
            self.secondArc.bounds = CGPathGetBoundingBox(secondCirclePath.CGPath);

            
            break;
        
        case 3:
            //CERCHIO MIDDLE CENTER
            thirdCirclePath  = [UIBezierPath bezierPathWithArcCenter:center
                                                                            radius:radius - self.tickness *2
                                                                        startAngle:0
                                                                          endAngle:degreesToRadians(360)   //M_PI * 2
                                                                         clockwise:NO];
            
            thirdArcPath     = [UIBezierPath bezierPathWithArcCenter:center
                                                                            radius:radius - self.tickness *2
                                                                        startAngle:degreesToRadians(135) // -M_PI_4
                                                                          endAngle:degreesToRadians(45)  // M_PI_2 - M_PI_4
                                                                         clockwise:YES];
            
            
            self.thirdCircle.path   = thirdCirclePath.CGPath;
            self.thirdArc.path   = thirdArcPath.CGPath;
            
            [self.thirdCircle setFrame:CGRectMake(self.bounds.origin.x,self.bounds.origin.y,self.bounds.size.width,self.bounds.size.height)];
            [self.thirdArc setFrame:CGRectMake(self.bounds.origin.x,self.bounds.origin.y,self.bounds.size.width,self.bounds.size.height)];
            
            self.thirdCircle.bounds = CGPathGetBoundingBox(thirdCirclePath.CGPath);
            self.thirdArc.bounds = CGPathGetBoundingBox(thirdCirclePath.CGPath);

            break;
         
        case 4:
            //CERCHIO CENTER
            fourthCirclePath  = [UIBezierPath bezierPathWithArcCenter:center
                                                                             radius:radius - self.tickness *3
                                                                         startAngle:0
                                                                           endAngle:degreesToRadians(360)   //M_PI * 2
                                                                          clockwise:NO];
            
            fourthArcPath     = [UIBezierPath bezierPathWithArcCenter:center
                                                                             radius:radius - self.tickness *3
                                                                         startAngle:degreesToRadians(-135) // -M_PI_4
                                                                           endAngle:degreesToRadians(135)  // M_PI_2 - M_PI_4
                                                                          clockwise:YES];
            
            
            self.fourthCircle.path   = fourthCirclePath.CGPath;
            self.fourthArc.path   = fourthArcPath.CGPath;
            
            [self.fourthCircle setFrame:CGRectMake(self.bounds.origin.x,self.bounds.origin.y,self.bounds.size.width,self.bounds.size.height)];
            [self.fourthArc setFrame:CGRectMake(self.bounds.origin.x,self.bounds.origin.y,self.bounds.size.width,self.bounds.size.height)];
            
            self.fourthCircle.bounds = CGPathGetBoundingBox(fourthCirclePath.CGPath);
            self.fourthArc.bounds = CGPathGetBoundingBox(fourthCirclePath.CGPath);

            break;
            
        default:
            break;
    }
    
    
    
    
}

- (void)_commonInit {
    [self _registerForAppStateNotifications];
    
    self.hidden = NO;
    self.backgroundColor = [UIColor clearColor];
    
    if(self.tickness < 1) {
#if TARGET_OS_TV
        self.tickness = 6;
#else
        self.tickness = 2;
#endif
    }
    
    if(!self.firstCircleColor) {
        self.firstCircleColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
    }
    CAShapeLayer *firstCircle  = [CAShapeLayer layer];
    firstCircle.strokeColor    = self.firstCircleColor.CGColor;
    firstCircle.fillColor      = [UIColor clearColor].CGColor;
    firstCircle.lineWidth      = self.tickness;
    self.firstCircle           = firstCircle;
    
    if(!self.firstArcColor) {
        self.firstArcColor         = self.tintColor;
    }
    CAShapeLayer *firstArc     = [CAShapeLayer layer];
    firstArc.strokeColor       = self.firstArcColor.CGColor;
    firstArc.fillColor         = [UIColor clearColor].CGColor;
    firstArc.lineWidth         = self.tickness;
    self.firstArc              = firstArc;
    
    [self _setupBezierPathsForCircle:1];
    
    [self.layer addSublayer:firstCircle];
    [self.layer addSublayer:firstArc];
    
    
    
    
    
    if(!self.secondCircleColor) {
        self.secondCircleColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
    }
    CAShapeLayer *secondCircle = [CAShapeLayer layer];
    secondCircle.strokeColor   = self.secondCircleColor.CGColor;
    secondCircle.fillColor     = [UIColor clearColor].CGColor;
    secondCircle.lineWidth     = self.tickness;
    self.secondCircle          = secondCircle;
    
    if(!self.secondArcColor) {
        self.secondArcColor        = self.tintColor;
    }
    CAShapeLayer *secondArc    = [CAShapeLayer layer];
    secondArc.strokeColor      = self.secondArcColor.CGColor;
    secondArc.fillColor        = [UIColor clearColor].CGColor;
    secondArc.lineWidth        = self.tickness;
    self.secondArc             = secondArc;
    
    [self _setupBezierPathsForCircle:2];
    
    [self.layer addSublayer:secondCircle];
    [self.layer addSublayer:secondArc];
    
    
    
    
    
    if(!self.thirdCircleColor) {
        self.thirdCircleColor     = [[UIColor grayColor] colorWithAlphaComponent:0.2];
    }
    CAShapeLayer *thirdCircle = [CAShapeLayer layer];
    thirdCircle.strokeColor   = self.thirdCircleColor.CGColor;
    thirdCircle.fillColor     = [UIColor clearColor].CGColor;
    thirdCircle.lineWidth     = self.tickness;
    self.thirdCircle          = thirdCircle;
    
    if(!self.thirdArcColor) {
        self.thirdArcColor        = self.tintColor;
    }
    CAShapeLayer *thirdArc    = [CAShapeLayer layer];
    thirdArc.strokeColor      = self.fourthArcColor.CGColor;
    thirdArc.fillColor        = [UIColor clearColor].CGColor;
    thirdArc.lineWidth        = self.tickness;
    self.thirdArc             = thirdArc;
    
    [self _setupBezierPathsForCircle:3];
    
    [self.layer addSublayer:thirdCircle];
    [self.layer addSublayer:thirdArc];
    
    
    
    
    if(!self.fourthCircleColor) {
        self.fourthCircleColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
    }
    CAShapeLayer *fourthCircle = [CAShapeLayer layer];
    fourthCircle.strokeColor   = self.fourthCircleColor.CGColor;
    fourthCircle.fillColor     = [UIColor clearColor].CGColor;
    fourthCircle.lineWidth     = self.tickness;
    self.fourthCircle          = fourthCircle;
    
    if(!self.fourthArcColor) {
        self.fourthArcColor      = self.tintColor;
    }
    CAShapeLayer *fourthArc = [CAShapeLayer layer];
    fourthArc.strokeColor   = self.fourthArcColor.CGColor;
    fourthArc.fillColor     = [UIColor clearColor].CGColor;
    fourthArc.lineWidth     = self.tickness;
    self.fourthArc          = fourthArc;
    
    [self _setupBezierPathsForCircle:4];
    
    [self.layer addSublayer:fourthCircle];
    [self.layer addSublayer:fourthArc];
    
    
    [self startAnimating];
    
    _percentValue = 12.5;
    

}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.percent.frame = self.bounds;
    self.percent.backgroundColor = [UIColor redColor];
    self.percent.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

- (void)_addAnimation {
    //[self.layer addAnimation:[self _animation] forKey:kRotationAnimationKey];
    [self.firstArc addAnimation:[self clockWiseAnimation:_firstClockWise interval:_firstVelocity] forKey:@"rotation"];
    [self.firstCircle addAnimation:[self clockWiseAnimation:_firstClockWise interval:_firstVelocity] forKey:@"rotation"];
    
    [self.secondArc addAnimation:[self clockWiseAnimation:_secondClockWise interval:_secondVelocity] forKey:@"rotation"];
    [self.secondCircle addAnimation:[self clockWiseAnimation:_secondClockWise interval:_secondVelocity] forKey:@"rotation"];
    
    [self.thirdArc addAnimation:[self clockWiseAnimation:_thirdClockWise interval:_thirdVelocity] forKey:@"rotation"];
    [self.thirdCircle addAnimation:[self clockWiseAnimation:_thirdClockWise interval:_thirdVelocity] forKey:@"rotation"];
    
    [self.fourthArc addAnimation:[self clockWiseAnimation:_fourthClockWise interval:_fourthVelocity] forKey:@"rotation"];
    [self.fourthCircle addAnimation:[self clockWiseAnimation:_fourthClockWise interval:_fourthVelocity] forKey:@"rotation"];
    
}

- (CABasicAnimation *)clockWiseAnimation:(BOOL)isClockWise interval:(CFTimeInterval) interval {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    if (isClockWise) {
        animation.fromValue = @(0);
        animation.toValue   = @(degreesToRadians(360));//@(360); @(M_PI * 2);
    } else {
        animation.fromValue = @(degreesToRadians(360));//@(M_PI * 2);
        animation.toValue   = @(0);
    }
    animation.duration       = interval;
    animation.repeatCount    = INFINITY;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    return animation;
}

- (void)_restartAnimationIfNeeded {
    if(self.animating && ![[self.layer animationKeys] containsObject:kRotationAnimationKey]) {
        [self _addAnimation];
    }
}

#pragma mark - Notifications

- (void)_registerForAppStateNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_restartAnimationIfNeeded) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)_unregisterFromAppStateNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
