//
//  BlurryModalSegue.m
//  BlurryModal
//
//  Created by Matthew Hupman on 11/21/13.
//  Copyright (c) 2013 Citrrus. All rights reserved.
//

#import "BlurryModalSegue.h"
#import <QuartzCore/QuartzCore.h>
#import <UIImage+BlurredFrame/UIImage+ImageEffects.h>
#import <MZAppearance/MZAppearance.h>

static UIImageOrientation ImageOrientationFromInterfaceOrientation(UIInterfaceOrientation orientation) {
    switch (orientation)
    {
        case UIInterfaceOrientationPortraitUpsideDown:
            return UIImageOrientationDown;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            return UIImageOrientationRight;
            break;
        case UIInterfaceOrientationLandscapeRight:
            return UIImageOrientationLeft;
            break;
        default:
            return UIImageOrientationUp;
    }
}

@implementation BlurryModalSegue

+ (id)appearance
{
    return [MZAppearance appearanceForClass:[self class]];
}

- (id)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination
{
    self = [super initWithIdentifier:identifier source:source destination:destination];
    
    if (self)
    {
        // Some sane defaults
        self.backingImageBlurRadius = @(20);
        self.backingImageSaturationDeltaFactor = @(.45f);
        
        [[[self class] appearance] applyInvocationTo:self];
    }
    
    return self;
}

- (void)perform
{
    UIViewController* source = (UIViewController*)self.sourceViewController;
    UIViewController* destination = (UIViewController*)self.destinationViewController;

    CGRect windowBounds = source.view.window.bounds;
    
    // Normalize based on the orientation
    CGRect nomalizedWindowBounds = [source.view convertRect:windowBounds fromView:nil];
    
    UIGraphicsBeginImageContextWithOptions(windowBounds.size, YES, 0.0);

    [source.view.window drawViewHierarchyInRect:windowBounds afterScreenUpdates:NO];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    if (self.processBackgroundImage)
    {
        snapshot = self.processBackgroundImage(self, snapshot);
    }
    else
    {
        snapshot = [snapshot applyBlurWithRadius:self.backingImageBlurRadius.doubleValue
                                       tintColor:self.backingImageTintColor
                           saturationDeltaFactor:self.backingImageSaturationDeltaFactor.doubleValue
                                       maskImage:nil];
    }
    
    snapshot = [UIImage imageWithCGImage:snapshot.CGImage scale:1.0 orientation:ImageOrientationFromInterfaceOrientation([UIApplication sharedApplication].statusBarOrientation)];
    
    destination.view.clipsToBounds = YES;
    
    UIImageView* backgroundImageView = [[UIImageView alloc] initWithImage:snapshot];

    CGRect frame;
    switch (destination.modalTransitionStyle) {
        case UIModalTransitionStyleCoverVertical:
            // Only the CoverVertical transition make sense to have an
            // animation on the background to make it look still while
            // destination view controllers animates from the bottom to top
            frame = CGRectMake(0, -nomalizedWindowBounds.size.height, nomalizedWindowBounds.size.width, nomalizedWindowBounds.size.height);
            break;
        default:
            frame = CGRectMake(0, 0, nomalizedWindowBounds.size.width, nomalizedWindowBounds.size.height);
            break;
    }
    backgroundImageView.frame = frame;
    
    [destination.view addSubview:backgroundImageView];
    [destination.view sendSubviewToBack:backgroundImageView];
    
    [self.sourceViewController presentModalViewController:self.destinationViewController animated:YES];
    
    [destination.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [UIView animateWithDuration:[context transitionDuration] animations:^{
            backgroundImageView.frame = CGRectMake(0, 0, nomalizedWindowBounds.size.width, nomalizedWindowBounds.size.height);
        }];
    } completion:nil];
}

@end
