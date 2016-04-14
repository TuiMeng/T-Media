//
//  TaskInfo.h
//  推盟
//
//  Created by joinus on 16/1/12.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskInfo : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

-(void)setValueWithDictionary:(NSDictionary*)dic;

@end

NS_ASSUME_NONNULL_END

#import "TaskInfo+CoreDataProperties.h"
