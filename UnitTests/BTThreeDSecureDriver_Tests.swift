import XCTest

class BTThreeDSecureDriver_Tests: XCTestCase {
    
    let originalNonce_lookupEnrolledAuthenticationNotRequired = "some-credit-card-nonce-where-3ds-succeeds-without-user-authentication"
    let originalNonce_lookupEnrolledAuthenticationRequired = "some-credit-card-nonce-where-3ds-succeeds-after-user-authentication"
    let originalNonce_lookupCardNotEnrolled = "some-credit-card-nonce-where-card-is-not-enrolled-for-3ds"
    let originalNonce_lookupFails = "some-credit-card-nonce-where-3ds-fails"
    let viewControllerPresentingDelegate = MockViewControllerPresentationDelegate()
    var mockAPIClient : MockAPIClient = MockAPIClient(authorization: "development_client_key")!
    var observers : [NSObjectProtocol] = []
    let ValidClientToken = "eyJ2ZXJzaW9uIjoyLCJhdXRob3JpemF0aW9uRmluZ2VycHJpbnQiOiI3ODJhZmFlNDJlZTNiNTA4NWUxNmMzYjhkZTY3OGQxNTJhODFlYzk5MTBmZDNhY2YyYWU4MzA2OGI4NzE4YWZhfGNyZWF0ZWRfYXQ9MjAxNS0wOC0yMFQwMjoxMTo1Ni4yMTY1NDEwNjErMDAwMFx1MDAyNmN1c3RvbWVyX2lkPTM3OTU5QTE5LThCMjktNDVBNC1CNTA3LTRFQUNBM0VBOEM4Nlx1MDAyNm1lcmNoYW50X2lkPWRjcHNweTJicndkanIzcW5cdTAwMjZwdWJsaWNfa2V5PTl3d3J6cWszdnIzdDRuYzgiLCJjb25maWdVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvZGNwc3B5MmJyd2RqcjNxbi9jbGllbnRfYXBpL3YxL2NvbmZpZ3VyYXRpb24iLCJjaGFsbGVuZ2VzIjpbXSwiZW52aXJvbm1lbnQiOiJzYW5kYm94IiwiY2xpZW50QXBpVXJsIjoiaHR0cHM6Ly9hcGkuc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbTo0NDMvbWVyY2hhbnRzL2RjcHNweTJicndkanIzcW4vY2xpZW50X2FwaSIsImFzc2V0c1VybCI6Imh0dHBzOi8vYXNzZXRzLmJyYWludHJlZWdhdGV3YXkuY29tIiwiYXV0aFVybCI6Imh0dHBzOi8vYXV0aC52ZW5tby5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIiwiYW5hbHl0aWNzIjp7InVybCI6Imh0dHBzOi8vY2xpZW50LWFuYWx5dGljcy5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIn0sInRocmVlRFNlY3VyZUVuYWJsZWQiOnRydWUsInRocmVlRFNlY3VyZSI6eyJsb29rdXBVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvZGNwc3B5MmJyd2RqcjNxbi90aHJlZV9kX3NlY3VyZS9sb29rdXAifSwicGF5cGFsRW5hYmxlZCI6dHJ1ZSwicGF5cGFsIjp7ImRpc3BsYXlOYW1lIjoiQWNtZSBXaWRnZXRzLCBMdGQuIChTYW5kYm94KSIsImNsaWVudElkIjpudWxsLCJwcml2YWN5VXJsIjoiaHR0cDovL2V4YW1wbGUuY29tL3BwIiwidXNlckFncmVlbWVudFVybCI6Imh0dHA6Ly9leGFtcGxlLmNvbS90b3MiLCJiYXNlVXJsIjoiaHR0cHM6Ly9hc3NldHMuYnJhaW50cmVlZ2F0ZXdheS5jb20iLCJhc3NldHNVcmwiOiJodHRwczovL2NoZWNrb3V0LnBheXBhbC5jb20iLCJkaXJlY3RCYXNlVXJsIjpudWxsLCJhbGxvd0h0dHAiOnRydWUsImVudmlyb25tZW50Tm9OZXR3b3JrIjp0cnVlLCJlbnZpcm9ubWVudCI6Im9mZmxpbmUiLCJ1bnZldHRlZE1lcmNoYW50IjpmYWxzZSwiYnJhaW50cmVlQ2xpZW50SWQiOiJtYXN0ZXJjbGllbnQzIiwiYmlsbGluZ0FncmVlbWVudHNFbmFibGVkIjpmYWxzZSwibWVyY2hhbnRBY2NvdW50SWQiOiJzdGNoMm5mZGZ3c3p5dHc1IiwiY3VycmVuY3lJc29Db2RlIjoiVVNEIn0sImNvaW5iYXNlRW5hYmxlZCI6dHJ1ZSwiY29pbmJhc2UiOnsiY2xpZW50SWQiOiIxMWQyNzIyOWJhNThiNTZkN2UzYzAxYTA1MjdmNGQ1YjQ0NmQ0ZjY4NDgxN2NiNjIzZDI1NWI1NzNhZGRjNTliIiwibWVyY2hhbnRBY2NvdW50IjoiY29pbmJhc2UtZGV2ZWxvcG1lbnQtbWVyY2hhbnRAZ2V0YnJhaW50cmVlLmNvbSIsInNjb3BlcyI6ImF1dGhvcml6YXRpb25zOmJyYWludHJlZSB1c2VyIiwicmVkaXJlY3RVcmwiOiJodHRwczovL2Fzc2V0cy5icmFpbnRyZWVnYXRld2F5LmNvbS9jb2luYmFzZS9vYXV0aC9yZWRpcmVjdC1sYW5kaW5nLmh0bWwiLCJlbnZpcm9ubWVudCI6Im1vY2sifSwibWVyY2hhbnRJZCI6ImRjcHNweTJicndkanIzcW4iLCJ2ZW5tbyI6Im9mZmxpbmUiLCJhcHBsZVBheSI6eyJzdGF0dXMiOiJtb2NrIiwiY291bnRyeUNvZGUiOiJVUyIsImN1cnJlbmN5Q29kZSI6IlVTRCIsIm1lcmNoYW50SWRlbnRpZmllciI6Im1lcmNoYW50LmNvbS5icmFpbnRyZWVwYXltZW50cy5zYW5kYm94LkJyYWludHJlZS1EZW1vIiwic3VwcG9ydGVkTmV0d29ya3MiOlsidmlzYSIsIm1hc3RlcmNhcmQiLCJhbWV4Il19fQ=="
    
    override func setUp() {
        super.setUp()
        
        mockAPIClient = MockAPIClient(authorization: "development_client_key")!
        
        
    }
    
    override func tearDown() {
        for observer in observers { NSNotificationCenter.defaultCenter().removeObserver(observer) }
        super.tearDown()
    }
    
    func testInitialization_initializesWithClientAndDelegate() {
        let threeDSecureDriver = BTThreeDSecureDriver.init(APIClient: mockAPIClient, delegate:viewControllerPresentingDelegate )
        XCTAssertNotNil(threeDSecureDriver)
    }
    
    func testVerification_whenAPIClientIsNil_callsBackWithError() {
        let threeDSecureDriver = BTThreeDSecureDriver.init(APIClient: mockAPIClient, delegate:viewControllerPresentingDelegate )
        threeDSecureDriver.apiClient = nil
        
        let expectation = expectationWithDescription("verification fails with errors")

        threeDSecureDriver.verifyCardWithNonce(originalNonce_lookupEnrolledAuthenticationNotRequired, amount: NSDecimalNumber.one(), completion: { (tokenizedCard, error) -> Void in
            XCTAssertNil(tokenizedCard)
            XCTAssertNotNil(error)
            XCTAssertEqual(error!.domain, BTThreeDSecureErrorDomain)
            XCTAssertEqual(error!.code, BTThreeDSecureErrorType.Integration.rawValue)
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(2, handler: nil)
    }
    
    func testVerification_whenRemoteConfigurationFetchFails_callsBackWithConfigurationError() {
        mockAPIClient.cannedConfigurationResponseError = NSError(domain: "", code: 0, userInfo: nil)
        let threeDSecureDriver = BTThreeDSecureDriver.init(APIClient: mockAPIClient, delegate:viewControllerPresentingDelegate )
        mockAPIClient = threeDSecureDriver.apiClient as! MockAPIClient
        
        let expectation = expectationWithDescription("verification fails with errors")
        
        threeDSecureDriver.verifyCardWithNonce(originalNonce_lookupEnrolledAuthenticationNotRequired, amount: NSDecimalNumber.one(), completion: { (tokenizedCard, error) -> Void in
            XCTAssertEqual(error!, self.mockAPIClient.cannedConfigurationResponseError!)
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(2, handler: nil)
    }
    
    func testVerification_callsCompletion() {
        let threeDSecureDriver = BTThreeDSecureDriver.init(APIClient: mockAPIClient, delegate:viewControllerPresentingDelegate )
        
        let expectation = expectationWithDescription("willCallCompletion")
        
        threeDSecureDriver.verifyCardWithNonce(originalNonce_lookupEnrolledAuthenticationNotRequired, amount: NSDecimalNumber.one(), completion: { (tokenizedCard, error) -> Void in
            XCTAssertNotNil(tokenizedCard)
            XCTAssertNil(error)
            XCTAssertFalse(tokenizedCard!.liabilityShifted)
            XCTAssertFalse(tokenizedCard!.liabilityShiftPossible)
            expectation.fulfill()
        })

        waitForExpectationsWithTimeout(3, handler: nil)
    }
    
}

