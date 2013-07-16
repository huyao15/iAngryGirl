//
//  DDDataBaseUtil.h
//  diandian
//
//  Created by 李 鹏鹏 on 13-6-20.
//
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"

@interface XLQDataBaseUtil : NSObject

@property (strong, nonatomic) FMDatabaseQueue *dbQueue;
@property (strong, nonatomic) FMDatabase *dataBase;

+(XLQDataBaseUtil *)sharedInstance;
-(void)updateTable;

@end
