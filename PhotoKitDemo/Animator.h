//
//  Animator.h
//  PhotoKitDemo
//
//  Created by 解梁 on 16/7/14.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Animator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, retain)UIImage *image;
@property (nonatomic, assign)CGRect rect;

@end
