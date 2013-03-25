//
//  EndViewController.m
//  CreatTest
//
//  Created by Mac04 on 13/1/9.
//  Copyright (c) 2013年 Mac04. All rights reserved.
//

#import "EndViewController.h"
#import "STHTTPRequest.h"

@interface EndViewController ()

@end

@implementation EndViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(BOOL) connectedToNetwork{
    
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    
    return (isReachable && !needsConnection) ? YES : NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    ActDicArray = [[NSMutableArray alloc]init];
    UploadArray = [[NSMutableArray alloc]init];
    readFile = [[FileOPs alloc]init];
    fileCount = [readFile numOfQuizFiles];
    NSLog(@"要傳檔案數 %i",fileCount);
    timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(detectNetWork) userInfo:nil repeats:YES];
    
    networkLabel = [[UILabel alloc]initWithFrame:CGRectMake(280, 150, 200, 40)];
    networkLabel.font = [UIFont systemFontOfSize:20];
    networkLabel.textColor = [UIColor redColor];
    [networkLabel setHidden:YES];
    [self.view addSubview:networkLabel];
    
    UploadBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    UploadBtn.frame = CGRectMake(270, 210, 180, 40);
    [UploadBtn setTitle:@"資料上傳網路" forState:UIControlStateNormal];
    [self.view addSubview:UploadBtn];
    
    giveupLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 350, 650, 40)];
    giveupLabel.font = [UIFont systemFontOfSize:25];
    giveupLabel.text = @"測驗到此結束，感謝你的填答!!!(未上傳成功)";
    [self.view addSubview:giveupLabel];
    [giveupLabel setHidden:YES];

#if DEMO
    ReturnBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    ReturnBtn.frame = CGRectMake(270, 510, 180, 40);
    [ReturnBtn setTitle:@"回到首頁" forState:UIControlStateNormal];
    [self.view addSubview:ReturnBtn];
    [ReturnBtn addTarget:self action:@selector(ReturnToCover:) forControlEvents:UIControlEventTouchUpInside];
#endif
    
    }
-(void)detectNetWork{
    //NSLog(@"網路偵測");
    
    if (![self connectedToNetwork]) {
        networkLabel.text =@"還沒有連上網路喔!!!";
        [UploadBtn setHidden:YES];
        [networkLabel setHidden:NO];
        [giveupLabel setHidden:YES];
        
    }
    else{
        [networkLabel setHidden:YES];
        [UploadBtn setHidden:NO];
        [UploadBtn addTarget:self action:@selector(sendToServer:) forControlEvents:UIControlEventTouchUpInside];
        

    }
    
}
-(void)ReturnToCover:(id)sender{
    Stroyboard = self.storyboard;
    [self presentViewController:[Stroyboard instantiateViewControllerWithIdentifier:@"ActCover"] animated:YES completion:Nil];
}
-(void)sendToServer:(id)sender{
    
    NSString *tmpFile;
    
    numOfFile = [readFile numOfQuizFiles];
    NSLog(@"number of QuizFiles %i",numOfFile);
    
   //__block STHTTPRequest *up = [[STHTTPRequest requestWithURLString:@"http://dtd.ntue.edu.tw/questionnaire/UploadUser.php"] retain];
   __block STHTTPRequest *up = [[STHTTPRequest requestWithURLString:@"http://irating.ntue.edu.tw:8080/mobile/UploadUser.php"] retain];
    
    //NSLog(@"-- url%@", [self urlEncodedString]);
    if (numOfFile > 0) {
        [ReturnBtn setHidden:YES];
        ActDicArray =[readFile getQuizFileList];

        tmpFile = [[ActDicArray lastObject] retain];
        //NSLog(@"待傳資料%@",tmpFile);
        NSMutableDictionary *tmpDic = [readFile TurnJsonToDic:tmpFile];
        //NSLog(@"%@",tmpDic.description);
        
        up.POSTDictionary = tmpDic;
        
        up.uploadProgressBlock = ^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
            NSLog(@"-- %d / %d / %d", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
            [UploadBtn setHidden:YES];
            networkLabel.text =@"資料正在傳送中…";
            [networkLabel setHidden:NO];
            [giveupLabel setHidden:YES];
            
        };
        
        up.completionBlock = ^(NSDictionary *headers, NSString *body) {
            NSLog(@"-- body: %@", body);
            [UploadBtn setHidden:YES];
            [giveupLabel setHidden:YES];
            if (body) {
                //取得圖片列表
                NSArray *imgArray = [readFile getImageFiles:tmpFile];
                if ([imgArray count] > 0) {
                    //ftp圖片上傳
                    PutController *putFtp = [[PutController alloc] init];
                    [putFtp sendImageFile:imgArray body:body];
                    putFtp.completionBlock = ^(NSDictionary *headers, NSString *hello) {
                        //NSLog(@"end view ftp complete");
                        
                        //ftp全部完成後的處理
                        //刪除檔案
                        BOOL success = [readFile DeleteFile:tmpFile];
                        if (success) {
                            [UploadArray addObject:body];
                            NSLog(@"已傳完檔案數 %i",[UploadArray count]);
                            [up release];
                            [ActDicArray release];
                            [self sendToServer:NULL];
                        }
                        if(!success){
                            NSLog(@"Delete file fail");
                        }
                    };
                }
            }
            
        };
        
        up.errorBlock = ^(NSError *error) {
            NSLog(@"-- error%@", [error localizedDescription]);
            [networkLabel setHidden:YES];
            //若id值為空值也不能刪資料，出現錯誤要讓小朋友選擇是否要再上傳一次或是跳出，回來後再請老師自己上傳,封面再多一個buttn
            tellError = [[UIAlertView alloc] initWithTitle:@"錯誤" message:@"傳送失敗!\n請先檢查平板電腦網路\n或是伺服器是否連線" delegate:self cancelButtonTitle:@"重新上傳" otherButtonTitles:@"放棄",nil];
            tellError.tag = 0;
            [tellError show];
            
        };
        
        //先判斷是否有圖片答案，有兩張以上則上傳，否則刪除
        NSArray *imgArray = [readFile getImageFiles:tmpFile];
        if ([imgArray count] > 1) {
            [up startAsynchronous];
        }
        else {
            //刪除檔案
            BOOL success = [readFile DeleteFile:tmpFile];
            if (success) {
                NSLog(@"直接刪除");
                [self sendToServer:NULL];
            }
            if(!success){
                NSLog(@"Delete file fail");
            }
        }
    }
    else if (numOfFile < 1 && [UploadArray count] > 0){
        [self sendEndShow];
    }
    else{
        [ReturnBtn setHidden:NO];
        tellNoData = [[UIAlertView alloc] initWithTitle:@"上傳資料" message:@"沒有資料要上傳" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [tellNoData show];
    }
}

- (void) sendEndShow {
    fileCount = 0;
    [UploadArray removeAllObjects];
    [timer invalidate];
    [UploadBtn setHidden:YES];
    [networkLabel setHidden:YES];
    [giveupLabel setHidden:YES];
    [ReturnBtn setHidden:NO];
    successLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 350, 650, 40)];
    successLabel.font = [UIFont systemFontOfSize:25];
    successLabel.text = @"資料上傳成功，測驗到此結束，感謝你的填答!!!";
    [self.view addSubview:successLabel];
}

- (NSString *)urlEncodedString {
    // https://dev.twitter.com/docs/auth/percent-encoding-parameters
    
    NSString *s = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                      (CFStringRef)@"a&d",
                                                                      NULL,
                                                                      CFSTR("!*'();:@&=+$/,?%#[]"),
                                                                      kCFStringEncodingUTF8);
    return [s autorelease];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 0:
            switch (buttonIndex) {
                case 0:
                    [giveupLabel setHidden:YES];
                    [ReturnBtn setHidden:NO];
                    break;
                case 1:
                    //NSLog(@"放棄");
                    [networkLabel setHidden:YES];
                    [ReturnBtn setHidden:NO];
                    [giveupLabel setHidden:NO];
                    break;
                
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
}
-(void)dealloc{
    [networkLabel release];
    [giveupLabel release];
    [successLabel release];
    [timer release];
    [readFile release];
    [ActDicArray release];
    [UploadArray release];
    [UploadBtn release];
    [DeleteBtn release];
    [ReturnBtn release];
    [tellError release];
    [tellNoData release];
    [super dealloc];
}
-(void)viewDidUnload{
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
