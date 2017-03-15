@import Specta;
@import Expecta;
#import "ObjectPool.h"

// Surprisingly, this was difficult to accomplish with OCMock or OCMockito.
// OCMock doesn't support verifying call count, and OCMockito doesn't support
// forwarding to the real object. So, doing without mocks. If you know how
// to do this cleanly, please open an issue or PR.

@interface Factory : NSObject
@property (assign) BOOL shouldError;
@property (assign) NSUInteger callCount;
@end
@implementation Factory
- (id) createObjectWithError:(NSError **) outError {
    self.callCount += 1;
    
    if (self.shouldError) {
        *outError = [NSError errorWithDomain:@"ErrorDomain" code:-1 userInfo:nil];
        return nil;
    } else {
        return [[NSObject alloc] init];
    }
}
@end

SpecBegin(SimpleObjectPool)

describe(@"SimpleObjectPool", ^{
    
    __block Factory *factory;
    __block ObjectPool *pool;
    beforeEach(^{
        factory = [[Factory alloc] init];
        pool = [ObjectPool poolWithCreateBlock:^id(NSError **outError) {
            return [factory createObjectWithError:outError];
        }];
    });
    
    it(@"Creates the first object lazily", ^{
        expect(factory.callCount).to.equal(0);
        [pool objectFromPoolWithError:nil];
        expect(factory.callCount).to.equal(1);
    });

    it(@"Creates new objects when needed", ^{
        [pool objectFromPoolWithError:nil];
        [pool objectFromPoolWithError:nil];
        [pool objectFromPoolWithError:nil];
        
        expect(factory.callCount).to.equal(3);
    });
    
    it(@"Returns the created object", ^{
        id obj = [pool objectFromPoolWithError:nil];
        expect(obj).to.beInstanceOf([NSObject class]);
    });
    
    it(@"Reuses object when they are available", ^{
        [pool objectFromPoolWithError:nil];
        id second = [pool objectFromPoolWithError:nil];
        [pool objectFromPoolWithError:nil];
        [pool returnObjectToPool:second];
        id fourth = [pool objectFromPoolWithError:nil];
        [pool returnObjectToPool:fourth];
        id fifth = [pool objectFromPoolWithError:nil];

        expect(fourth).to.beIdenticalTo(second);
        expect(fifth).to.beIdenticalTo(second);
        
        expect(factory.callCount).to.equal(3);
    });
    
    it(@"Does not set error on success", ^{
        NSError *error = nil;
        [pool objectFromPoolWithError:&error];
        expect(error).to.beFalsy();
    });

    it(@"Sets error and returns nil on failure", ^{
        NSError *error = nil;
        factory.shouldError = YES;
        id obj = [pool objectFromPoolWithError:&error];
        expect(error).to.beInstanceOf([NSError class]);
        expect(obj).to.beFalsy();
    });
    
});

SpecEnd
