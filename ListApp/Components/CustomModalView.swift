//
//  CustomModalView.swift
//  ListApp
//
//  Created by Aditi Nath on 05/01/25.
//
import SwiftUI

struct CustomModalView<M: View>: View {
    @Binding var isPresented: Bool
    var modalBody: () -> M
    
    init(_ isPresented: Binding<Bool>, @ViewBuilder modalBody: @escaping () -> M) {
        self._isPresented = isPresented
        self.modalBody = modalBody
    }
    var body: some View {
        ZStack {
            Color.gray
                .ignoresSafeArea()
                .opacity(isPresented ? 0.5 : 0)
            VStack {
                modalBody()
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .multilineTextAlignment(.center)
        }
        .ignoresSafeArea()
        .zIndex(.greatestFiniteMagnitude)
    }
}

extension View {
    func customModal<M>(
    _ isPresented: Binding<Bool>,
    @ViewBuilder modalBody: @escaping () -> M
    ) -> some View where M: View {
        fullScreenCover(isPresented: isPresented) {
            CustomModalView(isPresented, modalBody: modalBody)
                .presentationBackgroundInteraction(.disabled)
                .presentationBackground(.clear)
        }
    }
}
