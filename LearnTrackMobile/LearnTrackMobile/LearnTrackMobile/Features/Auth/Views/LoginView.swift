import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showRegister = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                Spacer()
                
                // Logo
                Image(systemName: "graduationcap.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                
                Text("LearnTrack")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer().frame(height: 20)
                
                // Form
                VStack(spacing: 15) {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                    
                    SecureField("Mot de passe", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    if let errorMessage = authViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                    }
                    
                    Button(action: {
                        Task {
                            await authViewModel.login(email: email, password: password)
                        }
                    }) {
                        if authViewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            Text("Se connecter")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .disabled(email.isEmpty || password.isEmpty || authViewModel.isLoading)
                    
                    Button("Créer un compte") {
                        showRegister = true
                    }
                    .foregroundColor(.blue)
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
            .navigationTitle("Connexion")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showRegister) {
                RegisterView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
