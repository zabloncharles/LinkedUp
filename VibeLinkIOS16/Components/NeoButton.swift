//
//  NeoButton.swift
//  VibeLink
//
//  Created by Zablon Charles on 1/12/25.
//

import SwiftUI


struct TapCompletionModifier2: ViewModifier {
    @State var isTapped = false
    @State var appeared = false
    var isToggle = false
    var cornerRadius : CGFloat = 15
    
    
    func body(content: Content) -> some View {
        content
            .background(Color("white").opacity( appeared ? 0.20 : 0.80))
            .cornerRadius(CGFloat(cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color("black").opacity(0.70), lineWidth: 0.5)
                
            )
        //            .shadow(color:  .black.opacity( appeared ? 0.2 : 0.15 ), radius: 15, x:isTapped ? appeared ? -5 : -1 : 10, y:isTapped ? appeared ? -5 : -2 : appeared ? 10 : 5 )
        //            .shadow(color: Color("white").opacity( appeared ?  0.9 : 0.5),radius: 10, x:isTapped  ? appeared ? 10 : 5 : appeared ? -5 : -2, y:isTapped  ? appeared ? 10:5 : appeared ? -5 : -2)
            .scaleEffect(isTapped ? 0.97 : appeared ? 1 : 0.97)
        
            .onAppear{
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25)  {
                    withAnimation(.easeIn) {
                        appeared = true
                    }
                }
            }
    }
}


extension View {
    func neoButtonOff(isToggle: Bool, cornerRadius: CGFloat) -> some View {
        return modifier(TapCompletionModifier2(isToggle: isToggle, cornerRadius: cornerRadius))
    }
}
