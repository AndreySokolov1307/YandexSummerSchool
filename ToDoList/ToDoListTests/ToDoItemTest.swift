import XCTest
@testable import ToDoList

fileprivate enum MockConstants {
    static let dateString = "2024-06-15T23:10:23Z"
    static let date = try! Date(dateString, strategy: .iso8601)
    static let id = "12345"
    static let id2 = "55555"
    static let text = "Hello, world!"
    static let text2 = "Yandex"
    static let text3 = "Google"
    static let isDone = false
    static let importanceRegular = ToDoItem.Importance.regular
    static let importanceLow = ToDoItem.Importance.low
    static let deadline: Date? = nil
    static let invalidCSVRow: [String?] = ["123",nil,"low","2024-06-16T19:31:56+02:00","true","2024-06-16T19:31:56+02:00", nil]
    static let validCSVRow: [String?] = ["123","Hello, world!","low","2024-06-16T19:31:56+02:00","true","2024-06-16T19:31:56+02:00", nil]
    static let csv = """
    id,text,importance,deadline,isDone,creationDate,modificationDate
    \(id),\"\(text)\",\(importanceLow.title),,\(isDone),\(dateString),
    \(id2),\(text2),\(importanceRegular.title),,\(isDone),\(dateString),\(dateString)
    ,\(text3),\(importanceRegular.title),,\(isDone),
    """
}

final class ToDoItemTest: XCTestCase {
    
    var dictionary: [String : Any] = [
        Constants.JsonKeys.id : MockConstants.id,
        Constants.JsonKeys.text : MockConstants.text,
        Constants.JsonKeys.isDone : MockConstants.isDone,
        Constants.JsonKeys.creationDate: MockConstants.dateString,
        Constants.JsonKeys.modificationDate : MockConstants.dateString]
    
    func testToDoItemInitValid() {
        // Given
        let sut = ToDoItem(text: MockConstants.text,
                           importance: MockConstants.importanceRegular,
                           isDone: MockConstants.isDone,
                           creationDate: MockConstants.date)
        // When
        
        // Then
        XCTAssertNil(sut.deadline)
        XCTAssertNil(sut.modificationDate)
    }
    
    func testToDoItemRowInitValid() {
        // Given
        let validRow = MockConstants.validCSVRow
        
        // When
        let sut = ToDoItem(row: validRow)
        
        // Then
        XCTAssertNotNil(sut)
    }
    
    func testToDoItemRowInitInvalid() {
        // Given
        let invalidRow = MockConstants.invalidCSVRow
        
        // When
        let sut = ToDoItem(row: invalidRow)
        
        // Then
        XCTAssertNil(sut)
    }
    
    func testInvalidJSON() {
        // Given
        
        
        // When
        dictionary[Constants.JsonKeys.text] = MockConstants.date
        let invalidDeadline = MockConstants.deadline as Any
        
        // Then
        XCTAssertNil(ToDoItem.parse(json: dictionary))
        XCTAssertNil(ToDoItem.parse(json: invalidDeadline))
    }
    
    func testJSONWithLowImportance() throws {
        // Given
        let sut = ToDoItem(id: MockConstants.id,
                       text: MockConstants.text,
                       importance: MockConstants.importanceLow,
                       deadline: MockConstants.deadline,
                       isDone: MockConstants.isDone,
                       creationDate: MockConstants.date,
                       modificationDate: MockConstants.date)
        // When
        let json = sut.json as! [String : Any]
        dictionary[Constants.JsonKeys.importance] = MockConstants.importanceLow.title
        
        // Then
        XCTAssert(NSDictionary(dictionary: dictionary).isEqual(to: json))
    }
    
    func testJSONWithRegularImportance() throws {
        // Given
        let sut = ToDoItem(id: MockConstants.id,
                       text: MockConstants.text,
                       importance: MockConstants.importanceRegular,
                       deadline: MockConstants.deadline,
                       isDone: MockConstants.isDone,
                       creationDate: MockConstants.date,
                       modificationDate: MockConstants.date)
        // When
        let json = sut.json as! [String : Any]
        
        // Then
        XCTAssert(NSDictionary(dictionary: dictionary).isEqual(to: json))
    }
    
    func testJSONParseWithRegularImportance() throws {
        // Given
        let sut = ToDoItem(id: MockConstants.id,
                       text: MockConstants.text,
                       importance: MockConstants.importanceRegular,
                       deadline: MockConstants.deadline,
                       isDone: MockConstants.isDone,
                       creationDate: MockConstants.date,
                       modificationDate: MockConstants.date)
        // When
        let json = sut.json as! [String : Any]
        
        // Then
        XCTAssertEqual(sut, ToDoItem.parse(json: json))
    }
    
    func testJSONParseWithLowImportance() throws {
        // Given
        let sut = ToDoItem(id: MockConstants.id,
                       text: MockConstants.text,
                       importance: MockConstants.importanceLow,
                       deadline: MockConstants.deadline,
                       isDone: MockConstants.isDone,
                       creationDate: MockConstants.date,
                       modificationDate: MockConstants.date)
        // When
        let json = sut.json as! [String : Any]
        dictionary[Constants.JsonKeys.importance] = MockConstants.importanceLow.title
        
        // Then
        XCTAssertEqual(sut, ToDoItem.parse(json: json))
    }
    
    func testCSVParse() throws {
        // Given
        let sut = MockConstants.csv
        
        let item1 = ToDoItem(id: MockConstants.id,
                             text: MockConstants.text,
                             importance: MockConstants.importanceLow,
                             deadline: MockConstants.deadline,
                             isDone: MockConstants.isDone,
                             creationDate: MockConstants.date,
                             modificationDate: nil)
        
        let item2 = ToDoItem(id: MockConstants.id2,
                             text: MockConstants.text2,
                             importance: MockConstants.importanceRegular,
                             deadline: MockConstants.deadline,
                             isDone: MockConstants.isDone,
                             creationDate: MockConstants.date,
                             modificationDate: MockConstants.date)
        // When
        let items = [item1, item2, nil]
        
        // Then
        XCTAssertEqual(items, ToDoItem.parse(csv: sut))
    }
}
