//
//  UAGithubEngineRepositoryMethod_Tests.m
//  UAGithubEngineRepositoryMethod Tests
//
//  Created by Martin Kim Dung-Pham on 22/10/14.
//
//
//  These are the tests for the repository methods of the GithubEngine.
//
//  It may happen that the rate limit is reached (https://developer.github.com/v3/#rate-limiting).
//  In this case please initialise the engine under test in the setUp
//  method of the tests with username and password. This will get you
//  a higher rate limit.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

#import "UAGithubEngine.h"

@interface UAGithubEngineRepositoryMethod_Tests : XCTestCase
{
    UAGithubEngine *_engineUnderTest;
}
@end

@implementation UAGithubEngineRepositoryMethod_Tests

// Don't commit these!
static NSString * const kGitHubUserName = @"";
static NSString * const kGitHubPassword = @"";

static NSString * const kRepositoryUserName = @"github";
static CGFloat const kExpectationWaitTimeOut = 5;

- (void)setUp
{
    [super setUp];

    if (0 < [kGitHubUserName length] && 0 < [kGitHubPassword length])
    {
        _engineUnderTest = [[UAGithubEngine alloc] initWithUsername:kGitHubUserName password:kGitHubPassword withReachability:NO];
    }
    else
    {
        _engineUnderTest = [[UAGithubEngine alloc] init];
    }
    
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark - Tests for Repository methods

- (void)testRepositoriesForUser
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetched repositories expectation"];
    
    [_engineUnderTest repositoriesForUser:kRepositoryUserName includeWatched:NO success:^(id result) {
        
        [expectation fulfill];
        
    } failure:^(NSError *error) {
        
        [expectation fulfill];
        
        XCTFail(@"Error:%@", [error domain]);
    }];
    
    [self waitForExpectationsWithTimeout:kExpectationWaitTimeOut handler:nil];
}

- (void)testRepositoriesForUserWithItemsPerPage
{
    const int kNumberOfCases = 4;
    
    NSUInteger expectedItemsCounts[kNumberOfCases] = {1, 2, 3, 4};
    
    for (int i = 0; i < kNumberOfCases; i++) {
        
        XCTestExpectation *expectation = [self expectationWithDescription:@"Fetched repositories expectation"];

        int expectedItemsCount = (int)expectedItemsCounts[i];
        __block NSUInteger fetchedItemsCount = 0;
        
        [_engineUnderTest repositoriesForUser:kRepositoryUserName includeWatched:NO page:1 itemsPerPage:expectedItemsCount success:^(id result) {
        
            fetchedItemsCount = [result count];
            
            [expectation fulfill];
            
        } failure:^(NSError *error) {
            
            XCTFail(@"Repositories could not be fetched for user %@ due to error %@", kRepositoryUserName, [error domain]);
            
        }];
        
        XCTAssertEqual(fetchedItemsCount, expectedItemsCount);
        
        [self waitForExpectationsWithTimeout:kExpectationWaitTimeOut handler:^(NSError *error) {
        }];
    }
}

@end