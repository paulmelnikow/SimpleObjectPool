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
        self.privateAllObjects = [NSMutableArray array];
        self.createBlock = createBlock;
    }
    return self;
}

+ (instancetype) poolWithCreateBlock:(CreateObjectBlock) createBlock {
    ObjectPool *result = [[self alloc] initWithCreateBlock:createBlock];
#if __has_feature(objc_arc)
    return result;
#else
    return [result autorelease];
#endif
}

#if !__has_feature(objc_arc)
- (void) dealloc {
    [self.createBlock release];
    [self.pool release];
    [self.privateAllObjects release];
    [super dealloc];
}
#endif

- (id) objectFromPoolWithError:(NSError **) outError {
    id result = nil;
    @synchronized(self.pool) {
        result = [self.pool lastObject];
        [self.pool removeLastObject];
    }

    if (result == nil) {
        result = self.createBlock(outError);
        if (result != nil)
            @synchronized(self.privateAllObjects) {
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
