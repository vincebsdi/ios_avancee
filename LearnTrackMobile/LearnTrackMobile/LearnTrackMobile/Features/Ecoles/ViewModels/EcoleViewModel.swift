import Foundation
import SwiftUI

@MainActor
class EcoleViewModel: ObservableObject {
    @Published var ecoles: [EcoleModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiService = APIService.shared
    
    func fetchEcoles() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedEcoles = try await apiService.getEcoles()
            self.ecoles = fetchedEcoles
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func createEcole(_ ecole: EcoleCreate) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await apiService.createEcole(ecole)
            await fetchEcoles()
            isLoading = false
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    func updateEcole(id: Int, _ ecole: EcoleUpdate) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await apiService.updateEcole(id: id, ecole)
            await fetchEcoles()
            isLoading = false
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    func deleteEcole(id: Int) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            try await apiService.deleteEcole(id: id)
            await fetchEcoles()
            isLoading = false
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    func getEcoleSessions(ecoleId: Int) async -> [SessionModel] {
        do {
            return try await apiService.getEcoleSessions(ecoleId: ecoleId)
        } catch {
            self.errorMessage = error.localizedDescription
            return []
        }
    }
}
