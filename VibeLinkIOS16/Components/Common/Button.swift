import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    var isEnabled: Bool = true
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text(title)
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(isEnabled ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .disabled(!isEnabled || isLoading)
    }
}

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    var isEnabled: Bool = true
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                } else {
                    Text(title)
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.white)
            .foregroundColor(.blue)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue, lineWidth: 1)
            )
        }
        .disabled(!isEnabled || isLoading)
    }
}

struct IconButton: View {
    let icon: String
    let action: () -> Void
    var color: Color = .blue
    var size: CGFloat = 44
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size * 0.5))
                .foregroundColor(color)
                .frame(width: size, height: size)
                .background(Color.white)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
} 