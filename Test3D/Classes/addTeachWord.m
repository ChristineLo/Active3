//
//  addTeachWord.m
//  CreatTest
//
//  Created by Mac04 on 12/11/29.
//  Copyright (c) 2012年 Mac04. All rights reserved.
//

#import "addTeachWord.h"

@implementation addTeachWord

-(id)init{
    if (self == [super init]) {
       
    }
    return self;
}

-(void)addTeachingWordImage:(NSString *)teachingwordimageName :(int)x :(int)y :(int)width :(int)height{
    image = [UIImage imageNamed:teachingwordimageName];
    imageView = [[UIImageView alloc]initWithImage:image];
    
    //imageView.frame = CGRectMake(384-image.size.width*0.5, 512-image.size.height*0.5, image.size.width, image.size.height);
    imageView.frame = CGRectMake(384-image.size.width*0.5, 512-image.size.height*0.5, image.size.width, image.size.height);
    [imageView setContentMode:UIViewContentModeCenter];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:imageView];
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(280, 512+image.size.height*0.5+10, 150, 40)];
    [button setTitle:@"進入活動頁面!!" forState:UIControlStateNormal];
    
    [button addTarget:self.delegate
               action:@selector(StartCountDownTimer:)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

@end
