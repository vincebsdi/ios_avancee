import SwiftUI

struct EcoleDetailView: View {
    let ecole: EcoleModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(spacing: 15) {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.purple.opacity(0.2))
                        .frame(width: 100, height: 100)
                        .overlay(
                            Text(ecole.initials)
                                .font(.largeTitle)
                                .foregroundColor(.purple)
                        )
                    
                    Text(ecole.nom)
                        .font(.title2)
                        .bold()
                    
                    if let capacite = ecole.capacite {
                        Text("\(capacite) places")
                            .font(.subheadline)
                            .foregroundColor(.purple)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                
                Divider()
                
                // Quick actions
                HStack(spacing: 20) {
                    if let telephone = ecole.telephone {
                        Button(action: { callPhone(telephone) }) {
                            VStack {
                                Image(systemName: "phone.fill")
                                    .font(.title2)
                                Text("Appeler")
                                    .font(.caption)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .foregroundColor(.green)
                            .cornerRadius(10)
                        }
                    }
                    
                    if let email = ecole.email {
                        Button(action: { sendEmail(email) }) {
                            VStack {
                                Image(systemName: "envelope.fill")
                                    .font(.title2)
                                Text("Email")
                                    .font(.caption)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                // Info
                VStack(alignment: .leading, spacing: 15) {
                    Text("Informations")
                        .font(.headline)
                    
                    if let email = ecole.email {
                        InfoRow(icon: "envelope", title: "Email", value: email)
                    }
                    
                    if let telephone = ecole.telephone {
                        InfoRow(icon: "phone", title: "Téléphone", value: telephone)
                    }
                    
                    if let adresse = ecole.adresse {
                        InfoRow(icon: "mappin", title: "Adresse", value: adresse)
                    }
                    
                    if let ville = ecole.ville {
                        InfoRow(icon: "location", title: "Ville", value: ville)
                    }
                    
                    if let responsableNom = ecole.responsableNom {
                        InfoRow(icon: "person", title: "Responsable", value: responsableNom)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func callPhone(_ phone: String) {
        if let url = URL(string: "tel://\(phone.replacingOccurrences(of: " ", with: ""))") {
            UIApplication.shared.open(url)
        }
    }
    
    func sendEmail(_ email: String) {
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
}
