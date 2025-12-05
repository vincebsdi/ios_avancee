import Foundation
import Supabase

class SupabaseService {
    static let shared = SupabaseService()
    
    let client: SupabaseClient
    
    private init() {
        // TODO: Replace with your actual Supabase URL and Anon Key
        let supabaseURL = URL(string: "https://epsksludoqhtpxjwrdmk.supabase.co")!
        let supabaseKey = "sb_publishable_EGI8p-vAtwRsEkk6ajwhAA_odtrHX6S"
        
        self.client = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseKey
        )
    }
}
