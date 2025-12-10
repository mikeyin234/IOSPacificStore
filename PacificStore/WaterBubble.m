//
//  WaterBubble.m
//  PacificStore
//
//  Created by 尹竑翰 on 2020/6/2.
//  Copyright © 2020 greatsoft. All rights reserved.
//

#import "WaterBubble.h"

@implementation WaterBubble


- (void)createBubble:(UIView*)view
{
    
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble"]];
    
    CGFloat size = [self randomFloatBetween:10 and:50];
    
    /* If you are not animating your fish, this will work fine
    [bubbleImageView setFrame:CGRectMake(self.fishImageView.frame.origin.x + 5, self.fishImageView.frame.origin.y + 80, size, size)]; */
    
    // If you are animating your fish, you need to get the starting point from the
    // fish's presentation layer, since it will be animating at the time.
    
    
    
//=====================================================//
    
    CGFloat XPos = [self randomFloatBetween:50 and:UIScreen.mainScreen.bounds.size.width-50];
    CGFloat YPos = [self randomFloatBetween:200 and:UIScreen.mainScreen.bounds.size.height-50];
    
    
    [bubbleImageView setFrame:CGRectMake(XPos, YPos, size, size)];
    
    bubbleImageView.alpha = [self randomFloatBetween:.1 and:1];
    
    [view addSubview:bubbleImageView];
    
    UIBezierPath *zigzagPath = [[UIBezierPath alloc] init];
    CGFloat oX = bubbleImageView.frame.origin.x;
    CGFloat oY = bubbleImageView.frame.origin.y;
    CGFloat eX = oX;
    CGFloat eY = oY - [self randomFloatBetween:50 and:300];
    CGFloat t = [self randomFloatBetween:20 and:100];
    CGPoint cp1 = CGPointMake(oX - t, ((oY + eY) / 2));
    CGPoint cp2 = CGPointMake(oX + t, cp1.y);
    
    // randomly switch up the control points so that the bubble
    // swings right or left at random
    NSInteger r = arc4random() % 2;
    if (r == 1) {
        CGPoint temp = cp1;
        cp1 = cp2;
        cp2 = temp;
    }
    
    // the moveToPoint method sets the starting point of the line
    [zigzagPath moveToPoint:CGPointMake(oX, oY)];
    // add the end point and the control points
    [zigzagPath addCurveToPoint:CGPointMake(eX, eY) controlPoint1:cp1 controlPoint2:cp2];
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        // transform the image to be 1.3 sizes larger to
        // give the impression that it is popping
        [UIView transitionWithView:bubbleImageView
                          duration:0.1f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            bubbleImageView.transform = CGAffineTransformMakeScale(1.3, 1.3);
                        } completion:^(BOOL finished) {
                            [bubbleImageView removeFromSuperview];
                        }];
    }];
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.duration = 2;
    pathAnimation.path = zigzagPath.CGPath;
    // remains visible in it's final state when animation is finished
    // in conjunction with removedOnCompletion
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    
    [bubbleImageView.layer addAnimation:pathAnimation forKey:@"movingAnimation"];
    
    [CATransaction commit];

}

- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}



@end
