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

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && self.view.window == nil) {
        NSLog(@"VCT3 MemoryWarning");
        [[CCDirector sharedDirector] purgeCachedData];
    }
    else if ([self isViewLoaded] && self.view.window != nil) {
        NSLog(@"VCT3 單頁記憶體不足");
        Test3DAppDelegate *delegate = (Test3DAppDelegate*)[[UIApplication sharedApplication] delegate];
        //儲存後從新載入畫布
        [slv save2File:kFILE_ANS filefolder:delegate.TestNumberString];
        [slv clearButtonClicked];
        [self reloadDrawImage:delegate];
    }
}

-(void) reloadDrawImage:(Test3DAppDelegate*)del {
    NSString  *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/Active3.png",del.TestNumberString]];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    if (image) {
        [slv loadFromAlbumButtonClicked:image];
    }
    //[path release];
}

-(void) viewDidDisappear:(BOOL)animated {
    if (tCountDownTimer) {
        NSLog(@"disabpper timer invalidate");
        [tCountDownTimer invalidate];
        tCountDownTimer = nil;
    }
    [[CCDirector sharedDirector] stopAnimation];
    //[director popScene];
    [[director openGLView] removeFromSuperview];
    [director end];
    [[CCDirector sharedDirector] purgeCachedData];
    self.view = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    addTeachingWord = [[addTeachWord alloc] init];
    [addTeachingWord addTeachingWordString:@"     這裡有一些圖形，現在要請你想出一幅完整的圖畫或是一件新發明，讓它包含下列所有的圖形。\n\n     你可以將這些圖形轉方向、擴大、縮小或是將幾個圖形組合成一個圖形，但是必須符合這些圖形原來的形狀；除了這些圖形之外，可以加上其他的東\n\n     請你儘量想出別人想不到的圖案、故事或發明，畫完之後幫它取一個名字或下一個標題，寫在底下畫線的地方。同樣的，也請你想出一個特別的標題，讓圖畫變得更有意思，（請你根據下面的圖形，將你要畫的圖案或物品，畫在下一頁的空白處，注意：不能改變下列圖形原有的形狀，並且每個圖形只能出現一次）。（十分鐘）" title:@"活動三"];
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ac3img.png"]];
    [img setAutoresizesSubviews:YES];
    [img setFrame:CGRectMake(284, 750, 200, 200)];
    [addTeachingWord.view addSubview:img];
    //[addTeachingWord addTeachingWordImage:@"TeachingWord3.png" :120 :30 :620 :160];
    addTeachingWord.delegate = self;
    [self.view addSubview:addTeachingWord.view];
    [self addChildViewController:addTeachingWord];
#if DEMO
    UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [skipButton setFrame: CGRectMake(712, 5, 50, 44)];
    [skipButton setTitle:@"下一步" forState:UIControlStateNormal];
    [skipButton addTarget:self action:@selector(timeIsUpHandle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:skipButton];
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
    
    
    [self init3D];
    [self initDraw];
    [self initButton];
    
    editState = TWO_D;
    [self checkEditState];
    
    iActionTime = 600;
    [self setCoundDownLabel];
    tCountDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(setCoundDownLabel) userInfo:NULL repeats:YES];
    
    [addTeachingWord release];
}

//到數計時
-(void) setCoundDownLabel {
    //NSLog(@"timer");
    [ulCountDownTime setText:[NSString stringWithFormat:@"%02d:%02d",iActionTime/60,iActionTime%60]];
    if (iActionTime == 10) {
        [ulCountDownTime setTextColor:[UIColor redColor]];
    }
    else if (iActionTime == 60)
    {
        UIAlertView *tellTimeStop = [[UIAlertView alloc] initWithTitle:@"一分鐘提醒" message:@"標題要記得填喔！" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [tellTimeStop show];
    }
    else if (iActionTime < 1) {
        NSLog(@"timer remove");
        [tCountDownTimer invalidate];
        tCountDownTimer = nil;
        
        [self timeIsUpHandle];
    }
    --iActionTime;
}

//填寫完成，時間停止
-(void) timeIsUpHandle{
    if ([title.text isEqual:@""]) {
        UIAlertView *tellTimeStop = [[UIAlertView alloc] initWithTitle:@"時間到！" message:@"請在下方輸入標題。" delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil];
        [tellTimeStop setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [tellTimeStop setTag:2];
        [tellTimeStop show];
        
    } else {
        UIAlertView *tellTimeStop = [[UIAlertView alloc] initWithTitle:@"活動三" message:@"時間到，停止作答!!\n進入下一活動" delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil];
        tellTimeStop.tag = 1;
        [tellTimeStop show];
    }
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
        case 2:
            if (buttonIndex == 0) {
                [title setText:[alertView textFieldAtIndex:0].text];
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
    
    [glView setMultipleTouchEnabled:NO];
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
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 100, 40)];
    [lable setBackgroundColor:[UIColor clearColor]];
    [lable setFont:[UIFont fontWithName:@"ArialMT" size:30]];
    [lable setTextColor:[UIColor blackColor]];
    [lable setText:@"標題："];
    [slv addSubview:lable];
    
    title = [[UITextView alloc] initWithFrame:CGRectMake(120, 70, 600, 40)];
    [title setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:200/255 alpha:0.1]];
    //[title setBorderStyle:UITextBorderStyleBezel];
    [title setFont:[UIFont fontWithName:@"ArialMT" size:15]];
    [slv addSubview:title];
    
    self.curColor = [UIColor blackColor];
}

-(void) dealloc {
    [[CCDirector sharedDirector] release];
    [threeDButtons dealloc];
    [twoDButtons dealloc];
    [slv dealloc];
    [tCountDownTimer dealloc];
    [ulCountDownTime dealloc];
    [threeDLayer dealloc];
    [super dealloc];
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
    /*
    undoButton = (UIGlossyButton*) [self.toolBar viewWithTag: 1001];
    [self setButtonAttrib:undoButton];
    
    redoButton = (UIGlossyButton*) [self.toolBar viewWithTag: 1002];
    [self setButtonAttrib:redoButton];
    */
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
        twoDButtons = [[NSArray arrayWithObjects:clearButton, eraserButton, blackPenButton, whitePenButton, nil] retain];
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
    if (!depthButton.isEnabled) {
        [threeDLayer scaleModel:guesture.scale];
    }
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
    slv.lineColor = [UIColor grayColor];
}

-(IBAction)save2FileButtonClicked:(id)sender
{
    //資料夾暫存
    /*
    Test3DAppDelegate *delegate = (Test3DAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    UIGraphicsBeginImageContext(self.smallView.bounds.size);
    [self.smallView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
     */
    
    //儲存後從新載入畫布
    Test3DAppDelegate *delegate = (Test3DAppDelegate*)[[UIApplication sharedApplication] delegate];
    [slv save2File:kFILE_ANS filefolder:delegate.TestNumberString];
    NSString  *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/Active3.png",delegate.TestNumberString]];
    UIImage *image1 = [UIImage imageWithContentsOfFile:path];
    [slv clearButtonClicked];
    
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
    image1 = nil;
    image2 = nil;
    
    NSLog(@"%@",delegate.TestNumberString);
    NSData *imageData = UIImagePNGRepresentation(resultImg);
    NSString  *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/Active3.png",delegate.TestNumberString]];
    [imageData writeToFile:pngPath atomically:YES];
}

-(IBAction)defaultButtonClicked:(id)sender
{
    [threeDLayer setEditMode:EMode3DTransfer];
    [defaultButton setEnabled:NO];
    [rotateButton setEnabled:YES];
    [depthButton setEnabled:YES];
}
-(IBAction)rotateButtonClicked:(id)sender
{
    [threeDLayer setEditMode:EMode3DRotate];
    [defaultButton setEnabled:YES];
    [rotateButton setEnabled:NO];
    [depthButton setEnabled:YES];
}
-(IBAction)depthButtonClicked:(id)sender
{
    [threeDLayer setEditMode:EMode3DZDepth];
    [defaultButton setEnabled:YES];
    [rotateButton setEnabled:YES];
    [depthButton setEnabled:NO];
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
/*cocos2d*/
- (void)applicationWillResignActive:(UIApplication *)application {
    
    [[CCDirector sharedDirector] pause];
}

/** Resume the cocos3d/cocos2d action. */
-(void) resumeApp { [[CCDirector sharedDirector] resume];
}

- (void)applicationDidBecomeActive: (UIApplication*) application {
	
    // Workaround to fix the issue of drop to 40fps on iOS4.X on app resume.
    // Adds short delay before resuming the app.
    [NSTimer scheduledTimerWithTimeInterval: 0.5f
                                     target: self
                                   selector: @selector(resumeApp)
                                   userInfo: nil
                                    repeats: NO];
    
    // If dropping to 40fps is not an issue, remove above, and uncomment the following to avoid delay.
    //	[self resumeApp];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[director openGLView] removeFromSuperview];
    [director end];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}
@end
