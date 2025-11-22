import XCTest
@testable import SportsIQ

final class UserDTOTests: XCTestCase {
    
    func testUserDTOToDomain() throws {
        let id = UUID()
        let dateString = "2023-01-01T12:00:00Z"
        
        let dto = UserDTO(
            id: id.uuidString,
            clerk_user_id: "ext_123",
            email: "test@example.com",
            role: "user",
            status: "active",
            created_at: dateString,
            updated_at: dateString
        )
        
        let profileDTO = UserProfileDTO(
            user_id: id.uuidString,
            display_name: "Test User",
            username: "testuser",
            avatar_url: "https://example.com/avatar.jpg",
            bio: "Hello",
            country: "US",
            timezone: "UTC",
            birth_year: 1990,
            favorite_team_id: nil,
            notification_preferences: [:],
            privacy_settings: [:],
            created_at: dateString,
            updated_at: dateString
        )
        
        let user = try dto.toDomain(profile: profileDTO)
        
        XCTAssertEqual(user.id, id)
        XCTAssertEqual(user.externalId, "ext_123")
        XCTAssertEqual(user.username, "testuser")
        XCTAssertEqual(user.email, "test@example.com")
        XCTAssertEqual(user.displayName, "Test User")
        XCTAssertEqual(user.avatarURL, "https://example.com/avatar.jpg")
    }
    
    func testUserDTOToDomainWithoutProfile() throws {
        let id = UUID()
        let dateString = "2023-01-01T12:00:00Z"
        
        let dto = UserDTO(
            id: id.uuidString,
            clerk_user_id: "ext_123",
            email: "test@example.com",
            role: "user",
            status: "active",
            created_at: dateString,
            updated_at: dateString
        )
        
        let user = try dto.toDomain(profile: nil)
        
        XCTAssertEqual(user.id, id)
        XCTAssertEqual(user.externalId, "ext_123")
        XCTAssertEqual(user.username, "test") // Derived from email
        XCTAssertEqual(user.email, "test@example.com")
        XCTAssertNil(user.displayName)
    }
}
