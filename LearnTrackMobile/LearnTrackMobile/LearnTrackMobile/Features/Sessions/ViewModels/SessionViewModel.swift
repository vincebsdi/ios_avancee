import Foundation
import SwiftUI

@MainActor
class SessionViewModel: ObservableObject {
    @Published var sessions: [SessionModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiService = APIService.shared
    
    func fetchSessions() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedSessions = try await apiService.getSessions()
            self.sessions = fetchedSessions
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func createSession(_ session: SessionCreate) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await apiService.createSession(session)
            await fetchSessions()
            isLoading = false
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    func updateSession(id: Int, _ session: SessionUpdate) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await apiService.updateSession(id: id, session)
            await fetchSessions()
            isLoading = false
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    func deleteSession(id: Int) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            try await apiService.deleteSession(id: id)
            await fetchSessions()
            isLoading = false
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
}
