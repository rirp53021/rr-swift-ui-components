// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI
import Foundation
import Combine

// MARK: - Modal Presentation Style

public enum PresentationStyle: Equatable {
    case sheet
    case fullScreenCover
    case popover
    case bottomSheet
    
    public static func == (lhs: PresentationStyle, rhs: PresentationStyle) -> Bool {
        switch (lhs, rhs) {
        case (.sheet, .sheet), (.fullScreenCover, .fullScreenCover), (.popover, .popover), (.bottomSheet, .bottomSheet):
            return true
        default:
            return false
        }
    }
}

// MARK: - RRModal

public struct RRModal<Content: View>: View {
    private let content: Content
    private let isPresented: Binding<Bool>
    private let style: PresentationStyle
    private let onDismiss: (() -> Void)?
    
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging = false
    
    public init(
        _ style: PresentationStyle = .sheet,
        isPresented: Binding<Bool>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.style = style
        self.isPresented = isPresented
        self.onDismiss = onDismiss
        self.content = content()
    }
    
    public var body: some View {
        if isPresented.wrappedValue {
            ZStack {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        dismiss()
                    }
                
                VStack {
                    if style == .bottomSheet {
                        Spacer()
                    }
                    
                    VStack(spacing: 0) {
                        if style == .bottomSheet {
                            // Handle for bottom sheet
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.secondary)
                                .frame(width: 40, height: 4)
                                .padding(.top, RRSpacing.sm)
                        }
                        
                        content
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(style == .bottomSheet ? 16 : 0)
                    .offset(y: dragOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if style == .bottomSheet {
                                    isDragging = true
                                    dragOffset = max(0, value.translation.height)
                                }
                            }
                            .onEnded { value in
                                if style == .bottomSheet {
                                    isDragging = false
                                    if value.translation.height > 100 {
                                        dismiss()
                                    } else {
                                        withAnimation(.spring()) {
                                            dragOffset = 0
                                        }
                                    }
                                }
                            }
                    )
                    
                    if style != .bottomSheet {
                        Spacer()
                    }
                }
            }
            .transition(.opacity)
            .animation(.spring(), value: isPresented.wrappedValue)
        }
    }
    
    private func dismiss() {
        withAnimation(.spring()) {
            isPresented.wrappedValue = false
        }
        onDismiss?()
    }
}

// MARK: - Modal Manager

public class RRModalManager: ObservableObject {
    public static let shared = RRModalManager()
    
    @Published public var isPresented = false
    @Published public var currentModal: AnyView?
    
    private init() {}
    
    public func show<Content: View>(
        _ style: PresentationStyle = .sheet,
        @ViewBuilder content: @escaping () -> Content
    ) {
        currentModal = AnyView(
            RRModal(style, isPresented: .constant(true)) {
                content()
            }
        )
        isPresented = true
    }
    
    public func dismiss() {
        isPresented = false
    }
}

// MARK: - Preview

#if DEBUG
struct RRModal_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Text("Modal Styles")
                .font(.headline)
            
            VStack(spacing: 10) {
                RRModal(.sheet, isPresented: .constant(true)) {
                    VStack(spacing: RRSpacing.md) {
                        Text("Sheet Modal")
                            .font(.headline)
                        
                        Text("This is a sheet modal presentation.")
                            .foregroundColor(.secondary)
                        
                        Button("Close") {
                            // Close action
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(RRSpacing.lg)
                }
                
                RRModal(.bottomSheet, isPresented: .constant(true)) {
                    VStack(spacing: RRSpacing.md) {
                        Text("Bottom Sheet")
                            .font(.headline)
                        
                        Text("This is a bottom sheet modal presentation.")
                            .foregroundColor(.secondary)
                        
                        Button("Close") {
                            // Close action
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(RRSpacing.lg)
                }
            }
        }
        .padding()
    }
}
#endif
