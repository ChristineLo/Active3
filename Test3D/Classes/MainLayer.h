//
//  MainLayer.h
//  Test3D
//
//  Created by Mac06 on 12/12/7.
//
//

#import "CCLayer.h"
#import "Test3DLayer.h"
#import "Test3DScene.h"
#import "cocos2d.h"

@interface MainLayer : CCLayer
{
    CC3Layer* tileLayer;
}
-(CC3Scene*) makeScene;
-(void) takeScreenShot;
@end
