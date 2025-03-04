import SwiftUI

struct EventCard: View {
    let event: Event
    let onTap: () -> Void
    var isBookmarked: Bool = false
    var onBookmark: (() -> Void)?
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                // Event Image
                AsyncImage(url: URL(string: event.images.first ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(height: 200)
                .clipped()
                .cornerRadius(12)
                
                // Event Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.name)
                        .font(.headline)
                        .lineLimit(2)
                    
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.gray)
                        Text(event.startDate.formatted(date: .abbreviated, time: .shortened))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Image(systemName: "location")
                            .foregroundColor(.gray)
                        Text(event.location)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                    
                    HStack {
                        Text("$\(event.price)")
                            .font(.headline)
                            .foregroundColor(.blue)
                        
                        Spacer()
                        
                        if let onBookmark = onBookmark {
                            Button(action: onBookmark) {
                                Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                                    .foregroundColor(isBookmarked ? .blue : .gray)
                            }
                        }
                    }
                }
                .padding(.horizontal, 8)
            }
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}

struct ProfileCard: View {
    let user: UserProfile
    let onEdit: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            // Profile Image
            AsyncImage(url: URL(string: user.avatar)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            
            // User Info
            VStack(spacing: 4) {
                Text("\(user.firstName) \(user.lastName)")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(user.email)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            // Edit Button
            Button(action: onEdit) {
                Text("Edit Profile")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 120, height: 36)
                    .background(Color.blue)
                    .cornerRadius(18)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
} 