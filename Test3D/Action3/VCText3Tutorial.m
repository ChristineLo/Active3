//
//  VCText3Tutorial.m
//  Test3D
//
//  Created by gdlab on 12/12/27.
//
//

#import "VCText3Tutorial.h"

@interface VCText3Tutorial ()

@end

@implementation VCText3Tutorial
@synthesize undoButton;
@synthesize redoButton;
@synthesize clearButton;
@synthesize eraserButton;
@synthesize save2FileButton;
@synthesize save2AlbumButton;
@synthesize loadFromAlbumButton;
@synthesize curColor;

@synthesize ulCountDownTime;
@synthesize toolBar;
@synthesize smallView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self init3D];
    [self initDraw];
}

- (void)init3D
{
    [CCDirector setDirectorType:kCCDirectorTypeDisplayLink];
    director = [CCDirector sharedDirector];
    [director setAnimationInterval:1.0/30];
    [director setDisplayFPS:YES];
    
    EAGLView *glView = [CC3EAGLView viewWithFrame:self.view.frame
                                      pixelFormat:kEAGLColorFormatRGBA8
                                      depthFormat:GL_DEPTH24_STENCIL8_OES
                               preserveBackbuffer:NO
                                       sharegroup:Nil
                                    multiSampling:NO
                                  numberOfSamples:4];
    
    [glView setMultipleTouchEnabled:YES];
    
    [director setOpenGLView:glView];
    
    if (![director enableRetinaDisplay:YES]) {
        CCLOG(@"Retina Display Not supported");
    }
    
    [self.smallView addSubview:glView];
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
    CCScene *scene = [CCScene node];
    [scene addChild:[MainLayer node]];
    [[CCDirector sharedDirector] runWithScene:scene];
}

- (void)initDraw
{
    slv = [[[SmoothLineView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + kMENU_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - kMENU_HEIGHT)] autorelease];
    slv.delegate = self;
    
    [smallView addSubview:slv];
    
    [self initButton];
    [self initQuest];
    
    self.curColor = [UIColor blackColor];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    undoButton = (UIGlossyButton*) [self.view viewWithTag: 1001];
    [self setButtonAttrib:undoButton];
    
    redoButton = (UIGlossyButton*) [self.view viewWithTag: 1002];
    [self setButtonAttrib:redoButton];
    
    clearButton = (UIGlossyButton*) [self.view viewWithTag: 1003];
    [self setButtonAttrib:clearButton];
    
    eraserButton = (UIGlossyButton*) [self.view viewWithTag: 1004];
    [self setButtonAttrib:eraserButton];
        
    save2FileButton = (UIGlossyButton*) [self.view viewWithTag: 1007];
    [self setButtonAttrib:save2FileButton];
}

-(void) initQuest {
    backNum = 1;
    [self setQuesImage:backNum];
}

-(void)  setQuesImage :(int) Num {
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"action4_image%d.png",backNum]];
    
    if (backImage != NULL) {
        [slv clearButtonClicked];
        [backImage removeFromSuperview];
        [backImage release];
    }
    
    backImage = [[UIImageView alloc] initWithImage:image];
    [backImage setFrame:CGRectMake(backImage.frame.origin.x, backImage.frame.origin.y+80, backImage.frame.size.width, backImage.frame.size.height)];
    [slv addSubview:backImage];
    [image release];
}

-(void) nextQuest {
    if (backNum < 7) {
        [self save2FileButtonClicked:self];
        [self setQuesImage:++backNum];
    }
}

-(void) preQuest {
    if (backNum > 1) {
        [self setQuesImage:--backNum];
        
        NSFileManager *mgr = [[NSFileManager alloc] init];
        NSString  *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Screenshot %@.png",kFILE_ANS]];
        if([mgr fileExistsAtPath:pngPath isDirectory:NO])
        {
            UIImage *image = [UIImage imageWithContentsOfFile:pngPath];
            [slv loadFromAlbumButtonClicked:image];
        }
        [mgr release];
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
    if (eraserButton.borderColor == [UIColor redColor]) {
        eraserButton.borderColor = [UIColor clearColor];
    }
    else {
        eraserButton.borderColor = [UIColor redColor];
    }
}

-(IBAction)save2FileButtonClicked:(id)sender
{
    //[slv save2FileButtonClicked];
    [slv save2File:kFILE_ANS];
}

-(IBAction)save2AlbumButtonClicked:(id)sender
{
    [slv save2AlbumButtonClicked];
    
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
-(void) setSave2FileButtonEnable:(NSNumber*)isEnable
{
    [save2FileButton setEnabled:[isEnable boolValue]];
}
-(void) setSave2AlbumButtonEnable:(NSNumber*)isEnable
{
    [save2AlbumButton setEnabled:[isEnable boolValue]];
}

@end
