import Foundation
import Supabase
import SwiftUI

@MainActor
class FormateurViewModel: ObservableObject {
    @Published var formateurs: [Formateur] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let client = SupabaseService.shared.client
    
    func fetchFormateurs() async {
        isLoading = true
        do {
            let response: [Formateur] = try await client
                .from("formateurs")
                .select()
                .order("nom", ascending: true)
                .execute()
                .value
            self.formateurs = response
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func createFormateur(_ formateur: Formateur) async {
        do {
            try await client.from("formateurs").insert(formateur).execute()
            await fetchFormateurs()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // Add update and delete similarly
}
