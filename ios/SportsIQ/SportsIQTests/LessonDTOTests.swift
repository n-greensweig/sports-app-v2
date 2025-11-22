import XCTest
@testable import SportsIQ

final class LessonDTOTests: XCTestCase {
    
    func testLessonDTOToDomain() throws {
        let id = UUID()
        let moduleId = UUID()
        let dto = LessonDTO(
            id: id.uuidString,
            module_id: moduleId.uuidString,
            title: "Test Lesson",
            description: "Description",
            order_index: 1,
            est_minutes: 5,
            xp_award: 50,
            prerequisite_lesson_id: nil,
            is_locked: false,
            created_at: "2023-01-01T00:00:00Z",
            updated_at: "2023-01-01T00:00:00Z",
            deleted_at: nil
        )
        
        let lesson = try dto.toDomain()
        
        XCTAssertEqual(lesson.id, id)
        XCTAssertEqual(lesson.moduleId, moduleId)
        XCTAssertEqual(lesson.title, "Test Lesson")
        XCTAssertEqual(lesson.description, "Description")
        XCTAssertEqual(lesson.orderIndex, 1)
        XCTAssertEqual(lesson.estimatedMinutes, 5)
        XCTAssertEqual(lesson.xpAward, 50)
        XCTAssertFalse(lesson.isLocked)
    }
    
    func testLessonToDTO() {
        let id = UUID()
        let moduleId = UUID()
        let lesson = Lesson(
            id: id,
            moduleId: moduleId,
            title: "Test Lesson",
            description: "Description",
            orderIndex: 1,
            estimatedMinutes: 5,
            xpAward: 50
        )
        
        let dto = lesson.toDTO()
        
        XCTAssertEqual(dto.id, id.uuidString)
        XCTAssertEqual(dto.module_id, moduleId.uuidString)
        XCTAssertEqual(dto.title, "Test Lesson")
        XCTAssertEqual(dto.description, "Description")
        XCTAssertEqual(dto.order_index, 1)
    }
}
