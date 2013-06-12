ObjectPool
==========

Simple implementation of a thread-safe object pool. When the pool is empty, it
naively creates another object using the createBlock.

To use:

``` objc
ObjectPool *pool = [ObjectPool poolWithCreateBlock:^id(NSError **outError) {
DDLogInfo(@"Opening database connection");
MyDBConnection *connection = [MyDBConnection connection]
if (![connection openWithError:outError])
	return nil;
else
 	return connection;
}];

MyDBConnection *connection = [pool objectFromPoolWithError:nil];
 
// do stuff with connection

pool returnObjectToPool:connection];
```