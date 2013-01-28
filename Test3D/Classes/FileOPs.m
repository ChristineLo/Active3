//
//  FileOPs.m
//  CreatTest
//
//  Created by Mac04 on 12/12/14.
//  Copyright (c) 2012年 Mac04. All rights reserved.
//

#import "FileOPs.h"

@implementation FileOPs
@synthesize fileMgr,TestNumberFilepath , DataFilepath ,Datafilename;

-(id)init{
    if (self == [super init]) {
        if (fileMgr == Nil) {
            fileMgr = [NSFileManager defaultManager];
            
            //資料夾暫存
            delegate = (Test3DAppDelegate*)[[UIApplication sharedApplication] delegate];
            
            TestNumberFilepath = [[NSString alloc]init];
            DataFilepath = [[NSString alloc]init];
            
            JsonWriter = [[SBJsonWriter alloc]init];
            JsonParser = [[SBJsonParser alloc]init];
            //資料夾名稱
            TestNumberFilepath = [HOME_PATH stringByAppendingPathComponent:delegate.TestNumberString];
            NSLog(@"TestNumberFilepath %@ ",TestNumberFilepath);
            
            if ([fileMgr fileExistsAtPath:TestNumberFilepath]) {
                [fileMgr createDirectoryAtPath:TestNumberFilepath withIntermediateDirectories:YES attributes:Nil error:Nil];
            }
        }
    }
    return self;
}

-(void)saveToJsonFile:(NSMutableDictionary *)ActionData{
    NSError *err;
    Datafilename = NULL;
    Datafilename = [delegate.TestNumberString stringByAppendingFormat:@"%@",FILE_TYPE];
    DataFilepath = NULL;
    TestNumberFilepath = [HOME_PATH stringByAppendingPathComponent:delegate.TestNumberString];
    
    //NSLog(@"%@",TestNumberFilepath);
    DataFilepath = [TestNumberFilepath stringByAppendingPathComponent:Datafilename];
    //NSLog(@"%@",[JsonWriter stringWithObject:ActionData]);
    
    NSString *JsonDataString = [JsonWriter stringWithObject:ActionData];
    BOOL ok=[JsonDataString writeToFile:DataFilepath atomically:YES encoding:NSUTF8StringEncoding error:&err];
    
    if(!ok){
        NSLog(@"Error writing file at %@\n%@",DataFilepath, [err localizedFailureReason]);
        [fileMgr createDirectoryAtPath:TestNumberFilepath withIntermediateDirectories:YES attributes:Nil error:Nil];
        [JsonDataString writeToFile:DataFilepath atomically:YES encoding:NSUTF8StringEncoding error:&err];
    }
}
-(NSMutableDictionary *)readFromJsonFile{
    NSError *err;
    Datafilename = NULL;
    Datafilename = [delegate.TestNumberString stringByAppendingFormat:@"%@",FILE_TYPE];
    DataFilepath = NULL;
    TestNumberFilepath = [HOME_PATH stringByAppendingPathComponent:delegate.TestNumberString];
    DataFilepath = [TestNumberFilepath stringByAppendingPathComponent:Datafilename];
    //NSLog(@"%@",[JsonWriter stringWithObject:ActionData]);
    NSString *JsondataString = [[NSString alloc]initWithContentsOfFile:DataFilepath encoding:NSUTF8StringEncoding error:&err];
    
    NSMutableDictionary *data = [JsonParser objectWithString:JsondataString error:&err];
    if (!data) {
        NSLog(@"Error reading file at %@\n%@",DataFilepath, [err localizedFailureReason]);
    }
    return data;
}

//取得檔案列表並存在Array裡
-(NSMutableArray *)getQuizFileList{
    NSError *error=nil;
    NSArray *fileList = [fileMgr contentsOfDirectoryAtPath:HOME_PATH error:&error];
    NSMutableArray *dirList = [[NSMutableArray alloc]init];
    for (NSString *file in fileList) {
        
        BOOL other = NO;
        other = [file isEqualToString:@".DS_Store"]; 
        if (!other) {
            [dirList addObject:file];
            //NSLog(@"get QuizFileList %@",file);
        }
        //NSLog(@"not in %@",file);
    }
    return dirList;
}

-(int) numOfQuizFiles{
    NSArray *TestfileList = [self getQuizFileList];
    return [TestfileList count];
}
-(NSMutableDictionary *)TurnJsonToDic:(NSString *)file{
    NSError *error=nil;
    NSMutableDictionary *JsonToDicFile = nil;
    NSString *tmpPath = [HOME_PATH stringByAppendingPathComponent:file];
    NSString *filename = [file stringByAppendingFormat:@"%@",FILE_TYPE];//檔案與所存資料夾名稱相同
    NSString *path = [tmpPath stringByAppendingPathComponent:filename];
    BOOL isDir;
    BOOL success = [fileMgr fileExistsAtPath:path isDirectory:&isDir];
    if (success & !isDir) {
        NSString *JsondataString = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        
         JsonToDicFile = [JsonParser objectWithString:JsondataString error:&error];
    }
    return JsonToDicFile;
}
-(BOOL) DeleteFile:(NSString *)file{
    NSError *error;
    BOOL deleteSuccess;
    NSString *tmpPath = [HOME_PATH stringByAppendingPathComponent:file];
    if (file) {
        NSLog(@"刪除檔案：%@",file);
        deleteSuccess = [fileMgr removeItemAtPath:tmpPath error:&error];
    }
    if (!deleteSuccess) {
         NSLog(@"Error delete file at %@\n%@",tmpPath, [error localizedFailureReason]);
    }
    return deleteSuccess;
}
-(void)showTestNumberString{

    TestNumberFilepath = [HOME_PATH stringByAppendingPathComponent:delegate.TestNumberString];
    NSLog(@"TestNumberFilepath %@ ",TestNumberFilepath);
}
@end
