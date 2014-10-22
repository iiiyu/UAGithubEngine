//
//  UAGithubEngine_Tests.m
//  UAGithubEngine Tests
//
//  Created by Martin Kim Dung-Pham on 22/10/14.
//
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

#import "UAGithubEngine.h"

@interface UAGithubEngine_Tests : XCTestCase
{
    UAGithubEngine *_engineUnderTest;
}
@end

@implementation UAGithubEngine_Tests

static NSString * const kUserName = @"github";

- (void)setUp
{
    [super setUp];
    
    _engineUnderTest = [[UAGithubEngine alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark - Repositories

- (void)testRepositoriesForUser
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetched repositories expectation"];
    
    [_engineUnderTest repositoriesForUser:kUserName includeWatched:NO success:^(id result) {
        [expectation fulfill];
    } failure:^(NSError *error) {
        XCTFail(@"Repositories could not be fetched for user %@ due to error %@", kUserName, error);
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
    }];
}

- (void)testRepositoriesForUserWithItemsPerPage
{
    const int kNumberOfCases = 4;
    
    NSUInteger expectedItemsCounts[kNumberOfCases] = {1, 2, 3, 4};
    
    for (int i = 0; i < kNumberOfCases; i++) {
        
        XCTestExpectation *expectation = [self expectationWithDescription:@"Fetched repositories expectation"];

        int expectedItemsCount = (int)expectedItemsCounts[i];
        __block NSUInteger fetchedItemsCount = 0;
        
        [_engineUnderTest repositoriesForUser:kUserName includeWatched:NO page:1 itemsPerPage:expectedItemsCount success:^(id result) {
        
            fetchedItemsCount = [result count];
            
            [expectation fulfill];
            
        } failure:^(NSError *error) {
            
            XCTFail(@"Repositories could not be fetched for user %@ due to error %@", kUserName, [error domain]);
            
        }];
        
        XCTAssertEqual(fetchedItemsCount, expectedItemsCount);
        
        [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        }];
    }
}

@end