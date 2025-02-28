import SwiftUI

// MARK: - Notification Model
struct Notification: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let time: String
    let date: String
    let icon: String // SF Symbol or custom image name
}

struct NotificationListView: View {
    @State var notifications: [Notification] = [
        Notification(
            title: "1 no money, recharge your card or add another card",
            message: "We were unable to debit funds from your card. You may not have enough…",
            time: "14:00",
            date: "Today",
            icon: "dollarsign.circle"
        ),
        Notification(
            title: "Cancellation of service",
            message: "Unfortunately the service cannot be performed on September 15 at 15:06…",
            time: "14:00",
            date: "Today",
            icon: "person.crop.circle.badge.exclamationmark"
        ),
        Notification(
            title: "Reminder: Update Payment Information",
            message: "Your payment method will expire soon. Please update to avoid service interruption.",
            time: "10:30",
            date: "12th of September",
            icon: "creditcard"
        )
    ]
    
 
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    // Group notifications by date
                    ForEach(groupedNotifications.keys.sorted(), id: \.self) { date in
                        if let notifications = groupedNotifications[date] {
                            Section(header: Text(date)
                                .font(.headline)
                                .foregroundColor(.primary.opacity(0.90))
                                .padding(.leading, 16)
                                .frame(maxWidth: .infinity, alignment: .leading)) {
                                    
                                    ForEach(notifications) { notification in
                                        NotificationCard(notification: notification) { deletedNotification in
                                            deleteNotification(deletedNotification)
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                        }
                    }

                }
                .padding(.top)
                .padding(.bottom,60)
            }
            .navigationTitle("Notification")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink(destination: NotificationSettingsDetailView()) {
                        Image(systemName: "gearshape")
                    }
                    
                    NavigationLink(destination: NotificationSettingsDetailView()) {
                        ZStack {
                            Image(systemName: "bell")
                            ZStack {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 16, height: 16)
                                Text("\(groupedNotifications.count)")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            .offset(x: 12, y: -12)
                        }
                    }
                }
            }
            .blurredBackground()
        }
    }
    
    // Function to delete a notification from the notifications array
    private func deleteNotification(_ notification: Notification) {
        // Remove notification from the notifications array
        if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
            notifications.remove(at: index)
        }
    }
    
    // Group notifications by date
    private var groupedNotifications: [String: [Notification]] {
        // This is a computed property that groups the notifications by date
        Dictionary(grouping: notifications, by: { $0.date })
    }
}


struct NotificationCard: View {
    let notification: Notification
    @State var expand = false
    @State var animateClick = false
    var delete: (Notification) -> Void  // Closure for delete action
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 12) {
                if !expand {
                    Image(systemName: notification.icon) // Replace with custom image if needed
                        .font(.title)
                    .foregroundColor(.blue)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(notification.title)
                            .font(.headline)
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [.blue, .purple]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .lineLimit(expand ? 5 : 2)
                        Spacer()
                        Text(notification.time)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Divider()
                    Text(notification.message)
                        .font(.subheadline)
                        .foregroundColor(expand ? Color.invert : .gray)
                        .lineLimit(expand ? nil : 2)
                    
                    
                    
                }
            }
            .padding()
            .background(Color.dynamic)
            .background(.ultraThinMaterial)
            .cornerRadius(21)
            .overlay(
                RoundedRectangle(cornerRadius: 21)
                    .stroke(Color.invert.opacity(0.09), lineWidth: 1)
            )
            .scaleEffect(animateClick ? 0.97 : 1)
            .onTapGesture {
                // Show the full message
                withAnimation(.spring()) {
                    animateClick = true
                    expand.toggle()
                    
                    triggerLightVibration()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    withAnimation(.spring()) {
                        animateClick = false
                       // delete(notification)
                    }
                }
        }
            if expand {
                
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut) {
                            delete(notification)
                            triggerLightVibration()
                        } // Call delete closure
                    }) {
                        Text("Delete")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        // Call cancel closure
                        withAnimation(.spring()) {
                            expand.toggle()
                            triggerLightVibration()
                        }
                    }) {
                        Text("Cancel")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 6) // Space between content and buttons
                .offset(y: expand ? 0 : -80)
            }
        }
       
    }
}


// MARK: - Preview
struct NotificationListView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationListView()
    }
}


struct NotificationSettingsDetailView: View {
    @State private var receiveNews = true
    @State private var notifyOffers = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Bell Icon with Badge
                Image(systemName: "bell.badge")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.gray)
                    .padding(.top)
                
                // Description Text
                Text("Sometimes we send you the latest news and promotional offers. Stay tuned to keep getting great deals.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                // Toggle Settings
                VStack(spacing: 16) {
                    SettingToggleRow(
                        title: "Receive news from QOffer",
                        isOn: $receiveNews
                    )
                    SettingToggleRow(
                        title: "Notify me about the appearance of QOffers and discounts",
                        isOn: $notifyOffers
                    )
                }
                .padding(.horizontal, 16)
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
          
            .blurredBackground()
        }
    }
}


struct SettingToggleRow: View {
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .foregroundColor(.black)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
