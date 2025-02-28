//
//  TabBar.swift
//  DesignCodeiOS15
//
//  Created by Meng To on 2021-11-05.
//

import SwiftUI

struct TabBar: View {
    @AppStorage("selectedTab") var selectedTab: Tab = .home
    @AppStorage("hideTab") var hideTab: Bool = false
    @State var color: Color = .teal
    @State var tabItemWidth: CGFloat = 0
    @State var animateClick = false
    
    var body: some View {
        HStack(alignment: .center) {
            buttons
        }
        .padding(.horizontal, 8)
        .padding(.top, 14)
        .frame(height: 78, alignment: .top)
        
        .background(Color.dynamic.opacity(0.60))
        .background(.ultraThinMaterial)
        
       
        .cornerRadius(60)
        .overlay(
            RoundedRectangle(cornerRadius: 60)
                .stroke(Color.invert.opacity(0.09), lineWidth: 1)
        )
        .scaleEffect(animateClick ? 0.97 : 1)
        .padding(.bottom,20)
        .offset(y: hideTab ? 200 : 0) // Move the tab downwards when hideTab is true
        .animation(.spring(), value: hideTab) // Animate the offset change
        .frame(maxHeight: .infinity, alignment: .bottom)
        .padding(.horizontal,30)
        .onChange(of: selectedTab, perform: { change in
            withAnimation(.spring()) {
                animateClick = true
                triggerLightVibration()
               
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.spring()) {
                    animateClick = false
                }
            }
        })
        .ignoresSafeArea()
    }
    
    var buttons: some View {
        ForEach(tabItems) { item in
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedTab = item.tab
                    color = item.color
                }
            } label: {
                VStack(spacing: 0) {
                    Image(systemName: item.icon)
                        .symbolVariant(.fill)
                        .font(.body.bold())
                        .frame(width: 44, height: 29)
                    Text(item.text)
                        .font(.caption2)
                        .lineLimit(1)
                    Rectangle()
                        .fill(selectedTab == item.tab ? color : .clear)
                        .frame(width:18, height:2)
                        .cornerRadius(3)
                        .animation(.linear , value: selectedTab)
                        .offset(y:5)
                }
                .frame(maxWidth: .infinity)
            }
            .foregroundStyle(selectedTab == item.tab ? color : .secondary)
            .blendMode(selectedTab == item.tab ? .normal : .normal)
            .overlay(
                GeometryReader { proxy in
//                            Text("\(proxy.size.width)")
                    Color.clear.preference(key: TabPreferenceKey.self, value: proxy.size.width)
                }
            )
            .onPreferenceChange(TabPreferenceKey.self) { value in
                tabItemWidth = value
            }
        }
    }
    
   
    
   
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
.previewInterfaceOrientation(.portrait)
    }
}
