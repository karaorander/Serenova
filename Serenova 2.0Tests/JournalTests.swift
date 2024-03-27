import XCTest
import FirebaseFirestore
@testable import Serenova_2_0

class JournalTests: XCTestCase {

    func testAddJournalEntry() async throws {
        
        let journalTitle = "Test Journal Title"
        let journalContent = "Test Journal Content"
        
        // Create an instance of Journal
        let journal = Journal(journalTitle: journalTitle, journalContent: journalContent)
        
        // Call the addJournalEntry function
        try await journal.addJournalEntry()
        
       
        XCTAssertEqual(journal.journalTitle, journalTitle, "Journal title should match the input data")
        XCTAssertEqual(journal.journalContent, journalContent, "Journal content should match the input data")
        
       
    }
    
    func testGetRealTime() throws {
        
        let journal = Journal()
        let timeStamp = Timestamp(date: Date())
        journal.timeStamp = timeStamp
        
        // Call the getRealTime function
        let realTime = journal.getRealTime()
        
        
        XCTAssertFalse(realTime.isEmpty, "Real time should not be empty")
        
    }
    
  /*  func testUpdateValues() throws {
        
        let journal = Journal()
        journal.journalId = "testJournalId"
        
        
        let newValues: [String: Any] = [
            "journalTitle": "Updated Journal Title",
            "journalContent": "Updated Journal Content"
        ]
        
        // Call the updateValues function
        journal.updateValues(newValues: newValues)
       
        
        XCTAssertEqual(journal.journalTitle, "Updated Journal Title", "Journal title should be updated")
        XCTAssertEqual(journal.journalContent, "Updated Journal Content", "Journal content should be updated")
        
        
    }
   */
    
    func testDeleteJournal() throws {
        
        let journal = Journal()
        journal.journalId = "testJournalId"
        
        // Call the deleteJournal function
        journal.deleteJournal()
        
       
        XCTAssertNil(journal.journalId, "Journal ID should be nil after deletion")
        
    }
}
