
//  DDDataBaseUtil.m
//  diandian
//
//  Created by 李 鹏鹏 on 13-6-20.
//
//

#import "XLQDataBaseUtil.h"
#import "XLQMoodDAO.h"

static XLQDataBaseUtil * sharedInstance = nil;

@implementation XLQDataBaseUtil

+(XLQDataBaseUtil *)sharedInstance{
    @synchronized(self) {
        if (sharedInstance == nil)
            sharedInstance = [[self alloc] init];
        NSString *userDBPath = [NSString stringWithFormat:@"%@_mood.db", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/angrygirl"]];
        sharedInstance.dataBase=[FMDatabase databaseWithPath:userDBPath];
        sharedInstance.dbQueue=[FMDatabaseQueue databaseQueueWithPath:userDBPath];
        [self createDataBaseAndTable:sharedInstance];
    }
    return sharedInstance;
}

+(void)createDataBaseAndTable:(XLQDataBaseUtil *) dataBaseUtil{
    if(dataBaseUtil.dataBase == nil){
        NSLog(@"数据库创建失败:mood.db");
    } else {
        if ([dataBaseUtil.dataBase open]) {
            [XLQMoodDAO createTable:dataBaseUtil.dataBase];
        }
        [dataBaseUtil.dataBase close];
    }
    
}

-(void)updateTable{
    BOOL result = [XLQMoodDAO hasColumn:@"description" atTable:@"mood"];
    if (!result) {
        [XLQMoodDAO addDescriptionColumn];
    }
}

//唯一一次alloc单例，之后均返回nil
+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    return nil;
}

//copy返回单例本身
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}



@end
