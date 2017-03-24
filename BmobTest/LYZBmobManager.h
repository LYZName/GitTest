//
//  BmobManager.h
//  BmobTest
//
//  Created by liyazhou on 17/3/22.
//  Copyright © 2017年 liyazhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>

@interface LYZBmobManager : NSObject

//插入数据
+ (void)addObjectWithTableName:(NSString *)tableName params:(NSDictionary *)params;

//获取某张表里的一条数据
+ (void)getObjectWithTableName:(NSString *)tableName objectId:(NSString *)objectId;

//修改某张表里的数据
+ (void)changeObjectWithTableName:(NSString *)tableName objectId:(NSString *)objectId pramas:(NSDictionary *)pramas;

//删除某张表里的一条数据
+ (void)deleteObjectWithTableName:(NSString *)tableName objectId:(NSString *)objectId;

//获取多条数据
+ (void)getObjectsWithTableName:(NSString *)tableName limit:(NSInteger)limit completeBlock:(void (^)(NSArray *objects, NSError *error))completeBlock;
@end
