import SwiftUI

struct InputField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var icon: String?
    var error: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(.gray)
                }
                
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .keyboardType(keyboardType)
                        .textContentType(.password)
                } else {
                    TextField(placeholder, text: $text)
                        .keyboardType(keyboardType)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            
            if let error = error {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
}

struct SearchField: View {
    @Binding var text: String
    var placeholder: String = "Search"
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct DatePickerField: View {
    let title: String
    @Binding var date: Date
    var error: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            DatePicker("", selection: $date, displayedComponents: [.date, .hourAndMinute])
                .labelsHidden()
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            
            if let error = error {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
}

struct PriceRangeField: View {
    let title: String
    @Binding var range: ClosedRange<Double>
    var error: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack {
                Text("$\(Int(range.lowerBound))")
                    .foregroundColor(.gray)
                
                Slider(value: Binding(
                    get: { range.lowerBound },
                    set: { range = $0...range.upperBound }
                ), in: 0...1000)
                
                Text("$\(Int(range.upperBound))")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            
            if let error = error {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
} 