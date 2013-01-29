//
//  VCTest3.m
//  Test3D
//
//  Created by gdlab on 12/12/3.
//
//

#import "VCTest3.h"

@interface VCTest3 ()

@end

@implementation VCTest3
@synthesize undoButton;
@synthesize redoButton;
@synthesize clearButton;
@synthesize eraserButton;
@synthesize whitePenButton;
@synthesize blackPenButton;
@synthesize defaultButton;
@synthesize rotateButton;
@synthesize depthButton;
@synthesize switchButton;
@synthesize curColor;

@synthesize ulCountDownTime;
@synthesize toolBar;
@synthesize smallView;

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    addTeachingWord = [[addTeachWord alloc] init];
    [addTeachingWord addTeachingWordImage:@"TeachingWord3.png" :120 :30 :620 :160];
    addTeachingWord.delegate = self;
    [self.view addSubview:addTeachingWord.view];
    [self addChildViewController:addTeachingWord];
#if DEMO
    UIButton *skipButton = (UIButton*) [self.view viewWithTag: 2001];
    [skipButton addTarget:self action:@selector(timeIsUpHandle) forControlEvents:UIControlEventTouchUpInside];
    if (skipButton == NULL) {
        NSLog(@"button is null");
    }
#endif
}

-(void)StartCountDownTimer:(id)sender {
    UIAlertView *tellTimeStart = [[UIAlertView alloc] initWithTitle:@"活動三" message:@"十分鐘計時開始!!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定",nil];
    tellTimeStart.tag = 0;
    [tellTimeStart show];
}

-(void) startAction{
    [addTeachingWord.view removeFromSuperview];
    [addTeachingWord removeFromParentViewController];
    [addTeachingWord release];
    
    [self init3D];
    [self initDraw];
    [self initButton];
    
    editState = TWO_D;
    [self checkEditState];
    
    iActionTime = 600;
    [self setCoundDownLabel];
    tCountDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(setCoundDownLabel) userInfo:NULL repeats:YES];
}

//到數計時
-(void) setCoundDownLabel {
    NSLog(@"timer");
    [ulCountDownTime setText:[NSString stringWithFormat:@"%02d:%02d",iActionTime/60,iActionTime%60]];
    if (iActionTime == 10) {
        [ulCountDownTime setTextColor:[UIColor redColor]];
    }
    else if (iActionTime < 1) {
        NSLog(@"timer remove");
        [tCountDownTimer invalidate];
        [self timeIsUpHandle];
    }
    --iActionTime;
}

//填寫完成，時間停止
-(void) timeIsUpHandle{
    
    UIAlertView *tellTimeStop = [[UIAlertView alloc] initWithTitle:@"活動三" message:@"時間到，停止作答!!\n進入下一活動" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
    tellTimeStop.tag = 1;
    [tellTimeStop show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 0:
            if (buttonIndex == 1) {
                [self startAction];
            }
            break;
        case 1:
            //結束
            if(buttonIndex == 0) {
                    [self save2FileButtonClicked:NULL];
                    [self switchNextAction];
            }
            break;
    }
}

//進入活動三頁面
-(void)switchNextAction{
    [director popScene];
    UIStoryboard *secondStoryboard = self.storyboard;
    //[self presentViewController:[secondStoryboard instantiateViewControllerWithIdentifier:@"ACT5"] animated:YES completion:Nil];
    [self presentViewController:[secondStoryboard instantiateViewControllerWithIdentifier:@"ACT4"] animated:YES completion:Nil];
}

- (void)init3D
{
    [CCDirector setDirectorType:kCCDirectorTypeDisplayLink];
    director = [CCDirector sharedDirector];
    [director setAnimationInterval:1.0/30];
    [director setDisplayFPS:NO];
    
    EAGLView *glView = [CC3EAGLView viewWithFrame:self.view.frame
                                      pixelFormat:kEAGLColorFormatRGBA8
                                      depthFormat:GL_DEPTH24_STENCIL8_OES
                               preserveBackbuffer:NO
                                       sharegroup:Nil
                                    multiSampling:NO
                                  numberOfSamples:4];
    
    [glView setMultipleTouchEnabled:YES];
    [glView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    
    [director setOpenGLView:glView];
    
    if (![director enableRetinaDisplay:YES]) {
        CCLOG(@"Retina Display Not supported");
    }
    
    [self.smallView addSubview:glView];
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
    threeDLayer = [MainLayer node];
    CCScene *scene = [CCScene node];
    [scene addChild:threeDLayer];
    [[CCDirector sharedDirector] runWithScene:scene];
    //一開始的編輯模式
    [threeDLayer setEditMode:EMode3DTransfer];
}

- (void)initDraw
{
    slv = [[[SmoothLineView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + kMENU_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - kMENU_HEIGHT)] autorelease];
    slv.delegate = self;
    
    [smallView addSubview:slv];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(250, 50, 100, 40)];
    [lable setBackgroundColor:[UIColor clearColor]];
    [lable setFont:[UIFont fontWithName:@"ArialMT" size:30]];
    [lable setTextColor:[UIColor blackColor]];
    [lable setText:@"標題："];
    [smallView addSubview:lable];
    
    UITextField *title = [[UITextField alloc] initWithFrame:CGRectMake(330, 50, 250, 40)];
    [title setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:200/255 alpha:0.1]];
    [title setBorderStyle:UITextBorderStyleBezel];
    [title setFont:[UIFont fontWithName:@"ArialMT" size:30]];
    [smallView addSubview:title];
    
    self.curColor = [UIColor blackColor];
}
-(void) viewDidDisappear:(BOOL)animated {
    [tCountDownTimer invalidate];
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"memory warning");
    [super didReceiveMemoryWarning];
    [threeDButtons dealloc];
    [twoDButtons dealloc];
    [threeDButtons dealloc];
    [twoDButtons dealloc];
    [director dealloc];
    [slv dealloc];
    [tCountDownTimer dealloc];
    [ulCountDownTime dealloc];
}

-(void)setButtonAttrib:(UIGlossyButton*)_button
{
    [_button useWhiteLabel: YES];
    _button.buttonCornerRadius = 2.0; _button.buttonBorderWidth = 1.0f;
	[_button setStrokeType: kUIGlossyButtonStrokeTypeBevelUp];
    _button.tintColor = _button.borderColor = [UIColor colorWithRed:70.0f/255.0f green:105.0f/255.0f blue:192.0f/255.0f alpha:1.0f];
}

- (void) initButton
{
    undoButton = (UIGlossyButton*) [self.toolBar viewWithTag: 1001];
    [self setButtonAttrib:undoButton];
    
    redoButton = (UIGlossyButton*) [self.toolBar viewWithTag: 1002];
    [self setButtonAttrib:redoButton];
    
    clearButton = (UIGlossyButton*) [self.toolBar viewWithTag: 1003];
    [self setButtonAttrib:clearButton];
    
    eraserButton = (UIGlossyButton*) [self.toolBar viewWithTag: 1004];
    [self setButtonAttrib:eraserButton];
    
    blackPenButton = (UIGlossyButton*) [self.toolBar viewWithTag: 1005];
    [self setButtonAttrib:blackPenButton];
    
    whitePenButton = (UIGlossyButton*) [self.toolBar viewWithTag: 1006];
    [self setButtonAttrib:whitePenButton];
    
    [blackPenButton setEnabled: YES];
    [whitePenButton setEnabled: YES];
    
    if (twoDButtons == NULL) {
        twoDButtons = [[NSArray arrayWithObjects:undoButton, redoButton, clearButton, eraserButton, blackPenButton, whitePenButton, nil] retain];
    }
    
    defaultButton = (UIGlossyButton*) [self.toolBar viewWithTag: 1008];
    [self setButtonAttrib:defaultButton];
    
    rotateButton = (UIGlossyButton*) [self.toolBar viewWithTag: 1009];
    [self setButtonAttrib:rotateButton];
    
    depthButton = (UIGlossyButton*) [self.toolBar viewWithTag: 1010];
    [self setButtonAttrib:depthButton];
    
    if (threeDButtons == NULL) {
        threeDButtons = [[NSArray arrayWithObjects:defaultButton, rotateButton, depthButton, nil] retain];
    }
    
    switchButton = (UIGlossyButton*) [self.toolBar viewWithTag: 1007];
    [self setButtonAttrib:switchButton];
    [switchButton setEnabled:YES];
}

-(void) setThreeDButtonVisible:(BOOL) isEnable
{
    for (UIGlossyButton *aButton in threeDButtons) {
        [aButton setHidden:!isEnable];
        [aButton setEnabled:isEnable];
    }
}

-(void) setTwoDButtonVisible:(BOOL) isEnable
{
    for (UIGlossyButton *aButton in twoDButtons) {
        [aButton setHidden:!isEnable];
    }
}

-(void) checkEditState {
    switch (editState) {
        case THREE_D:
            [slv setUserInteractionEnabled:NO];
            [slv setIsAccessibilityElement:NO];
            
            [smallView setMultipleTouchEnabled:YES];
            UIGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGuestureHandler:)];
            [smallView addGestureRecognizer:pinch];
            
            [self setThreeDButtonVisible:YES];
            [self setTwoDButtonVisible:NO];
            break;
        case TWO_D:
            [slv setUserInteractionEnabled:YES];
            [slv setIsAccessibilityElement:YES];
            [smallView removeGestureRecognizer:[smallView.gestureRecognizers lastObject]];
            
            [self setThreeDButtonVisible:NO];
            [self setTwoDButtonVisible:YES];
            break;
        default:
            break;
    }
}

#pragma mark Guesture Movement
-(void) pinchGuestureHandler:(UIPinchGestureRecognizer*) guesture
{
    [threeDLayer scaleModel:guesture.scale];
}

#pragma mark Button Click Event

-(IBAction)undoButtonClicked:(id)sender
{
    [slv undoButtonClicked];
    
}

-(IBAction)redoButtonClicked:(id)sender
{
    [slv redoButtonClicked];
    
}

-(IBAction)clearButtonClicked:(id)sender
{
    [slv clearButtonClicked];
}

-(IBAction)eraserButtonClicked:(id)sender
{
    [slv eraserButtonClicked];
}

-(IBAction)blackPenButtonClicked:(id)sender
{
    [slv drawButtonClicked];
    slv.lineColor = [UIColor blackColor];
}

-(IBAction)whitePenButtonClicked:(id)sender
{
    [slv drawButtonClicked];
    slv.lineColor = [UIColor whiteColor];
}

-(IBAction)save2FileButtonClicked:(id)sender
{
    //資料夾暫存
    Test3DAppDelegate *delegate = (Test3DAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    UIGraphicsBeginImageContext(self.smallView.bounds.size);
    [self.smallView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //cocos2d截圖
    [CCDirector sharedDirector].nextDeltaTimeZero = YES;
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CCRenderTexture* rtx =
    [CCRenderTexture renderTextureWithWidth:winSize.width
                                     height:winSize.height];
    [rtx begin];
    [threeDLayer visit];
    [rtx end];
    UIImage *image2 = [rtx getUIImageFromBuffer];
    
    
    UIImage *resultImg = [self addImage:image2 toImage:image1];
    
    
    NSLog(@"%@",delegate.TestNumberString);
    NSData *imageData = UIImagePNGRepresentation(resultImg);
    NSString  *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/Active3.jpg",delegate.TestNumberString]];
    [imageData writeToFile:pngPath atomically:YES];
    
    //[delegate release];
}

-(IBAction)defaultButtonClicked:(id)sender
{
    [threeDLayer setEditMode:EMode3DTransfer];
}
-(IBAction)rotateButtonClicked:(id)sender
{
    [threeDLayer setEditMode:EMode3DRotate];
}
-(IBAction)depthButtonClicked:(id)sender
{
    [threeDLayer setEditMode:EMode3DZDepth];
}

-(IBAction)switchEditStateButtonClicked:(id)sender
{
    (editState == THREE_D)? (editState = TWO_D): (editState = THREE_D);
    [self checkEditState];
}

#pragma mark toolbarDelegate
-(void) setUndoButtonEnable:(NSNumber*)isEnable
{
    [undoButton setEnabled:[isEnable boolValue]];
}
-(void) setRedoButtonEnable:(NSNumber*)isEnable
{
    [redoButton setEnabled:[isEnable boolValue]];
}
-(void) setClearButtonEnable:(NSNumber*)isEnable
{
    [clearButton setEnabled:[isEnable boolValue]];
}
-(void) setEraserButtonEnable:(NSNumber*)isEnable
{
    [eraserButton setEnabled:[isEnable boolValue]];
}
-(void) setBlackPenButtonEnable:(NSNumber*)isEnable
{
    [blackPenButton setEnabled:[isEnable boolValue]];
}
-(void) setWhitePenButtonEnable:(NSNumber*)isEnable
{
    [whitePenButton setEnabled:[isEnable boolValue]];
}
#pragma mark 合成圖片
-(UIImage*) addImage:(UIImage*)image1 toImage:(UIImage*) image2 {
    UIGraphicsBeginImageContext(image1.size);
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}
@end
