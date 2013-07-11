//
//  DDOrderDAO.h
//  diandian
//
//  Created by 李 鹏鹏 on 13-6-20.
//
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "XLQDayData.h"
#import "XLQDataBaseUtil.h"

@interface XLQMoodDAO : NSObject

+(void)createTable:(FMDatabase *)database;
+(BOOL)saveDB:(XLQDayData *) data;
+(NSDictionary *)queryWithYear : (int)year withMonth : (int)month;

@end
