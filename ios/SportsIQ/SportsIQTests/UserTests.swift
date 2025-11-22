import XCTest
@testable import SportsIQ

final class UserTests: XCTestCase {
    
    func testUserInitialization() {
        let id = UUID()
        let now = Date()
        let user = User(
            id: id,
            externalId: "ext_123",
            username: "testuser",
            email: "test@example.com",
            displayName: "Test User",
            avatarURL: "https://example.com/avatar.jpg",
            createdAt: now,
            lastActiveAt: now
        )
        
        XCTAssertEqual(user.id, id)
        XCTAssertEqual(user.externalId, "ext_123")
        XCTAssertEqual(user.username, "testuser")
        XCTAssertEqual(user.email, "test@example.com")
        XCTAssertEqual(user.displayName, "Test User")
        XCTAssertEqual(user.avatarURL, "https://example.com/avatar.jpg")
        XCTAssertEqual(user.createdAt, now)
        XCTAssertEqual(user.lastActiveAt, now)
    }
    
    func testUserMock() {
        let mock = User.mock
        XCTAssertFalse(mock.username.isEmpty)
        XCTAssertFalse(mock.email.isEmpty)
        XCTAssertFalse(mock.externalId.isEmpty)
    }
}
