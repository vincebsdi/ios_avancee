import Foundation
import SwiftUI

@MainActor
class FormateurViewModel: ObservableObject {
    @Published var formateurs: [FormateurModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiService = APIService.shared
    
    func fetchFormateurs() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedFormateurs = try await apiService.getFormateurs()
            self.formateurs = fetchedFormateurs
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func createFormateur(_ formateur: FormateurCreate) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await apiService.createFormateur(formateur)
            await fetchFormateurs()
            isLoading = false
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    func updateFormateur(id: Int, _ formateur: FormateurUpdate) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await apiService.updateFormateur(id: id, formateur)
            await fetchFormateurs()
            isLoading = false
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    func deleteFormateur(id: Int) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            try await apiService.deleteFormateur(id: id)
            await fetchFormateurs()
            isLoading = false
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    func getFormateurSessions(formateurId: Int) async -> [SessionModel] {
        do {
            return try await apiService.getFormateurSessions(formateurId: formateurId)
        } catch {
            self.errorMessage = error.localizedDescription
            return []
        }
    }
}
