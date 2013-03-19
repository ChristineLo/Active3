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

-(void) didReceiveMemoryWarning
{
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
}

-(void) dealloc {
    image = nil;
    [image release];
    imageView.image = nil;
    [imageView release];
    NSLog(@"teachWord dealloc");
    [super dealloc];
}

-(void)addTeachingWordString:(NSString *)content title:(NSString*)title
{
    if (title) {
        UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(34, 30, 700, 60)];
        [titleView setFont:[UIFont fontWithName:@"ArialMT" size:40]];
        [titleView setTextColor:[UIColor blackColor]];
        //[titleView setBackgroundColor:[UIColor yellowColor]];
        [titleView setTextAlignment:NSTextAlignmentCenter];
        [titleView setText:title];
        //[titleView setEditable:NO];
        [self.view addSubview:titleView];
        [titleView release];
    }
    
    if (content) {
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(34, 110, 700, 700)];
        [textView setFont:[UIFont fontWithName:@"ArialMT" size:30]];
        [textView setTextColor:[UIColor blackColor]];
        //[textView setBackgroundColor:[UIColor redColor]];
        [textView setTextAlignment:NSTextAlignmentJustified];
        [textView setText:content];
        [textView setEditable:NO];
        [self.view addSubview:textView];
        [textView release];
    }
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self addLeafButtonWithFram:CGRectMake(309, 960, 150, 40)];
}

-(void)addTeachingWordImage:(NSString *)teachingwordimageName :(int)x :(int)y :(int)width :(int)height{
    image = [UIImage imageNamed:teachingwordimageName];
    imageView = [[UIImageView alloc]initWithImage:image];
    
    //imageView.frame = CGRectMake(384-image.size.width*0.5, 512-image.size.height*0.5, image.size.width, image.size.height);
    imageView.frame = CGRectMake(384-image.size.width*0.5, 512-image.size.height*0.5, image.size.width, image.size.height);
    [imageView setContentMode:UIViewContentModeCenter];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:imageView];
    [self addLeafButtonWithFram:CGRectMake(280, 512+image.size.height*0.5+10, 150, 40)];
}

-(void) addLeafButtonWithFram: (CGRect)fram
{
    NSLog(@"teachWord release image");
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //[button setFrame:CGRectMake(280, 512+image.size.height*0.5+10, 150, 40)];
    [button setFrame:fram];
    [button setTitle:@"進入活動頁面!!" forState:UIControlStateNormal];
    
    [button addTarget:self.delegate
               action:@selector(StartCountDownTimer:)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

@end
