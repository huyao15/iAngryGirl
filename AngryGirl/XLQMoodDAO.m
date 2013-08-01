//
//  DDOrderDAO.m
//  diandian
//
//  Created by 李 鹏鹏 on 13-6-20.
//
//

#import "XLQMoodDAO.h"


@implementation XLQMoodDAO

+(void)createTable:(FMDatabase *)database{//,description varchar(255)
    [database executeUpdate:@"CREATE TABLE IF NOT EXISTS mood (year int(11), month int(11), day int(11), mood_code varchar(64), updated_time timestamp,description varchar(255)); CREATE UNIQUE INDEX y_m_d ON mood (`year`, `month`, `day`);"];
    NSLog(@"XLQMoodDAO createTable:%d,%@", [database lastErrorCode], [database lastErrorMessage]);
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

+(NSDictionary *)groupByMoodCodeWithYear:(int)year withMonth:(int)month{
    NSMutableDictionary *datas = [[NSMutableDictionary alloc] init];
    XLQDataBaseUtil * dataBaseUtil = [XLQDataBaseUtil sharedInstance];
    [dataBaseUtil.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT mood_code ,count(mood_code) mcount FROM mood WHERE year=? AND month=? group by mood_code ", [NSNumber numberWithInt:year], [NSNumber numberWithInt:month]];
        while ([rs next]) {
            NSString *mood_code = [rs stringForColumn:@"mood_code"];
            NSInteger mood_count = [rs intForColumn:@"mcount"];
            [datas setValue:[NSNumber numberWithInt:mood_count ] forKey:mood_code];
        }
        [rs close];
    }];
    return datas;
}

+(XLQDayData *)queryWithYear:(int)year withMonth:(int)month withDay:(int)day
{
     XLQDayData *data = [[XLQDayData alloc] init];
    XLQDataBaseUtil * dataBaseUtil = [XLQDataBaseUtil sharedInstance];
    [dataBaseUtil.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM mood WHERE year=? AND month=? and day=?", [NSNumber numberWithInt:year], [NSNumber numberWithInt:month],[NSNumber numberWithInt:day]];
        while ([rs next]) {
            [self parse:rs withMsg:data];
        }
        [rs close];
        NSLog(@"XLQDayDataDAO.query:%d,%@", [db lastErrorCode], [db lastErrorMessage]);
    }];
    return data;
}

+(BOOL)updateDescription:(NSString *)desc WithYear:(int)year withMonth:(int)month withDay:(int) day{
    XLQDataBaseUtil * dataBaseUtil = [XLQDataBaseUtil sharedInstance];
    __block BOOL result=NO;
    [dataBaseUtil.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql =  @"update mood set description=? where year=? and month=? and day=?";
        result=[db executeUpdate:sql,desc,[NSNumber numberWithInt:year],[NSNumber numberWithInt:month],[NSNumber numberWithInt:day]];
        NSLog(@"DDMoodDAO.updateDescription:%d,%@", [db lastErrorCode], [db lastErrorMessage]);
    }];
    return result;
}

//判断某表中某字段是否存在
+(BOOL)isExistColumnInTable:(NSString *)tableName ColumnName:(NSString *)column{
    XLQDataBaseUtil * dataBaseUtil = [XLQDataBaseUtil sharedInstance];
    __block BOOL result=NO;
    if ((tableName == nil) || (column == nil)) return NO;
    NSString *sql = [NSString stringWithFormat:@"select sql from sqlite_master where tbl_name='%@';", tableName];
    [dataBaseUtil.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs  = [db executeQuery:sql];
        while ([rs next]) {
            NSString *createSQL=[rs objectForColumnIndex:0];
            NSRange range = [createSQL rangeOfString:column];
            if (range.location!=NSNotFound) {
                result=YES;
            }
        }
        [rs close];
        NSLog(@"XLQMoodDAO.isExistColumnInTable:%d,%@", [db lastErrorCode], [db lastErrorMessage]);
    }];
    return result;
}

+(BOOL)hasColumn:(NSString *)columnName atTable:(NSString *)tableName{
    XLQDataBaseUtil * dataBaseUtil = [XLQDataBaseUtil sharedInstance];
    __block BOOL result=NO;
    if ((tableName == nil) || (columnName == nil)) return NO;
    NSString *sql = [NSString stringWithFormat:@"select * from %@ limit 1", tableName];
    [dataBaseUtil.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs  = [db executeQuery:sql];
        while ([rs next]) {
           int up= [rs columnIndexForName:columnName];
            if (up>0) {
                result=YES;
            }
        }
        [rs close];
        NSLog(@"XLQMoodDAO.hasColumn:%d,%@", [db lastErrorCode], [db lastErrorMessage]);
    }];
    return result;

}

+(void)parse:(FMResultSet *)rs withMsg:(XLQDayData *)data{
    data.year = [rs intForColumn:@"year"];
    data.month = [rs intForColumn:@"month"];
    data.day = [rs intForColumn:@"day"];
    data.mood = [XLQMood getMoodByCode:[rs stringForColumn:@"mood_code"]];
    data.updatedTime = [rs dateForColumn:@"updated_time"];
    data.description=[rs stringForColumn:@"description"];
}

/////////////////////////////////////////////////////////////////////////
//table change ...
+(BOOL)addDescriptionColumn{
    XLQDataBaseUtil * dataBaseUtil = [XLQDataBaseUtil sharedInstance];
    __block BOOL result=NO;
    [dataBaseUtil.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @" alter table mood add column description varchar(255) ";
        result = [db executeUpdate:sql];
        NSLog(@"XLQMoodDAO:%d,%@", [db lastErrorCode], [db lastErrorMessage]);
    }];
    return result;
}

@end
