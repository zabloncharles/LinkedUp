//
//  ProfileEditView.swift
//  VibeLink
//
//  Created by Zablon Charles on 1/13/25.
//

import SwiftUI

struct ProfileEditView: View {
    @State private var firstName = "Alesia"
    @State private var lastName = "Karapova"
    @State private var email = "Karapova@gmail.com"
    @State private var dateOfBirth = "05/25/1997"
    @State private var phoneNumber = "+1 201 298 9777"
    @State private var country = "United States"
    @State private var user = User(
        firstName: "",
        lastName: "",
        email: "",
        dateOfBirth: "",
        phoneNumber: "",
        avatar: "",
        bookmark: [""],
        myEvents: ["5IBXl9PHiXLl4ToKVuss"],
        attendedEvents: ["481CsW9n1sHmlpTXfZbZ"]
    )
    
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Image("Background 1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .cornerRadius(60)
                    .overlay(
                        Circle()
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .overlay(
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Image(systemName: "pencil.slash")
                                    .background(Circle().padding(.horizontal,12)
                                        .padding(.vertical,12)
                                        .background(.ultraThinMaterial)
                                        .cornerRadius(60))
                            }
                        }
                    )
                
                Text(firstName + " " + lastName)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(email)
                    .font(.body)
                    .foregroundColor(.gray)
            }
            
            
            VStack(alignment: .leading, spacing: 10) {
               
                TextEditPlaceholder(placeholderText: $user.firstName, title: "Full Name", placeholder: "First name")
                
                TextEditPlaceholder(placeholderText: $user.lastName, title: "", placeholder: "Last name")
                Divider()
                    .frame(width: 23)
                TextEditPlaceholder(placeholderText: $user.email, title: "Email", placeholder: "Your email")
                Divider()
                    .frame(width: 23)
                TextEditPlaceholder(placeholderText: $user.dateOfBirth, title: "Date of Birth", placeholder: "month/day/year")
                Divider()
                    .frame(width: 23)
                TextEditPlaceholder(placeholderText: $user.phoneNumber, title: "Phone number", placeholder: "What's your phone number?")
           
                
               
            }
            Spacer()
        }
        .padding()
    }
}


struct ProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditView()
    }
}




struct TextEditPlaceholder: View {
    @Binding var placeholderText : String
    var title = "title"
    var placeholder = "placeholder"
    var body: some View {
        VStack(alignment: .leading){
            Text(title)
                .bold()
            TextField(placeholder.lowercased(), text: $placeholderText)
                .padding(.horizontal)
                .padding(.vertical,15)
                .background(Color.dynamic)
                .background(.ultraThinMaterial)
                .cornerRadius(13)
                .overlay(
                    RoundedRectangle(cornerRadius: 13)
                        .stroke(Color.invert.opacity(0.09), lineWidth: 1)
                )
        }
    }
}
