//
//  addTeachWord.h
//  CreatTest
//
//  Created by Mac04 on 12/11/29.
//  Copyright (c) 2012年 Mac04. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol addTeachWordDelegate;
@protocol addTeachWordDelegate <NSObject>
-(void)StartCountDownTimer:(id)sender;
@end

@interface addTeachWord : UIViewController{
    UIButton *button;
    UIImage *image;
    UIImageView *imageView;
}
@property (strong, nonatomic) id<addTeachWordDelegate> delegate;

-(void)addTeachingWordImage:(NSString *)teachingwordimageName :(int)x :(int)y :(int)width :(int)height;
-(void)addTeachingWordString:(NSString *)content title:(NSString*)title;

@end
