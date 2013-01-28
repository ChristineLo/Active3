//
//  FileOPs.h
//  CreatTest
//
//  Created by Mac04 on 12/12/14.
//  Copyright (c) 2012年 Mac04. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Test3DAppDelegate.h"
#import "SBJson.h"
#import "SBJsonParser.h"
#define HOME_PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define FILE_TYPE @".json"
@interface FileOPs : NSObject{
    Test3DAppDelegate *delegate;
    SBJsonWriter *JsonWriter;
    SBJsonParser *JsonParser;
    NSFileManager *fileMgr;
    NSString *TestNumberFilepath;
    NSString *DataFilepath;
    NSString *Datafilename;
    
}
@property(nonatomic,retain) NSFileManager *fileMgr;
@property(nonatomic,retain) NSString *TestNumberFilepath ,*DataFilepath ,*Datafilename;
-(void)saveToJsonFile:(NSMutableDictionary *)ActionData;
-(NSMutableDictionary *)readFromJsonFile;
-(NSMutableArray *)getQuizFileList;
-(int) numOfQuizFiles;
-(NSMutableDictionary *)TurnJsonToDic:(NSString *)filepath;
-(BOOL) DeleteFile:(NSString *)file;
-(void)showTestNumberString;
@end
