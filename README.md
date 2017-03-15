SimpleObjectPool
================

Simple implementation of a thread-safe object pool.

[![Version](https://img.shields.io/cocoapods/v/SimpleObjectPool.svg)](http://cocoapods.org/pods/SimpleObjectPool)
[![License](https://img.shields.io/cocoapods/l/SimpleObjectPool.svg?style=flat)](http://cocoapods.org/pods/SimpleObjectPool)
[![Platform](https://img.shields.io/cocoapods/p/SimpleObjectPool.svg?style=flat)](http://cocoapods.org/pods/SimpleObjectPool)
[![Build](https://img.shields.io/travis/paulmelnikow/SimpleObjectPool.svg)](https://travis-ci.org/paulmelnikow/SimpleObjectPool)

![Pool](https://raw.githubusercontent.com/paulmelnikow/SimpleObjectPool/assets/dogs.png)


Usage
-----

When the pool is empty, it naively creates another object using the
createBlock.

```objc
ObjectPool *pool = [ObjectPool poolWithCreateBlock:^id(NSError **outError) {
    NSLog(@"Opening database connection");
    MyDBConnection *connection = [MyDBConnection connection]
    if (![connection openWithError:outError])
	    return nil;
    else
 	    return connection;
}];

MyDBConnection *connection = [pool objectFromPoolWithError:nil];

// do stuff with connection

[pool returnObjectToPool:connection];
```


Installation
------------

Install [via CocoaPods][project].

[project]: https://cocoapods.org/pods/SimpleObjectPool


Contribute
----------

- Issue Tracker: https://github.com/paulmelnikow/SimpleObjectPool/issues
- Source Code: https://github.com/paulmelnikow/SimpleObjectPool

Pull requests welcome!


Support
-------

If you are having issues, please let me know.


Development
-----------

This project includes unit tests. To run them, run `pod install` inside the
`TestProject` folder, then load the workspace and execute the test action.

[httpbin]: https://httpbin.org/


License
-------

This project is licensed under the Apache license.
