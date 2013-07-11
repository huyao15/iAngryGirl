//
//  DDOrderDAO.m
//  diandian
//
//  Created by 李 鹏鹏 on 13-6-20.
//
//

#import "XLQMoodDAO.h"

@implementation XLQMoodDAO

+(void)createTable:(FMDatabase *)database{
    [database executeUpdate:@"CREATE TABLE IF NOT EXISTS mood (year int(11), month int(11), day int(11), mood_code varchar(64), updated_time timestamp); CREATE UNIQUE INDEX y_m_d ON mood (`year`, `month`, `day`);"];
    NSLog(@"XLQMoodDAO:%d,%@", [database lastErrorCode], [database lastErrorMessage]);
}

+(BOOL)saveDB:(XLQDayData *) data{
    XLQDataBaseUtil * dataBaseUtil = [XLQDataBaseUtil sharedInstance];
    __block BOOL result=NO;
    [dataBaseUtil.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"UPDATE mood SET mood_code=?, updated_time=? WHERE year=? AND month=? AND day=? ;";
        result = [db executeUpdate:sql, data.mood.code, data.updatedTime, [NSNumber numberWithInt:data.year], [NSNumber numberWithInt:data.month], [NSNumber numberWithInt:data.day]];
        if (db.changes == 0) {
            sql = @"INSERT INTO mood(year,month,day,mood_code,updated_time) VALUES(?,?,?,?,?)";
            result = [db executeUpdate:sql, [NSNumber numberWithInt:data.year], [NSNumber numberWithInt:data.month], [NSNumber numberWithInt:data.day], data.mood.code, data.updatedTime];
        }
        NSLog(@"XLQMoodDAO:%d,%@", [db lastErrorCode], [db lastErrorMessage]);
    }];
    return result;
}

+(NSDictionary *)queryWithYear:(int)year withMonth:(int)month
{
    NSMutableDictionary *datas = [[NSMutableDictionary alloc] init];
    XLQDataBaseUtil * dataBaseUtil = [XLQDataBaseUtil sharedInstance];
    [dataBaseUtil.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM mood WHERE year=? AND month=?", [NSNumber numberWithInt:year], [NSNumber numberWithInt:month]];
        while ([rs next]) {
            XLQDayData *data = [[XLQDayData alloc] init];
            [self parse:rs withMsg:data];
            [datas setValue:data forKey:[NSString stringWithFormat:@"%d_%d_%d", data.year, data.month, data.day]];
        }
        [rs close];
        NSLog(@"DDOrderDAO.query:%d,%@", [db lastErrorCode], [db lastErrorMessage]);
    }];
    return datas;
}

+(void)parse:(FMResultSet *)rs withMsg:(XLQDayData *)data{
    data.year = [rs intForColumn:@"year"];
    data.month = [rs intForColumn:@"month"];
    data.day = [rs intForColumn:@"day"];
    data.mood = [XLQMood getMoodByCode:[rs stringForColumn:@"mood_code"]];
    data.updatedTime = [rs dateForColumn:@"updated_time"];
}


@end
