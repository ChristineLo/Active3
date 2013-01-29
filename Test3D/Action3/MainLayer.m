//
//  MainLayer.m
//  Test3D
//
//  Created by Mac06 on 12/12/7.
//
//

#import "MainLayer.h"

#define kSnapShopImageName @"Active3.jpg"
#define kMenuPosY 1000
#define k3DMenu YES

@implementation MainLayer
/**
 * Creates a new scene and chooses one of the template nodes
 * and sets it as the main node of the scene.
 */
-(CC3Scene*) makeScene {
	Test3DScene* scene = [Test3DScene scene];		// A new scene
	[scene createGLBuffers];
	return scene;
}

-(id) init {
    if (self = [super init]) {
        //背景顏色
        CCLayerColor *backGround = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255)];
        [self addChild:backGround];
        
        //2D 圖層:畫圖
        //drawLayer = [[DrawCanvasLayer alloc] init];
        //[self addChild: drawLayer];
        
        //3D 圖層
        tileLayer = [Test3DLayer layerWithColor: ccc4(0, 0, 0, 0)];
        tileLayer.cc3Scene = [self makeScene];
        [self addChild: tileLayer];
        
        [self initializeControls];
    }
    return self;
}

-(void) initializeControls {
    // Turn depth testing off for 2D content to improve performance and allow us to reduce
	// the clearing of the depth buffer when transitioning from the 3D scene to the 2D scene.
	// See the notes for the CC3Scene shouldClearDepthBufferBefore2D property for more info.
	[[CCDirector sharedDirector] setDepthTest: NO];
    
    /*
    [self addButtons];
    cm3DMenu.visible = k3DMenu;
    cmDrawMenu.visible = !cm3DMenu.visible;
    tileLayer.isTouchEnabled = k3DMenu;
    drawLayer.isTouchEnabled = !tileLayer.isTouchEnabled;
    //[self addLabel];
     */
    [self scheduleUpdate];
}

-(void) dealloc {
    [super dealloc];
}
/**
 * UI 物件
 */
#if 0
#define kMenuFontSize 38
-(void) addButtons {
    //切換與截圖
    CCMenuItemFont *menu8 = [CCMenuItemFont  itemFromString:@"儲存" target:self selector:@selector(saveScreenShotSelected:)];
    CCMenuItemFont *menu7 = [CCMenuItemFont  itemFromString:@"3D" target:self selector:@selector(switchEditStateSelected:)];
    [menu7 setContentSize:menu8.boundingBox.size];
    
    cmSwitchMenu = [CCMenu menuWithItems:menu7, menu8, nil];
    [cmSwitchMenu alignItemsHorizontallyWithPadding:10.0f];
    [cmSwitchMenu setPosition:ccp(680, kMenuPosY)];
    [cmSwitchMenu setColor:ccBLACK];
    [self addChild:cmSwitchMenu];
    
    //繪圖
    CCMenuItemFont *menu6 = [CCMenuItemFont  itemFromString:@"橡皮擦" target:self selector:@selector(drawModeSelected:)];
    [menu6 setTag:EModeDrawEraser];
    CCMenuItemFont *menu5 = [CCMenuItemFont  itemFromString:@"畫筆" target:self selector:@selector(drawModeSelected:)];
    [menu5 setTag:EModeDrawPen];
    [menu5 setContentSize:menu6.boundingBox.size];
    cmDrawMenu = [CCMenu menuWithItems:menu5, menu6, nil];
    [cmDrawMenu alignItemsHorizontallyWithPadding:10.0f];
    [cmDrawMenu setPosition:ccp(120, kMenuPosY)];
    [cmDrawMenu setColor:ccBLACK];
    [self addChild:cmDrawMenu];
    
    //3D模型控制
    CCMenuItemFont *menu1 = [CCMenuItemFont  itemFromString:@"平移" target:self selector:@selector(editModeSelected:)];
    menu1.tag = EMode3DTransfer;
    CCMenuItemFont *menu2 = [CCMenuItemFont  itemFromString:@"旋轉" target:self selector:@selector(editModeSelected:)];
    menu2.tag = EMode3DRotate;
    CCMenuItemFont *menu3 = [CCMenuItemFont  itemFromString:@"深度" target:self selector:@selector(editModeSelected:)];
    menu3.tag = EMode3DZDepth;
    CCMenuItemFont *menu4 = [CCMenuItemFont  itemFromString:@"縮放" target:self selector:@selector(editModeSelected:)];
    menu4.tag = EMode3DScale;
    /*
    CCMenuItem *menu1 = [CCMenuItemImage itemFromNormalImage:@"Icon-Small-50.png" selectedImage:@"Icon-Small-50.png" target:self selector:@selector(saveScreenShotSelected:)];
    CCMenuItem *menu2 = [CCMenuItemImage itemFromNormalImage:@"Icon-Small-50.png" selectedImage:@"Icon-Small-50.png" target:self selector:@selector(saveScreenShotSelected:)];
    CCMenuItem *menu3 = [CCMenuItemImage itemFromNormalImage:@"Icon-Small-50.png" selectedImage:@"Icon-Small-50.png" target:self selector:@selector(saveScreenShotSelected:)];
    */
    menu1.fontSize = kMenuFontSize;
    menu2.fontSize = kMenuFontSize;
    menu3.fontSize = kMenuFontSize;
    menu4.fontSize = kMenuFontSize;
    
    cm3DMenu = [CCMenu menuWithItems:menu1, menu2, menu3, menu4,nil];
    [cm3DMenu alignItemsHorizontallyWithPadding:20.0];
    [cm3DMenu setPosition:ccp(200, kMenuPosY)];
    [cm3DMenu setColor:ccBLACK];
    [self addChild:cm3DMenu];
}
#endif
/**
 * 設定3D編輯模式 
 */
-(void) setEditMode:(int)mode
{
    Test3DScene *tileScene = (Test3DScene*)tileLayer.cc3Scene;
    tileScene.iEditMode = mode;
}
/**
 * 按鈕動作
 */
-(void) scaleModel:(CGFloat)scale
{
    Test3DScene *tileScene = (Test3DScene*)tileLayer.cc3Scene;
    [tileScene scaleNodeFromSwipeAt:scale];
}

-(void) saveScreenShotSelected: (CCMenuItemToggle*) menuItem {
    [self takeScreenShot];
}

-(void) editModeSelected: (CCMenuItemToggle*) menuItem {
    Test3DScene *tileScene = (Test3DScene*)tileLayer.cc3Scene;
    tileScene.iEditMode = menuItem.tag;
    NSLog(@"main layer click, EditMode:%d",menuItem.tag);
}
#if 0
-(void) drawModeSelected: (CCMenuItemToggle*) menuItem {
    drawLayer.iDrawMode = menuItem.tag;
    NSLog(@"main layer click, EditMode:%d",menuItem.tag);
}

-(void) switchEditStateSelected: (CCMenuItemToggle*) menuItem {
    CCMenuItemFont *fontMenu = (CCMenuItemFont*)menuItem;
    if ([fontMenu.label.string isEqualToString:@"3D"]) {
        [fontMenu setString:@"繪圖"];
        cm3DMenu.visible = NO;
        cmDrawMenu.visible = YES;
        tileLayer.isTouchEnabled = NO;
        drawLayer.isTouchEnabled = YES;
    }
    else
    {
        [fontMenu setString:@"3D"];
        cm3DMenu.visible = YES;
        cmDrawMenu.visible = NO;
        tileLayer.isTouchEnabled = YES;
        drawLayer.isTouchEnabled = NO;
    }
}
#endif

#pragma mark Updating
-(void) update: (ccTime)dt {
    [tileLayer update: dt];
}

/**
 * 畫面截圖制作
 */
-(void) takeScreenShot
{
    NSLog(@"save screen");
    /* [self getScreenshot:^(UIImage *image){
     CCLOG(@"Saving Screenshot to Photo Album");
     //UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
     }];*/
    
    // cocos2d 1.0, change 'view' to 'openGLView'
    //UIView * eagleView = (UIView*)[[CCDirector sharedDirector] view];
    UIView * eagleView = (UIView*)[[CCDirector sharedDirector] openGLView];
    GLint backingWidth, backingHeight;
    
    // Bind the color renderbuffer used to render the OpenGL ES view
    // If your application only creates a single color renderbuffer which is already bound at this point,
    // this call is redundant, but it is needed if you're dealing with multiple renderbuffers.
    // Note, replace "_colorRenderbuffer" with the actual name of the renderbuffer object defined in your class.
    // In Cocos2D the render-buffer is already binded (and it's a private property...).
    //glBindRenderbufferOES(GL_RENDERBUFFER_OES, _colorRenderbuffer);
    //glBindRenderbufferOES(GL_RENDERBUFFER_OES, glIsRenderbuffer);
    
    // Get the size of the backing CAEAGLLayer
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    
    NSInteger x = 0, y = 0, width = backingWidth, height = backingHeight;
    NSInteger dataLength = width * height * 4;
    GLubyte *data = (GLubyte*)malloc(dataLength * sizeof(GLubyte));
    
    // Read pixel data from the framebuffer
    glPixelStorei(GL_PACK_ALIGNMENT, 4);
    glReadPixels(x, y, width, height, GL_RGBA, GL_UNSIGNED_BYTE, data);
    
    // Create a CGImage with the pixel data
    // If your OpenGL ES content is opaque, use kCGImageAlphaNoneSkipLast to ignore the alpha channel
    // otherwise, use kCGImageAlphaPremultipliedLast
    CGDataProviderRef ref = CGDataProviderCreateWithData(NULL, data, dataLength, NULL);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGImageRef iref = CGImageCreate (
                                     width,
                                     height,
                                     8,
                                     32,
                                     width * 4,
                                     colorspace,
                                     // Fix from Apple implementation
                                     // (was: kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast).
                                     kCGBitmapByteOrderDefault,
                                     ref,
                                     NULL,
                                     true,
                                     kCGRenderingIntentDefault
                                     );
    
    // OpenGL ES measures data in PIXELS
    // Create a graphics context with the target size measured in POINTS
    NSInteger widthInPoints, heightInPoints;
    if (NULL != UIGraphicsBeginImageContextWithOptions)
    {
        // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
        // Set the scale parameter to your OpenGL ES view's contentScaleFactor
        // so that you get a high-resolution snapshot when its value is greater than 1.0
        CGFloat scale = eagleView.contentScaleFactor;
        widthInPoints = width / scale;
        heightInPoints = height / scale;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(widthInPoints, heightInPoints), NO, scale);
    }
    
    CGContextRef cgcontext = UIGraphicsGetCurrentContext();
    
    // UIKit coordinate system is upside down to GL/Quartz coordinate system
    // Flip the CGImage by rendering it to the flipped bitmap context
    // The size of the destination area is measured in POINTS
    CGContextSetBlendMode(cgcontext, kCGBlendModeCopy);
    CGContextDrawImage(cgcontext, CGRectMake(0.0, 0.0, widthInPoints, heightInPoints), iref);
    
    // Retrieve the UIImage from the current context
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //儲存圖片
    if (image) {
        NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:kSnapShopImageName];
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:path atomically:YES];
        NSLog(@"%@",path);
    }
    UIGraphicsEndImageContext();
    
    // Clean up
    free(data);
    CFRelease(ref);
    CFRelease(colorspace);
    CGImageRelease(iref);
}
@end
