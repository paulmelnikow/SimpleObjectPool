#import <Foundation/Foundation.h>

typedef id (^CreateObjectBlock)(NSError ** outError);

/**
 Simple, thread-safe object pool. The pool re-uses existing objects when
 one is available, and creates new ones when one is not.

 It keeps references to all the objects it creates.
 */
@interface ObjectPool : NSObject

/**
 Create a new pool.

 Example:

    ObjectPool *pool = [ObjectPool poolWithCreateBlock:^id(NSError **outError) {
        NSLog(@"Opening database connection");
        MyDBConnection *connection = [MyDBConnection connection]
        if (![connection openWithError:outError])
          return nil;
        else
          return connection;
    }];

 @param createBlock A block used to create the object. This block returns
   the new object, and takes one argument: a pointer to an error object
   which can be filled if an error occurs while creating the new
   object.

 @return The newly initialized pool
 */
+ (instancetype) poolWithCreateBlock:(CreateObjectBlock) createBlock;

/**
 Obtain an object from the pool. If the pool is empty, one is created
 using the createBlock.

 @param outError The address at which a pointer to an error object is
    placed when an error occurs creating a new object.

 @return The new or recycled object, or nil if an error occurred
 */
- (id) objectFromPoolWithError:(NSError **) outError;

/**
 Return an object to the pool, making it available for re-use.

 @param object The object to return to the pool
 */
- (void) returnObjectToPool:(id) object;

/**
 All objects created by the pool, including those which are in use.
 */
@property (retain, readonly) NSArray *allObjects;

@end
