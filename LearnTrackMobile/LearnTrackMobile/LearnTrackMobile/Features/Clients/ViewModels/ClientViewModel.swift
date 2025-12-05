import Foundation
import SwiftUI

@MainActor
class ClientViewModel: ObservableObject {
    @Published var clients: [ClientModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiService = APIService.shared
    
    func fetchClients() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedClients = try await apiService.getClients()
            self.clients = fetchedClients
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func createClient(_ client: ClientCreate) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await apiService.createClient(client)
            await fetchClients()
            isLoading = false
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    func updateClient(id: Int, _ client: ClientUpdate) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await apiService.updateClient(id: id, client)
            await fetchClients()
            isLoading = false
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    func deleteClient(id: Int) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            try await apiService.deleteClient(id: id)
            await fetchClients()
            isLoading = false
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    func getClientSessions(clientId: Int) async -> [SessionModel] {
        do {
            return try await apiService.getClientSessions(clientId: clientId)
        } catch {
            self.errorMessage = error.localizedDescription
            return []
        }
    }
}
