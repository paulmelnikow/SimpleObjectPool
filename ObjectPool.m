//
//  ObjectPool.h
//
//  Created by Paul Melnikow on 6/12/13.
//  Copyright (c) 2013 Paul Melnikow. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "ObjectPool.h"

@interface ObjectPool ()
@property (copy) CreateObjectBlock createBlock;
@property (retain) NSMutableArray *pool;
@property (retain, readwrite) NSMutableArray *privateAllObjects;
@end

@implementation ObjectPool

- (id) initWithCreateBlock:(CreateObjectBlock) createBlock {
    if (self = [super init]) {
        self.pool = [NSMutableArray array];
        self.createBlock = createBlock;
    }
    return self;
}

+ (instancetype) poolWithCreateBlock:(CreateObjectBlock) createBlock {
    ObjectPool *result = [[self alloc] initWithCreateBlock:createBlock];
#if __has_feature(objc_arc)
    return [result autorelease];
#else
    return result;
#endif
}

#if !__has_feature(objc_arc)
- (void) dealloc {
    [self.createBlock release];
    [self.pool release];
    [self.allObjects release];
    [super dealloc];
}
#endif

- (id) objectFromPoolWithError:(NSError **) outError {
    id result = nil;
    @synchronized(self.pool) {
        result = [self.pool lastObject];
    }
    
    if (result == nil) {
        result = self.createBlock(outError);
        if (result != nil)
            @synchronized(self.allObjects) {
                [self.privateAllObjects addObject:result];
            }
    }
    
    return result;
}

- (void) returnObjectToPool:(id) object {
    @synchronized(self.pool) {
        [self.pool addObject:object];
    }
}

- (NSArray *) allObjects {
    @synchronized(self.privateAllObjects) {
        return [self.privateAllObjects copy];
    }
}

@end
