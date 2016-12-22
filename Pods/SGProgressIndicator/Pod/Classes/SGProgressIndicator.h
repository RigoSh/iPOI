//
//  SGProgressIndicator.h
//  Test
//
//  Created by Salvatore Graf on 29/02/16.
//  Copyright © 2016 Italwork S.r.l. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@protocol SGProgressDelegate <NSObject>
@required

-(void) refreshStatus ;

@end

IB_DESIGNABLE

@interface SGProgressIndicator : UIView {
    id <SGProgressDelegate> delegate;
}

@property (retain) id SGProgressDelegate;
/**
 *  Tickness cerchio (default 2.)
 */
@property (nonatomic) IBInspectable CGFloat tickness;

/**
 *  Colore cerchio (20% transparent gray)
 */
@property (nonatomic) IBInspectable UIColor *firstCircleColor;
@property (nonatomic) IBInspectable UIColor *secondCircleColor;
@property (nonatomic) IBInspectable UIColor *thirdCircleColor;
@property (nonatomic) IBInspectable UIColor *fourthCircleColor;
/**
 *  Impostazione visibiltà
 */
@property (nonatomic) IBInspectable BOOL firstVisible;
@property (nonatomic) IBInspectable BOOL secondVisible;
@property (nonatomic) IBInspectable BOOL thirdVisible;
@property (nonatomic) IBInspectable BOOL fourthVisible;

/**
 *  colore arco (Default: nil, usa 'Tint color')
 */
@property (nonatomic, null_resettable) IBInspectable UIColor *firstArcColor;
@property (nonatomic, null_resettable) IBInspectable UIColor *secondArcColor;
@property (nonatomic, null_resettable) IBInspectable UIColor *thirdArcColor;
@property (nonatomic, null_resettable) IBInspectable UIColor *fourthArcColor;

/**
*  Impostazione rotazione
*/
@property (nonatomic) IBInspectable BOOL firstClockWise;
@property (nonatomic) IBInspectable BOOL secondClockWise;
@property (nonatomic) IBInspectable BOOL thirdClockWise;
@property (nonatomic) IBInspectable BOOL fourthClockWise;

/**
 *  Impostazione velocita circolare
 */
@property (nonatomic) IBInspectable CGFloat firstVelocity;
@property (nonatomic) IBInspectable CGFloat secondVelocity;
@property (nonatomic) IBInspectable CGFloat thirdVelocity;
@property (nonatomic) IBInspectable CGFloat fourthVelocity;

@property (nonatomic, readonly) BOOL animating;


@property (nonatomic) CGFloat percentValue;


@property (nonatomic) IBOutlet UIView *percent;

- (void)startAnimating;
- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
