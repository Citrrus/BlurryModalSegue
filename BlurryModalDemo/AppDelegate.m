//
//  AppDelegate.m
//  BlurryModal
//
//  Created by Matthew Hupman on 11/21/13.
//  Copyright (c) 2013 Citrrus. All rights reserved.
//

#import "AppDelegate.h"
#import <BlurryModalSegue/BlurryModalSegue.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[BlurryModalSegue appearance] setBackingImageBlurRadius:@(20)];
    [[BlurryModalSegue appearance] setBackingImageSaturationDeltaFactor:@(.45)];
    
    return YES;
}

@end
