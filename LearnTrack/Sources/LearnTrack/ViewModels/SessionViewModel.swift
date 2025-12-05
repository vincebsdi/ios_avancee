import Foundation
import Supabase
import SwiftUI

@MainActor
class SessionViewModel: ObservableObject {
    @Published var sessions: [Session] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let client = SupabaseService.shared.client
    
    func fetchSessions() async {
        isLoading = true
        errorMessage = nil
        do {
            let response: [Session] = try await client
                .from("sessions")
                .select()
                .order("date", ascending: false)
                .execute()
                .value
            
            self.sessions = response
        } catch {
            errorMessage = error.localizedDescription
            print("Error fetching sessions: \(error)")
        }
        isLoading = false
    }
    
    func createSession(_ session: Session) async {
        isLoading = true
        do {
            try await client
                .from("sessions")
                .insert(session)
                .execute()
            await fetchSessions()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func updateSession(_ session: Session) async {
        guard let id = session.id else { return }
        isLoading = true
        do {
            try await client
                .from("sessions")
                .update(session)
                .eq("id", value: id)
                .execute()
            await fetchSessions()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func deleteSession(id: UUID) async {
        isLoading = true
        do {
            try await client
                .from("sessions")
                .delete()
                .eq("id", value: id)
                .execute()
            await fetchSessions()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
