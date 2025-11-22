import XCTest
@testable import SportsIQ

final class LessonTests: XCTestCase {
    
    func testLessonInitialization() {
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
        
        XCTAssertEqual(lesson.id, id)
        XCTAssertEqual(lesson.moduleId, moduleId)
        XCTAssertEqual(lesson.title, "Test Lesson")
        XCTAssertEqual(lesson.description, "Description")
        XCTAssertEqual(lesson.orderIndex, 1)
        XCTAssertEqual(lesson.estimatedMinutes, 5)
        XCTAssertEqual(lesson.xpAward, 50)
        XCTAssertFalse(lesson.isLocked)
        XCTAssertTrue(lesson.items.isEmpty)
    }
    
    func testMockLessons() {
        let lessons = Lesson.mockLessons
        XCTAssertFalse(lessons.isEmpty)
        
        let first = lessons.first!
        XCTAssertEqual(first.title, "The Field & Players")
        XCTAssertFalse(first.items.isEmpty)
    }
}
