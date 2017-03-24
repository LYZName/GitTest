//
//  BmobManager.m
//  BmobTest
//
//  Created by liyazhou on 17/3/22.
//  Copyright © 2017年 liyazhou. All rights reserved.
//

#import "LYZBmobManager.h"

@implementation LYZBmobManager

+ (void)addObjectWithTableName:(NSString *)tableName params:(NSDictionary *)params;
{
    BmobObject *object = [BmobObject objectWithClassName:tableName];
    NSArray *keys = [params allKeys];
    for (NSString *key in keys)
    {
        [object setObject:params[key] forKey:key];
    }
    [object saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful)
        {
            NSLog(@"数据插入成功");
        }
    }];
}

//获取某张表里的一条数据
+ (void)getObjectWithTableName:(NSString *)tableName objectId:(NSString *)objectId
{
    BmobQuery *query = [BmobQuery queryWithClassName:tableName];
    [query getObjectInBackgroundWithId:objectId block:^(BmobObject *object, NSError *error) {
        NSLog(@"%@",object);
    }];
}

//修改某张表里的一条数据
+ (void)changeObjectWithTableName:(NSString *)tableName objectId:(NSString *)objectId pramas:(NSDictionary *)pramas
{
//    BmobQuery *query = [BmobQuery queryWithClassName:tableName];
//    [query getObjectInBackgroundWithId:objectId block:^(BmobObject *object, NSError *error) {
//        if (object)
//        {
//            BmobObject *obj1 = [BmobObject objectWithoutDataWithClassName:tableName objectId:objectId];
//            [obj1 set]
//            //异步更新数据
//            [obj1 updateInBackground];
//        }
//    }];
    BmobObjectsBatch *batch = [[BmobObjectsBatch alloc] init];
    [batch updateBmobObjectWithClassName:tableName objectId:objectId parameters:pramas];
}

//删除某张表里的一条数据
+ (void)deleteObjectWithTableName:(NSString *)tableName objectId:(NSString *)objectId
{
    BmobQuery *query = [BmobQuery queryWithClassName:tableName];
    [query getObjectInBackgroundWithId:objectId block:^(BmobObject *object, NSError *error) {
        if (object)
        {
            BmobObject *obj1 = [BmobObject objectWithoutDataWithClassName:tableName objectId:objectId];
            //异步删除数据
            [obj1 deleteInBackground];
        }
    }];
}

//获取某张标的limit条数据
+ (void)getObjectsWithTableName:(NSString *)tableName limit:(NSInteger)limit completeBlock:(void (^)(NSArray *, NSError *))completeBlock
{
    BmobQuery *query = [BmobQuery queryWithClassName:tableName];
    [query setLimit:limit?:0];
    [query findObjectsInBackgroundWithBlock:completeBlock];
}

//查询满足条件的数据
+ (void)findObjectsWithTableName:(NSString *)tableName withWhereKey:(NSArray *)whereKey
{
    BmobQuery *query = [BmobQuery queryWithClassName:tableName];
    //查询"name","age"有值的数据
    [query whereKeysExists:[NSArray arrayWithObjects:@"name",@"age", nil]];
    //查询"name"有值的数据
    [query whereKeyExists:@"name"];
    //查询"name"没有值的数据
    [query whereKeyDoesNotExist:@"name"];
    //查询name为小明的数据
    [query whereKey:@"name" equalTo:@"小明"];
    //查询name不是小张的数据
    [query whereKey:@"name" notEqualTo:@"小张"];
    //查询age<18的数据
    [query whereKey:@"age" lessThan:[NSNumber numberWithInteger:18]];
    //查询age<=18的数据
    [query whereKey:@"age" lessThanOrEqualTo:[NSNumber numberWithInteger:18]];
    //查询age>18的数据
    [query whereKey:@"age" greaterThan:[NSNumber numberWithInteger:18]];
    //查询age>=18的数据
    [query whereKey:@"age" greaterThanOrEqualTo:[NSNumber numberWithInteger:18]];
    
    //时间搜索的话，等于的情况因为服务器是精确到微秒值，所以比较的值要加1秒
    
    //查询小明，小红，小张的数据
    [query whereKey:@"name" containedIn:[NSArray arrayWithObjects:@"小明",@"小红",@"小张", nil]];
    //排除小明，小张，小红的数据
    [query whereKey:@"name" notContainedIn:[NSArray arrayWithObjects:@"小明",@"小张",@"小红", nil]];
    
    //模糊查询,付费后方可使用
    //正则表达式查询(查询name符合该正则的数据)
    [query whereKey:@"name" matchesWithRegex:@""];
    //查询name以"明"结尾的数据
    [query whereKey:@"name" endWithString:@"明"];
    //查询name以"明"开头的数据
    [query whereKey:@"name" startWithString:@"明"];
    
    //限制一次最多返回10条数据
    query.limit = 10;
    //跳过前10条数据,做分页加载
    query.skip = 10;
    
    //得到的数据根据age升序排序(从小到大)
    [query orderByAscending:@"age"];
    //得到的数据根据降序排序(从大到小)
    [query orderByDescending:@"age"];
    
    //先根据age从小到大排序，age相同在根据更新时间从大到小排序
    [query orderByAscending:@"age"];
    [query orderByDescending:@"updateAt"];
    
    /*Key 	Operation
     $lt 	小于
     $lte 	小于等于
     $gt 	大于
     $gte 	大于等于
     $ne 	不等于
     $in 	在数组中
     $nin 	不在数组中
     $exists 	值不为空
     $or 	合成查询中的或查询
     $and 	合成查询中的与查询
     $regex 	匹配PCRE表达式*/
    //查询age>10和name等于小明的数据
    [query addTheConstraintByAndOperationWithArray:@[@{@"age":@{@"$gt":@10}},@{@"name":@"小明"}]];
    
    //查询age>10或name在数组array里的数据
    [query addTheConstraintByOrOperationWithArray:@[@{@"age":@{@"$gt":@10}}, @{@"name":@{@"$nin":@[@"小张", @"小明"]}}]];
    
    //createdAt大于或等于 2014-07-15 00:00:00
    NSDictionary *condiction1 = @{@"createdAt":@{@"$gte":@{@"__type": @"Date", @"iso": @"2014-07-15 00:00:00"}}};
    //createdAt小于 2014-10-15 00:00:00
    NSDictionary *condiction2 = @{@"createdAt":@{@"$lt":@{@"__type": @"Date", @"iso": @"2014-10-15 00:00:00"}}};
    NSArray *condictonArray = @[condiction1,condiction2];
    //作用就是查询创建时间在2014年7月15日到2014年10月15日之间的数据
    [query addTheConstraintByAndOperationWithArray:condictonArray];
    
    //列author为pointer类型，指向用户表
    //假设用户A的objectId为aaaa ,其中classname为表名(__type数据类型，className表名，objectId)
    NSDictionary *condiction3 = @{@"author":@{@"__type":@"Pointer",@"className":@"_User",@"objectId":@"aaaa"}};
    //假设用户b的objecId为bbbb
    NSDictionary *condiction4= @{@"author":@{@"__type":@"Pointer",@"className":@"_User",@"objectId":@"bbbb"}};
    NSArray *condictionArray = @[condiction3,condiction4];
    //查找作者为用户A或者作者为用户B的数据
    [query addTheConstraintByOrOperationWithArray:condictionArray];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
    }];
    
    //只返回name,age这两列的数据
    [query selectKeys:@[@"name",@"age"]];
}

@end













