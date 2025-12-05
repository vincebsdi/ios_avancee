import Foundation
import Supabase
import SwiftUI

@MainActor
class ClientViewModel: ObservableObject {
    @Published var clients: [Client] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let client = SupabaseService.shared.client
    
    func fetchClients() async {
        isLoading = true
        do {
            let response: [Client] = try await client
                .from("clients")
                .select()
                .order("raison_sociale", ascending: true)
                .execute()
                .value
            self.clients = response
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func createClient(_ clientObj: Client) async {
        do {
            try await client.from("clients").insert(clientObj).execute()
            await fetchClients()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
