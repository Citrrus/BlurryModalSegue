//
//  BlurryModalSegue.h
//  BlurryModal
//
//  Created by Matthew Hupman on 11/21/13.
//  Copyright (c) 2013 Citrrus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BlurryModalSegue;

typedef UIImage*(^ProcessBackgroundImage)(BlurryModalSegue* blurryModalSegue, UIImage* rawImage);

@interface BlurryModalSegue : UIStoryboardSegue

@property (nonatomic, copy) ProcessBackgroundImage processBackgroundImage;

@end
